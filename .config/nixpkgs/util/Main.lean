abbrev FilePath := System.FilePath
abbrev realPath := IO.FS.realPath
abbrev writeFile := IO.FS.writeFile

def run : List String -> IO String
    | [] => IO.Process.run { cmd := "nothing" }
    | head :: [] => IO.Process.run { cmd := head }
    | head :: tail => IO.Process.run {
        cmd := head
        args := tail.toArray
      }

def fd_handle_results (r : String) : List FilePath :=
  let split := r.splitOn "\n"
  split.map (λ x => System.FilePath.mk x) |> List.dropLast

#eval fd_handle_results "hello/world\none/two/three\n" ==
  [System.FilePath.mk "hello/world",
   System.FilePath.mk "one/two/three"]

def fd (path : String) (pattern : String) : IO (List FilePath) :=
  let results := run ["fd", pattern, "--color", "never", path]
  (results.map fd_handle_results)

def mkdir (dir : String) : IO String :=
  run ["mkdir", "-p", dir]

def sequence_iter : IO (List FilePath) -> IO FilePath -> IO (List FilePath) :=
  λ io path => do
    let path' <- path
    let io' <- io
    return (path' :: io')

def sequence : List (IO FilePath) -> IO (List FilePath) :=
  λ x => x.foldl sequence_iter (pure [])

def write_fennel (fnl : FilePath) : IO Unit := do
  let x <- run ["fennel", "--compile", fnl.toString]
  let lua := fnl.withExtension "lua"
  writeFile lua x

def main := do
  let fnl <- fd "../../nvim" ".fnl"
  let fnl <- fnl.map realPath |> sequence
  let _ <- fnl.forA write_fennel

  pure ()

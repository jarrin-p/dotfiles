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

def sequence_iter : IO (List FilePath) -> IO FilePath -> IO (List FilePath) :=
  λ io path => do
    let path' <- path
    let io' <- io
    return (path' :: io')

def sequence : List (IO FilePath) -> IO (List FilePath) :=
  λ x => x.foldl sequence_iter (pure [])

def fd_handle_results (r : String) : List FilePath :=
  let split := r.splitOn "\n"
  split.map (λ x => System.FilePath.mk x) |> List.dropLast

#eval fd_handle_results "hello/world\none/two/three\n" ==
  [System.FilePath.mk "hello/world",
   System.FilePath.mk "one/two/three"]

def fd (path : FilePath) (pattern : String) : IO (List FilePath) := do
  let results := run ["fd", pattern, "--color", "never", path.toString]
  (results.map fd_handle_results)
  --let out <- (results.map fd_handle_results)
  --out.map realPath |> sequence

def mkdir (dir : String) : IO String :=
  run ["mkdir", "-p", dir]

def write_fennel (source : FilePath) (dest : FilePath) : IO Unit := do
  let x <- run ["fennel", "--compile", source.toString]
  let _ : (Except _ _) := match dest.parent with
    | some dir => run ["mkdir", "-p", dir.toString] |> pure
    | _ => throw "there needs to be a directory associated with this file."
  let _ <- writeFile dest x

def copy_lua (source : FilePath) (dest : FilePath) : IO Unit := do
  _ <- run ["cp", source.toString, dest.toString]

-- base gets cleaned from the source.
def dir_structure (source : FilePath) (base : FilePath) :=
  let count := source.components.length - base.components.length
  let taken := source.components.reverse.take count
  System.mkFilePath taken.reverse

structure CompilationPath where
  source : FilePath -- the relative path to file itself.
  dest : FilePath -- the desired destination.

-- source is the actual file that exists.
-- base gets removed from the source path.
def CompilationPath.fromRel (base : FilePath) (output_dir : FilePath) (source : FilePath) : CompilationPath := {
    source := source
    dest := output_dir.join (dir_structure source base)
}

def do_the_things (search_dir : FilePath) (output_dir : FilePath) : IO Unit := do
  let fennel_files <- fd search_dir ".fnl"
  let fennel_files := fennel_files.map (CompilationPath.fromRel search_dir output_dir)
  fennel_files.forA λ p => IO.println p.dest
  -- fennel_files.forA λ p => IO.println (p.source)
  -- fennel_files.forA λ p => IO.println (dir_structure p store_path)
  -- fennel_files.forA (write_fennel λ path => path.withExtension "lua")
  pure ()

def main (args : List String) := do
  match args with
    | store_path :: out_path :: [] => do_the_things store_path out_path
    | _ => pure ()

  -- let lua <- fd "../../nvim" ".lua"

  pure ()

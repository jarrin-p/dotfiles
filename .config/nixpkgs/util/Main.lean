abbrev FilePath := System.FilePath
abbrev realPath := IO.FS.realPath
abbrev writeFile := IO.FS.writeFile

def run : List String -> IO IO.Process.Output
    | [] => IO.Process.output { cmd := "nothing" }
    | head :: [] => IO.Process.output { cmd := head }
    | head :: tail => IO.Process.output {
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

def fd (fd_path : String) (path : FilePath) (pattern : String) : IO (List FilePath) := do
  let results <- run [fd_path, pattern, "--color", "never", path.toString]
  let _ <- IO.println results.stdout
  return fd_handle_results results.stdout

def write_fennel (source : FilePath) (dest : FilePath) (fennel_path : String) : IO Unit := do
  let x <- run [fennel_path, "--compile", source.toString]
  let dir := dest.parent.get!.toString
  let _ <- IO.println dest.toString
  let _ <- run ["mkdir", "-p", dir]
  writeFile (dest.withExtension "lua") x.stdout

def copy_lua (source : FilePath) (dest : FilePath) : IO Unit := do
  let dir := dest.parent.get!.toString
  let _ <- IO.println dest.toString
  let _ <- run ["mkdir", "-p", dir]
  let _ <- run ["cp", source.toString, dest.toString]

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

def do_the_things (search_dir : FilePath) (output_dir : FilePath) (fd_path : String) (fennel_path : String) : IO Unit := do
  let fennel_files <- fd fd_path search_dir ".fnl"
  let fennel_files := fennel_files.map (CompilationPath.fromRel search_dir output_dir)
  fennel_files.forA λ p => write_fennel p.source p.dest fennel_path

  let lua_files <- fd fd_path search_dir ".lua"
  let lua_files := lua_files.map (CompilationPath.fromRel search_dir output_dir)
  lua_files.forA λ p => copy_lua p.source p.dest
  pure ()

def main (args : List String) := do
  match args with
    | store_path :: out_path :: fd_path :: fennel_path :: [] =>
      do_the_things store_path out_path fd_path fennel_path
    | _ => pure ()

  -- let lua <- fd "../../nvim" ".lua"

  pure ()

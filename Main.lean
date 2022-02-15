import CMark

/--
  Read the input file and output the rendered HTML.
-/
def main (args : List String) : IO Unit := do
  match args.get? 0 with
  | some file =>
    let input ← IO.FS.readFile file
    IO.println <| CMark.renderHtml input
  | _         => IO.println "Usage: lean-cmark <file>"
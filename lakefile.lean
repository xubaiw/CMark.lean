import Lake
open System Lake DSL

package CMark

def cmarkDir : FilePath := "cmark"
def wrapperDir := "wrapper"
def srcNames := #[
  "blocks", "buffer", "cmark_ctype", "cmark",
  "commonmark", "houdini_href_e", "houdini_html_e",
  "houdini_html_u", "html", "inlines", "iterator",
  "latex", "man", "node", "references", "render",
  "scanners", "utf8", "xml"]
def wrapperName := "wrapper"
def buildDir := defaultBuildDir

def cmarkOTarget (pkg : Package) (srcName : String) : IndexBuildM (BuildJob FilePath) := do
  let oFile := pkg.dir / buildDir / cmarkDir / ⟨ srcName ++ ".o" ⟩
  let srcTarget ← inputFile <| pkg.dir / cmarkDir / ⟨ srcName ++ ".c" ⟩
  buildFileAfterDep oFile srcTarget λ srcFile => do
    let flags := #["-I", (pkg.dir / cmarkDir).toString, "-fPIC"]
    compileO (srcName ++ "c") oFile srcFile flags

def wrapperOTarget (pkg : Package) : IndexBuildM (BuildJob FilePath) := do
  let oFile := pkg.dir / buildDir / wrapperDir / ⟨ wrapperName ++ ".o" ⟩
  let srcTarget ← inputFile <| pkg.dir / wrapperDir / ⟨ wrapperName ++ ".c" ⟩
  buildFileAfterDep oFile srcTarget λ srcFile => do
    let flags := #["-I", (← getLeanIncludeDir).toString, "-I", (pkg.dir / cmarkDir).toString, "-fPIC"]
    compileO (wrapperName ++ "c") oFile srcFile flags

@[default_target]
lean_lib CMark

extern_lib cmark (pkg : Package) := do
  let libFile := pkg.dir / buildDir / cmarkDir / "libleancmark.a"
  let oTargets := (←srcNames.mapM (cmarkOTarget pkg)) ++ #[←wrapperOTarget pkg]
  buildStaticLib libFile oTargets

import Lake
open System Lake DSL

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

def cmarkOTarget (pkgDir : FilePath) (srcName : String) : FileTarget :=
  let oFile := pkgDir / buildDir / cmarkDir / ⟨ srcName ++ ".o" ⟩ 
  let srcTarget := inputFileTarget <| pkgDir / cmarkDir / ⟨ srcName ++ ".c" ⟩
  fileTargetWithDep oFile srcTarget λ srcFile => do
    compileO oFile srcFile #["-I", (pkgDir / cmarkDir).toString] "clang"

def wrapperOTarget (pkgDir : FilePath) : FileTarget :=
  let oFile := pkgDir / buildDir / wrapperDir / ⟨ wrapperName ++ ".o" ⟩ 
  let srcTarget := inputFileTarget <| pkgDir / wrapperDir / ⟨ wrapperName ++ ".c" ⟩
  fileTargetWithDep oFile srcTarget λ srcFile => do
    compileO oFile srcFile #["-I", (← getLeanIncludeDir).toString, "-I", (pkgDir / cmarkDir).toString] "clang"

def cmarkTarget (pkgDir : FilePath) : FileTarget :=
  let libFile := pkgDir / buildDir / cmarkDir / "libleancmark.a"
  staticLibTarget libFile <| srcNames.map (cmarkOTarget pkgDir) ++ #[wrapperOTarget pkgDir]

package CMark (pkgDir) (args) {
  binName := "lean-cmark"
  moreLibTargets := #[cmarkTarget pkgDir]
}

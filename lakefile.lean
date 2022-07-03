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

def cmarkOTarget (srcName : String) : FileTarget :=
  let oFile := __dir__ / buildDir / cmarkDir / ⟨ srcName ++ ".o" ⟩ 
  let srcTarget := inputFileTarget <| __dir__ / cmarkDir / ⟨ srcName ++ ".c" ⟩
  fileTargetWithDep oFile srcTarget λ srcFile => do
    compileO oFile srcFile #["-I", (__dir__ / cmarkDir).toString]

def wrapperOTarget : FileTarget :=
  let oFile := __dir__ / buildDir / wrapperDir / ⟨ wrapperName ++ ".o" ⟩ 
  let srcTarget := inputFileTarget <| __dir__ / wrapperDir / ⟨ wrapperName ++ ".c" ⟩
  fileTargetWithDep oFile srcTarget λ srcFile => do
    compileO oFile srcFile #["-I", (← getLeanIncludeDir).toString, "-I", (__dir__ / cmarkDir).toString]

def cmarkTarget : FileTarget :=
  let libFile := __dir__ / buildDir / cmarkDir / "libleancmark.a"
  staticLibTarget libFile <| srcNames.map (cmarkOTarget) ++ #[wrapperOTarget]

@[defaultTarget]
lean_lib CMark

extern_lib cmark := cmarkTarget

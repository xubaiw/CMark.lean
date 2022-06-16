namespace CMark

@[extern "lean_cmark_markdown_to_html"]
opaque renderHtml (md : @& String) : String

end CMark
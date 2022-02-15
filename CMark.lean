namespace CMark

@[extern "lean_cmark_markdown_to_html"]
constant renderHtml (md : @& String) : String

end CMark
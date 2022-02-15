#include <lean/lean.h>
#include <cmark.h>

lean_obj_res lean_cmark_markdown_to_html(b_lean_obj_res s) {
    char* html_cstr = cmark_markdown_to_html(lean_string_cstr(s), lean_string_size(s) - 1, 0);
    lean_object *html_string = lean_mk_string(html_cstr);
    free(html_cstr);
    return html_string;
}
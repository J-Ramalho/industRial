library(rmarkdown)
library(bookdown)
library(here)

render_book(
  input = here("inst/book/"),
  output_format = 'bookdown::gitbook', 
  encoding = 'UTF-8',
  config_file = here("inst/book/_bookdown.yml"),
  output_dir = here("docs")
)

serve_book(
  dir = here("inst/book/"), 
  output_dir = here("docs"),
  preview = FALSE
  )

render_book(
  html_chapters(
    toc = TRUE,
    number_sections = TRUE,
    fig_caption = TRUE,
    lib_dir = "libs",
    template = bookdown_file("templates/default.html"),
    pandoc_args = NULL,
    base_format = rmarkdown::html_document,
    split_bib = TRUE,
    page_builder = build_chapter,
    split_by = c(
      "section+number",
      "section",
      "chapter+number",
      "chapter",
      "rmd",
      "none"
    )
  )
)

bookdown::render_book(
  input = here("inst/book/index.Rmd"),
  pdf_book(
    toc = TRUE,
    number_sections = TRUE,
    fig_caption = TRUE,
    pandoc_args = NULL,
    base_format = rmarkdown::pdf_document,
    latex_engine = "xelatex",
    toc_unnumbered = TRUE,
    toc_appendix = FALSE,
    toc_bib = TRUE,
    quote_footer = NULL,
    highlight_bw = FALSE,
    output_dir = here("docs")
  )
)

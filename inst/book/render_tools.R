library(rmarkdown)
library(bookdown)

render_book(
  input = "~/Documents/data_science/industRial/inst/book/index.Rmd",
  output_format = 'bookdown::gitbook', 
  encoding = 'UTF-8',
  config_file = "inst/book/_bookdown.yml"
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
bookdown::render_book("index.Rmd",
  pdf_book(
    toc = TRUE,
    number_sections = TRUE,
    fig_caption = TRUE,
    pandoc_args = NULL,
    base_format = rmarkdown::pdf_document,
    toc_unnumbered = TRUE,
    toc_appendix = FALSE,
    toc_bib = TRUE,
    quote_footer = NULL,
    highlight_bw = FALSE
  )
)

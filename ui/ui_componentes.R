# Pie de página con el logo institucional
pieLogo <- function() {
  tags$div(
    style = "text-align: center;",
    tags$img(src = RUTA_LOGO, width = ANCHO_LOGO)
  )
}
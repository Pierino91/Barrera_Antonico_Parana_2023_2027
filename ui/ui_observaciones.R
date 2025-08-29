source("ui/ui_componentes.R")

pestanaObservaciones <- bs4TabItem(
  tabName = "Obs",
  h2("Documentación"),
  box(
    title = NULL,
    status = "success",
    solidHeader = TRUE,
    width = 12,
    uiOutput("mensaje_tabla"),
    reactableOutput("tabla")
  ),
  pieLogo()
)
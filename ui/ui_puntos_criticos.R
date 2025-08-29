source("ui/ui_componentes.R")

pestanaPuntosCriticos <- bs4TabItem(
  tabName = "PtosCriticos",
  h2("Puntos críticos"),
  box(
    status = "success",
    solidHeader = TRUE,
    width = 12,
    leafletOutput("mapa_puntos_criticos", height = "600px")
  ),
  pieLogo()
)
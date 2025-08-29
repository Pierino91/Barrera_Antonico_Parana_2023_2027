source("ui/ui_componentes.R")

pestanaMonitor <- bs4TabItem(
  tabName = "Monitor",
  h2("Resumen semanal"),
  fluidRow(
    bs4Card(
      title = tagList(icon("calendar-alt"), "Última actualización"),
      status = "info",
      solidHeader = TRUE,
      collapsible = FALSE,
      width = 6,
      tags$div(
        style = "font-size: 30px; font-weight: bold; text-align: center;",
        uiOutput("fecha_max")
      )
    ),
    bs4Card(
      title = tagList(icon("road-barrier"), "Estado de la barrera"),
      status = "primary",
      solidHeader = TRUE,
      collapsible = FALSE,
      width = 6,
      uiOutput("estado_barrera")
    ),
    bs4Card(
      title = tagList(icon("recycle"), "Residuos retenidos totales"),
      status = "olive",
      solidHeader = TRUE,
      collapsible = FALSE,
      width = 6,
      tags$div(
        style = "font-size: 30px; font-weight: bold; text-align: center;",
        uiOutput("total_residuos_retenidos")
      )
    ),
    bs4Card(
      title = tagList(icon("water"), "Calidad del agua"),
      status = "lightblue",
      solidHeader = TRUE,
      collapsible = FALSE,
      width = 6
      # Agregar más salidas si es necesario
    )
  ),
  pieLogo()
)
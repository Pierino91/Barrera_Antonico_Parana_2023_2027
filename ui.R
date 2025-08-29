# =============================================================================
# UI - Barrera de Retención de Residuos 2023-2027
# Dashboard principal de monitoreo para la Subsecretaría de Ambiente
# =============================================================================

# ---- Librerías ----
library(bs4Dash)
library(shiny)

# ---- Archivos externos ----
source("global.R")            # Variables y funciones globales
source("functionEpicollect.R")# Funciones para la obtención de datos

# ---- Parámetros globales ----
RUTA_LOGO <- "multimedia/Logo-Municipalidad.png"
ANCHO_LOGO <- "50%"

# ---- Componentes reutilizables ----
# Pie de página con el logo institucional
pieLogo <- function() {
  tags$div(
    style = "text-align: center;",
    tags$img(src = RUTA_LOGO, width = ANCHO_LOGO)
  )
}

# ---- Pestañas individuales ----
# Recomendación: separar cada pestaña en un archivo externo según el proyecto crezca

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

pestanaResiduos <- bs4TabItem(
  tabName = "Residuos",
  h2("Residuos retenidos por la barrera"),
  box(
    title = NULL,
    status = "success",
    solidHeader = TRUE,
    width = 12,
    uiOutput("mensaje_residuos"),
    plotlyOutput("grafico_tiempo", height = "300px")
  ),
  pieLogo()
)

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

# ---- Menú lateral ----
menuLateral <- bs4SidebarMenu(
  bs4SidebarMenuItem("Monitor", tabName = "Monitor", icon = icon("tv")),
  bs4SidebarMenuItem("Residuos", tabName = "Residuos", icon = icon("trash")),
  bs4SidebarMenuItem("Puntos críticos", tabName = "PtosCriticos", icon = icon("map")),
  bs4SidebarMenuItem("Documentación", tabName = "Obs", icon = icon("eye"))
)

# ---- UI principal ----
ui <- bs4DashPage(
  title = "Dashboard Barrera Retención de Residuos - Subsecretaría de Ambiente",
  header = bs4DashNavbar(skin = "light", status = "success"),
  sidebar = bs4DashSidebar(
    skin = "light",
    status = "success",
    title = "Monitoreo Barrera Antoñico",
    menuLateral
  ),
  body = bs4DashBody(
    bs4TabItems(
      pestanaMonitor,
      pestanaResiduos,
      pestanaPuntosCriticos,
      pestanaObservaciones
    )
  )
)

# =============================================================================
# FIN DEL ARCHIVO UI
# =============================================================================
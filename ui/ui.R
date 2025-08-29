# =============================================================================
# UI principal: dashboard modularizado
# =============================================================================

# ---- Librerías ----
library(bs4Dash)
library(shiny)

# ---- Archivos externos ----
source("global.R")
source("ui/ui_monitor.R")
source("ui/ui_residuos.R")
source("ui/ui_puntos_criticos.R")
source("ui/ui_observaciones.R")

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
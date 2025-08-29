# =============================================================================
# app.R - Punto de entrada principal de la aplicación Shiny
# =============================================================================
# Este archivo inicializa la app, cargando la UI y el server de forma modular.
# Recomendado para proyectos grandes y mantenibles.
# =============================================================================

# ---- Librerías principales ----
library(shiny)
library(bs4Dash)

# ---- Carga de archivos globales ----
source("global.R")             # Variables globales, rutas, estilos, funciones comunes
source("functionEpicollect.R") # Funciones para recolección y procesamiento de datos

# ---- Carga de la UI modular ----
source("ui/ui.R")              # Interfaz de usuario principal (modularizada)

# ---- Carga del servidor modular ----
source("server/server.R")      # Lógica del servidor (modularizada)

# ---- Inicialización de la aplicación ----
shinyApp(
  ui = ui,
  server = server
)
# =============================================================================
# FIN DEL ARCHIVO
# =============================================================================
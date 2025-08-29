# =============================================================================
# global.R - Variables y configuración global para la aplicación Shiny
# =============================================================================

# ---- Librerías principales ----
library(reactable)
library(leaflet)
library(sf)
library(lubridate)
library(plotly)
library(dplyr)
library(tidyr)

# ---- Endpoints Epicollect ----
ENDPOINT_EPICOLLECT_ENTRY <- "https://five.epicollect.net/api/export/entries/plan-de-manejo-de-barrera-del-arroyo-antonico?form_ref=15b0d62c918b47c6b3ae8a5f127857cd_6895db4e0b6c2"
ENDPOINT_EPICOLLECT_PUNTOS_CRITICOS <- "https://five.epicollect.net/api/export/entries/plan-de-manejo-de-barrera-del-arroyo-antonico?form_ref=15b0d62c918b47c6b3ae8a5f127857cd_6895db4e0b6c2&branch_ref=15b0d62c918b47c6b3ae8a5f127857cd_6895db4e0b6c2_6895dd62da036"

# ---- Parámetros de actualización ----
REFRESH_MIN <- 60  # minutos entre actualizaciones automáticas

# ---- Tema de visualización para gráficos ----
tema <- theme(
  text = element_text(family = "Montserrat"),
  plot.title = element_text(size = 20, face = "bold", color = "#4caf50", hjust = 0.5),
  plot.subtitle = element_text(size = 14, face = "italic", hjust = 0.5),
  axis.title = element_text(size = 12, face = "bold", color = "#007aff"),
  axis.text = element_text(size = 10, color = "black"),
  legend.title = element_text(size = 12, face = "bold"),
  legend.text = element_text(size = 10),
  plot.background = element_rect(fill = "white", color = NA),
  panel.border = element_rect(fill = NA, color = "#4caf50", linewidth = 1, linetype = "solid")
)

# =============================================================================
# FIN DEL ARCHIVO
# =============================================================================
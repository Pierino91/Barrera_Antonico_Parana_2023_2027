# =============================================================================
# server/server.R - Lógica principal del servidor Shiny (modularizada)
# =============================================================================

# ---- Carga de dependencias y funciones globales ----
source("global.R")
source("functionEpicollect.R")

# ---- Módulos de servidor ----
# Se recomienda crear carpetas y archivos para cada módulo en server/
source("server/mod_monitor.R")
source("server/mod_puntos_criticos.R")
source("server/mod_residuos.R")
source("server/mod_documentacion.R")

# ---- Servidor principal ----
server <- function(input, output, session) {
  
  # --- Procesamiento central de datos (reactivos compartidos) ---
  auto_update <- reactiveTimer(REFRESH_MIN * 60 * 100)
  
  datos_branch <- reactive({
    auto_update()
    obtener_datos_epicollect(ENDPOINT_EPICOLLECT_PUNTOS_CRITICOS)
  })
  
  datos_entradas <- reactive({
    auto_update()
    obtener_datos_epicollect(ENDPOINT_EPICOLLECT_ENTRY)
  })
  
  # Procesa y une los datos para todas las pestañas
  datos_observacion <- reactive({
    datos <- datos_branch()
    datos_tec <- datos_entradas()
    if (is.null(datos)) return(NULL)
    datos_tec %>%
      left_join(datos, by = c("ec5_uuid" = "ec5_branch_owner_uuid")) %>%
      rename_with(~ gsub("^\\d+_", "", .x)) %>%
      rename(
        Estado_barrera = "Estado_de_la_barre",
        latitud_pto_critico = "latitude.y",
        longitud_pto_critico = "longitude.y",
        Foto_pto_crit = "Foto__Punto_crtic",
        Video_pto_crit = "Video__Punto_crti",
        Obs_pto_crit = "Obs__Punto_crtico",
        Foto_Obs = "Foto_observacin",
        Video_Obs = "Video_observacin",
        Obs = "Observacin",
        RSU = "RSU",
        Patologico = "Patolgico",
        REGU = "REGU",
        Peligrosos = "Peligrosos"
      ) %>%
      select(
        Estado_barrera, Foto_Obs, Video_Obs, Obs,
        longitud_pto_critico, latitud_pto_critico, Foto_pto_crit, Video_pto_crit, Obs_pto_crit,
        RSU, Patologico, REGU, Peligrosos, Fecha
      ) %>%
      mutate(
        Fecha = dmy(Fecha),
        RSU = as.numeric(RSU),
        Patologico = as.numeric(Patologico),
        REGU = as.numeric(REGU),
        Peligrosos = as.numeric(Peligrosos)
      )
  })
  
  # ---- Llamadas a módulos por cada pestaña ----
  mod_monitor_server(input, output, session, datos_observacion)
  mod_puntos_criticos_server(input, output, session, datos_observacion)
  mod_residuos_server(input, output, session, datos_observacion)
  mod_documentacion_server(input, output, session, datos_observacion)
  
}
# =============================================================================
# FIN DEL ARCHIVO
# =============================================================================
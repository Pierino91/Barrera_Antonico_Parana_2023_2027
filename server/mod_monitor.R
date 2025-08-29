# =============================================================================
# server/mod_monitor.R - Monitor de estado y resumen
# =============================================================================

mod_monitor_server <- function(input, output, session, datos_observacion) {
  
  output$fecha_max <- renderUI({
    datos <- datos_observacion()
    fecha_max <- if (!is.null(datos) && nrow(datos) > 0) {
      max(datos$Fecha, na.rm = TRUE)
    } else {
      "Sin datos"
    }
    tags$h3(style = "font-size: 32px; margin: 0;", fecha_max)
  })
  
  output$estado_barrera <- renderUI({
    datos <- datos_observacion() %>% arrange(Fecha) %>% slice_tail(n = 1)
    color <- switch(datos$Estado_barrera,
                    "Óptimo"  = "green",
                    "Bueno"  = "yellow4",
                    "Regular" = "yellow",
                    "Deficiente"  = "orange",
                    "Crítico"  = "red",
                    "black")
    if (!is.null(datos) && nrow(datos) > 0) {
      tags$div(
        style = sprintf("font-size:30px; font-weight:bold; text-align:center; color:%s;", color),
        datos$Estado_barrera
      )
    } else {
      "Sin datos"
    }
  })
  
  output$total_residuos_retenidos <- renderUI({
    datos <- datos_observacion() %>%
      reframe(total = sum(RSU, na.rm = TRUE) +
                sum(Patologico, na.rm = TRUE) +
                sum(REGU, na.rm = TRUE) +
                sum(Peligrosos, na.rm = TRUE))
    total_residuos_retenidos <- if (!is.null(datos) && nrow(datos) > 0) {
      datos
    } else {
      "Sin datos"
    }
    tags$h3(style = "font-size: 32px; margin: 0;", paste0(total_residuos_retenidos), " kg")
  })
  
}
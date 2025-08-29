# =============================================================================
# server/mod_documentacion.R - Módulo para la pestaña "Documentación"
# =============================================================================

mod_documentacion_server <- function(input, output, session, datos_observacion) {
  
  output$mensaje_tabla <- renderUI({
    datos <- datos_observacion()
    if (is.null(datos) || nrow(datos) == 0) {
      tags$p("No hay datos para mostrar")
    } else {
      NULL  # No muestra mensaje si hay datos
    }
  })
  
  output$tabla <- renderReactable({
    datos <- datos_observacion() %>%
      select(Fecha, Foto_Obs, Video_Obs, Obs) %>%
      filter(Foto_Obs != "") %>%
      mutate(
        Foto_Obs  = paste0("<img src='", Foto_Obs, "' width='120'/>"),
        Video_Obs = paste0(
          "<iframe width='320' height='180' src='", Video_Obs, 
          "' frameborder='0' allowfullscreen></iframe>"
        )
      ) %>%
      rename(
        "Foto de observación" = Foto_Obs,
        "Video de observación" = Video_Obs,
        "Observación" = Obs
      )
    
    if (is.null(datos) || nrow(datos) == 0) {
      return(NULL)
    }
    reactable(datos,
              columns = list(
                `Foto de observación` = colDef(html = TRUE),
                `Video de observación` = colDef(html = TRUE)
              )
    )
  })
  
}
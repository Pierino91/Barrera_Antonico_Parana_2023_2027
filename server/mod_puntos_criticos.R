# =============================================================================
# server/mod_puntos_criticos.R - Módulo para la pestaña "Puntos críticos"
# =============================================================================

mod_puntos_criticos_server <- function(input, output, session, datos_observacion) {
  
  output$mapa_puntos_criticos <- renderLeaflet({
    datos <- datos_observacion() %>%
      filter(!is.na(longitud_pto_critico) & !is.na(latitud_pto_critico)) %>%
      select(Fecha, longitud_pto_critico, latitud_pto_critico, Foto_pto_crit, Video_pto_crit, Obs_pto_crit)
    
    if (is.null(datos) || nrow(datos) == 0) {
      leaflet() %>%
        addTiles() %>%
        addPopups(lng = 0, lat = 0, popup = "Sin datos georreferenciados")
    } else {
      datos_sf <- datos %>%
        st_as_sf(coords = c("longitud_pto_critico", "latitud_pto_critico"), crs = 4326,
                 remove = FALSE, na.fail = FALSE)
      leaflet() %>%
        addTiles() %>%
        addCircleMarkers(
          data = datos_sf,
          radius = 3,
          color = "#4caf50",
          fillOpacity = 0.7,
          popup = ~paste0(
            "<br>Fecha: ", Fecha,
            "<br>Observación: ", Obs_pto_crit,
            "<br><img src='", Foto_pto_crit, "' width='192' height='256'>"
          )
        )
    }
  })
  
}
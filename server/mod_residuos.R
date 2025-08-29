# =============================================================================
# server/mod_residuos.R - Módulo para la pestaña "Residuos"
# =============================================================================

mod_residuos_server <- function(input, output, session, datos_observacion) {
  
  output$mensaje_residuos <- renderUI({
    datos <- datos_observacion()
    if (is.null(datos) || nrow(datos) == 0) {
      tags$p("No hay datos para mostrar")
    } else {
      NULL  # No muestra mensaje si hay datos
    }
  })
  
  output$grafico_tiempo <- renderPlotly({
    datos <- datos_observacion() %>%
      select(RSU, Patologico, REGU, Peligrosos, Fecha) %>%
      pivot_longer(
        cols = c(RSU, Patologico, REGU, Peligrosos),
        names_to = "tipo",
        values_to = "cantidad"
      ) %>%
      mutate(
        tipo = factor(tipo),
        cantidad = as.numeric(cantidad)
      )
    
    datos_acumulados <- datos %>%
      group_by(Fecha) %>%
      reframe(cantidad_total = sum(cantidad, na.rm = TRUE)) %>%
      arrange(Fecha) %>%
      mutate(acumulado = cumsum(cantidad_total))
    
    if (is.null(datos) || nrow(datos) == 0) {
      plot_ly() |> 
        layout(
          annotations = list(
            text = "Sin datos disponibles",
            x = 0.5,
            y = 0.5,
            showarrow = FALSE,
            font = list(size = 20)
          ),
          xaxis = list(showticklabels = FALSE, zeroline = FALSE),
          yaxis = list(showticklabels = FALSE, zeroline = FALSE)
        )
    } else {
      plot_ly() |> 
        add_bars(
          data = datos,
          x = ~Fecha,
          y = ~cantidad,
          color = ~tipo,
          colors = "Set2",
          name = ~tipo,
          opacity = 0.7
        ) |>
        add_lines(
          data = datos_acumulados,
          x = ~Fecha,
          y = ~acumulado,
          name = "Acumulado",
          line = list(width = 2, color = 'black')
        ) |>
        add_markers(
          data = datos_acumulados,
          x = ~Fecha,
          y = ~acumulado,
          name = "Puntos Acumulado",
          marker = list(size = 6, color = 'black')
        ) |>
        layout(
          xaxis = list(title = "Fecha"),
          yaxis = list(title = "Cantidad"),
          showlegend = FALSE,
          barmode = 'stack'
        )
    }
  })
  
}
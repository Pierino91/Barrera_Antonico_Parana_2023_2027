source("global.R")
source("functionEpicollect.R")

function(input, output, session) {

  auto_update <- reactiveTimer(REFRESH_MIN *
                                 60 * 
                                 100
                               )

  datos_branch <- reactive({
    auto_update()  # Actualiza cada vez que el timer se activa
    # Obtener el primer enlace del endpoint
    tryCatch({
      first_link <- get_data(ENDPOINT_EPICOLLECT_PUNTOS_CRITICOS)$links$first
      datos <- get_all_entries(first_link)
      # Si no es dataframe o viene vacío, devolvés NULL
      if (is.null(datos) || nrow(datos) == 0) {
        return(NULL)
      }

      return(datos)
    }, error = function(e) {
      # Podrías agregar un log o mensaje interno aquí
      warning("Error al obtener los datos: ", conditionMessage(e))
      return(NULL)
    })
  })
  
  datos_entradas <- reactive({
    auto_update()  # Actualiza cada vez que el timer se activa
    # Obtener el primer enlace del endpoint
    tryCatch({
      first_link <- get_data(ENDPOINT_EPICOLLECT_ENTRY)$links$first
      datos <- get_all_entries(first_link)
       # datos_tec <- get_all_entries(first_link)
      # Si no es dataframe o viene vacío, devolvés NULL
      if (is.null(datos) || nrow(datos) == 0) {
        return(NULL)
      }

      return(datos)
    }, error = function(e) {
      # Podrías agregar un log o mensaje interno aquí
      warning("Error al obtener los datos: ", conditionMessage(e))
      return(NULL)
    })
  })
  
  datos_observacion <- reactive({
    datos <- datos_branch()
    datos_tec <- datos_entradas()

    if (is.null(datos)) return(NULL)
    datos_Observacion <-
      datos_tec %>%
      left_join(datos, by = c("ec5_uuid" = "ec5_branch_owner_uuid"))%>%
      rename_with(~ gsub("^\\d+_", "", .x))%>%
      rename(
        Estado_barrera = "Estado_de_la_barre",
        
        latitud_pto_critico = "latitude.y",
        longitud_pto_critico = "longitude.y",
        Foto_pto_crit ="Foto__Punto_crtic",
        Video_pto_crit ="Video__Punto_crti",
        Obs_pto_crit ="Obs__Punto_crtico",
        
        Foto_Obs = "Foto_observacin",
        Video_Obs = "Video_observacin",
        Obs = "Observacin",
        RSU = "RSU",
        Patologico = "Patolgico",
        REGU = "REGU",
        Peligrosos = "Peligrosos"
        
      #   edad = "Edad_meses",
      #   altura = "Altura_cm",
      #   obs = "Observacion",
      #   origen = "Origen",
      #   lugar_especifico = "Tipo_de_intervenc",
      #   sitio = "Lugar",
      #   otro_sitio ="Si_eligi_otro_siti",
      #   fecha_plantado = "Fecha_plantado",
      #   agente = "Agente",
      #   momento_relevado_arbol = "created_at.x"
      )%>%
      select(Estado_barrera,
             Foto_Obs, Video_Obs, Obs,
             longitud_pto_critico, latitud_pto_critico, Foto_pto_crit, Video_pto_crit, Obs_pto_crit,
             RSU, Patologico, REGU, Peligrosos,
             Fecha
      )%>%
      mutate(
        Fecha = dmy(Fecha),
        RSU=as.numeric(RSU),
        Patologico = as.numeric(Patologico),
        REGU= as.numeric(REGU),
        Peligrosos= as.numeric(Peligrosos)
      )

  })

  #### MONITOR ####
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
    
    datos <- datos_observacion()%>%
      arrange(Fecha)%>%
      slice_tail(n = 1)
    
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
    
    datos <- datos_observacion()%>%
      reframe(total=sum(RSU, na.rm = TRUE)+
                sum(Patologico, na.rm = TRUE)+
                sum(REGU, na.rm = TRUE)+
                sum(Peligrosos, na.rm = TRUE))
    
    total_residuos_retenidos <- if (!is.null(datos) && nrow(datos) > 0) {
      datos
    } else {
      "Sin datos"
    }
    tags$h3(style = "font-size: 32px; margin: 0;", paste0(total_residuos_retenidos), " kg")
    
  })

#### PUNTOS CRÍTICOS ####
  
  output$mapa_puntos_criticos <- renderLeaflet({
    datos <- datos_observacion()%>%
      filter(!is.na(longitud_pto_critico) & !is.na(latitud_pto_critico)) %>%
      select(Fecha, longitud_pto_critico, latitud_pto_critico, Foto_pto_crit, Video_pto_crit, Obs_pto_crit)

    
    if (is.null(datos) || nrow(datos) == 0) {
      leaflet() %>%
        addTiles() %>%
            addPopups(., lng = 0, lat = 0, popup = "Sin datos georreferenciados")} 
    else {
      
      datos <- datos %>%
        st_as_sf(coords = c("longitud_pto_critico", "latitud_pto_critico"), crs = 4326,
                 remove = FALSE,
                 na.fail = FALSE  # permite NAs
                 )
      
      leaflet() %>%
        addTiles() %>%
          addCircleMarkers(
              .,
              data = datos,
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
  
#### RESIDUOS ####
  
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
    # datos <- datos_Observacion %>%
      select(RSU, Patologico, REGU, Peligrosos, Fecha)%>%
      pivot_longer(
        cols = c(RSU, Patologico, REGU, Peligrosos),        # todas las columnas seleccionadas
        names_to = "tipo",          # la nueva columna que contendrá los nombres
        values_to = "cantidad"             # la nueva columna que contendrá los valores
      )%>%
      mutate(
        tipo = factor(tipo),
        cantidad = as.numeric(cantidad)
      )
    
    datos_acumulados <- 
      datos %>%
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
          name =  ~tipo,
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

#### DOCUMENTACION ####

  output$mensaje_tabla <- renderUI({
    datos <- datos_observacion()
    if (is.null(datos) || nrow(datos) == 0) {
      tags$p("No hay datos para mostrar")
    } else {
      NULL  # No muestra mensaje si hay datos
    }
  })
  
  output$tabla <- renderReactable({
    
    datos <- datos_observacion()%>%
      select(
        Fecha, Foto_Obs, Video_Obs, Obs
      )%>%
      filter(
        Foto_Obs != "" &
        Video_Obs != "" &
        Obs != "" 
      )%>%
      mutate(
        Foto_Obs  = paste0("<img src='", Foto_Obs, "' width='120'/>"),
        Video_Obs = paste0(
          "<iframe width='320' height='180' src='", Video_Obs, 
          "' frameborder='0' allowfullscreen></iframe>"
        )
      )%>%
      rename("Foto de observación"= Foto_Obs,
            "Video de observación"  = Video_Obs,
            "Observación" = Obs
      )

    if (is.null(datos) || nrow(datos) == 0) {
      return(NULL)
    }
    reactable(datos,
              columns = list(
                `Foto de observación` = colDef(html = TRUE), # activar HTML en esta columna
                `Video de observación` = colDef(html = TRUE)
                )
              )
  })

  

  
  
  
  
  
  
  
  
  
  
}
# =============================================================================
# functionEpicollect.R - Funciones para la obtención y manejo de datos Epicollect5
# =============================================================================

library(httr)
library(jsonlite)
library(dplyr)
library(purrr)
library(tibble)

# ----------- FUNCIONES DE CARGA DE DATOS API ----------- #

# Obtiene el contenido JSON de un endpoint Epicollect5
get_data <- function(url) {
  response <- GET(url)
  if (status_code(response) == 200) {
    content <- fromJSON(content(response, as = "text"))
    return(content)
  } else {
    warning(paste("Error al acceder al enlace:", url, " - Código de estado: ", status_code(response)))
    return(NULL)
  }
}

# Descarga todas las entradas de Epicollect5 recorriendo paginación (optimizada)
get_all_entries <- function(base_url) {
  all_entries <- list()
  all_lugar <- list()
  url_actual <- base_url
  count <- 1
  
  repeat {
    datos <- get_data(url_actual)
    if (is.null(datos)) break
    
    if (!is.null(datos$data$entries)) {
      entries <- as_tibble(datos$data$entries)
      # Convertir columnas numéricas a character para evitar problemas de tipo
      entries <- mutate(entries, across(where(is.numeric), as.character))
      # Procesar posibles columnas de ubicación
      col_lugar <- names(entries)[sapply(entries, is.list)]
      if (length(col_lugar) > 0) {
        lugar_df <- entries[col_lugar] %>%
          map_dfr(~ tibble(
            latitude = as.character(.x$latitude),
            longitude = as.character(.x$longitude),
            accuracy = as.character(.x$accuracy)
          ))
        all_lugar[[count]] <- lugar_df
        entries <- select(entries, -all_of(col_lugar))
      }
      all_entries[[count]] <- entries
      count <- count + 1
    }
    
    next_link <- datos$links$`next`
    if (is.null(next_link)) break
    url_actual <- next_link
    Sys.sleep(1)  # Evita saturar el endpoint
  }
  
  # Combina y retorna los datos
  entries_final <- bind_rows(all_entries)
  lugar_final <- bind_rows(all_lugar)
  if (nrow(lugar_final) > 0) {
    return(bind_cols(entries_final, lugar_final))
  } else {
    return(entries_final)
  }
}

# Función principal recomendada para obtener datos validados desde Epicollect5
obtener_datos_epicollect <- function(endpoint_url) {
  contenido <- get_data(endpoint_url)
  if (is.null(contenido) || is.null(contenido$links$first)) {
    warning("No se encontró enlace 'first' en el endpoint: ", endpoint_url)
    return(NULL)
  }
  datos <- get_all_entries(contenido$links$first)
  if (is.null(datos) || nrow(datos) == 0) {
    warning("No se encontraron datos válidos en el endpoint: ", endpoint_url)
    return(NULL)
  }
  return(datos)
}


# =============================================================================
# FIN DEL ARCHIVO
# =============================================================================
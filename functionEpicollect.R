#### Funciones ####

library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(bsicons)
library(bslib)
library(htmltools)
library(readr)
library(purrr)
library(dplyr)
library(ggplot2)
library(httr)
library(jsonlite)


# ----------- FUNCIONES DE CARGA DE DATOS API ----------- #

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



get_all_entries <- function(base_url) {
  
  all_entries <- tibble()  # Inicializar el tibble vacío
  all_lugar <- tibble()    # Inicializar el tibble para coordenadas si existen
  
  # Obtener el primer conjunto de datos
  operarios_crudo_get <- get_data(base_url)

  while (!is.null(operarios_crudo_get$links$self)) {
    
    if (!is.null(operarios_crudo_get$data$entries)) {
      
      # Convertir a tibble
      entries <- as_tibble(operarios_crudo_get$data$entries)
      
      # Convertir todas las columnas numéricas a character
      entries <- entries %>%
        mutate(across(where(is.numeric), as.character))
      
      # Detectar si hay una columna con datos de ubicación y procesarla
      col_lugar <- names(entries)[sapply(entries, is.list)]  
      
      if (length(col_lugar) > 0) {
        # Extraer datos de latitud, longitud y precisión
        lugar_df <- entries[col_lugar] %>%
          map_dfr(~ tibble(
            latitude = as.character(.x$latitude),
            longitude = as.character(.x$longitude),
            accuracy = as.character(.x$accuracy)
          ))
        
        all_lugar <- bind_rows(all_lugar, lugar_df)
        
        # Eliminar la columna de ubicación del dataframe original
        entries <- select(entries, -all_of(col_lugar))
        
      }
      
      # Acumular los datos
      all_entries <- bind_rows(all_entries, entries)
    }
    
    # Obtener el siguiente enlace
    next_link <- operarios_crudo_get$links$`next`
    
    # Si no hay más páginas, salir del bucle
    if (is.null(next_link)) {
      break
    }
    
    # Obtener el siguiente conjunto de datos
    operarios_crudo_get <- get_data(next_link)
    Sys.sleep(1)
  }
  
  # Retornar los datos combinados si existe información de ubicación
  if (nrow(all_lugar) > 0) {
    return(cbind(all_entries, all_lugar))
  } else {
    return(all_entries)
  }
}
#################################################

# ----------- TEMA DE VISUALIZACIÓN ----------- #

tema <- 
  theme(
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



#### 
# Link_ 
# para unir los datos############################



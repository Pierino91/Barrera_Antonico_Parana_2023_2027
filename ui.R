library(bs4Dash)
library(shiny)

source("global.R")
source("functionEpicollect.R")

ui <- bs4DashPage(
  title = "Barrera retención de residuos - 2023 a 2027 - Subsecretaría de Ambiente",
  
  header = bs4DashNavbar(skin = "light", status = "success"),
  
  sidebar = bs4DashSidebar(
    skin = "light",
    status = "success",
    title = "Monitor Barrera Antoñico",
    bs4SidebarMenu(
      bs4SidebarMenuItem("Monitor", 
                         tabName = "Monitor", 
                         icon = icon("tv")),
    bs4SidebarMenuItem("Residuos", 
                       tabName = "Residuos", 
                       icon = icon("trash")),
    bs4SidebarMenuItem("Puntos críticos", 
                       tabName = "PtosCriticos", 
                       icon = icon("map")),
    bs4SidebarMenuItem("Observaciones", 
                       tabName = "Obs", 
                       icon = icon("eye"))
    ),
  ),
  body = bs4DashBody(
    bs4TabItems(
      bs4TabItem(
        tabName = "Monitor",
        h2("Resumen Semanal"),
        fluidRow(
          # Última actualización
          bs4Card(
            title = tagList(icon("calendar-alt"), 
                            "Última actualización"),
            status = "info",
            solidHeader = TRUE,
            collapsible = FALSE,
            width = 6,
            tags$div(
              style = "font-size: 30px; font-weight: bold; text-align: center;",
              uiOutput("fecha_max")
            )
          ),
          bs4Card(
            title = tagList(icon("road-barrier"), "Estado de la barrera"),
            status = "primary",      # queda fijo
            solidHeader = TRUE,
            collapsible = FALSE,
            width = 6,
            uiOutput("estado_barrera")
          ),
          bs4Card(
            title = tagList(icon("recycle"), 
                            "Residuos totales retenido"),
            status = "olive",
            solidHeader = TRUE,
            collapsible = FALSE,
            width = 6,
            tags$div(
              style = "font-size: 30px; font-weight: bold; text-align: center;",
              uiOutput("total_residuos_retenidos")
            )
          ),
          bs4Card(
            title = tagList(icon("water"), 
                            "Calidad de agua"),
            status = "lightblue",
            solidHeader = TRUE,
            collapsible = FALSE,
            width = 6,
            tags$div(
              # style = "font-size: 30px; font-weight: bold; text-align: center;",
              # uiOutput("fecha_max")
            )
          )
        ),
        tags$div(
          style = "text-align: center;",
          tags$img(src = "multimedia/Logo-Municipalidad.png", width = "50%")
        )
      ),
      bs4TabItem(
        tabName = "Residuos",
        h2("Residuos retenidos por la barrera"),
        
        box(
          title = "",
          status = "success",
          solidHeader = TRUE,
          width = 12,
          uiOutput("mensaje_residuos"),
          plotlyOutput("grafico_tiempo", height = "300px")
        ),
        
        
        tags$div(
          style = "text-align: center;",
          tags$img(src = "multimedia/Logo-Municipalidad.png", width = "50%")
        )
      ),
      bs4TabItem(
        tabName = "PtosCriticos",
        h2("Puntos críticos"),
        
        box(
          # title = "Puntos críticos",
          status = "success",
          solidHeader = TRUE,
          width = 12,
          leafletOutput("mapa_puntos_criticos", height = "600px"),
        ),  
        
        tags$div(
          style = "text-align: center;",
          tags$img(src = "multimedia/Logo-Municipalidad.png", width = "50%")
        )
      ),
      bs4TabItem(
        tabName = "Obs",
        h2("Documentación"),
        box(
          title = "",
          status = "success",
          solidHeader = TRUE,
          width = 12,
          uiOutput("mensaje_tabla"),
          reactableOutput("tabla")
        ),   
        tags$div(
          style = "text-align: center;",
          tags$img(src = "multimedia/Logo-Municipalidad.png", width = "50%")
        )
      )
    )
  )
)

# # install.packages('rsconnect')
# 
# library(rsconnect)
# rsconnect::setAccountInfo(name='secretaria-de-ambiente-y-salud',
#                           token='59A4D29D0B62C7DC32941F343F767900',
#                           secret='67dK/Pwf3vnv46IiKiftaxO7xjhg1Sfz8m00TwhY')
# 
# 
# rsconnect::deployApp(appName="Barrera_Antonico_2023_2027")


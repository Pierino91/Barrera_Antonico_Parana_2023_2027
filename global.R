
library(reactable)
library(leaflet)
library(sf)
library(lubridate)
library(plotly)
library(dplyr)
library(tidyr)

# library(leafpop)



##### LINK EPICOLLECT

ENDPOINT_EPICOLLECT_ENTRY <- 
  "https://five.epicollect.net/api/export/entries/plan-de-manejo-de-barrera-del-arroyo-antonico?form_ref=15b0d62c918b47c6b3ae8a5f127857cd_6895db4e0b6c2"
ENDPOINT_EPICOLLECT_PUNTOS_CRITICOS <-
  "https://five.epicollect.net/api/export/entries/plan-de-manejo-de-barrera-del-arroyo-antonico?form_ref=15b0d62c918b47c6b3ae8a5f127857cd_6895db4e0b6c2&branch_ref=15b0d62c918b47c6b3ae8a5f127857cd_6895db4e0b6c2_6895dd62da036"

REFRESH_MIN <- 60

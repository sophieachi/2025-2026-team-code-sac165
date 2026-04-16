library(shiny)
library(tidyverse)
library(lubridate)
library(plotly)
library(readr)
library(readxl)

setwd("C:/Users/annab/OneDrive/Desktop/Summer2026VisualizationTool")

# Load data
# CMAST
cmast_do <- read_excel("Cleaned/CMAST_DO_Cleaned.xlsx") %>%
  mutate(DateTime = ymd_hms(DateTime),
         DO = as.numeric(DomgL),
         Temp_C = as.numeric(Temp_C),
         Farm = "CMAST") %>%
  select(DateTime, Farm, DO, Temp_C)

cmast_ph <- read_excel("Cleaned/CMAST_pH_Cleaned.xlsx") %>%
  mutate(DateTime = ymd_hms(DateTime),
         pH = as.numeric(pH),
         Farm = "CMAST") %>%
  select(DateTime, Farm, Temp_C)

cmast_sal <- read_excel("Cleaned/CMAST_Con_Cleaned.xlsx") %>%
  mutate(DateTime = ymd_hms(DateTime),
         Salinity = as.numeric(Sal_ppt),
         Farm = "CMAST") %>%
  select(DateTime, Farm, Temp_C)

# Stump Sound
stump_do <- read_excel("Cleaned/StumpSound_DO_Cleaned.xlsx") %>%
  mutate(DateTime = ymd_hms(DateTime),
         DO = as.numeric(DomgL),
         Temp_C = as.numeric(Temp_C),
         Farm = "Stump Sound") %>%
  select(DateTime, Farm, Temp_C)

stump_ph <- read_excel("Cleaned/StumpSound_pH_Cleaned.xlsx") %>%
  mutate(DateTime = ymd_hms(DateTime),
         pH = as.numeric(pH),
         Farm = "Stump Sound") %>%
  select(DateTime, Farm, Temp_C)

stump_sal <- read_excel("Cleaned/StumpSound_Con_Cleaned.xlsx") %>%
  mutate(DateTime = ymd_hms(DateTime),
         Salinity = as.numeric(Sal_ppt),
         Farm = "Stump Sound") %>%
  select(DateTime, Farm, Temp_C)

# Ward Creek
ward_do <- read_excel("Cleaned/WardCreek_DO_Cleaned.xlsx") %>%
  mutate(DateTime = ymd_hms(DateTime),
         DO = as.numeric(DomgL),
         Temp_C = as.numeric(Temp_C),
         Farm = "Ward Creek") %>%
  select(DateTime, Farm, DO, Temp_C)

ward_ph <- read_excel("Cleaned/WardCreek_pH_Cleaned.xlsx") %>%
  mutate(DateTime = ymd_hms(DateTime),
         pH = as.numeric(pH),
         Farm = "Ward Creek") %>%
  select(DateTime, Farm, Temp_C)

ward_sal <- read_excel("Cleaned/WardCreek_Con_Cleaned.xlsx") %>%
  mutate(DateTime = ymd_hms(DateTime),
         Salinity = as.numeric(Sal_ppt),
         Farm = "Ward Creek") %>%
  select(DateTime, Farm, Temp_C)

# DUML
duml_ph <- read_excel("Cleaned/DUML_pH_Cleaned.xlsx") %>%
  mutate(DateTime = ymd_hms(DateTime),
         pH = as.numeric(pH),
         Farm = "DUML") %>%
  select(DateTime, Farm, Temp_C)

duml_do <- read_excel("Cleaned/DUML_DO_Cleaned.xlsx") %>%
  mutate(DateTime = ymd_hms(DateTime),
         DO = as.numeric(DomgL),
         Temp_C = as.numeric(Temp_C),
         Farm = "DUML") %>%
  select(DateTime, Farm, DO, Temp_C)

duml_sal <- read_excel("Final Datasets/DUML_Con_Final.xlsx") %>%
  mutate(DateTime = ymd_hms(DateTime),
         Salinity = as.numeric(Sal_ppt),
         Farm = "DUML") %>%
  select(DateTime, Farm, Temp_C)

# Nelson Bay
nelson_do <- read_excel("Final Datasets/Nelson_DO_Final.xlsx") %>%
  mutate(DateTime = ymd_hms(DateTime),
         DO = as.numeric(DomgL),
         Temp_C = as.numeric(Temp_C),
         Farm = "Nelson Bay") %>%
  select(DateTime, Farm, DO, Temp_C)

nelson_ph <- read_excel("Final Datasets/Nelson_pH_Final.xlsx") %>%
  mutate(DateTime = ymd_hms(DateTime),
         pH = as.numeric(pH),
         Farm = "Nelson Bay") %>%
  select(DateTime, Farm, Temp_C)

nelson_sal <- read_excel("Final Datasets/Nelson_Con_Final.xlsx") %>%
  mutate(DateTime = ymd_hms(DateTime),
         Salinity = as.numeric(Sal_ppt),
         Farm = "Nelson Bay") %>%
  select(DateTime, Farm, Temp_C)

ysi <- read_excel("Final Datasets/YSITemp.xlsx") %>%
  mutate(DateTime = ymd_hms(DateTime),
         Temp_C = as.numeric(Temp_C),
         Farm = as.character(Farm)) %>%
  select(DateTime, Farm, Temp_C)

all_farms <- list(
  "CMAST" = list(
    do  = cmast_do,
    ph  = cmast_ph,
    sal = cmast_sal,
    ysi = ysi %>% filter(Farm == "CMAST")
  ),
  
  "Stump Sound" = list(
    do  = stump_do,
    ph  = stump_ph,
    sal = stump_sal,
    ysi = ysi %>% filter(Farm == "Stump Sound")
  ),
  
  "Ward Creek" = list(
    do  = ward_do,
    ph  = ward_ph,
    sal = ward_sal,
    ysi = ysi %>% filter(Farm == "Ward Creek")
  ),
  
  "DUML" = list(
    do  = duml_do,
    ph  = duml_ph,
    sal = duml_sal,
    ysi = ysi %>% filter(Farm == "DUML")
  ),
  
  "Nelson Bay" = list(
    do  = nelson_do,
    ph  = nelson_ph,
    sal = nelson_sal,
    ysi = ysi %>% filter(Farm == "Nelson Bay")
  )
)

colors <- c(
  "DO"  = "#ED665D",
  "pH"  = "#67BF5C",
  "Con" = "#729ECE",
  "YSI" = "#000000"
)

# UI
ui <- fluidPage(
  titlePanel("Temperature Variation Across Sensors"),
  tabsetPanel(
    tabPanel("DUML", plotlyOutput("plot_DUML",  height = "600px")),
    tabPanel("CMAST", plotlyOutput("plot_CMAST", height = "600px")),
    tabPanel("Stump Sound", plotlyOutput("plot_Stump", height = "600px")),
    tabPanel("Ward Creek", plotlyOutput("plot_Ward",  height = "600px")),
    tabPanel("Nelson Bay", plotlyOutput("plot_Nelson", height = "600px"))
  )
)

# server
server <- function(input, output) {
  
  render_farm_plot <- function(farm_name){
    p <- plot_ly()
    sensors <- all_farms[[farm_name]]
    
    # DO sensor
    if(!is.null(sensors$do)){
      p <- add_lines(p, x = sensors$do$DateTime, y = sensors$do$Temp_C,
                     name = "DO", line = list(color = colors["DO"]))
    }
    
    # pH sensor
    if(!is.null(sensors$ph)){
      p <- add_lines(p, x = sensors$ph$DateTime, y = sensors$ph$Temp_C,
                     name = "pH", line = list(color = colors["pH"]))
    }
    
    # conductivity sensor
    if(!is.null(sensors$sal)){
      p <- add_lines(p, x = sensors$sal$DateTime, y = sensors$sal$Temp_C,
                     name = "Con", line = list(color = colors["Con"]))
    }
    
    # YSI dATA
    if(!is.null(sensors$ysi) && nrow(sensors$ysi) > 0){
      p <- add_markers(p,
                       x = sensors$ysi$DateTime,
                       y = sensors$ysi$Temp_C,
                       name = "YSI",
                       marker = list(color = colors["YSI"], size = 6)
      )
    }
    
    p %>% layout(
      title = paste("Temperature Variation at", farm_name),
      xaxis = list(type = "date", title = "DateTime"),
      yaxis = list(title = "Temperature (°C)"),
      legend = list(title = list(text = "Sensor"))
    )
  }
  
  output$plot_CMAST  <- renderPlotly({ render_farm_plot("CMAST") })
  output$plot_Stump  <- renderPlotly({ render_farm_plot("Stump Sound") })
  output$plot_Ward   <- renderPlotly({ render_farm_plot("Ward Creek") })
  output$plot_DUML   <- renderPlotly({ render_farm_plot("DUML") })
  output$plot_Nelson <- renderPlotly({ render_farm_plot("Nelson Bay") })
}

# Run app
shinyApp(ui, server)
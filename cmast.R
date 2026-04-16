library(shiny)
library(tidyverse)
library(lubridate)
library(plotly)
library(readxl)

# Load data
# 2025
cmast_do_25 <- read_excel("C:/Users/annab/OneDrive/Desktop/Cleaned/CMAST_DO_Cleaned.xlsx") %>%
  mutate(
    DateTime = ymd_hms(DateTime)
  ) %>%
  filter(month(DateTime) %in% c(7, 8)) %>%
  mutate(
    Year = year(DateTime),
    OverlayTime = update(DateTime, year = 2000),
    DO = as.numeric(DomgL),
    Temp_C = as.numeric(Temp_C)
  ) %>%
  select(DateTime, OverlayTime, Year, DO, Temp_C)

cmast_ph_25 <- read_excel("C:/Users/annab/OneDrive/Desktop/Cleaned/CMAST_pH_Cleaned.xlsx") %>%
  mutate(
    DateTime = ymd_hms(DateTime)  
    ) %>%
  filter(month(DateTime) %in% c(7, 8)) %>%
  mutate(
    Year = year(DateTime),
    OverlayTime = update(DateTime, year = 2000),
    pH = as.numeric(pH)
  ) %>%
  select(DateTime, OverlayTime, Year, pH)

cmast_sal_25 <- read_excel("C:/Users/annab/OneDrive/Desktop/Cleaned/CMAST_Con_Cleaned.xlsx") %>%
  mutate(
    DateTime = ymd_hms(DateTime)
  ) %>%
  filter(month(DateTime) %in% c(7, 8)) %>%
  mutate(
    Year = year(DateTime),
    OverlayTime = update(DateTime, year = 2000),
    Salinity = as.numeric(Sal_ppt)
  ) %>%
  select(DateTime, OverlayTime, Year, Salinity)

# 2024
cmast_do_24 <- read_excel("C:/Users/annab/OneDrive/Desktop/DOsensor_2024.xlsx") %>%
  mutate(
    DateTime = ymd_hms(DateTime)
  ) %>%
  filter(month(DateTime) %in% c(7, 8)) %>%
  mutate(
    Year = year(DateTime),
    OverlayTime = update(DateTime, year = 2000),
    DO = as.numeric(DomgL),
    Temp_C = as.numeric(Temp_C)
  ) %>%
  select(DateTime, OverlayTime, Year, DO, Temp_C)

cmast_ph_24 <- read_excel("C:/Users/annab/OneDrive/Desktop/pH_2024.xlsx") %>%
  mutate(
    DateTime = ymd_hms(DateTime)
  ) %>%
  filter(month(DateTime) %in% c(7, 8)) %>%
  mutate(
    Year = year(DateTime),
    OverlayTime = update(DateTime, year = 2000),
    pH = as.numeric(pH)
  ) %>%
  select(DateTime, OverlayTime, Year, pH)

cmast_sal_24 <- read_excel("C:/Users/annab/OneDrive/Desktop/Salinity_2024.xlsx") %>%
  mutate(
    DateTime = ymd_hms(DateTime)
  ) %>%
  filter(month(DateTime) %in% c(7, 8)) %>%
  mutate(
    Year = year(DateTime),
    OverlayTime = update(DateTime, year = 2000),
    Salinity = as.numeric(Sal_ppt)
  ) %>%
  select(DateTime, OverlayTime, Year, Salinity)

# Combine years
cmast_do  <- bind_rows(cmast_do_24,  cmast_do_25)
cmast_ph  <- bind_rows(cmast_ph_24,  cmast_ph_25)
cmast_sal <- bind_rows(cmast_sal_24, cmast_sal_25)

param_list <- c("Temperature", "Dissolved Oxygen", "pH", "Salinity")

colors <- c(
  "Temperature 2024" = "#729ECE",
  "Dissolved Oxygen 2024" = "#ED665D",
  "pH 2024" = "#67BF5C",
  "Salinity 2024" = "#ED97CA",

  "Temperature 2025" = "#AD8BC9",
  "Dissolved Oxygen 2025" = "#CDCC5D",
  "pH 2025" = "#A8786E",
  "Salinity 2025" = "#FF9E4A"
)

# UI
ui <- fluidPage(
  titlePanel("CMAST 2024-25 Environmental Data"),
  
  sidebarLayout(
    sidebarPanel(
      
      h4("Select Parameters:"),
      checkboxGroupInput(
        "param_select",
        NULL,
        choices = param_list,
        selected = param_list
      ),
      
      br(),
      
      h4("Edit Plot Title:"),
      textInput(
        "custom_title",
        NULL,
        "CMAST Data"
      )
    ),
    
    mainPanel(
      plotlyOutput("plot", height = "650px")
    )
  )
)

server <- function(input, output) {
  
  output$plot <- renderPlotly({
    
    p <- plot_ly()
    
    params <- input$param_select
    
    show_param <- function(param_name) {
      param_name %in% params
    }
    
    add_overlay_lines <- function(p, data, yvar, label){
      
      # remove NA rows so plotly always gets valid x and y
      data <- data %>%
        filter(!is.na(OverlayTime), !is.na(.data[[yvar]]))
      
      for(yr in unique(data$Year)){
        
        df_year <- data %>% filter(Year == yr)
        
        if(nrow(df_year) > 0){
          
          trace_name <- paste(label, yr)
          trace_color <- colors[trace_name]
          
          p <- add_lines(
            p,
            x = df_year$OverlayTime,
            y = df_year[[yvar]],
            name = trace_name,
            line = list(color = trace_color)
          )
        }
      }
      
      return(p)
    }
    
    if(show_param("Temperature"))
      p <- add_overlay_lines(p, cmast_do, "Temp_C", "Temperature")
    
    if(show_param("Dissolved Oxygen"))
      p <- add_overlay_lines(p, cmast_do, "DO", "Dissolved Oxygen")
    
    if(show_param("pH"))
      p <- add_overlay_lines(p, cmast_ph, "pH", "pH")
    
    if(show_param("Salinity"))
      p <- add_overlay_lines(p, cmast_sal, "Salinity", "Salinity")
    
    p %>% layout(
      title = input$custom_title,
      xaxis = list(
        title = "Date",
        type = "date",
        tickformat = "%b %d",      # Shows "May 01"
        hoverformat = "%b %d"      # Removes 2000 in tooltip
      ),
      yaxis = list(title = "Value"),
      legend = list(title = list(text = "Parameter & Year"))
    )
  })
}

shinyApp(ui, server)
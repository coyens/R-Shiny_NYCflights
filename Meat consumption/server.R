
library(shiny)
library(dplyr)
library(ggplot2)
library(leaflet)
library(ggthemes)
library(tidyverse)
library(purrr)
library(tidyr)


data <- read_csv("https://raw.githubusercontent.com/coyens/Shiny-projects-R-/master/Meat%20consumption/per-capita-meat-consumption-by-type-kilograms-per-year.csv")


regions <- c("Africa",	"Americas",	"Asia",	"Caribbean",	"Central America",	"Central Asia",	"Eastern Africa",	"Eastern Asia",	"Eastern Europe",	"Europe",	"European Union",	"South America",	"South-Eastern Asia",	"Southern Africa",	"Southern Asia",	"Southern Europe,	Western Africa",	"Western Asia",	"Western Europe",	"Northern Africa",	"Northern America",	"Northern Europe",	"Oceania	Micronesia",	"Middle Africa")

data_gat <-gather(data, meat, meat_weight, - Entity, -Code, -Year)


data_gat <- data_gat  %>% 
  mutate(region_or_country = case_when(
    grepl(regions, Entity)~ "region",
    ! grepl(regions, Entity)~ "country"))
##################################################


shinyServer(function(input, output, session) {
  
  aggData <- reactive({
    meat_con <- data_gat %>%  #modflights =data_gat, aggDelay = meat_con
      filter(Entity %in% input$regionName)  
    meat_con
  })
  
  output$delay_plot <- renderPlot({
    
    # Create a plot
    ggplot(aggData(), aes(Year, meat_weight, color = meat)) + 
      geom_line() +
      theme_hc(base_size = 18) + 
      scale_fill_hc() +
      xlab("Year") +
      ylab("Meat pcomsumtion (kg)") 

  })
  
  output$delay_table <- renderTable({
    aggData() %>% 
      group_by(Entity, Year) %>%
      mutate(
        suma = sum(meat_weight)
      ) %>% 
      rename(
        "Airline" = Year
      )
    
  })
  
})
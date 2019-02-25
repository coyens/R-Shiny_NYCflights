library(nycflights13)
library(shiny)
library(dplyr)
library(ggplot2)
library(ggthemes)
library(tidyverse)

nobel <- read_csv("datasets/nobel.csv")

#£¹czenie tabel
joinFlights <- inner_join(flights, airlines, by = 'carrier')

#wybór linii lotniczych (10 najczêstrzych)
Carriers_10 <- joinFlights %>%
  count(name) %>%
  arrange(desc(n)) %>%
  head(10)

#Usuniêcie NA
joinFlights <- joinFlights %>%
  filter(!is.na(dep_delay), name %in% Carriers_10$name)




function(input, output, session){
  
  aggData <- reactive({
    aggDelayFlights <- joinFlights %>%  #kod zaimplementowany do reactive
      filter(name %in% input$car) %>% # robi wykres interaktywnym, nazwe wybieramy z listy
      group_by(name, hour) %>% 
      summarise(delayed_flight_perc = sum(dep_delay > input$Delaymin[1] & 
                                            dep_delay < input$Delaymin[2] &
                                            distance > input$dystans) / n())  # Tutaj wybieramy zakres opznienia, min i max 
    aggDelayFlights
  })
  
  output$delay_plot <- renderPlot({
    
    # Create a plot
    ggplot(aggData(), aes(hour, delayed_flight_perc, fill = name)) + 
      geom_col(position = 'dodge') +
      theme_hc(base_size = 18) + 
      scale_fill_hc() +
      xlab("Hour") +
      ylab("Percentage of delayed flights") +
      scale_y_continuous(labels = scales::percent) +
      scale_x_continuous(limits = c(0,24), breaks = seq(0, 24, 2))   
  }) 
  
  output$tabela <- renderTable ({
    aggData()
    
    
  })
}

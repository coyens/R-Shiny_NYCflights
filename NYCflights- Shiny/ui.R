library(nycflights13)
library(shiny)
library(dplyr)
library(ggplot2)
library(ggthemes)

flights <- flights
airlines <- airlines

#Łączenie tabel
joinFlights <- inner_join(flights, airlines, by = 'carrier')

#wybór linii lotniczych (10 najczęstrzych)
Carriers_10 <- joinFlights %>%
  count(name) %>%
  arrange(desc(n)) %>%
  head(10)

#Usunięcie NA
joinFlights <- joinFlights %>%
  filter(!is.na(dep_delay), name %in% Carriers_10$name)






fluidPage(
  titlePanel("Analiza opóźnienia"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "car",
        label = "Wybierz linie lotnicze",
        choices = Carriers_10$name,
        selected = Carriers_10$name[1],
        multiple = TRUE
      ),
      numericInput(
        inputId = "dystans",
        label = "dystans lotu",
        value = 500
      ),
      sliderInput(
        inputId = "Delaymin",
        label = "",
        min = 0, max = 1000,
        value = c(50,1000)
      )
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Delay over day",
                 plotOutput(outputId = "delay_plot")
        ),
        tabPanel("Explore data",
                 tableOutput("tabela"))
      )
    )
  )
)

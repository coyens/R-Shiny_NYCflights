################################################################################
# A file including user interface (UI) code

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
################################################################################

fluidPage(
  titlePanel(""),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "regionName",
        label = "Select region/country",
        selected = "World",
        choices = data_gat$Entity,
        multiple = FALSE
      ),
      numericInput(
        inputId = "distanceVal",
        label = "",
        value = 500
      ),
      sliderInput(
        inputId = "delayRange",
        label = "",
        min = 0, max = 1000,
        value = c(0,1000)
      )
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Delay over day",
                 plotOutput(outputId = "delay_plot")
        ),
        tabPanel("Explore data",
                 tableOutput("delay_table")
        )
      )
    )
  )
)


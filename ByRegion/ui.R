require(raster)
require(rgdal)
library(dplyr)

df <- read.csv(file="https://raw.githubusercontent.com/scottkarr/IS608FinalProject/master/data/ELAScoresBySchool.csv", header=TRUE, sep=",",stringsAsFactors=FALSE)


# Define UI for application that draws a histogram
shinyUI(
  fluidPage(
    # Application title
    titlePanel("State Test Scores"),
    # Generate a row with a sidebar
    sidebarLayout(
      # Define the sidebar with three input
      sidebarPanel(
        selectInput("select", label = h5("Select Test"), 
                    choices = list("ELA" = 1, "Math" = 2), 
                    selected = 1),
        selectInput('year', 'Year', sort(unique(as.character(df$Year)), decreasing=TRUE), selected='2016'),
        selectInput('grade', 'Grade', unique(as.character(df$Grade)), selected='7')
      ),
      
      mainPanel(
        tabsetPanel(type = "tabs", 
                    tabPanel("Plot", plotOutput("plot1")), 
                    tabPanel("Summary", verbatimTextOutput("summary")), 
                    tabPanel("Table", tableOutput("table"))
        )
      )
    )
  )
)

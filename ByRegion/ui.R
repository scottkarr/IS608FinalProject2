require(raster)
require(rgdal)
library(dplyr)

df <- read.csv(file="https://raw.githubusercontent.com/scottkarr/IS608FinalProject2/master/data/ELAScoresBySchool.csv", header=TRUE, sep=",",stringsAsFactors=FALSE)
df$Test      <- 'ELA'
df2 <- read.csv(file="https://raw.githubusercontent.com/scottkarr/IS608FinalProject2/master/data/MathScoresBySchool.csv", header=TRUE, sep=",",stringsAsFactors=FALSE)
df2$Test      <- 'Math'
df <- rbind(df,df2)

# Define UI for application that draws a histogram
shinyUI(
  fluidPage(
    # Application title
    titlePanel("State Test Scores"),
    # Generate a row with a sidebar
    sidebarLayout(
      # Define the sidebar with three input
      sidebarPanel(
        selectInput('test', 'Test', sort(unique(df$Test), decreasing=TRUE), selected='ELA'),
        selectInput('year', 'Year', sort(unique(as.character(df$Year)), decreasing=TRUE), selected='2016'),
        selectInput('grade', 'Grade', unique(as.character(df$Grade)), selected='8')
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

library(raster)
library(rgdal)
library(dplyr)
library(ggplot2)
library(colorspace)

df <- read.csv(file="https://raw.githubusercontent.com/scottkarr/IS608FinalProject2/master/data/ELAScoresBySchool.csv", header=TRUE, sep=",",stringsAsFactors=FALSE)
df$Test      <- 'ELA'
df2 <- read.csv(file="https://raw.githubusercontent.com/scottkarr/IS608FinalProject2/master/data/MathScoresBySchool.csv", header=TRUE, sep=",",stringsAsFactors=FALSE)
df2$Test      <- 'Math'
df <- rbind(df,df2)

# create a local directory for the data
localDir <- "nysd_17a"
if (!file.exists(localDir)) {
  dir.create(localDir)
}

# download and unzip the data
url <- "https://github.com/scottkarr/IS608FinalProject2/blob/master/nysd_17a.zip"
file <- paste(localDir, basename(url), sep='/')
if (!file.exists(file)) {
  download.file(url, file)
  path <- paste(getwd(),"nysd_17a/nysd_17a.zip",sep='/')
  shpdir <- paste(getwd(),"nysd_17a",sep='/')
  unzip(path)
}


# create a layer name for the shapefiles (text before file extension)
layerName <- "nysd"

shinyServer(
  function(input, output) {
      
      selectedData <- reactive({
        
        dfSlice <- df %>%
          filter(Test == input$test, Year == input$year, Grade == input$grade)
        
        dfSlice <- dfSlice[,c(2,4,7,8,20,21)]
        dfSlice <- dfSlice[complete.cases(dfSlice),]

    })

    output$plot1 <- renderPlot({
      
      # read data into a SpatialPolygonsDataFrame object
      shpfile <- readOGR(shpdir, "nysd")
      
      dfSlice <- df %>%
        filter(Test == input$test, Year == input$year, Grade == input$grade)
      
      dfSlice <- dfSlice[,c(2,4,7,8,20,21)]
      dfSlice <- dfSlice[complete.cases(dfSlice),]
        
      dfSum <- dfSlice %>% 
        group_by (Borough, District) %>%
        summarize(Pass = mean(as.numeric(Lvl_Pass_Pct), na.rm = TRUE))
      
      shpfile@data <- left_join(shpfile@data, dfSum, by=c("SchoolDist" = "District"))
      spplot(shpfile, z="Pass",  main = "New York City", sub = "ELA Pass Rate Pct by School District")
    })
    
    
    # Generate a summary of the data
    output$summary <- renderPrint({
      summary(selectedData())
    })
    
    # Generate an HTML table view of the data
    output$table <- renderTable({
      
      dfSlice <- df %>%
        filter(Test == input$test, Year == input$year, Grade == input$grade)
      
      data.frame(x=selectedData())
    })
  }
)
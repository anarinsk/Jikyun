# Data Prepare 

library(dplyr)
library(ggplot2)

load("src.RData")


#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
my_ggfont <- "AppleMyungjo"

# Define UI for application that draws a histogram
ui <- shinyUI(fluidPage(
   
   # Application title
   titlePanel("Loneliness in Variety"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
       
         sliderInput("year",
                     "Range of years:",
                     min = 1999,
                     max = 2008, 
                     value = 1999, 
                     sep ="",
                     tick = FALSE,
                     animate=animationOptions(interval=600, loop=F))
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("distPlot")
      )
   )
))

# Define server logic required to draw a histogram
server <- shinyServer(function(input, output) {
   
   output$distPlot <- renderPlot({
      # generate bins based on input$bins from ui.R
      my_hist(tdf, input$year)
   })
})

# Run the application 
shinyApp(ui = ui, server = server)


library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    # Application title
    titlePanel("Hello Shiny!"),
    
    # Sidebar with a slider input for the number of bins
    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30),
            dateRangeInput("predates", 
                           label = "Pre-Experiment Period",
                           start = Sys.Date()-28,
                           end = Sys.Date()-15),
            dateRangeInput("postdates", 
                           label = "Experiment Period",
                           start = Sys.Date()-14,
                           end = Sys.Date()),
            fileInput('file1', 'Choose file to upload',
                      accept = c(
                          'text/csv',
                          'text/comma-separated-values',
                          '.csv'
                      )
            )
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("distPlot"),
            tableOutput('contents'),
            verbatimTextOutput("prevalue"),
            verbatimTextOutput("postvalue"),
            plotOutput("impact")
        )
    )
))
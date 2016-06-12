library(shiny)

# Define UI for application that draws a histogram
shinyUI(
    
    shinyUI(
        
   navbarPage("Lift Calculator",
    tabPanel("Impact Analysis",
        sidebarLayout(
            sidebarPanel(
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
            mainPanel(
                verbatimTextOutput("prevalue"),
                verbatimTextOutput("postvalue"),
                plotOutput("impactPlot"),
                verbatimTextOutput("impactReport")
            )
        )
    ),
    tabPanel("Summary",
             verbatimTextOutput("prevalue")
    )
    )

#     fluidPage(
#     
#     # Application title
#     titlePanel("Lift Calculator"),
#     
#     # Sidebar with a slider input for the number of bins
#     sidebarLayout(
#         sidebarPanel(
#             dateRangeInput("predates", 
#                            label = "Pre-Experiment Period",
#                            start = Sys.Date()-28,
#                            end = Sys.Date()-15),
#             dateRangeInput("postdates", 
#                            label = "Experiment Period",
#                            start = Sys.Date()-14,
#                            end = Sys.Date()),
#             fileInput('file1', 'Choose file to upload',
#                       accept = c(
#                           'text/csv',
#                           'text/comma-separated-values',
#                           '.csv'
#                       )
#             )
#         ),
#         
#         # Show a plot of the generated distribution
#         mainPanel(
#             verbatimTextOutput("prevalue"),
#             verbatimTextOutput("postvalue"),
#             plotOutput("impactPlot"),
#             verbatimTextOutput("impactReport")
#         )
#     )
#     )

    
))
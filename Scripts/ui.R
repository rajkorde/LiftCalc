library(shiny)
library(markdown)

shinyUI(navbarPage("Lift Calculator",
                   tabPanel("Impact Analysis",
                            sidebarLayout(
                                sidebarPanel(
                                    dateRangeInput("predates", 
                                        label = "Pre-Experiment Period",
                                        start = as.Date("2016-05-10", format="%Y-%m-%d"),
                                        end = as.Date("2016-05-23", format="%Y-%m-%d")),
                                    dateRangeInput("postdates", 
                                        label = "Experiment Period",
                                        start = as.Date("2016-05-24", format="%Y-%m-%d"),
                                        end = as.Date("2016-06-04", format="%Y-%m-%d")),
                                    fileInput('file1', 'Choose file to upload',
                                        accept = c(
                                            'text/csv',
                                            'text/comma-separated-values',
                                            '.csv'
                                            )
                                    )
                                ),
                                mainPanel(
                                    plotOutput("impactPlot"),
                                    verbatimTextOutput("impactReport")
                                )
                            )
                   ),
                   tabPanel("Test of means",
                            sidebarLayout(
                                sidebarPanel(
                                    fileInput('file2', 'Choose file to upload',
                                              accept = c(
                                                  'text/csv',
                                                  'text/comma-separated-values',
                                                  '.csv'
                                              )
                                    )
                                ),
                                mainPanel(
                                    strong("Lift: "),
                                    textOutput("meansLift"),
                                    strong("Significance level: "),
                                    textOutput("meansSiglevel"),
                                    strong("Control Means: "),
                                    textOutput("meansControl"),
                                    strong("Treatment Means: "),
                                    textOutput("meansTreatment"),
                                    plotOutput("meansPlot")
                                )
                            )
                   ),
                   tabPanel("Test of propoptions",
                            sidebarLayout(
                                sidebarPanel(
                                    h3("Control"),
                                    numericInput("cprop", 
                                        label = "Proportion", 
                                        value = 50),
                                    numericInput("ctotal", 
                                                 label = "Sample Size", 
                                                 value = 100),
                                    h3("Treatment"),
                                    numericInput("tprop", 
                                                 label = "Proportion", 
                                                 value = 50),
                                    numericInput("ttotal", 
                                                 label = "Sample Size", 
                                                 value = 100),
                                    submitButton("Submit")
                                ),
                                mainPanel(
                                    verbatimTextOutput("propDebug"),
                                    strong("Lift: "),
                                    textOutput("propLift"),
                                    strong("Significance level: "),
                                    textOutput("propSiglevel"),
                                    strong("Power: "),
                                    textOutput("propPower"),
                                    strong("Control Proportion: "),
                                    textOutput("propControl"),
                                    strong("Treatment Proportion: "),
                                    textOutput("propTreatment"),
                                    plotOutput("propPlot")
                                )
                            )
                   )
))


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

    
#)
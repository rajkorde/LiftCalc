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
                                    strong("Lift: "),
                                    textOutput("impactLift"),
                                    strong("Confidence Interval: "),
                                    textOutput("impactLiftCI"),
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
                                    strong("Means: "),
                                    textOutput("meansValue"),
                                    strong("Sample size: "),
                                    textOutput("meansSS"),
                                    strong("Ideal Sample size: "),
                                    textOutput("meansIdealSS"),
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
                                        value = 0),
                                    numericInput("ctotal", 
                                                 label = "Sample Size", 
                                                 value = 0),
                                    h3("Treatment"),
                                    numericInput("tprop", 
                                                 label = "Proportion", 
                                                 value = 0),
                                    numericInput("ttotal", 
                                                 label = "Sample Size", 
                                                 value = 0),
                                    submitButton("Submit")
                                ),
                                mainPanel(
                                    strong("Lift: "),
                                    textOutput("propLift"),
                                    strong("Significance level: "),
                                    textOutput("propSiglevel"),
                                    strong("Power: "),
                                    textOutput("propPower"),
                                    strong("Proportions: "),
                                    textOutput("propValue"),
                                    strong("Sample size: "),
                                    textOutput("propSS"),
                                    strong("Ideal Sample size: "),
                                    textOutput("propIdealSS"),
                                    plotOutput("propPlot")
                                )
                            )
                   )
))
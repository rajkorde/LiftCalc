library(shiny)
library(CausalImpact)

# By default, the file size limit is 5MB. It can be changed by
# setting this option. Here we'll raise limit to 25MB.
options(shiny.maxRequestSize = 25*1024^2)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    getImpact <- reactive({
        inFile <- input$file1
        
        if (is.null(inFile))
            return(NULL)
        
        d = read.csv(inFile$datapath, header=FALSE, col.names=
                         c("Date", "Control", "Treat"))
        d$Date = as.Date(d$Date, format="%Y-%m-%d")
        
        pre.period = c(as.Date("2016-05-10", format="%Y-%m-%d"),
                       as.Date("2016-05-23", format="%Y-%m-%d"))
        post.period = c(as.Date("2016-05-24", format="%Y-%m-%d"),
                        as.Date("2016-06-04", format="%Y-%m-%d"))
        
        
        z = zoo(cbind(y=d$Treat, x=d$Control), d$Date)
        set.seed(420)
        CausalImpact(z, pre.period, post.period)
        
    })
    
    output$impactPlot <- renderPlot({
        impact = getImpact()
        plot(impact)        
    })
    
    output$impactReport  <- renderText({
        impact = getImpact()
        impact$report
    })
    
    output$prevalue  <- renderText({
        paste("input$predates is", 
              paste(as.character(input$predates), collapse = " to ")
        )
    })
    
    output$postvalue  <- renderText({
        paste("input$postdates is", 
              paste(as.character(input$postdates), collapse = " to ")
        )
    })
    
    
})
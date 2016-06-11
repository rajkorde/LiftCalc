library(shiny)
library(CausalImpact)

# By default, the file size limit is 5MB. It can be changed by
# setting this option. Here we'll raise limit to 25MB.
options(shiny.maxRequestSize = 25*1024^2)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    # Expression that generates a histogram. The expression is
    # wrapped in a call to renderPlot to indicate that:
    #
    #  1) It is "reactive" and therefore should be automatically
    #     re-executed when inputs change
    #  2) Its output type is a plot
    
    output$distPlot <- renderPlot({
        x    <- faithful[, 2]  # Old Faithful Geyser data
        bins <- seq(min(x), max(x), length.out = input$bins + 1)
        
        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white')
    })
    
    output$contents <- renderTable({
        # input$file1 will be NULL initially. After the user selects
        # and uploads a file, it will be a data frame with 'name',
        # 'size', 'type', and 'datapath' columns. The 'datapath'
        # column will contain the local filenames where the data can
        # be found.
        
        inFile <- input$file1
        
        if (is.null(inFile))
            return(NULL)
        
        read.csv(inFile$datapath, header=FALSE)
    })
    
    output$impact <- renderPlot({
        # input$file1 will be NULL initially. After the user selects
        # and uploads a file, it will be a data frame with 'name',
        # 'size', 'type', and 'datapath' columns. The 'datapath'
        # column will contain the local filenames where the data can
        # be found.
        
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
        impact = CausalImpact(z, pre.period, post.period)
        plot(impact)        
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
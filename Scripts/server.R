library(shiny)
library(CausalImpact)
library(pwr)

# By default, the file size limit is 5MB. It can be changed by
# setting this option. Here we'll raise limit to 25MB.
options(shiny.maxRequestSize = 25*1024^2)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
        
    
    ######################
    ## Impact Analysis
    ######################
    
    getImpact <- reactive({
        inFile <- input$file1
        
        if (is.null(inFile))
            return(NULL)
        
        d = read.csv(inFile$datapath, header=FALSE, col.names=
                         c("Date", "Control", "Treat"))
        d$Date = as.Date(d$Date, format="%Y-%m-%d")
        
        pre.period = c(input$predates[1],
                       input$predates[2])
        post.period = c(input$postdates[1],
                        input$postdates[2])
        
        
        z = zoo(cbind(y=d$Treat, x=d$Control), d$Date)
        set.seed(420)
        CausalImpact(z, pre.period, post.period)
        
    })
    
    output$impactPlot <- renderPlot({
        if (is.null(input$file1))
            return(NULL)
        impact = getImpact()
        plot(impact)        
    })
    
    output$impactReport  <- renderText({
        if (is.null(input$file1))
            return(NULL)
        impact = getImpact()
        impact$report
    })
    
    ######################
    ## Means test
    ######################
    
    getMeansTest <- reactive({
        inFile <- input$file2
        
        if (is.null(inFile))
            return(NULL)
        
        d = read.csv(inFile$datapath, header=FALSE, col.names=
                         c("ID", "Group", "Value"))
        t = t.test(Value~Group, data=d)
        dc = d[d$Group=="Control"|d$Group=="control",]
        dt = d[d$Group=="Treatment"|d$Group=="treatment",]
        cmean = mean(dc$Value)
        tmean = mean(dt$Value)
        lift = (tmean - cmean)/cmean
        l = list(t=t, d=d, dc=dc, dt=dt, cmean=cmean, tmean=tmean, lift=lift)
    })
    
    output$meansPlot <- renderPlot({
        l = getMeansTest()
        boxplot(Value~Group, data=l$d)        
    })
    
#     output$meansDebug  <- renderText({
#         l = getPropTest()
#         paste(l$cprop, l$ctotal, l$tprop, l$ttotal)
#     })
    
    output$meansLift  <- renderText({
        l = getMeansTest()
        l$lift
    })
    
#     output$propPower  <- renderText({
#         l = getPropTest()
#         l$p$power
#     })
    
    output$meansControl  <- renderText({
        l = getMeansTest()
        l$cmean
    })

    output$meansTreatment  <- renderText({
        l = getMeansTest()
        l$tmean
    })
    
    output$meansSiglevel  <- renderText({
        l = getMeansTest()
        msg = ifelse(l$t$p.value<0.05, 
                     "(Statistically significant difference found!)",
                     "(Difference is not statistically significant)")
        paste(l$t$p.value, msg)
    })
    
    ######################
    ## Prop test
    ######################
    
    getPropTest <- reactive({
            sig.level=0.05
        
            prop = c(input$cprop, input$tprop)
            total = c(input$ctotal, input$ttotal)
            tp = input$tprop/input$ttotal
            cp = input$cprop/input$ctotal
            r = prop.test(prop, total)
            h=ES.h(tp, cp)
            p = pwr.2p2n.test(h=h, 
                          n1=input$ttotal, n2=input$ctotal, sig.level=sig.level)
            lift = ((tp-cp)*100)/cp
            l = list(p=p, r=r, lift=lift, cp=cp, tp=tp, 
                     cprop = input$cprop, ctotal = input$ctotal,
                     tprop = input$tprop, ttotal = input$ttotal)
            l
        })
    
    output$PropDebug  <- renderText({
        l = getPropTest()
        paste(l$cprop, l$ctotal, l$tprop, l$ttotal)
    })
    
    output$propLift  <- renderText({
        l = getPropTest()
        l$lift
    })
    
    output$propPower  <- renderText({
        l = getPropTest()
        l$p$power
    })
    
    output$propControl  <- renderText({
        l = getPropTest()
        l$cp
    })
    output$propTreatment  <- renderText({
        l = getPropTest()
        l$tp
    })
    
    output$propSiglevel  <- renderText({
        l = getPropTest()
        msg = ifelse(l$r$p.value<0.05, 
                     "(Statistically significant difference found!)",
                     "(Difference is not statistically significant)")
        paste(l$r$p.value, msg)
    })
    
    output$propPlot <- renderPlot({
        l = getPropTest()
        barplot(c(treatment=l$tp, control=l$cp))
    })
})
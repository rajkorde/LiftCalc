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
    
    output$impactReport  <- renderPrint({
        if (is.null(input$file1))
            return(NULL)
        impact = getImpact()
        #impact$report
        summary(impact, "report")
    })
    
    output$impactLiftCI <- renderText({
        if (is.null(input$file1))
            return(NULL)
        impact = getImpact()
        paste0(round(impact$summary$RelEffect.lower[2], 2), "% to ",
               round(impact$summary$RelEffect.upper[2], 2), "%")       
    })
    
    output$impactLift <- renderText({
        if (is.null(input$file1))
            return(NULL)
        impact = getImpact()
        paste0(round(impact$summary$RelEffect[2], 2), "%")       
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
        lift = ((tmean - cmean)*100)/cmean
        l = list(t=t, d=d, dc=dc, dt=dt, cmean=cmean, tmean=tmean, lift=lift)
    })
    
    output$meansPlot <- renderPlot({
        
        if (is.null(input$file2))
            return(NULL)
        
        l = getMeansTest()
        boxplot(Value~Group, data=l$d)        
    })
    
    output$meansLift  <- renderText({
        if (is.null(input$file2))
            return(NULL)
        l = getMeansTest()
        paste0(round(l$lift, 2), "%")
    })
    
    output$meansValue  <- renderText({
        if (is.null(input$file2))
            return(NULL)
        l = getMeansTest()
        paste(round(l$cmean, 2), "(control) and", 
              round(l$tmean, 2), "(treatment)")
    })
    
    output$meansMedianValue  <- renderText({
        if (is.null(input$file2))
            return(NULL)
        l = getMeansTest()
        paste(median(l$dc$Value), "(control) and", 
              median(l$dt$Value), "(treatment)")
    })
    
    output$meansSiglevel  <- renderText({
        if (is.null(input$file2))
            return(NULL)
        l = getMeansTest()
        msg = ifelse(l$t$p.value<0.05, 
                     "(t-test: Statistically significant difference found!)",
                     "(t-test: Difference is not statistically significant)")
        paste(round(l$t$p.value, 5), msg)
    })
    
    output$meansSiglevelWRST  <- renderText({
        if (is.null(input$file2))
            return(NULL)
        w = wilcox.test(Value~Group, data=d)
        msg = ifelse(w$p.value<0.05, 
                     "(Wilcoxon Rank Sum test: Statistically significant difference found!)",
                     "(Wilcoxon Rank Sum test: Difference is not statistically significant)")
        paste(round(w$p.value, 5), msg)
    })

#     output$meansPower  <- renderText({
#         if (is.null(input$file2))
#             return(NULL)
#         l = getMeansTest()
#     })
    
    output$meansSS  <- renderText({
        if (is.null(input$file2))
            return(NULL)
        l = getMeansTest()
        paste(nrow(l$dc), "(control) and", nrow(l$dt), "(treatment)")
    })
    
    output$meansIdealSS  <- renderText({
        if (is.null(input$file2))
            return(NULL)
        l = getMeansTest()
        sdev = sd(l$dc$Value)
        p=power.t.test(delta=l$tmean-l$cmean, sd=sdev, sig.level=0.05, power=0.8)
        paste(round(p$n, 2), "would have been a good sample size for this difference in means 
              with 0.05 significance level, 0.8 power and 50-50 split")
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
                          n1=as.numeric(input$ttotal), 
                          n2=as.numeric(input$ctotal), 
                          sig.level=sig.level)
            lift = ((tp-cp)*100)/cp
            l = list(p=p, r=r, lift=lift, cp=cp, tp=tp)
            l
        })

    output$propSS  <- renderText({
        if (input$ctotal==0||input$ttotal==0)
            return(NULL)
        l = getPropTest()
        paste(input$ctotal, "(control) and", input$ttotal, "(treatment)")
    })

    output$propIdealSS  <- renderText({
        if (input$ctotal==0||input$ttotal==0)
            return(NULL)
        l = getPropTest()
        p = power.prop.test(p1=l$cp, p2=l$tp, sig.level=0.05, power=0.8)
        paste(round(p$n, 2), "would have been a good sample size for these proportions 
              with 0.05 significance level, 0.8 power and 50-50 split")
    })

    
    output$propLift  <- renderText({
        if (input$ctotal==0||input$ttotal==0)
            return(NULL)
        l = getPropTest()
        paste0(round(l$lift, 2), "%")
    })
    
    output$propPower  <- renderText({
        if (input$ctotal==0||input$ttotal==0)
            return(NULL)
        l = getPropTest()
        paste(round(l$p$power, 2), "at 0.05 significance level at these proportions and sample sizes")
    })
    
    output$propValue  <- renderText({
        if (input$ctotal==0||input$ttotal==0)
            return(NULL)
        l = getPropTest()
        paste(round(l$cp, 5), "(control) and", 
              round(l$tp, 5), "(treatment)")
    })
    
    output$propSiglevel  <- renderText({
        if (input$ctotal==0||input$ttotal==0)
            return(NULL)
        l = getPropTest()
        msg = ifelse(l$r$p.value<0.05, 
                     "(Statistically significant difference found!)",
                     "(Difference is not statistically significant)")
        paste(round(l$r$p.value, 5), msg)
    })
    
    output$propPlot <- renderPlot({
        if (input$ctotal==0||input$ttotal==0)
            return(NULL)
        l = getPropTest()
        barplot(c(control=l$cp, treatment=l$tp))
    })
})
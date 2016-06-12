library(CausalImpact)
d = read.csv(file="Data/treatBdata.csv", header=FALSE, col.names=
                 c("Date", "Control", "Treat"))
d$Date = as.Date(d$Date, format="%Y-%m-%d")

pre.period = c(as.Date("2016-05-10", format="%Y-%m-%d"),
               as.Date("2016-05-23", format="%Y-%m-%d"))
post.period = c(as.Date("2016-05-24", format="%Y-%m-%d"),
                as.Date("2016-06-04", format="%Y-%m-%d"))


z = zoo(cbind(y=d$Treat, x=d$Control), d$Date)
set.seed(420)
impact=CausalImpact(z, pre.period, post.period)
plot(impact)
summary(impact, "report")
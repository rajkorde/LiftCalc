library(CausalImpact)
library(pwr)
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
summary(impact)

#prop test
cprop=391
ctotal=47606 
tprop=663
ttotal=68409
sig.level=0.05

prop = c(cprop, tprop)
total = c(ctotal, ttotal)
tp = tprop/ttotal
cp = cprop/ctotal
r = prop.test(prop, total)
h=ES.h(tp, cp)
p = pwr.2p2n.test(h=h, 
                  n1=ttotal, ctotal, sig.level=sig.level)
lift = ((tp-cp)*100)/cp
p = power.prop.test(p1=cp, p2=tp, sig.level=0.05, power=0.8)

l = list(p=p, r=r, lift=lift)

barplot(c(treatment=tprop/ttotal, control=cprop/ctotal))

#means test
d = read.csv(file="Data/ETtreatB.csv", header=FALSE, col.names=
                 c("ID", "Group", "Value"))
t = t.test(Value~Group, data=d)

dc = d[d$Group=="Control"|d$Group=="control",]
dt = d[d$Group=="Treatment"|d$Group=="treatment",]
p=power.t.test(delta=t$estimate[1]-t$estimate[2], sd=sd(dc$Value), sig.level=0.05, power=0.8)


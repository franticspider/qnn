# QNN
R package for measuring evolutionary activity, so called becuase it is a "Quantitative, Non-Neutral" measure. This means that the analysis yields a number that can be used to compare activity between samples, and that the measure is based on the idea that any non-neutral evolutionary change will be detected. 


##Installation

We recommend installation via devtools, but alternatively, you can download the files in the R subdirectory as you need them.



##Test Datasets

1. example01 - data shown in fig 1 of paper [1]
- example02 - Ed Clark data set
- example03 - Ed Clark data set

##Examples

```R
x <- read.popdy("popdyeg.dat")
c <- ecea.activity(x)
q <- qnn.activity(x)
par(mfrow=c(3,1))
plot.popdy2(x)
plot.popdy2(c,ylab="ECEA")
plot.popdy2(q,ylab="QNN")
```


##TODO:

###General tidy up of the package



###Add the EClark measure


##References.
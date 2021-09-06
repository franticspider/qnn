# QNN
R package for measuring evolutionary activity, so called becuase it is a "Quantitative, Non-Neutral" measure. This means that the analysis yields a number that can be used to compare activity between samples, and that the measure is based on the idea that any non-neutral evolutionary change will be detected. 


## Installing from the R command-line

You'll need the `devtools` package to install q2e so either do this:

 `> require("devtools")`
 
or this:
 
 `> install.packages("devtools")`
 
 `> library(devtools)`
 
Then you can use the `install_github` function to install q2e:
 
 `> install_github("franticspider/qnn/qnn")`
 
Of course, you'll only need to do that once for your R installation. After that, whenever you want to use qnn, simply enter: 
 
 `> library("qnn")`


## Test Datasets

1. example01 - data shown in fig 1 of paper [1]
- example02 - Ed Clark data set
- example03 - Ed Clark data set

## Examples

```R
require("qnn")

#Get the file path of example data set:
filename <- system.file("extdata", "example01.dat", package="qnn")

x <- read.popdy(filename)
c <- ecea.activity(x)
q <- qnn.activity(x)
b <- bray.curtis.activity(x)
par(mfrow=c(4,1))
popdyplot(x)
popdyplot(c,ylab="ECEA")
popdyplot(q,ylab="QNN")
popdyplot(q,ylab="Bray-Curtis")
```


##TODO:

1. General tidy up of the package
- Incorporate C version of qnn measure
- Add external C makefile etc. for direct use in C code

##References.

*A quantitative measure of non-neutral evolutionary activity for systems that exhibit intrinsic fitness*, **Alastair Droop and Simon Hickinbotham**, ALife XIII, Michigan, USA, July 2012. MIT Press, 2012

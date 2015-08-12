

##################################################################################
##################################################################################


#POPDY CLASS INFO:

suppressPackageStartupMessages(library(Matrix, quietly=TRUE))

#message('loading popdy-class...')
#source('popdy-class.R')
############
#sink("tmp.txt")

setClass("popdy", representation(tracks="dgCMatrix", times="numeric"))
setClass("popdat", contains="popdy")

setMethod("show", signature(object="popdy"), function(object){
	cat(sprintf("stringmol popdy object containing %d species across %d times (%d-%d)\n", ncol(object@tracks), nrow(object@tracks), min(object@times), max(object@times)))
})

setMethod("show", signature(object="popdat"), function(object){
	cat(sprintf("stringmol popdat object containing data for %d species across %d times (%d-%d)\n", ncol(object@tracks), nrow(object@tracks), min(object@times), max(object@times)))
})


setMethod("[", signature(x="popdy", i="ANY", j="missing"), function (x, i){
	return(x@tracks[,i])
})

setMethod("names", signature(x="popdy"), function(x){
	return(colnames(x@tracks))
})

setGeneric("plot")
setGeneric("lines")

setMethod("lines", signature(x="popdy"), function(x, col="black", plot.zero=FALSE, ...){
	col <- rep(col, ncol(x@tracks))
	for(i in 1:ncol(x@tracks)){
		# TODO: THIS IS A CHEAP HACK CURRENTLY!
		# CHECK THIS!
		y <- x@tracks[,i]
		if(identical(plot.zero, FALSE)) y[y==0] <- NA
		lines(x=times(x), y=y, col=col[i], ...)
	}
})

setMethod("plot", signature(x="popdy", y="missing"), function(x, col.fun=rainbow, add.lines=TRUE, add.points=FALSE, epochs=NA, epoch.border=NA, epoch.col.fun=cm.colors, epoch.alpha=0.25, axis.exponent=0, draw.box=TRUE, plot.zero=FALSE){
	x.times <- times(x)
	x.species <- speciesnames(x)
	x.range <- range(x.times)
	y.range <- range(tracks(x), na.rm=TRUE) # THIS IS MODIFIED TO ALLOW EA FAKE POPDY OBJECTS HERE.
	species.colours <- col.fun(length(x.species))
	if(!missing(epochs)) epoch.bg <- rgb(t(col2rgb(epoch.col.fun(nrow(epochs)))), alpha=(epoch.alpha * 255), maxColorValue=255)
	plot(NA, xlim=x.range, ylim=y.range, ann=FALSE, axes=FALSE, xaxs='i', yaxs='i')
	if(!missing(epochs)) rect(xleft=epochs$start, ybottom=y.range[1], xright=epochs$end, ytop=y.range[2], col=epoch.bg, border=epoch.border)
	if(identical(add.points, TRUE)) lines(x, col=species.colours, plot.zero=plot.zero, type='p', pch=16, cex=0.5)
	if(identical(add.lines, TRUE)) lines(x, col=species.colours, plot.zero=plot.zero)
	axis(2, las=2)
	title(ylab='population')
	x.time.positions <- axTicks(1)
	if(missing(axis.exponent) || identical(axis.exponent, 0)){
		axis(1, at=x.time.positions, labels=x.time.positions)
		title(xlab=expression(time))
	} else {
		axis.labels <- x.time.positions / (10 ^ axis.exponent)
		axis(1, at=x.time.positions, labels=axis.labels)
		title(xlab=as.expression(substitute(time%*%10^e, list(e=axis.exponent))))
	}
	if(identical(draw.box, TRUE)) box()
})
sink(NULL)



##################################################################################
##################################################################################


#FUNCTIONS:


##################################################################################
#' read a file into a popdy object
#'
#' @param file a comma-delimited file, each line of which details time,species,count
#' @keywords qnn evolution
#' @export

read.popdy <- function(file){
	file.data <- read.table(file, sep=",")
	species.ids <- unique(as.character(file.data[,2]))
	times <- sort(unique(as.numeric((file.data[,1]))))
	time.index <- match(file.data[,1], times)
	species.index <- match(file.data[,2], species.ids)
	tracks <- as(new("dgTMatrix", i=as.integer(time.index - 1), j=as.integer(species.index - 1), x=as.double(file.data[,3]), Dim=c(length(times), length(species.ids))), "dgCMatrix")
	colnames(tracks) <- species.ids
	return(new("popdy", tracks=tracks, times=times))
}





##################################################################################
#' get a vector of times from a popdy object
#'
#' @param x a popdy data object
#' @keywords qnn evolution
#' @export

times <- function(x){
	return(x@times)
}





##################################################################################
#' get the number of species in a popdy object
#'
#' @param x a popdy data object
#' @keywords qnn evolution
#' @export

nspecies <- function(x){
	return(ncol(x@tracks))
}





##################################################################################
#' summarises QNN activity into a single figure
#'
#' @param x a popdy data object holding the qnn values (rather than the popdy values)
#' @keywords qnn evolution
#' @export

qnn.summarize <- function(x){
	return(sum(apply((x@tracks), 2, sum, na.rm=TRUE), na.rm=TRUE))
}





##################################################################################
#' Gets QNN activity for a popdy data object
#'
#' @param x a popdy data object
#' @param scale flag to specify whether the output is to be scaled by the population 
#' @keywords qnn evolution
#' @export

qnn.activity <- function(x, scale=FALSE){
    # Calculate the total population at each time step (each member of x@tracks is the popdy of a single species)
	population.per.time <- apply(x@tracks, 1, sum)

    # Calculate the proportion of each species at each time step
	species.proportions <- sweep(x@tracks, 1, population.per.time, FUN="/")

    # Expected proportions are the proportions at the last time step
	expected.species.proportions.per.time <- rBind(rep(NA, nspecies(x)), species.proportions[1:(nrow(species.proportions) - 1),])

    # Substact expected from observed
	diff.expected <- (species.proportions - expected.species.proportions.per.time)
	diff.expected[diff.expected < 0] <- 0

    # square any positive result
	diff.expected <- diff.expected ^ 2

    # scale, if requested as an argument
	if(identical(scale, TRUE)) diff.expected <- diff.expected * population.per.time
	output <- as(x, "popdat")

    # return the result as another popdy object
	output@tracks <- as(diff.expected, "dgCMatrix")
	return(output)
}





##################################################################################
#' Gets QNN summary data for a set of files and stores the data in an output file
#'
#' This function allows you to calculate QNN for a set of files with the same name
#' for example, if your files are called 'pop001.dat', 'pop002.dat'
#' @param stem a string for the root name of the file
#' @param N the number of files to be processed
#' @param outstem a string for the root of the output name of the file 
#' @keywords qnn evolution
#' @export
#' @examples
#' get_qnns("pop",3,"qnn")
#' reads files 'pop1.dat', 'pop2.dat' and 'pop3.dat', 
#' and outputs files 'qnn1.dat', 'qnn2.dat' and 'qnn3.dat'
 
get_qnns <-function(stem="popdy",N=1,outstem="qnn"){

	message("Calculating qnn...\n");

	for(i in 1:N){
		infile<-sprintf("%s%d.dat",stem,i)
		message("processing ",infile)

		x <- read.popdy(infile)#"popdy.dat");

		#xqnn<-qnn.activity(x,TRUE);
		xqnn<-qnn.activity(x);
		qnn<-qnn.summarize(xqnn);

		message(sprintf("\n--------------------------------------\nfile %s, qnn is %e, runtime is %d, %f, %e\n--------------------------------------",infile,qnn, max(times(x)),qnn,qnn));

		outfile <-sprintf("%s%d.txt",outstem,i)
		sink(outfile)#"qnn.txt")
		cat(    sprintf(  "%d\t%e\t%d\n",i,qnn,max(times(x))))
		sink()

	}
}


#########################################################
# THIS IS HOW YOU CALL ALL THIS FOR THE ECAL 2015 PAPER #
#########################################################
#
#	get_qnns("tpdtrim",100,"qnntrim")
#	get_qnns("tpd",100,"qnn")





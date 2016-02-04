


#TODO: I don't know what this function is for anymore! - delete if obsolete - use popdyplot below
plot.popdy <- function(x, col.fun=rainbow){

	time.lim <- range(x$time)
	valid.species <- unique(x$species)
	colours <- col.fun(length(valid.species))
	y.lim <- c(0, max(x$count))#max(x$count))

	# pdf(file=outfn, height=h, width=w, title=outfn)
	#  	par(mar=c(5,5, 0.1, 0.1))
	plot(NA, xlim=time.lim, ylim=y.lim, ann=FALSE, axes=FALSE )
	sapply(1:length(valid.species), function(i){
		data <- x[x$species==valid.species[i],]
		lines(x=data$time, y=data$count, col=colours[i])
	})
	axis(2, las=2)
	title(ylab='population')
	x.positions <- seq(from=time.lim[1], to=time.lim[2], length.out=20)
	axis(1, at=x.positions, labels=sprintf('%d', x.positions / 1e3))
	title(xlab=expression(time%*%10^3))
	box()
	# dev.off()
}


##################################################################################
#' plots a  popdy data object
#'
#' @param x a popdy data object
#' @param xlab The label on the x-axis (default = "Time") 
#' @param ylab The label on the y-axis (default = "Count") 
#' @param plot.zero flag to plot zero-valued columns (default = FALSE) ) 
#' @param col.fun  specifies the method for generating the line colours (default = "rainbow") ) 
#' @param minpop the minimum population size for a species to be plotted
#' @param logrey plots small populations in grey
#' @param smooth values greater than zero do loess smoothing
#' @keywords qnn evolution
#' @export
popdyplot <-
function(x, xlab="Time", ylab="Count", #epochs=NA, epoch.col=cm.colors, epoch.border=NA, 
plot.zero=FALSE, #lines=TRUE, 
col.fun=rainbow, colours = NA,
minpop=1, logrey = F, xlim = NA,smooth=0)
{
	if(identical(xlim,NA))
    	xlim = range(x@times)
    ylim = c(0, max(x@tracks))
    
    #if a palette hasn't been specified...use a rainbow
    if(identical(colours,NA))
		colours <- col.fun(ncol(x@tracks))

	plot(NA, xlim=xlim, ylim=ylim, xlab=xlab, ylab=ylab     )#, ...)

    #sapply(1:, function(i){
	
	#plot the small populations:
	if(logrey){
	    for(j in 1:ncol(x@tracks)){
    		if(max(x@tracks[,j] < minpop)){
				lines(x=x@times, y=x@tracks[,j], col="grey")
			}	
		}
	}


    for(j in 1:ncol(x@tracks)){
    	if(max(x@tracks[,j] >= minpop)){
    		#TODO: Need a 'verbose' flag
    		message(sprintf("Plotting run %d with colour %s",j,colours[j]))
			if(smooth>0){
				#message("making Loess data")
				lx<-x@times
				ly<-x@tracks[,j]
				#message("Calculating Loess fit")
				lo <- loess(ly ~ lx,span=smooth)
				#message("Plotting Loess fit")
				lines(lx,lo$fitted, col=colours[j],lwd = 2)
				#message("done")
			}
			else{
				lines(x=x@times, y=x@tracks[,j], col=colours[j])
			}
		}
	}


#THIS IS APD'S EPOCH PLOTTING CODE - 
# TODO: GET THIS WORKING AGAIN.
#	if(!missing(epochs)){
#		if(is.function(epoch.col)) 
#            epoch.colours <- epoch.col(nrow(epochs)) 
#        else 
#            epoch.colours <- rep(epoch.col, length.out=nrow(epochs))
#		rect(xleft=epochs$start, ybottom=par("usr")[3], xright=epochs$end, ytop=par("usr")[4], col=epoch.colours, border=epoch.border)
	#}
	#if(identical(lines, TRUE)) lines(x, col=col, plot.zero=plot.zero)
}#)






# TODO: This needs to be integrated with the popdy objects 
# so we don't have to re-read from file
# (doesn't use the popdy structure...)
plot.popdy.file <- function(infn,outfn,w,h, col.fun=rainbow){

	x	<- read.table(infn,sep=",", col.names=c('time', 'species', 'count'))
    plot.popdy(x, col.fun)
}




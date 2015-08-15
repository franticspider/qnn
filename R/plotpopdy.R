



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


plot.popdy2 <-
# setGeneric("plot")
# setMethod("plot", signature(x="popcount", y="missing"), 
# function(x, col=rainbow, xlim=range(times(x)), ylim=c(0, max(tracks(x))), 
# xlab="Time", ylab="Count", epochs=NA, epoch.col=cm.colors, epoch.border=NA, 
# plot.zero=FALSE, lines=TRUE, ...)
function(x, xlab="Time", ylab="Count", epochs=NA, epoch.col=cm.colors, epoch.border=NA, 
plot.zero=FALSE, lines=TRUE, col.fun=rainbow)
{
    xlim = range(x@times)
    ylim = c(0, max(x@tracks))
	colours <- col.fun(ncol(x@tracks))

	plot(NA, xlim=xlim, ylim=ylim, xlab=xlab, ylab=ylab     )#, ...)

    #sapply(1:, function(i){

    for(j in 1:ncol(x@tracks)){
		lines(x=x@times, y=x@tracks[,j], col=colours[j])
	}



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




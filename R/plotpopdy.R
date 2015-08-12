

# TODO: This needs to be integrated with the popdy objects so we don't have to re-read from file
plot.onepop <- function(infn,outfn,w,h, col.fun=rainbow){

	x	<- read.table(infn,sep=",", col.names=c('time', 'species', 'count'))
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

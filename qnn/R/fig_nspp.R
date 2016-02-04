
library(Matrix)
library(stringr)

#source('/home/sjh/Desktop/Dropbox/R/popdy-class.R')
#source('/home/sjh/Desktop/Dropbox/R/read.popdy.R')
#source('/home/sjh/Desktop/Dropbox/R/plot.popdy.R')



plotpop <- function(infn,outfn){

	x <- read.popdy(infn)

	message("Data loaded successfully")
	
	pdf(outfn, width=5 * 3, height=2 * 4)

	apd.paper.panel(x, col.fun=rainbow, 'Population', y.axis=T, plot.label="ffff", plot.zero=TRUE)
	#paper.panel(x)#, 'Population', y,axis = T, plot.label = "fffff")
	dev.off()


	return (x);
}


################################
#
#infile <- "/home/sjh/Desktop/sjh/tierra/pd71/tpdtrim89.dat"
#outfile <-"lens71_89.pdf"
#
nspp<-function(path,inf1,inf2,outfn){


	infile<-sprintf("%s%s",path,inf1)
	x1 <- read.popdy(infile)
	nspp.per.time1 <- apply(x1@tracks, 1, nnzero)


	infile<-sprintf("%s%s",path,inf2)
	x2 <- read.popdy(infile)
	nspp.per.time2 <- apply(x2@tracks, 1, nnzero)

	#readline("did it work?")

	message("making file ",outfn)

	pdf(outfn, width=8 , height=3 )

	plot(x1@times,nspp.per.time1,type="l",ylim=c(0,500),xlim=c(0,10000),xlab="Time (x1000)", ylab = "Number of Species")

	#plot(all.data[,1],all.data[,4],cex=0.05,col="grey80",xlim=c(0,10000),xlab="Time (x1000)", ylab = "Species Length", log="y")
	

	lines(x2@times,nspp.per.time2,col="red",cex=0.05,type="l")


	#pdf(outfile, width=5 * 3, height=2 * 4)

	#apd.paper.panel(lpd, col.fun=rainbow, 'Population', y.axis=T, plot.label="ffff", plot.zero=TRUE)

	dev.off()
}

#	min	71med	72med	max
#d71t	89	80	100	81
#d72t	84	50	60	94
#qnnval		46.2	56.4	

#original submission
#nspp("/home/sjh/Desktop/sjh/tierra/pd71/","tpd89.dat","tpdtrim89.dat","nspp71_89.pdf")
#nspp("/home/sjh/Desktop/sjh/tierra/pd71/","tpd80.dat","tpdtrim80.dat","nspp71_80.pdf")
#nspp("/home/sjh/Desktop/sjh/tierra/pd71/","tpd100.dat","tpdtrim100.dat","nspp71_100.pdf")
#nspp("/home/sjh/Desktop/sjh/tierra/pd71/","tpd81.dat","tpdtrim81.dat","nspp71_81.pdf")#
##readline("hit return for 7.2 runs")
#
#
#nspp("/home/sjh/Desktop/sjh/tierra/pd72/","tpd84.dat","tpdtrim84.dat","nspp72_84.pdf")
#nspp("/home/sjh/Desktop/sjh/tierra/pd72/","tpd50.dat","tpdtrim50.dat","nspp72_50.pdf")
#nspp("/home/sjh/Desktop/sjh/tierra/pd72/","tpd60.dat","tpdtrim60.dat","nspp72_60.pdf")
#nspp("/home/sjh/Desktop/sjh/tierra/pd72/","tpd94.dat","tpdtrim94.dat","nspp72_94.pdf")



#	min	1med	2med	max
#7.1qnn	6.67	13.31	14.89	33.65
#7.1num	82	87	93	83

#7.2qnn	3.97	13.19	14.91	28.57			
#7.2num	91	2	33	63	
##





#EXAMPLE USAGE OF GETNSPPPLOTS...NOT SURE THIS'LL EVER BE NEEDED..
#create a vector of run numbers
#
#	> t2r <- c(75,48,67,31)
#	> getnsppplots("/home/sjh/721tpd/","72",t2r,dopng=T)
#
#
getnsppplots <- function(path,ty,rr,dopng=T){

	for(pp in 1:4){
		tpd<- sprintf("tpd%d.dat",rr[pp])
		trim<-sprintf("tpdtrim%d.dat",rr[pp])
	
		outn<-sprintf("nspp%s_%d.pdf",ty,rr[pp])
		
		message(sprintf("processing run %d, args are: %s, %s, %s, %s",pp,path,tpd,trim,outn))
		#tray.lenplot(path,tpd,trim,outn,dopng)

        nspp(path,tpd,trim,outn)
	}
}



#
#nspp("/home/sjh/Desktop/sjh/tierra/ecal15/tpd1/","tpd82.dat","tpdtrim82.dat","nspp71_82.pdf")
#nspp("/home/sjh/Desktop/sjh/tierra/ecal15/tpd1/","tpd87.dat","tpdtrim87.dat","nspp71_87.pdf")
#nspp("/home/sjh/Desktop/sjh/tierra/ecal15/tpd1/","tpd93.dat","tpdtrim93.dat","nspp71_93.pdf")
#nspp("/home/sjh/Desktop/sjh/tierra/ecal15/tpd1/","tpd83.dat","tpdtrim83.dat","nspp71_83.pdf")
#
#readline("hit return for 7.2 runs")
#
#nspp("/home/sjh/Desktop/sjh/tierra/ecal15/tpd2/","tpd91.dat","tpdtrim91.dat","nspp72_91.pdf")
#nspp("/home/sjh/Desktop/sjh/tierra/ecal15/tpd2/","tpd2.dat","tpdtrim2.dat","nspp72_2.pdf")
#nspp("/home/sjh/Desktop/sjh/tierra/ecal15/tpd2/","tpd33.dat","tpdtrim33.dat","nspp72_33.pdf")
#nspp("/home/sjh/Desktop/sjh/tierra/ecal15/tpd2/","tpd63.dat","tpdtrim63.dat","nspp72_63.pdf")
#
















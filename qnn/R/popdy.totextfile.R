##################################################################################
#' Exports a popdy object to a text file.
#' Each line in the text file is of format 't,s,p' where t=time,s=species,p=population 
#'
#' @param x a popdy data object
#' @param fn the output file name (default is 'popdy.dat' 
#' @keywords qnn evolution
#' @export

popdy.totextfile <- function(x=NA,fn="popdy.dat"){

    #TODO: Currently no error checking on x

    message("Writing same to file..")
    sink("popdyeg.dat")
    for(i in 1:length(x@times) ){
        for(j in 1:ncol(x@tracks)){
            if(x@tracks[i,j]>0)
                #message(sprintf("%d,sp%02d,%d",x@times[i],j,x@tracks[i,j]))
                cat(sprintf("%d,sp%02d,%d\n",x@times[i],j,x@tracks[i,j]))
        }
    }
    sink()
    message("..done")
}



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




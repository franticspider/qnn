##################################################################################
#' Gets Bray Curtis activity for a popdy data object
#'
#' @param x a popdy data object
#' @param scale flag to specify whether the output is to be scaled by the population 
#' @keywords qnn evolution
#' @export
bray.curtis.activity <- function(x, scale=TRUE){

	#we might not need to do this, but it keeps things clear:
	spp <- x@tracks

	#Get the species from time t-1:
	spplast <- rBind(rep(NA,nspecies(x)), spp[1:(nrow(spp) -1),])
	#Absolute value of the diffrence between t and t-1
	diff <- abs(spp-spplast)
	#sum of all the differences (numerator in bray-curtis)
	sum_diff <- apply(diff,1,sum)

	#Sum of t and t-1
	ssum <- spp + spplast
	#sum of sums (denominator in bray-curtis)
	sum_ssum <- apply(ssum,1,sum)

	#Bray-Curtis dissimilarity:
	result <- sum_diff/sum_ssum

	#Can't be any dissimilarity for the first timestep:
	result[1] <- 0

	#Allow scaling by population as in the other activity functions:
	if(identical(scale, TRUE)){ 
		population.per.time <- apply(x@tracks, 1, sum)
		result <- result * population.per.time
	}

    #
    #TODO: Check whether popdat or popdy is the way to go!
	#output <- as(x, "popdat")
	output <- as(x, "popdy")


    # TODO: 
    # return the result as another popdy object
	output@tracks <- Matrix(bc, sparse = TRUE)



	#we can't put the result back in a popdy structure because bray-curtis is a community-level measure..
	#output <- as(x, "popdat")
	#output@tracks <- as(result, "dgCMatrix")
	return(output)
	

}

#Methods above adapted from:
#qnn.activity <- function(x, scale=FALSE){
#	population.per.time <- apply(x@tracks, 1, sum)
#
#	species.proportions <- sweep(x@tracks, 1, population.per.time, FUN="/")
#
#
#	expected.species.proportions.per.time <- rBind(rep(NA, nspecies(x)), species.proportions[1:(nrow(species.proportions) - 1),])
#	diff.expected <- (species.proportions - expected.species.proportions.per.time)
#	diff.expected[diff.expected < 0] <- 0
#	diff.expected <- diff.expected ^ 2
#	if(identical(scale, TRUE)) diff.expected <- diff.expected * population.per.time
#	output <- as(x, "popdat")
#	output@tracks <- as(diff.expected, "dgCMatrix")
#	return(output)
#}




##################################################################################
#' Gets Ed Clark's activity for a popdy data object
#'
#' @param x a popdy data object
#' @param scale flag to specify whether the output is to be scaled by the population 
#' @keywords qnn evolution
#' @export

ecea.activity <- function(x, scale=FALSE){

    ##################
    # TODO:
    # Seeds = species that exist at first timestep  
    # these will be excluded from the measure

    # Main part, for a given species from Seeds+1:end (i.e. excluding seeds)

    # Take in the popdy file
    # Popvalue(t=0) = 0
    # Popchange(t=0) = 0

    # For t = each popvalue of a species (chronologically)
    # Popvalue(t) = population of whatever species
    # If Popvalue(t) != Popvalue(t-1)
    # Popchange++
    # Endif

    # DescriptiveVariableName(t) = (Popvalue(t))^2 / Popchange(t)

    # The next step gives the answer for THIS species
    # NearlyFinishedMeasureVaribale = max(DescriptiveVariableName)

    # To get the answer for the run
    # FinishedMeasure = sum(NearlyFinishedMeasureVaribale(all species)) - NumberOfSpecies
    ###################
    # VERSION 2 (same as above, but easier)

    # a = population^2 for all species
    pop <- x@tracks
    
    #remove seed species (should have 'if(remove_seed = T)' for this
    for(i in 1:ncol(pop)){if(pop[1,i]>0)pop[,i]<-0}

    pop.squared <- pop * pop

    # b = pop change for all (score 1 for every diff adjacent pop size)
    pop.shift <-  rBind(rep(0, ncol(pop)), pop[1:(nrow(pop)-1),])
    pdiff <- pop - pop.shift

    pdiff.count <- ifelse(pdiff!=0,1,0)
    pdiff.count.matrix <- matrix(pdiff.count,nrow = nrow(pdiff),ncol= ncol(pdiff))

    # TODO: this works for column 1 - need to do it over all columns....
    #r1 <- cumsum(pdiff.count.matrix[,1])
    pcumsum <- apply(pdiff.count.matrix,2,cumsum)
    pmax <- apply(pcumsum,2,max)

    c <- (pop.squared/pcumsum)-1

    # get rid of the nans:
    c@x[is.nan(c@x)] = 0

    # TODO: sparsify the zeros: 

    #get the max values
    #d = apply(c,2,max)

    #Finally, coerce c into x

    output <- x

	output@tracks <- as(c, "dgCMatrix")



    return(output)

    ##########################
    # QNN (for reference):

    #    # Calculate the total population at each time step (each member of x@tracks is the popdy of a single species)
    #	population.per.time <- apply(x@tracks, 1, sum)

    #    # Calculate the proportion of each species at each time step
    #	species.proportions <- sweep(x@tracks, 1, population.per.time, FUN="/")

    #    # Expected proportions are the proportions at the last time step
    #	expected.species.proportions.per.time <- rBind(rep(NA, nspecies(x)), species.proportions[1:(nrow(species.proportions) - 1),])

    #    # Substact expected from observed
    #	diff.expected <- (species.proportions - expected.species.proportions.per.time)
    #	diff.expected[diff.expected < 0] <- 0

    #    # square any positive result
    #	diff.expected <- diff.expected ^ 2
    #
    #    # scale, if requested via the 2ne argument
    #	if(identical(scale, TRUE)) diff.expected <- diff.expected * population.per.time
	
    #    # return the result as another popdy object
    #    output <- as(x, "popdat")
    #	output@tracks <- as(diff.expected, "dgCMatrix")
    #	return(output)
}



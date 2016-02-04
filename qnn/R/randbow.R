
##################################################################################
#' creates an array of colors, randomly permuted from a rainbow
#'
#' @param x a popdy data object
#' @keywords color colour
#' @export
randbow <-
function(x)
{
	return (sample(rainbow(x)))
}

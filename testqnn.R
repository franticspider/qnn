

#########################################################
# THIS IS HOW YOU CALL ALL THIS FOR THE ECAL 2015 PAPER #
#########################################################
#
#	get_qnns("tpdtrim",100,"qnntrim")
#	get_qnns("tpd",100,"qnn")


require(Matrix)
require("qnn")

setwd("testdata")

outstem<-"qnntrim"

get_qnns("tpdtrim",100,outstem)

founderror=FALSE
errorcount=0
for( i in 1:100){

	fn <- sprintf("%s%d.txt",outstem,i)
	if(file.exists(fn)){
		file.remove(fn)
	}
	else{
		message(sprintf("ERROR: File %s was not created",fn))
		founderror<-T
		errorcount <- errorcount+1

	}
}

if(founderror){
	message(sprintf("Test failed: %d errors" , errorcount))
}
if(!founderror){
	message("Test passed :)")
}

setwd("..")



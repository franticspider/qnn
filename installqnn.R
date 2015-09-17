

#-----------------------------------------------------#
#TO INSTALL THE PACKAGE FOR USE (NOT FOR DEVELOPMENT)
#	$ require("devtools")
#	$ require(roxygen2)
#	$ install_github('franticspider/qnn')





#-----------------------------------------------------#
#TO SET UP FOR DEVELOPMENT FROM A GITHUB REPOSITORY
#
#The following was derived from:
#http://kbroman.org/github_tutorial/pages/init.html
#
# My preferred strategy is to create a barebones repo on github and then init the local repository 
# from there. This avoids sync problems that I've experienced in the past. 
#
# Once the remote repo has been created, we need to create a local version. 
# To set up a new *local* repository, I did the following:
#	
#	$ git clone https://github.com/franticspider/qnn
#
# The file you are reading now should be in the directory immediately 'above' the repo directory





#-----------------------------------------------------#
#TO REBUILD THE PACKAGE (INCLUDING DOCUMENTATION
#
#The idea is that we run this whenever we update the code - based on:
#http://hilaryparker.com/2014/04/29/writing-an-r-package-from-scratch/
#


#These are the libraries you need to build a package:
require("devtools")
require(roxygen2)

#Try to build the help files:
setwd("qnn")
document()
setwd("..") #NB: if document() fails, you'll need to setwd("..") manually
#NB: sometimes this fails if you do it more than once - if so, restart R


#install the package:
install("qnn")





#-----------------------------------------------------#
#TO PUSH THE CHANGES BACK TO GITHUB
# (do this OUTSIDE of an R session (i.e. quit R before you do this))
#
#	$ git add .
#	$ git commit
#	$ git push 
#	<username and password will be requested>









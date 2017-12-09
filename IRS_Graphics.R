############################################################################
######## SFM1 - Project -> Compare the three different ways to value an IRS
############################################################################

# clear all variables
rm(list = ls(all = TRUE))
graphics.off()

# install and load packages
libraries = c("ggplot2")
lapply(libraries, function(x) 
  if (!(x %in% installed.packages())) {
    install.packages(x) 
  }
)
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

# Source the IRS_Valuation functions
source("IRS_Valuation.R")

######## 1. Input different to IRS_Valuation.R

# US Treausry yield curve as of 8/12/17 
maturity = c(0,1/12,3/12,0.5,1,2,3,5,7)
yields = c(0,0.0114,0.0128,0.0145,0.0165,0.0180,0.0192,0.0214,0.0229) 
Y = data.frame(maturity, yields) # zero-bond-yield-curve

######## 1. Plots

# US Treausry yield curve plot as of 8/12/17 
ggplot(data=data.frame("Maturity"=maturity,"Yields"=yields,"Forward"=c(0,sapply(1:(nrow(Y)-1),function(x) ForwardRates(Y,Y[x,1],Y[x+1,1]))))) + geom_line(aes(x=maturity,y=yields,color="blue")) +
  theme(legend.position = c(0.75,0.25),legend.justification = c(0, 1), panel.background = element_blank(),
        axis.line.x = element_line(color = "black", 
                                   arrow = arrow(length = unit(0.25, 
                                                               "cm"))),
        axis.line.y = element_line(color = "black", 
                                   arrow = arrow(length = unit(0.25, 
                                                               "cm")))) + 
  scale_colour_discrete(name="Rate Type",breaks=c("darkred","blue"), labels = c("Forward Rates", "Spot Rates"))

# US Treausry yield curve plot as of 8/12/17 incl. Forward Rates
ggplot(data=data.frame("Maturity"=maturity,"Yields"=yields,"Forward"=c(0,sapply(1:(nrow(Y)-1),function(x) ForwardRates(Y,Y[x,1],Y[x+1,1]))))) + geom_line(aes(x=maturity,y=yields,color="blue")) + geom_line(aes(x=maturity,y=Forward,color="darkred")) +
  theme(legend.position = c(0.75,0.25),legend.justification = c(0, 1), panel.background = element_blank(),
        axis.line.x = element_line(color = "black", 
                                   arrow = arrow(length = unit(0.25, 
                                                               "cm"))),
        axis.line.y = element_line(color = "black", 
                                   arrow = arrow(length = unit(0.25, 
                                                               "cm")))) + 
  scale_colour_discrete(name="Rate Type",breaks=c("darkred", "blue"), labels = c("Forward Rates", "Spot Rates"))

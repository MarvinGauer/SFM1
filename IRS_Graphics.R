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

######## 1. Plots

ggplot(data=data.frame(Maturity,Yields,"Forward"=c(0,sapply(1:(nrow(y)-1),function(x) ForwardRates(y,y[x,1],y[x+1,1]))))) + geom_line(aes(x=Maturity,y=Yields,color="darkred")) + geom_line(aes(x=Maturity,y=Forward,color="blue")) +
  theme(legend.position = c(0.75,0.25),legend.justification = c(0, 1), panel.background = element_blank(),
        axis.line.x = element_line(color = "black", 
                                   arrow = arrow(length = unit(0.25, 
                                                               "cm"))),
        axis.line.y = element_line(color = "black", 
                                   arrow = arrow(length = unit(0.25, 
                                                               "cm")))) + 
  scale_colour_discrete(name="Rate Type",breaks=c("blue", "darkred"), labels = c("Forward Rates", "Spot Rates"))

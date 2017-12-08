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

######## 1. Input Parameters

Rfix = 0.075 # Fix Rate

Maturity = c(0,0.5,1,1.5,2)
Yields = c(0,2*(1/0.97)-2,(1/0.94)-1,((1/0.91)-1)/3*2,((1/0.87)-1)/2)


y = data.frame(Maturity, Yields) # zero-bond-yield-curve

P = 1 # Principal

######## 2. Valuation

######## 2.1. Helper Functions

Bfix = function(yields, Coupon_Anually, P=1){
  
  D = sapply(1:(nrow(yields)), function(x) (yields[x,2]*yields[x,1]+1)^(-1)) # Discountfactors
  PayDiff = c(0,diff(yields[,1]))
  BondPrice = (D%*%(PayDiff*Coupon_Anually)+D[length(D)])*P
  
  return(BondPrice)
  
}

FRA = function(Rfix,yields,Si,Ti,P=1){ # Si<Ti and both are the times of the yield
  
  DSi = ((yields[,2][yields[,1]==Si]*Si)+1)^(-1) # Discountfactor corresponding to Si
  DTi = ((yields[,2][yields[,1]==Ti]*Ti)+1)^(-1) # Discountfactor corresponding to Ti
  FRA = DTi*(Ti-Si)*Rfix+DTi-DSi # Price of the FRA
  
  return(FRA)
}

ForwardRates = function(yields,Si,Ti){ # Si<Ti and both are the times of the yield
  
  DSi = ((yields[,2][yields[,1]==Si]*Si)+1)^(-1) # Discountfactor corresponding to Si
  DTi = ((yields[,2][yields[,1]==Ti]*Ti)+1)^(-1) # Discountfactor corresponding to Ti
  FR = (1/(Ti-Si))*((DSi/DTi)-1)
  
  return(FR)
  
}

######## 2.2. Valuation in Terms of Bond Prizes

VSwapB = as.numeric(Bfix(y,Rfix,P) - 1)

######## 2.3. Valuation in Terms of FRA Prizes

VSwapFRA = sum(unlist(lapply(1:(nrow(y)-1),function(x) FRA(Rfix,y,y[x,1],y[x+1,1])))) # Sumation of different FRAs

######## 2.4. Valuation in Terms of Forward Rates

VSwapR = as.numeric((sapply(2:(nrow(y)), function(x) (y[x,2]*y[x,1]+1)^(-1)) * diff(y[,1])) %*% (Rfix - sapply(1:(nrow(y)-1),function(x) ForwardRates(y,y[x,1],y[x+1,1]))))

######## 3. Results & Graphics

data.frame("Bond"=VSwapB,"FRA"=VSwapFRA,"Forward Rate"=VSwapR)

ggplot(data=data.frame(Maturity,Yields,"Forward"=c(0,sapply(1:(nrow(y)-1),function(x) ForwardRates(y,y[x,1],y[x+1,1]))))) + geom_line(aes(x=Maturity,y=Yields,color="darkred")) + geom_line(aes(x=Maturity,y=Forward,color="blue")) +
  theme(legend.position = c(0.75,0.25),legend.justification = c(0, 1), panel.background = element_blank(),
      axis.line.x = element_line(color = "black", 
                                 arrow = arrow(length = unit(0.25, 
                                                             "cm"))),
      axis.line.y = element_line(color = "black", 
                                 arrow = arrow(length = unit(0.25, 
                                                             "cm")))) + 
  scale_colour_discrete(name="Rate Type",breaks=c("blue", "darkred"), labels = c("Forward Rates", "Spot Rates"))
  
############################################################################
######## SFM1 - Project -> Compare the three different ways to value an IRS
############################################################################

######## 1. Input Parameters

Rfix = 0.08 # Fix Rate
Rflex = 0.102 # Flexible Rate (usually LIBOR)
Comp = 2 # Compounding Frequency

y = matrix(c(0.25,0.75,1.25,0.1,0.105,0.11),ncol=2,byrow = F) # zero-bond-yield-curve

P = 100 # Principial

######## 2. Valuation

######## 2.1. Calculation Functions

Bfix = function(yields, CompFreq, Coupon_Anually, Principal){
  
  N = nrow(yields) #Number of Payments
  C = (Coupon_Anually*Principal)/CompFreq # Coupon per Payment
  CF = rep(C,N) # Cashflow Vector incl. Coupons
  CF[length(CF)] = CF[length(CF)] + Principal # Cashflow Vector incl. Coupons and Principal
  Discount = exp(-1 * yields[,1] * yields[,2]) # Discount Factors per Payment
  BondPrice = Discount %*% CF
  
  return(BondPrice)
  
}

Bflex = function(yields, CompFreq, Rflex, Principal){
  
  K = (Rflex*Principal)/CompFreq
  CF = Principal + K
  Discount = exp(-1 * yields[1] * yields[2])
  Price = Discount %*% CF
  
  return(Price)
}

#UNDER CONSTRUCTION
FRA = function(Rfix,yields,Time1,Time2,P){
  Rforward = yields[,2][yields[,1]==Time1]
}

######## 2.2. Valuation in Terms of Bond Prizes

VSwap = Bfix(y,Comp,Rfix,P) - Bflex(y[1,],Comp,Rflex,P)

######## 2.3. Valuation in Terms of FRA Prizes

######## 2.4. Valuation in Terms of XXX Prizes

######## 3. Results & Graphics


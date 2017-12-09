# SFM1 - Project -> Compare the three different ways to value an IRS

import numpy as np


######## 1.Input Parameters

Rfix = 0.075 # Fixed Rate

Maturity = [0,0.5,1,1.5,2]
Yields = [0,2*(1/0.97)-2,(1/0.94)-1,((1/0.91)-1)/3*2,((1/0.87)-1)/2]

y = [Maturity,Yields]

P = 1 # Principal

######## 2. Valuation

######## 2.1. Helper Functions

def Bfix(yields, Coupon_Anually, P):
    
    yields = list(yields)
    Coupon_Anually = float(Coupon_Anually)
    P = float(P)    
    
    D = list(map(lambda x: (yields[1][x]*yields[0][x]+1)**(-1),range(len(yields[0]))))   
    PayDiff = list(np.diff(yields[0]))
    PayDiff.insert(0,0)
    PayDiff = [x*Coupon_Anually for x in PayDiff]
    BondPrice = (np.dot(D,PayDiff)+D[len(D)-1])*P
    
    return(BondPrice)

def FRA(Rfix,yields,Si,Ti,P):
    
    Rfix = float(Rfix)     
    yields = list(yields)
    P = float(P)
    Si = float(Si)
    Ti = float(Ti)
    
    DSi = ((yields[1][yields[0].index(Si)]*Si)+1)**(-1)
    DTi = ((yields[1][yields[0].index(Ti)]*Ti)+1)**(-1)
    FRA = P*(DTi*(Ti-Si)*Rfix+DTi-DSi) # Price of the FRA
    
    return(FRA)

def ForwardRates(yields,Si,Ti):
    
    yields = list(yields)
    Si = float(Si)
    Ti = float(Ti)    
    
    DSi = ((yields[1][yields[0].index(Si)]*Si)+1)**(-1)
    DTi = ((yields[1][yields[0].index(Ti)]*Ti)+1)**(-1)
    FR = (1/(Ti-Si))*((DSi/DTi)-1)
    
    return(FR)

######## 2.2. Valuation in Terms of Bond Prizes

VSwapB = float(Bfix(y,Rfix,P) - 1)

######## 2.3. Valuation in Terms of FRA Prizes

VSwapFRA = sum(list(map(lambda x: FRA(Rfix,y,y[0][x],y[0][x+1],P),range(len(y[0])-1))))

######## 2.4. Valuation in Terms of Forward Rates

VSwapR = np.dot(list(np.multiply(list(map(lambda x: (y[1][x]*y[0][x]+1)**(-1),range(1,len(y[0])))),list(np.diff(y[0])))),[Rfix-x for x in list(map(lambda x: ForwardRates(y,y[0][x],y[0][x+1]),range(len(y[0])-1)))])


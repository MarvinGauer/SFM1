# SFM1 - Project -> Compare the three different ways to value an IRS

import numpy as np
import matplotlib as mpl
import pandas as pd


######## 1.Input Parameters

Rfix = 0.075 # Fixed Rate

Maturity = [0,0.5,1,1.5,2,2.5]
Yields = [0,2*(1/0.97)-2,(1/0.94)-1,((1/0.91)-1)/3*2,((1/0.87)-1)/2,0.08]

y = [Maturity,Yields]

P = 10 # Principal

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
    
    NPVs = [x*y*P for x,y in zip(D,PayDiff)]
    NPVs[len(NPVs)-1] =  NPVs[len(NPVs)-1] + D[len(D)-1]*P
    
    
    return(BondPrice,NPVs)

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

VSwapB = float(Bfix(y,Rfix,P)[0] - P)

######## 2.3. Valuation in Terms of FRA Prizes

VSwapFRA = sum(list(map(lambda x: FRA(Rfix,y,y[0][x],y[0][x+1],P),range(len(y[0])-1))))

######## 2.4. Valuation in Terms of Forward Rates

ERate = [x-y for x,y in zip([Rfix]*(len(y[0])-1), list(map(lambda x: ForwardRates(y,y[0][x],y[0][x+1]),range(len(y[0])-1))) )]
L = list(np.diff(y[0]))
D = list(map(lambda x: (y[0][x]*y[1][x]+1)**(-1),range(len(y[0]))))[1:]

DCF = [x*y*z for x,y,z in zip(ERate,L,D)]
DCF.insert(0,0)
DCF = [x*P for x in DCF]

VSwapR = sum(DCF)


######## 3. Results
import plotly.offline as offline
import plotly.plotly as py
import plotly.graph_objs as go

headerColor = 'grey'

Maturity_tab    = Maturity + ['<b>RESULTS:</b>']
FixBondCashFlow = list(Bfix(y,Rfix,P)[1]) + [Bfix(y,Rfix,P)[0]]
FloatRateNote   = [P] + list(np.repeat('',len(Maturity)-1)) + [P]
BondBasedVal    = list(np.repeat('',len(Maturity))) + [Bfix(y,Rfix,P)[0]-P]
FRAVal          = pd.Series(list(np.arange(0,len(y[0])-1))).apply(lambda x: FRA(Rfix,y,y[0][x],y[0][x+1],P))
FRAVal          = [0] + FRAVal.tolist() + [VSwapFRA]
DCF_tab         = DCF + [sum(DCF)]

values = [Maturity_tab, FixBondCashFlow, FloatRateNote, BondBasedVal, FRAVal, DCF_tab]

trace0 = go.Table(
  type = 'table',
  header = dict(
    values = [['<b>Maturity</b>'],
              ['<b>Fixed Bond Cash Flows</b>'],
              ['<b>Floating Rate Note</b>'],
              ['<b>Bond based Value</b>'],
              ['<b>FRA Value</b>'],
              ['<b>DCF</b>']],
    fill = dict(color = '#506784'),
    align = ['center'],
    font = dict(color = 'white', size = 12)
  ),
  cells = dict(
    values = values,
    fill = dict(color = [list(np.repeat('white',len(Maturity))) + ['lightgrey']]),
    align = ['center'],
    height = 30,
    font = dict(color = '#506784', size = 12)
    ))

data = [trace0]

offline.plot(data, filename = "Results IRS Valuation")

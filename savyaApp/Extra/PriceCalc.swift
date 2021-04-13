//
//  PriceCalc.swift
//  savyaApp
//
//  Created by Yash on 9/13/20.
//  Copyright © 2020 Yash Rathod. All rights reserved.
//

public class PriceCalculation {
    
    static let shared = PriceCalculation()

    //  Gold Price calcuation
    public func goldPrice(goldRate:Double, goldweight:Double, goldPurity:Double, goldWastage:Double) -> Double {
        let goldRates = String(format: "%.1f", goldRate)
        let goldweights = String(format: "%.3f", goldweight)
        
        
        
        return goldRates.toDouble() * (goldweights.toDouble() * (goldPurity + goldWastage) / 100)
    }
    public func goldFineWeight(goldweight:Double, goldPurity:Double, goldWastage:Double) -> Double {

        return (goldweight * (goldPurity + goldWastage) / 100)
    }
    //Gold Making Charge Calculation
    public func goldMakingCharge( goldWeight:Double, makingTypeFixed:Bool, makingChargeRate:Double) -> Double {
      //  print("Making Charge "," "+makingChargeRate +" "+makingTypeFixed +" "+goldWeight)

        
        
        
        
        if makingTypeFixed {
            return makingChargeRate
        } else {
            return makingChargeRate * goldWeight
        }
    }


    //Stone Calculation

    public func stonePrice( stoneWeight:Double, stoneRate:Double) -> Double {
        return stoneRate * stoneWeight

    }

    // Diamond Calculation
    public func diamondPrice( diamondWeight:Double, diamondRate:Double) -> Double {
        return diamondRate * diamondWeight
    }

    public func certificateCost( weight:Double, isPerCertificate:Bool, rate:Double) -> Double {
        if (isPerCertificate) {
            return rate * weight
        } else {
            return  rate
        }
    }

    // Platinum calculation
    public func platinumPrice( weight:Double, rate:Double, wastage:Double, purity:Double) -> Double {

//        Log.e("Platinum Rate ",""+rate);
//        Log.e("Platinum weight ",""+weight);
//        Log.e("Platinum wastage ",""+wastage);
//        Log.e("Platinum purity ",""+purity);

        return rate * (weight * (wastage + purity) / 100)
    }

    public func MeenaCost( meenaRate:Double, weight:Double, isPergram:Bool) -> Double {
        if isPergram {
            return  meenaRate * weight
        } else {
           return meenaRate
        }
    }

    public func platinumMaking( weight:Double, rate:Double, isPerGram: Bool) -> Double {
        if isPerGram {
            return rate * weight
        } else {
            return  rate
        }
    }

    // Silver Calculation
    public func silverPrice( weight:Double, rate:Double, wastage:Double, purity:Double) -> Double {
        
        return  rate * (weight * (wastage + purity) / 100)
    }

    public func silverMaking( weight:Double, rate:Double, isPergram:Bool) -> Double {
        if isPergram {
            return rate * weight
        } else {
            return  rate
        }
    }

}

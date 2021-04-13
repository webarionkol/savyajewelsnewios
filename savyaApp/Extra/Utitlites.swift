//
//  Utitlites.swift
//  savyaApp
//
//  Created by Yash on 9/17/19.
//  Copyright © 2019 Yash Rathod. All rights reserved.
//

import Foundation

class Utils {
    
    class func calculatePrice(type:String,weight:Float,rate:Float,makingCharge:Float,option:String,goldValue:Float,gold24k:Float) -> Double {
        if type == "Platinum" {
            if option == "PerGram" {
                
                let ws = (rate + makingCharge)*weight
                let w1 = weight * rate
                let w2 = weight * makingCharge
                
                return Double(ws).rounded(digits: 2)
            } else if option == "Fixed" || option == "PerPiece" {
                return Double(weight * rate + makingCharge).rounded(digits: 2)
            } else if option == "Percentage" {
                let goldCalc = goldValue + makingCharge
                let calc1 = goldCalc * weight
                let fineWeight = calc1 / 100
                let fineprice = fineWeight * gold24k
                return Double(fineprice).rounded(digits: 2)
            }
            return 0.0
        }else if type == "Stone" {
            return Double(weight * rate + makingCharge).rounded(digits: 2)
        }else if type == "Silver" {
            if option == "PerGram" {
                let ws = (rate + makingCharge)*weight
                let w1 = weight * rate
                let w2 = weight * makingCharge
                
                return Double(w1).rounded(digits: 2)
            } else if option == "Fixed" {
                return Double(weight * rate).rounded(digits: 2)
            } else if option == "Percentage" {
                let goldCalc = goldValue + makingCharge
                let calc1 = goldCalc * weight
                let fineWeight = calc1 / 100
                let fineprice = fineWeight * gold24k
                return Double(fineprice).rounded(digits: 2)
            }
            return 0.0
        }
        
        else if type == "Diamond" {
            return Double(weight * rate).rounded(digits: 2)
        }
        else {
            if option == "PerGram" {
                let w1 = weight * rate
                let w2 = weight * makingCharge
                
                return Double(w1).rounded(digits: 2)
            } else if option == "Fixed" {
                return Double(weight * rate).rounded(digits: 2)
            } else if option == "Percentage" {
                let goldCalc = goldValue + makingCharge
                let calc1 = goldCalc * weight
                let fineWeight = calc1 / 100
                let fineprice = fineWeight * gold24k
                return Double(fineprice).rounded(digits: 2)
            }
            return 0.0
        }
        
    }
    class func calculateWeight(goldvalue:Float,weight:Float,makingCharge:Float) -> Float {
        let goldCalc = goldvalue + makingCharge
        let calc1 = goldCalc * weight
        let fineWeight = calc1 / 100
        print(fineWeight)
        return fineWeight
    }
    
    
    class func calculatePlatinumPrice( wastage:Float,purity:Float,weight:Float, rate:Float,  makingCharge:Float, isPerGram:String) -> Float {
        let purityy = Float(95.0)
        let totalPlatinum = wastage + purityy
        if isPerGram == "pergram" {
          
            
            let calc1 = weight * makingCharge
            let calc2 = rate * totalPlatinum / 100
            let calc3 = calc2 * weight
            let total = calc3 + calc1
            
            return total
            //Float(weight * (rate * totalPlatinum / 100) + weight * makingCharge)
        } else {
            return Float(weight * (rate * totalPlatinum / 100) + makingCharge)
        }
    }
}


//,platinumCollection:[String:Any]


/*
 let platinum_qty = platinumCollection["platinum_qty"] as! String
 let wastage = platinumCollection["wastage"] as! String
 let purity = platinumCollection["purity"] as! String
 let platinum_charge = platinumCollection["platinum_charge"] as! String
 let platinumRate = PlatinumPrice.sharedInstance.getpriceByPlatinumName(platinum_type: "Platinum")
 
 let intPurity = Int(purity.replacingOccurrences(of: "0.", with: ""))
 let intWastage = Int(wastage)
 
 let totalPercent = intPurity! + intWastage!
 let perCentCount = Float(totalPercent / 100)
 let intPlatinum_qty = Int(platinum_qty)! - 1
 let calc1 = perCentCount * Float(platinumRate)! * Float(intPlatinum_qty)
 
 let calc2 = Int(platinum_charge)! * intPlatinum_qty
 
 let total = calc1 + Float(calc2)
 
 return Double(total)
 */

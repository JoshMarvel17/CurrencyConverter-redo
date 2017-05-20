//
//  Data.swift
//  CurrencyConverter-redo
//
//  Created by Joshua Marvel on 5/18/17.
//  Copyright © 2017 Joshua Marvel. All rights reserved.
//

import Foundation

class CurrencyData {
    
    

    var currName : String
    
    var currCode : String
    
    var currSymbol : String
    
    var check : Bool
    
    
    
    
    init(currName: String, check: Bool, currCode: String, currSymbol : String){

        self.currName = currName
        
        self.check = check
        
        self.currCode = currCode
        
        self.currSymbol = currSymbol
        
    }
    
    
    
    
    class list {
        
        
        
        var c = [CurrencyData(currName: "US Dollar", check: false, currCode: "USD", currSymbol: "\u{0024}"), CurrencyData(currName: "British Pound", check: false, currCode: "GBP", currSymbol: "\u{00A3}"),CurrencyData(currName: "Yen", check: false, currCode: "JPY", currSymbol: "\u{00A5}"), CurrencyData(currName: "Euro", check: false, currCode: "EUR",currSymbol: "\u{20AC}")]
        static let shared = list()
    }
}

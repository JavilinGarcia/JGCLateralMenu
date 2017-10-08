//
//  NSDictionary+JGCExtension.swift
//  JGCLateralMenu
//
//  Created by Javier Garcia Castro on 8/10/17.
//  Copyright © 2017 Javier Garcia Castro. All rights reserved.
//

import Foundation

extension NSDictionary {
    
    func toJSONString() -> String {
        
        do {
            let jsonData:NSData? = try JSONSerialization.data(withJSONObject: self, options: []) as NSData?
            // you can now use t with the right type
            if jsonData != nil
            {
                return String.init(data: jsonData! as Data, encoding: String.Encoding.utf8)!
            }
                
            else {
                return ""
            }
        } catch let error as NSError {
            print(error)
            return ""
        }
    }
    
    func toURLString() -> String {
        do {
            let jsonData:NSData? = try JSONSerialization.data(withJSONObject: self, options: []) as NSData?
            // you can now use t with the right type
            if jsonData != nil
            {
                var auxString = String.init(data: jsonData! as Data, encoding: String.Encoding.utf8)!
                auxString = auxString.replacingOccurrences(of: ",", with: "&")
                auxString = auxString.replacingOccurrences(of: ":", with: "=")
                auxString = auxString.replacingOccurrences(of: "{", with: "")
                auxString = auxString.replacingOccurrences(of: "}", with: "")
                auxString = auxString.replacingOccurrences(of: "/", with: "")
                return auxString
            }
                
            else {
                return ""
            }
        } catch let error as NSError {
            print(error)
            return ""
        }
    }
    
    func arrayForKey(key: String) -> NSArray? {
        
        if let value: NSArray = self[key] as? NSArray {
            return value
        }
        
        //        let value:AnyObject = self[key] as AnyObject
        //
        //        if value.isKind(of: NSArray.classForCoder()) {
        //            return value as? NSArray
        //        }
        return nil
    }
    
    func dictionaryForKey(key: NSString) -> NSDictionary? {
        
        if let value: NSDictionary = self[key] as? NSDictionary {
            return value
        }
        
        //        let value:AnyObject = self[key] as AnyObject
        //
        //        if value.isKind(of: NSDictionary.classForCoder()) {
        //            return value as? NSDictionary
        //        }
        return nil
    }
    
    func stringForKey(key: String) -> String {
        
        if let value: String = self[key] as? String {
            
            var valueAux: String? = value
            
            if valueAux != nil {
                
                valueAux = self.parseHTML(string: valueAux!)
                
                return valueAux!.trimmingCharacters(in: NSCharacterSet.whitespaces)
            }
        }
        
        if let value: NSNumber = self[key] as? NSNumber {
            return "\(value)"
        }
        
        return ""
    }
    
    func parseHTML(string: String) -> String {
        
        var aux: String
        
        aux = string.replacingOccurrences(of: "&aacute;", with: "á")
        aux = string.replacingOccurrences(of: "&Aacute;", with: "A")
        aux = string.replacingOccurrences(of: "&eacute;", with: "é")
        aux = string.replacingOccurrences(of: "&Eacute;", with: "É")
        aux = string.replacingOccurrences(of: "&iacute;", with: "í")
        aux = string.replacingOccurrences(of: "&Iacute;", with: "I")
        aux = string.replacingOccurrences(of: "&oacute;", with: "ó")
        aux = string.replacingOccurrences(of: "&Oacute;", with: "Ó")
        aux = string.replacingOccurrences(of: "&uacute;", with: "ú")
        aux = string.replacingOccurrences(of: "&Uacute;", with: "Ú")
        aux = string.replacingOccurrences(of: "&nacute;", with: "ñ")
        aux = string.replacingOccurrences(of: "&Nacute;", with: "Ñ")
        aux = string.replacingOccurrences(of: "\\U00bf", with: "Ñ")
        aux = string.replacingOccurrences(of: "\\u00bf", with: "ñ")
        
        return aux
    }
    
    func boolForKey(key: String) -> Bool {
        
        if let value: String = self[key] as? String {
            
            let valueAux: String? = value
            
            if valueAux != nil {
                
                if valueAux!.uppercased().isEqual("TRUE")
                    || valueAux!.uppercased().isEqual("S")
                    || valueAux!.uppercased().isEqual("Y")
                    || valueAux!.uppercased().isEqual("YES") {
                    return true
                }
                else {
                    return false
                }
            }
            return false
        }
        
        return self[key] as! Bool
    }
    
    func intForKey(key: String) -> Int {
        
        if let value: Int = self[key] as? Int {
            
            return value
        }
        
        return 0
        
        //        let value:AnyObject = self[key] as AnyObject
        //
        //        if value.classForCoder == NSNumber.classForCoder() { return value as! Int }
        //
        //        if value.classForCoder == NSString.classForCoder() { return value as! Int }
        //
        //        return 0
    }
    
    func floatForKey(key: String) -> Float {
        
        if let value: Float = self[key] as? Float {
            
            return value
        }
        //        let value:AnyObject = self[key] as AnyObject
        //
        //        if value.classForCoder == NSNumber.classForCoder() { return value as! Float }
        //
        //        if value.classForCoder == NSString.classForCoder() { return value as! Float }
        
        return 0.0
    }
    
    func integerForKey(key: String) -> NSInteger {
        
        if let value: NSInteger = self[key] as? NSInteger {
            
            return value
        }
        
        //        let value:AnyObject = self[key] as AnyObject
        //
        //        if value.classForCoder == NSNumber.classForCoder() { return value as! NSInteger }
        //
        //        if value.classForCoder == NSString.classForCoder() { return value as! NSInteger }
        
        return 0
    }
    
}


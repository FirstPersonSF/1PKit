//
//  FPDataValidator.swift
//  FPKit
//
//  Created by Sruti Harikumar on 21/1/16.
//  Copyright © 2016 First Person. All rights reserved.
//

import Foundation


public class FPDataValidator {
    
//MARK:- Public Validation Methods
    
    class public func validateString(string: String, validations: [FPStringValidations]) -> (isValid: Bool, errorMessages: [String]?) {
        
        if(validations.count <= 0) {
            return (isValid: false, errorMessages: nil)
        }
        
        var errorMessages = [String]()
        var isValid : Bool = true
        
        for validation in validations {
            switch validation {
            
            case let .isEmail(errorMessage):
                if !FPDataValidator.isEmail(string) {
                    isValid = false
                    errorMessages.append(errorMessage)
                }
                
            case let .isURL(errorMessage):
                if !FPDataValidator.isURL(string) {
                    isValid = false
                    errorMessages.append(errorMessage)
                }
                
            case let .isPhoneNumber(errorMessage):
                if !FPDataValidator.isPhoneNumber(string) {
                    isValid = false
                    errorMessages.append(errorMessage)
                }
                
            case let .isFullName(errorMessage):
                if !FPDataValidator.isFullName(string) {
                    isValid = false
                    errorMessages.append(errorMessage)
                }
                
            case let .containsCharactersRange(lessThanNum, greaterThanNum, errorMessage):
                if !FPDataValidator.containsCharactersRange(string, lessThan: lessThanNum, greaterThan: greaterThanNum) {
                    isValid = false
                    errorMessages.append(errorMessage)
                }
                
            case let .containsCharactersLength(equalToNum, errorMessage):
                if !FPDataValidator.containsCharactersLength(string, equalTo: equalToNum) {
                    isValid = false
                    errorMessages.append(errorMessage)
                }
                
            case let .containsSpecialCharactersRange(lessThanNum, greaterThanNum, errorMessage):
                if !FPDataValidator.containsSpecialCharactersRange(string, lessThan: lessThanNum, greaterThan: greaterThanNum) {
                    isValid = false
                    errorMessages.append(errorMessage)
                }
                
            case let .containsSpecialCharactersLength(equalToNum, errorMessage):
                if !FPDataValidator.containsSpecialCharactersLength(string, equalTo: equalToNum) {
                    isValid = false
                    errorMessages.append(errorMessage)
                }
                
            case let .containsNumbersRange(lessThanNum, greaterThanNum, errorMessage):
                if !FPDataValidator.containsNumbersRange(string, lessThan: lessThanNum, greaterThan: greaterThanNum) {
                    isValid = false
                    errorMessages.append(errorMessage)
                }
                
            case let .containsNumbersLength(equalToNum, errorMessage):
                if !FPDataValidator.containsNumbersLength(string, equalTo: equalToNum) {
                    isValid = false
                    errorMessages.append(errorMessage)
                }
            case let .evaluatesWithRegex(regex, errorMessage):
                if !FPDataValidator.evaluatesWithRegex(string, regex: regex) {
                    isValid = false
                    errorMessages.append(errorMessage)
                }
                
            case let .containsUpperCaseCharactersRange(lessThanNum, greaterThanNum, errorMessage):
                if !FPDataValidator.containsUpperCaseCharactersRange(string, lessThan: lessThanNum, greaterThan: greaterThanNum) {
                    isValid = false
                    errorMessages.append(errorMessage)
                }
                
            case let .containsUpperCaseCharactersLength(equalToNum, errorMessage):
                if !FPDataValidator.containsUpperCaseCharactersLength(string, equalTo: equalToNum) {
                    isValid = false
                    errorMessages.append(errorMessage)
                }
            }
        }
        
        return(isValid: isValid, errorMessages: errorMessages)

    }
    
//MARK:- Internal Methods - String Validations
    
    class private func isEmail(string: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluateWithObject(string)
    }
    
    class private func isURL(string: String) -> Bool {
        let urlRegEx = "(?i)https?://(?:www\\.)?\\S+(?:/|\\b)"
        let urlTest = NSPredicate(format: "SELF MATCHES %@", urlRegEx)
        
        return urlTest.evaluateWithObject(string)
    }
    
    class private func isPhoneNumber(string: String) -> Bool {
        let phoneRegex1 = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneRegex2 = "^\\d{10}$"
        let phoneRegex3 = "^\\(\\d{3}\\)\\d{3}-\\d{4}$"
        
        let phoneTest1 = NSPredicate(format: "SELF MATCHES %@", phoneRegex1)
        let phoneTest2 = NSPredicate(format: "SELF MATCHES %@", phoneRegex2)
        let phoneTest3 = NSPredicate(format: "SELF MATCHES %@", phoneRegex3)
        
        let passed = phoneTest1.evaluateWithObject(string) || phoneTest2.evaluateWithObject(string) || phoneTest3.evaluateWithObject(string)
        
        return passed
    }
    
    class private func isFullName(string: String) -> Bool {
        let nameArray: [String] = string.characters.split { $0 == " " }.map { String($0) }
        
        return nameArray.count >= 2
    }
    
    class private func containsCharactersRange(string: String, lessThan: Int?, greaterThan: Int?) -> Bool {
        var passed = true
        let length = string.characters.count
        if let lessThanNum = lessThan {
            if length >= lessThanNum {
                passed = false
            }
        }
        if let greaterThanNum = greaterThan {
            if length <= greaterThanNum {
                passed = false
            }
        }
        
        return passed
    }
    
    class private func containsCharactersLength(string: String, equalTo: Int) -> Bool {
        let length = string.characters.count
        
        return length == equalTo
    }
    
    class private func containsSpecialCharactersRange(string: String, lessThan: Int?, greaterThan: Int?) -> Bool {
        var passed = true
        let specialCharRegex = "[^A-Za-z0-9]"
        var count = 0
        for char in string.characters {
            let c = String(char)
            let test = NSPredicate(format: "SELF MATCHES %@", specialCharRegex)
            if test.evaluateWithObject(c) {
                count++
            }
        }
        
        if let lessThanNum = lessThan {
            if count >= lessThanNum {
                passed = false
            }
        }
        if let greaterThanNum = greaterThan {
            if count <= greaterThanNum {
                passed = false
            }
        }
        
        return passed
    }
    
    class private func containsSpecialCharactersLength(string: String, equalTo: Int) -> Bool {
        let specialCharRegex = "[^A-Za-z0-9]"
        var count = 0
        for char in string.characters {
            let c = String(char)
            let test = NSPredicate(format: "SELF MATCHES %@", specialCharRegex)
            if test.evaluateWithObject(c) {
                count++
            }
        }
        
        return count == equalTo
    }
    
    class private func containsNumbersRange(string: String, lessThan: Int?, greaterThan: Int?) -> Bool {
        var passed = true
        let numberRegex = "[0-9]$"
        var count = 0
        for char in string.characters {
            let c = String(char)
            let test = NSPredicate(format: "SELF MATCHES %@", numberRegex)
            if test.evaluateWithObject(c) {
                count++
            }
        }
        if let lessThanNum = lessThan {
            if count >= lessThanNum {
                passed = false
            }
        }
        if let greaterThanNum = greaterThan {
            if count <= greaterThanNum {
                passed = false
            }
        }
        
        return passed
    }
    
    class private func containsNumbersLength(string: String, equalTo: Int) -> Bool {
        let numberRegex = "[0-9]$"
        var count = 0
        for char in string.characters {
            let c = String(char)
            let test = NSPredicate(format: "SELF MATCHES %@", numberRegex)
            if test.evaluateWithObject(c) {
                count++
            }
        }
        
        return count == equalTo
    }
    
    class private func evaluatesWithRegex(string: String,regex: String) -> Bool {
        
        let test = NSPredicate(format: "SELF MATCHES %@", regex)
        return test.evaluateWithObject(string)
    
    }
    
    class private func containsUpperCaseCharactersRange(string: String, lessThan: Int?, greaterThan: Int?) -> Bool {
        
        var passed = true
        let upperCaseRegex = "[A-Z]$"
        var count = 0
        for char in string.characters {
            let c = String(char)
            let test = NSPredicate(format: "SELF MATCHES %@", upperCaseRegex)
            if test.evaluateWithObject(c) {
                count++
            }
        }
        if let lessThanNum = lessThan {
            if count >= lessThanNum {
                passed = false
            }
        }
        if let greaterThanNum = greaterThan {
            if count <= greaterThanNum {
                passed = false
            }
        }
        
        return passed

        
    }
    
    class private func containsUpperCaseCharactersLength(string: String, equalTo:Int) -> Bool {
        
        let upperCaseRegex = "[A-Z]$"
        var count = 0
        for char in string.characters {
            let c = String(char)
            let test = NSPredicate(format: "SELF MATCHES %@", upperCaseRegex)
            if test.evaluateWithObject(c) {
                count++
            }
        }
        
        return count == equalTo
        
    }
}



 
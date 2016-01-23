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
    public func validateString(string: String,validations: [FPStringValidations]) -> (isValid: Bool, errorMessages: [String]?) {
        
        if(validations.count <= 0) {
            return (isValid: false, errorMessages: nil)
        }
        
        var errorMessages = [String]()
        var isValid : Bool = true
        
        for var validation in validations {
            switch validation {
            case let .isEmail(errorMessage):
                let emailPassed = self.isEmail(string)
                if emailPassed != true {
                    isValid = false
                    errorMessages.append(errorMessage)
                }
                break
            case let .isURL(errorMessage):
                let urlPassed = self.isURL(string)
                if urlPassed != true {
                    isValid = false
                    errorMessages.append(errorMessage)
                }
                break
            case let .isPhoneNumber(errorMessage):
                let phoneNumberPassed = self.isPhoneNumber(string)
                if phoneNumberPassed != true {
                    isValid = false
                    errorMessages.append(errorMessage)
                }
                break
            case let .isFullName(errorMessage):
                let fullNamePassed = self.isFullName(string)
                if fullNamePassed != true {
                    isValid = false
                    errorMessages.append(errorMessage)
                }
                break
            case let .containsCharactersRange(lessThanNum, greaterThanNum, errorMessage):
                let containsCharactersRangePassed = self.containsCharactersRange(string, lessThan: lessThanNum, greaterThan: greaterThanNum)
                if containsCharactersRangePassed != true {
                    isValid = false
                    errorMessages.append(errorMessage)
                }
                break
            case let .containsCharactersLength(equalToNum, errorMessage):
                let containsCharactersLengthPassed = self.containsCharactersLength(string, equalTo: equalToNum)
                if containsCharactersLengthPassed != true {
                    isValid = false
                    errorMessages.append(errorMessage)
                }
                break
            case let .containsSpecialCharactersRange(lessThanNum, greaterThanNum, errorMessage):
                let containsSpecialCharactersRangePassed = self.containsSpecialCharactersRange(string, lessThan: lessThanNum, greaterThan: greaterThanNum)
                if containsSpecialCharactersRangePassed != true {
                    isValid = false
                    errorMessages.append(errorMessage)
                }
                break
            case let .containsSpecialCharactersLength(equalToNum, errorMessage):
                let containsSpecialCharactersLength = self.containsSpecialCharactersLength(string, equalTo: equalToNum)
                if containsSpecialCharactersLength != true {
                    isValid = false
                    errorMessages.append(errorMessage)
                }
                break
            case let .containsNumbersRange(lessThanNum, greaterThanNum, errorMessage):
                let containsNumbersRangePassed = self.containsNumbersRange(string, lessThan: lessThanNum, greaterThan: greaterThanNum)
                if containsNumbersRangePassed != true {
                    isValid = false
                    errorMessages.append(errorMessage)
                }
                break
            case let .containsNumbersLength(equalToNum, errorMessage):
                let containsNumbersLengthPassed = self.containsNumbersLength(string, equalTo: equalToNum)
                if containsNumbersLengthPassed != true {
                    isValid = false
                    errorMessages.append(errorMessage)
                }
                break
            }
        }
        
        return(isValid: isValid,errorMessages: errorMessages)
    
    }
    
    
//MARK:- Internal Methods - String Validations
    private func isEmail(string: String) -> Bool{
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(string)
    }
    
    private func isURL(string: String) -> Bool{
        let urlRegEx = "(?i)https?://(?:www\\.)?\\S+(?:/|\\b)"
        let urlTest = NSPredicate(format: "SELF MATCHES %@", urlRegEx)
        return urlTest.evaluateWithObject(string)
    }
    
    private func isPhoneNumber(string: String) -> Bool {
        let phoneRegex1 = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneRegex2 = "^\\d{10}$"
        let phoneRegex3 = "^\\(\\d{3}\\)\\d{3}-\\d{4}$"
        
        let phoneTest1 = NSPredicate(format: "SELF MATCHES %@", phoneRegex1)
        let phoneTest2 = NSPredicate(format: "SELF MATCHES %@", phoneRegex2)
        let phoneTest3 = NSPredicate(format: "SELF MATCHES %@", phoneRegex3)
        
        return phoneTest1.evaluateWithObject(string) || phoneTest2.evaluateWithObject(string) || phoneTest3.evaluateWithObject(string)
        
    }
    
    private func isFullName(string: String) -> Bool {
        
        let nameArray: [String] = string.characters.split { $0 == " " }.map { String($0) }
        return nameArray.count >= 2
    }
    
    private func containsCharactersRange(string: String, lessThan: Int?, greaterThan: Int?) -> Bool {
        
        var passed = true
        let length = string.characters.count
        if let lessThanNum = lessThan {
            if length >= lessThanNum {
                passed = false
            }
        }
        if let greaterThanNum = greaterThan {
            if length < greaterThanNum {
                passed = false
            }
        }
        
        return passed
    }
    
    private func containsCharactersLength(string: String, equalTo: Int) -> Bool {
        let length = string.characters.count
        return length == equalTo
    }
    
    private func containsSpecialCharactersRange(string: String, lessThan: Int?, greaterThan: Int?) -> Bool {
        
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
            if count < greaterThanNum {
                passed = false
            }
        }
        
        return passed
    }
    
    private func containsSpecialCharactersLength(string: String, equalTo: Int) -> Bool {
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
    
    private func containsNumbersRange(string: String, lessThan: Int?, greaterThan: Int?) -> Bool {
        
        
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
            if count < greaterThanNum {
                passed = false
            }
        }
        
        return passed

    }
    
    private func containsNumbersLength(string: String, equalTo: Int) -> Bool {
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


    
}



 
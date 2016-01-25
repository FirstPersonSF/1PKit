//
//  FPDataValidatorSpec.swift
//  FPKit
//
//  Created by Sruti Harikumar on 22/1/16.
//  Copyright © 2016 First Person. All rights reserved.
//

import Foundation
import Quick
import Nimble
import FPKit


class FPDataValidatorSpec: QuickSpec {
    
    override func spec() {
//MARK:- String Validator - Email
        describe("A String Validator - Email ", closure: {
            
            let isEmailValidation = FPStringValidations.isEmail(errorMessage: "Email is not Valid")
            var validations: [FPStringValidations] = []
            
            context("when checking for a valid email", closure: {
                
                beforeEach({
                     validations  = [isEmailValidation]
                })
                
                it("is valid", closure: {
                    let emailString = "abcd@firstperson.is"
                    let valueReturned = FPDataValidator.validateString(emailString, validations: validations)
                    expect(valueReturned.isValid).to(beTrue())
                })
                
                it("is invalid - no '@' sign", closure: {
                    let emailString = "abcd.firstperson.is"
                    let valueReturned = FPDataValidator.validateString(emailString, validations: validations)
                    expect(valueReturned.isValid).to(beFalse())
                    expect(valueReturned.errorMessages).toNot(beEmpty())
                })
                
                it("is invalid - no domain", closure: {
                    let emailString = "abcd@firstpersonis"
                    let valueReturned = FPDataValidator.validateString(emailString, validations: validations)
                    expect(valueReturned.isValid).to(beFalse())
                    expect(valueReturned.errorMessages).toNot(beEmpty())
                })
                
                it("is invalid - ends with a dot", closure: {
                    let emailString = "abcd@firstpersonis."
                    let valueReturned = FPDataValidator.validateString(emailString, validations: validations)
                    expect(valueReturned.isValid).to(beFalse())
                    expect(valueReturned.errorMessages).toNot(beEmpty())
                })

                
            })
        })
        
        
        
        
//MARK:- String Validator - URL
        describe("A String Validator - URL ", closure: {
            
            let isURLValidation = FPStringValidations.isURL(errorMessage: "URL is not Valid")
            var validations: [FPStringValidations] = []
            
            context("when checking for a valid URL", closure: {
                
                beforeEach({
                    validations  = [isURLValidation]
                })
                
                it("is valid", closure: {
                    let urlString = "http://www.firstperson.is"
                    let valueReturned = FPDataValidator.validateString(urlString, validations: validations)
                    expect(valueReturned.isValid).to(beTrue())
                })
                
                it("is invalid - no http", closure: {
                    let urlString = "://www.firstperson.is"
                    let valueReturned = FPDataValidator.validateString(urlString, validations: validations)
                    expect(valueReturned.isValid).to(beFalse())
                    expect(valueReturned.errorMessages).toNot(beEmpty())
                })
                
                it("is invalid - ending with .", closure: {
                    let urlString = "http://www.firstperson."
                    let valueReturned = FPDataValidator.validateString(urlString, validations: validations)
                    expect(valueReturned.isValid).to(beFalse())
                    expect(valueReturned.errorMessages).toNot(beEmpty())
                })

                
            })
            
        })
        
        
//MARK:- String Validator - Phone number
        describe("A String Validator - Phone Number ", closure: {
            
            let isPhoneNumberValidation = FPStringValidations.isPhoneNumber(errorMessage: "Phone number is not Valid")
            var validations: [FPStringValidations] = []
            
            context("when checking for a valid Phone number - with parenthesis", closure: {
                
                beforeEach({
                    validations  = [isPhoneNumberValidation]
                })
                
                it("is valid", closure: {
                    let phoneNumberString = "(404)333-1111"
                    let valueReturned = FPDataValidator.validateString(phoneNumberString, validations: validations)
                    expect(valueReturned.isValid).to(beTrue())
                })
                
                it("is valid - without parenthesis", closure: {
                    let phoneNumberString = "404-333-1111"
                    let valueReturned = FPDataValidator.validateString(phoneNumberString, validations: validations)
                    expect(valueReturned.isValid).to(beTrue())
                })
                
                it("is invalid  - not 10 digits", closure: {
                    let phoneNumberString = "40433311198"
                    let valueReturned = FPDataValidator.validateString(phoneNumberString, validations: validations)
                    expect(valueReturned.isValid).to(beFalse())
                    expect(valueReturned.errorMessages).toNot(beEmpty())
                })
                
            })
        })
            

//MARK:- String Validator - Full Name
            describe("A String Validator - Full Name ", closure: {
                
                let isFullNameValidation = FPStringValidations.isFullName(errorMessage: "Not a Full Name")
                var validations: [FPStringValidations] = []
                
                context("when checking for a valid full Name", closure: {
                    
                    beforeEach({
                        validations  = [isFullNameValidation]
                    })
                    
                    it("is valid", closure: {
                        let fullNameString = "First Person"
                        let valueReturned = FPDataValidator.validateString(fullNameString, validations: validations)
                        expect(valueReturned.isValid).to(beTrue())
                    })
                    
                    it("is invalid - one word", closure: {
                        let fullNameString = "FirstPerson"
                        let valueReturned = FPDataValidator.validateString(fullNameString, validations: validations)
                        expect(valueReturned.isValid).to(beFalse())
                        expect(valueReturned.errorMessages).toNot(beEmpty())
                    })

                    
                })
        })

//MARK:- String Validator - String length Range
        describe("A String Validator - String length Range", closure: {
            
            let isStringLengthRangeValidation = FPStringValidations.containsCharactersRange(lessThan: 10, greaterThan: 5, errorMessage: "Number of characters should be greater than 5 and less than 10")
            var validations: [FPStringValidations] = []
            
            context("when checking for a valid String length Range", closure: {
                
                beforeEach({
                    validations  = [isStringLengthRangeValidation]
                })
                
                it("is valid", closure: {
                    let string = "Hello123"
                    let valueReturned = FPDataValidator.validateString(string, validations: validations)
                    expect(valueReturned.isValid).to(beTrue())
                })
                
                it("is invalid - More characters than Max", closure: {
                    let string = "Hello1234567"
                    let valueReturned = FPDataValidator.validateString(string, validations: validations)
                    expect(valueReturned.isValid).to(beFalse())
                    expect(valueReturned.errorMessages).toNot(beEmpty())
                })
                
                it("is invalid - Less characters than Min", closure: {
                    let string = "1P"
                    let valueReturned = FPDataValidator.validateString(string, validations: validations)
                    expect(valueReturned.isValid).to(beFalse())
                    expect(valueReturned.errorMessages).toNot(beEmpty())
                })

                
            })
            
        })
        
//MARK:- String Validator - String length
        describe("A String Validator - String length ", closure: {
            
            let isStringLengthValidation = FPStringValidations.containsCharactersLength(equalTo: 8, errorMessage: "Number of characters should be equal to 8")
            var validations: [FPStringValidations] = []
            
            context("when checking for a valid String length Range", closure: {
                
                beforeEach({
                    validations  = [isStringLengthValidation]
                })
                
                it("is valid", closure: {
                    let string = "Hello123"
                    let valueReturned = FPDataValidator.validateString(string, validations: validations)
                    expect(valueReturned.isValid).to(beTrue())
                })
                
                it("is invalid - wrong Length ", closure: {
                    let string = "Hello1234567"
                    let valueReturned = FPDataValidator.validateString(string, validations: validations)
                    expect(valueReturned.isValid).to(beFalse())
                    expect(valueReturned.errorMessages).toNot(beEmpty())
                })
                
            })
        })

//MARK:- String Validator - Number of Special Characters Range
        describe("A String Validator - Number of Special Characters Range", closure: {
            
            let isSpecialCharactersRangeValidation = FPStringValidations.containsSpecialCharactersRange(lessThan: 4, greaterThan: 0, errorMessage: "The Number of Special characters must be greater than 0 and less than 4")
            var validations: [FPStringValidations] = []
            
            context("when checking for valid Special Characters Range", closure: {
                
                beforeEach({
                    validations  = [isSpecialCharactersRangeValidation]
                })
                
                it("is valid", closure: {
                    let string = "Hello@"
                    let valueReturned = FPDataValidator.validateString(string, validations: validations)
                    expect(valueReturned.isValid).to(beTrue())
                })
                
                it("is invalid - More than Max", closure: {
                    let string = "Hello^%$#@@"
                    let valueReturned = FPDataValidator.validateString(string, validations: validations)
                    expect(valueReturned.isValid).to(beFalse())
                    expect(valueReturned.errorMessages).toNot(beEmpty())
                })
                
                it("is invalid - Less than Min", closure: {
                    let string = "1P"
                    let valueReturned = FPDataValidator.validateString(string, validations: validations)
                    expect(valueReturned.isValid).to(beFalse())
                    expect(valueReturned.errorMessages).toNot(beEmpty())
                })
                
            })
        })
        
//MARK:- String Validator - Number of Special Characters equal to
        describe("A String Validator - Number of Special Characters equal to", closure: {
            
            let isSpecialCharactersValidation = FPStringValidations.containsSpecialCharactersLength(equalTo: 2, errorMessage: "Number of Special Characters should be equal to 2")
            var validations: [FPStringValidations] = []
            
            context("when checking for valid Special Characters", closure: {
                
                beforeEach({
                    validations  = [isSpecialCharactersValidation]
                })
                
                it("is valid", closure: {
                    let string = "Hello@!"
                    let valueReturned = FPDataValidator.validateString(string, validations: validations)
                    expect(valueReturned.isValid).to(beTrue())
                })
                
                it("is invalid - wrong number of special Characters", closure: {
                    let string = "Hello@!$%"
                    let valueReturned = FPDataValidator.validateString(string, validations: validations)
                    expect(valueReturned.isValid).to(beFalse())
                    expect(valueReturned.errorMessages).toNot(beEmpty())
                })

                
            })
        })
        

        
//MARK:- String Validator - Number of Numbers Range
        describe("A String Validator - Number of Numbers Range", closure: {
            
            let isNumbersRange = FPStringValidations.containsNumbersRange(lessThan: 2, greaterThan: 0, errorMessage: "Number of numbers in the string should be greater than 0 and less than 2")
            var validations: [FPStringValidations] = []
            
            context("when checking for valid Numbers in String", closure: {
                
                beforeEach({
                    validations  = [isNumbersRange]
                })
                
                it("is valid", closure: {
                    let string = "Hello1"
                    let valueReturned = FPDataValidator.validateString(string, validations: validations)
                    expect(valueReturned.isValid).to(beTrue())
                })
                
                it("is invalid - Less than Min", closure: {
                    let string = "Hello"
                    let valueReturned = FPDataValidator.validateString(string, validations: validations)
                    expect(valueReturned.isValid).to(beFalse())
                    expect(valueReturned.errorMessages).toNot(beEmpty())
                })
                
                it("is invalid", closure: {
                    let string = "Hello12345"
                    let valueReturned = FPDataValidator.validateString(string, validations: validations)
                    expect(valueReturned.isValid).to(beFalse())
                    expect(valueReturned.errorMessages).toNot(beEmpty())
                })

                
            })
        })
        

        
//MARK:- String Validator - Number of Numbers equal to
        describe("A String Validator - Number of Numbers equal to", closure: {
            
            let isNumbers = FPStringValidations.containsNumbersLength(equalTo: 3, errorMessage: "Number of numbers in the string should be equal to 3")
            var validations: [FPStringValidations] = []
            
            context("when checking for valid Numbers in String", closure: {
                
                beforeEach({
                    validations  = [isNumbers]
                })
                
                it("is valid", closure: {
                    let string = "Hello123"
                    let valueReturned = FPDataValidator.validateString(string, validations: validations)
                    expect(valueReturned.isValid).to(beTrue())
                })
                
                it("is invalid - number of numbers is wrong", closure: {
                    let string = "Hello"
                    let valueReturned = FPDataValidator.validateString(string, validations: validations)
                    expect(valueReturned.isValid).to(beFalse())
                    expect(valueReturned.errorMessages).toNot(beEmpty())
                })

                
            })
        })


    }
}


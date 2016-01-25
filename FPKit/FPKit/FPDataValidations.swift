//
//  FPDataValidations.swift
//  FPKit
//
//  Created by Sruti Harikumar on 21/1/16.
//  Copyright © 2016 First Person. All rights reserved.
//

import Foundation

//MARK:- String Validations
public enum FPStringValidations {
    
//MARK:- Cases /Validations
    case isEmail(errorMessage: String)
    case isURL(errorMessage: String)
    case isPhoneNumber(errorMessage: String)
    case isFullName(errorMessage: String)
    case containsCharactersRange(lessThan: Int, greaterThan: Int, errorMessage: String)
    case containsCharactersLength(equalTo: Int, errorMessage: String)
    case containsSpecialCharactersRange(lessThan: Int, greaterThan: Int, errorMessage: String)
    case containsSpecialCharactersLength(equalTo: Int, errorMessage:String)
    case containsNumbersRange(lessThan: Int, greaterThan: Int, errorMessage: String)
    case containsNumbersLength(equalTo: Int, errorMessage: String)
    case evaluatesWithRegex(regex: String, errorMessage: String)
    case containsUpperCaseCharactersRange(lessThan: Int, greaterThan: Int, errorMessage: String)
    case containsUpperCaseCharactersLength(equalTo: Int,errorMessage: String)
    
}
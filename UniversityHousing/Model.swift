//
//  OwnerDetails.swift
//  UniversityHousing
//
//  Created by Saikiran Reddy Doddeni on 4/4/23.
//

import Foundation

class OwnerDetails: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var phoneNumber = ""
    @Published var street = ""
    @Published var aptNo = ""
    @Published var city = ""
    @Published var state = ""
    @Published var zipcode = ""
    
    func toDictionary() -> [String : Any] {
        return[
            "firstName" : firstName,
            "lastName" : lastName,
            "phoneNumber" : phoneNumber,
            "street" : street,
            "aptNo" : aptNo,
            "city" : city,
            "state" : state,
            "zipcode" : zipcode
        ]
    }
    
    func reset() {
        firstName = ""
        lastName = ""
        phoneNumber = ""
        street = ""
        aptNo = ""
        city = ""
        state = ""
        zipcode = ""
    }
}

class User : ObservableObject {
    @Published var userId = ""
    @Published var userType = ""
    
    func reset(){
        self.userId = ""
        self.userType = ""
    }
}

class CustomerDetails: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var phoneNumber = ""
    var emailId = ""
    
    func toDictionary() -> [String : Any] {
        return [
            "firstName" : firstName,
            "lastName" : lastName,
            "phoneNumber" : phoneNumber
        ]
    }
    
    
    func reset() {
        firstName = ""
        lastName = ""
        phoneNumber = ""
    }
}

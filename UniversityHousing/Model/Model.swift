//
//  OwnerDetails.swift
//  UniversityHousing
//
//  Created by Saikiran Reddy Doddeni on 4/4/23.
//

import Foundation
import FirebaseFirestore
import UIKit

class OwnerDetailsSignUp: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var phoneNumber = ""
    @Published var street = ""
    @Published var aptNo = ""
    @Published var city = ""
    @Published var state = ""
    @Published var zipcode = ""
    var emailId = ""
    
    func toDictionary() -> [String : Any] {
        return[
            "firstName" : firstName,
            "lastName" : lastName,
            "phoneNumber" : phoneNumber,
            "street" : street,
            "aptNo" : aptNo,
            "city" : city,
            "state" : state,
            "zipcode" : zipcode,
            "emailId" : emailId
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
        emailId = ""
    }
}

class UserSignUp : ObservableObject {
    @Published var userId = ""
    @Published var userType = ""
    
    func reset(){
        self.userId = ""
        self.userType = ""
    }
}

class CustomerDetailsSignUp: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var phoneNumber = ""
    var emailId = ""
    
    func toDictionary() -> [String : Any] {
        return [
            "firstName" : firstName,
            "lastName" : lastName,
            "phoneNumber" : phoneNumber,
            "emailId" : emailId
        ]
    }
    
    
    func reset() {
        firstName = ""
        lastName = ""
        phoneNumber = ""
        emailId = ""
    }
}


class PropertyDetailsSignUp : ObservableObject {
    @Published var streetAddress = ""
    @Published var aptNo = ""
    @Published var city = ""
    @Published var state = ""
    @Published var zipcode = ""
    @Published var bedrooms = 0
    @Published var bathrooms = 0
    @Published var rent = 0
    @Published var furnished = ""
    @Published var houseType = "Apartment"
    @Published var petsAllowed = false
    var ownerReference : DocumentReference?
    @Published var description = ""
    
    func toDictionary() -> [String : Any] {
        return [
            "streetAddress" : streetAddress,
            "aptNo" : aptNo,
            "city" : city,
            "state" : state,
            "zipcode" : zipcode,
            "bedrooms" : bedrooms,
            "bathrooms" : bathrooms,
            "rent" : rent,
            "furnished" : furnished,
            "houseType" : houseType,
            "petsAllowed" : petsAllowed,
            "ownerReference" : ownerReference!
        ]
    }
    
    func reset() {
         streetAddress = ""
         aptNo = ""
         city = ""
         state = ""
         zipcode = ""
         bedrooms = 0
         bathrooms = 0
         rent = 0
         furnished = "Fully Furnished"
         houseType = ""
         petsAllowed = false
    }
}

class UserSignin : ObservableObject {
    @Published var userId = ""
    @Published var userType = ""
}

struct PropertyDetail : Hashable {
    var propertyID: String
    var title : String
    var propertyImageURL : URL
    var bedrooms : Int
    var rent : Int
    var furnished : String
}

struct customerPropertyDetail : Hashable {
    var ownerID: String
    var propertyID: String
    var title : String
    var propertyImageURL : URL
    var bedrooms : Int
    var rent : Int
    var furnished : String
    var bathrooms: Int
    var houseType : String
}

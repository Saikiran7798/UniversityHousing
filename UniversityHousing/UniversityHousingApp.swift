//
//  UniversityHousingApp.swift
//  UniversityHousing
//
//  Created by Saikiran Reddy Doddeni on 4/2/23.
//

import SwiftUI
import FirebaseCore

@main
struct UniversityHousingApp: App {
    init(){
        FirebaseApp.configure()
    }
    @StateObject private var ownerDetails = OwnerDetails()
    @StateObject private var user = User()
    @StateObject private var customerDetails = CustomerDetails()
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(ownerDetails)
                .environmentObject(user)
                .environmentObject(customerDetails)
        }
    }
}

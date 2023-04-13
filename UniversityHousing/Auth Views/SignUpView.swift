//
//  SignUpView.swift
//  UniversityHousing
//
//  Created by Saikiran Reddy Doddeni on 4/2/23.
//

import SwiftUI

struct SignUpView: View {
    @State private var emailId = ""
    @State private var password = ""
    @EnvironmentObject var user : UserSignUp
    @EnvironmentObject var ownerDetails: OwnerDetailsSignUp
    @EnvironmentObject var customerDetails : CustomerDetailsSignUp
    @State var isOwner = false
    @State var isCustomer = false
    var body: some View {
            VStack(spacing: 20) {
                VStack{
                    Text("Create an Account")
                        .font(.largeTitle)
                    
                }
                .padding()
                TextField("Enter Email Id", text: $emailId)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                            .foregroundColor(.black)
                    )
                SecureField("Enter Password", text: $password)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                            .foregroundColor(.black)
                    )
                HStack{
                    RadioButton(title: "Customer", selected: user.userType == "Customer"){
                        user.userType = "Customer"
                    }
                    RadioButton(title: "Owner", selected: user.userType == "Owner"){
                        user.userType = "Owner"
                    }
                }
                Button("Sign Up"){
                    FirestoreRequests.shared.userSignUP(emailId: emailId, password: password, userType: user.userType) { uid in
                        self.user.userId = uid
                        print("Hi, user id is \(uid)")
                    }
                    if user.userType == "Owner" {
                        isOwner = true
                    }
                    if user.userType == "Customer" {
                        isCustomer = true
                    }
                }
                .padding()
                .background(.blue)
                .foregroundColor(.black)
                NavigationLink(destination: OwnerDetailsView(), isActive:$isOwner, label: {
                        EmptyView()
                    })
                NavigationLink(destination: CustomerDetailsView(), isActive:$isCustomer, label: {
                        EmptyView()
                    })

            }
            .padding()
        
    }
}


struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
            .environmentObject(UserSignUp())
            .environmentObject(OwnerDetailsSignUp())
            .environmentObject(CustomerDetailsSignUp())
    }
}

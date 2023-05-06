//
//  CustomerDetailsView.swift
//  UniversityHousing
//
//  Created by Saikiran Reddy Doddeni on 4/4/23.
//

import SwiftUI

struct CustomerDetailsView: View {
    @EnvironmentObject var customerDetails : CustomerDetailsSignUp
    @EnvironmentObject var user : UserSignUp
    @State var isThankyouView = false
    @State private var isPhoneNumberValid = false
    @State var isShowError = false
    @State var isLastname = false
    @State var isLastnameError = false
    @State var isFirstname = false
    @State var isFirstnameError = false
    var body: some View {
        VStack(spacing: 10){
            VStack{
                Image("Image")
                    .resizable()
                    .scaledToFit()
            }.padding()
            
            TextField("Enter First Name", text: $customerDetails.firstName)
                .onChange(of: customerDetails.firstName){ _ in
                    if customerDetails.firstName.isEmpty{
                        
                        isFirstname = false
                    }
                    else{
                        withAnimation(.easeInOut(duration: 0.5)){
                            isFirstname = true
                            isFirstnameError = false
                        }
                    }
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.black))
            if isFirstnameError{
                Text("Please Fill your First Name.")
                    .foregroundColor(.red)
            }
            
            TextField("Enter Last Name", text: $customerDetails.lastName)
                .onChange(of: customerDetails.lastName){ _ in
                    if customerDetails.lastName.isEmpty{
                        isLastname = false
                    }
                    else{
                        withAnimation(.easeInOut(duration: 0.5)){
                            isLastname = true
                            isLastnameError = false
                            
                        }
                    }
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.black))
            if isLastnameError {
                Text("Please Fill your Last Name.")
                    .foregroundColor(.red)
            }
            TextField("Enter phone number", text: $customerDetails.phoneNumber)
                .onChange(of: customerDetails.phoneNumber){ _ in
                    if isValidPhoneNumber(phoneNumber: customerDetails.phoneNumber) {
                        withAnimation(.easeInOut(duration: 0.5)){
                            isPhoneNumberValid = true
                            isShowError = false
                        }
                        
                    } else {
                        isPhoneNumberValid = false
                    }
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.black)
                )
            if isShowError {
                Text("Please enter a valid Phone Number.")
                    .foregroundColor(.red)
            }
            
            Button("Next"){
                if isPhoneNumberValid && isLastname && isFirstname{
                    FirestoreRequests.shared.customerDetailsSignup(customerDetails: customerDetails, userID: user.userId)
                    isThankyouView = true
                }
                else {
                    isShowError = true
                    isLastnameError = true
                    isFirstnameError = true
                }
            }
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            NavigationLink(destination: ThankyouView(), isActive: $isThankyouView, label: {
                EmptyView()
            })
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}

private func isValidPhoneNumber(phoneNumber: String) -> Bool {
       let phoneRegex = #"^\d{10}$"#
        return NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phoneNumber)
   }


struct CustomerDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerDetailsView()
            .environmentObject(CustomerDetailsSignUp())
            .environmentObject(UserSignUp())
    }
}


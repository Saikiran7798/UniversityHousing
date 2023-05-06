//
//  OwnerDetailsView.swift
//  UniversityHousing
//
//  Created by Saikiran Reddy Doddeni on 4/4/23.
//

import SwiftUI

struct OwnerDetailsView: View {
    @EnvironmentObject var ownerDetails : OwnerDetailsSignUp
    @EnvironmentObject var user: UserSignUp
    @Environment(\.presentationMode) var presentationMode
    @State var isthankYouView = false
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
                        .padding(.top, 50)
                }
                TextField("Enter First Name", text: $ownerDetails.firstName)
                    .onChange(of: ownerDetails.firstName){ _ in
                        if ownerDetails.firstName.isEmpty{
                            
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
                TextField("Enter Last Name", text: $ownerDetails.lastName)
                    .onChange(of: ownerDetails.lastName){ _ in
                        if ownerDetails.lastName.isEmpty{
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
                TextField("Enter phone number", text: $ownerDetails.phoneNumber)
                    .onChange(of: ownerDetails.phoneNumber){ _ in
                        if isValidPhoneNumber(phoneNumber: ownerDetails.phoneNumber) {
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
                        FirestoreRequests.shared.ownerDetailsSignup(ownerDetails: ownerDetails, userID: user.userId)
                        print("Value of user is \(user.userId)")
                        isthankYouView = true
                    }
                    else{
                        isShowError = true
                        isLastnameError = true
                        isFirstnameError = true
                    }
                }
                .padding()
                .background(.blue)
                .foregroundColor(.black)
                NavigationLink(destination: ThankyouView(), isActive : $isthankYouView){
                        Text("").hidden()
                }
            }
            .padding()
            .navigationBarBackButtonHidden(true)
    }
}

private func isValidPhoneNumber(phoneNumber: String) -> Bool {
       let phoneRegex = #"^\d{10}$"#
        return NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phoneNumber)
   }

struct OwnerDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        OwnerDetailsView().environmentObject(OwnerDetailsSignUp())
            .environmentObject(UserSignUp())
    }
}


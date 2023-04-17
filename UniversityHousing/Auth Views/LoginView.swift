//
//  LoginView.swift
//  UniversityHousing
//
//  Created by Saikiran Reddy Doddeni on 4/2/23.
//

import SwiftUI

struct LoginView: View {
    @State var emailId = ""
    @State var password = ""
    @State var isOwner = false
    @State var isCustomer = false
    @EnvironmentObject var user: UserSignin
    var body: some View {
        NavigationView{
            VStack(spacing: 20){
                VStack{
                    Text("Welcome!")
                        .font(.largeTitle)
                }
                VStack{
                    TextField("Enter Email", text: $emailId)
                        .padding()
                        .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                            .foregroundColor(.black))
                    SecureField("Enter Password", text: $password )
                        .padding()
                        .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                            .foregroundColor(.black))
                    HStack{
                        
                    }
                }
                NavigationLink(destination: SignUpView()){
                    Text("Don't have an account? Sign Up")
                }
                Button("SIGN IN"){
                    Task(priority: .background) {
                        let (userType, userID) : (String, String) = try await FirestoreRequests.shared.userSignIn(emailId: emailId, password: password)
                        DispatchQueue.main.async {
                            if userType == "Customer" {
                                isCustomer = true
                            }
                            else {
                                isOwner = true
                            }
                            self.user.userType = userType
                            self.user.userId = userID
                        }
                    }
                }
                .padding()
                .background(.blue)
                .foregroundColor(.black)
                NavigationLink(destination: OwnerMainView(), isActive: $isOwner, label: {
                    EmptyView()
                })
                NavigationLink(destination: CustomerView(), isActive: $isCustomer, label: {
                    EmptyView()
                })
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(UserSignin())
    }
}

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
    @EnvironmentObject var user: User
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
                    /*FirestoreRequests.shared.userSignIn(emailId: emailId, password: password){ result in
                        if result == "Owner" {
                            isOwner = true
                        }
                        else {
                            isCustomer = true
                        }
                    }*/
                    print("hi user \(user.userId)")
                }
                .padding()
                .background(.blue)
                .foregroundColor(.black)
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(User())
    }
}

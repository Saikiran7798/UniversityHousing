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
    @State var isInvalidLogin = false
    @State var errorMessage = ""
    @EnvironmentObject var user: UserSignin
    @State var isSecure = false
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    var body: some View {
        NavigationStack {
            if horizontalSizeClass == .compact && verticalSizeClass == .compact {
                ScrollView{
                    VStack(spacing : 20){
                        VStack{
                            Image("Image")
                                .resizable()
                                .scaledToFit()
                                //.padding(.top, 50)
                        }
                        .frame(height: 100)
                        VStack(spacing: 20){
                            Text("Email")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color.blue)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            HStack{
                                Image(systemName: "envelope")
                                TextField("Enter Email", text: $emailId)
                                    .autocorrectionDisabled(true)
                                    .autocapitalization(.none)
                                    .keyboardType(.emailAddress)
                            }
                            .padding(.vertical, 15)
                            .padding(.horizontal, 20)
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(lineWidth: 2)
                                    .foregroundColor(Color.black)
                            )
                            Text("Password")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color.blue)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            HStack{
                                Button(action: {
                                    isSecure.toggle()
                                }, label: {
                                    Image( systemName: !isSecure ? "eye.slash" : "eye")
                                        .foregroundColor(.black)
                                })
                                SecureField("Enter Password", text: $password )
                            }
                            .padding(.vertical, 15)
                            .padding(.horizontal, 20)
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(lineWidth: 2)
                                    .foregroundColor(Color.black)
                            )
                            
                        }
                        .padding()
                        Button("SIGN IN"){
                            Task(priority: .background) {
                                let (userType, userID) : (String, String) = try await FirestoreRequests.shared.userSignIn(emailId: emailId, password: password)
                                DispatchQueue.main.async {
                                    if userType == "error"{
                                        isInvalidLogin = true
                                        errorMessage = userID
                                    }
                                    else {
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
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                        .alert(isPresented: $isInvalidLogin){
                            Alert(title: Text("Login Failed"), message: Text("\(errorMessage)"), dismissButton: .default(Text("OK")))
                        }
                        
                        NavigationLink(destination: SignUpView()){
                            Text("Don't have an account? Sign Up")
                        }
                        NavigationLink(destination: ResetPasswordView(), label: {
                            Text("Forgot password")
                        })
                        Spacer()
                        
                        NavigationLink(destination: OwnerMainView(), isActive: $isOwner, label: {
                            EmptyView()
                        })
                        NavigationLink(destination: MainTabbedView(), isActive: $isCustomer, label: {
                            EmptyView()
                        })
                    }
                    .padding()
                    .navigationTitle("")
                    .navigationBarHidden(true)
                    .background(.white)
                }
            }
            else {
                VStack(spacing : 20){
                    VStack{
                        Image("Image")
                            .resizable()
                            .scaledToFit()
                            .padding(.top, 50)
                    }
                    VStack(spacing: 20){
                        Text("Email")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color.blue)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        HStack{
                            Image(systemName: "envelope")
                            TextField("Enter Email", text: $emailId)
                                .autocorrectionDisabled(true)
                                .autocapitalization(.none)
                                .keyboardType(.emailAddress)
                        }
                        .padding(.vertical, 15)
                        .padding(.horizontal, 20)
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 2)
                                .foregroundColor(Color.black)
                        )
                        Text("Password")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color.blue)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        HStack{
                            Button(action: {
                                isSecure.toggle()
                            }, label: {
                                Image( systemName: !isSecure ? "eye.slash" : "eye")
                                    .foregroundColor(.black)
                            })
                            SecureField("Enter Password", text: $password )
                        }
                        .padding(.vertical, 15)
                        .padding(.horizontal, 20)
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 2)
                                .foregroundColor(Color.black)
                        )
                        
                    }
                    .padding()
                    Button("SIGN IN"){
                        Task(priority: .background) {
                            let (userType, userID) : (String, String) = try await FirestoreRequests.shared.userSignIn(emailId: emailId, password: password)
                            DispatchQueue.main.async {
                                if userType == "error"{
                                    isInvalidLogin = true
                                    errorMessage = userID
                                }
                                else {
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
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                    .alert(isPresented: $isInvalidLogin){
                        Alert(title: Text("Login Failed"), message: Text("\(errorMessage)"), dismissButton: .default(Text("OK")))
                    }
                    
                    NavigationLink(destination: SignUpView()){
                        Text("Don't have an account? Sign Up")
                    }
                    NavigationLink(destination: ResetPasswordView(), label: {
                        Text("Forgot password")
                    })
                    Spacer()
                    
                    NavigationLink(destination: OwnerMainView(), isActive: $isOwner, label: {
                        EmptyView()
                    })
                    NavigationLink(destination: MainTabbedView(), isActive: $isCustomer, label: {
                        EmptyView()
                    })
                }
                .padding()
                .navigationTitle("")
                .navigationBarHidden(true)
                .background(.white)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(UserSignin())
    }
}

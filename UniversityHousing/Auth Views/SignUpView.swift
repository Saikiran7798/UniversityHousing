//
//  SignUpView.swift
//  UniversityHousing
//
//  Created by Saikiran Reddy Doddeni on 4/2/23.
//

import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    @State private var emailId = ""
    @State private var password = ""
    @EnvironmentObject var user : UserSignUp
    @EnvironmentObject var ownerDetails: OwnerDetailsSignUp
    @EnvironmentObject var customerDetails : CustomerDetailsSignUp
    @State var isOwner = false
    @State var isCustomer = false
    @State private var isEmailValid = false
    @State var isShowEmailError = false
    @State var isRadioSelected = false
    @State var isRadioError = false
    @State var isPasswordValid = false
    @State var ispasswordError = false
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @State var isAlert = false
    @State var alertMsg = ""
    var body: some View {
        VStack(spacing: 20) {
            if horizontalSizeClass == .compact && verticalSizeClass == .compact {
                ScrollView {
                    VStack{
                        Image("Image")
                            .resizable()
                            .scaledToFit()
                    }
                    .padding()
                    .frame(height: 100)
                    VStack {
                        Text("Create an Account")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                        
                        TextField("Enter Email Id", text: $emailId)
                            .onChange(of: emailId){ _ in
                                if isValidEmail(email: emailId) {
                                    withAnimation(.easeInOut(duration: 0.5)){
                                        isEmailValid = true
                                        isShowEmailError = false
                                    }
                                }
                                else {
                                    isEmailValid = false
                                }
                            }
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(lineWidth: 2)
                                    .foregroundColor(.black)
                            )
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                            .disableAutocorrection(true)
                        
                        if isShowEmailError {
                            Text("Please enter a valid email address.")
                                .foregroundColor(.red)
                        }
                        
                        
                        SecureField("Enter Password", text: $password)
                            .onChange(of: password){ _ in
                                if password.count < 8 {
                                    isPasswordValid = false
                                }
                                else {
                                    withAnimation(.easeInOut(duration: 0.5)){
                                        isPasswordValid = true
                                        ispasswordError = false
                                    }
                                }
                            }
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(lineWidth: 2)
                                    .foregroundColor(.black)
                            )
                        if ispasswordError {
                            Text("Please enter a password greater or equal to than 8 charecters")
                                .foregroundColor(.red)
                        }
                        HStack{
                            RadioButton(title: "Customer", selected: user.userType == "Customer"){
                                withAnimation(.easeInOut(duration: 0.5)){
                                    isRadioSelected = true
                                    isRadioError = false
                                }
                                user.userType = "Customer"
                            }
                            RadioButton(title: "Owner", selected: user.userType == "Owner"){
                                withAnimation(.easeInOut(duration: 0.5)){
                                    isRadioSelected = true
                                    isRadioError = false
                                }
                                user.userType = "Owner"
                            }
                        }
                        if isRadioError {
                            Text("Please Select Either Customer Or Owner.")
                                .foregroundColor(.red)
                        }
                        Button("Sign Up"){
                            if isEmailValid && isRadioSelected && isPasswordValid{
                                Task(priority: .background){
                                    let (userId, emailId) = try await FirestoreRequests.shared.userSignUP(emailId: emailId, password: password, userType: user.userType)
                                    DispatchQueue.main.async {
                                        if userId == "error" {
                                            isAlert = true
                                            alertMsg = emailId
                                        }
                                        else {
                                            isAlert = false
                                            self.user.userId = userId
                                            if user.userType == "Owner"{
                                                self.ownerDetails.emailId = emailId
                                            }
                                            else{
                                                self.customerDetails.emailId = emailId
                                            }
                                            if user.userType == "Owner" {
                                                isOwner = true
                                            }
                                            if user.userType == "Customer" {
                                                isCustomer = true
                                            }
                                        }
                                    }
                                }
                            }
                            else {
                                if !isRadioSelected {
                                    isRadioError = true
                                }
                                else {
                                    isRadioError = false
                                }
                                if !isEmailValid {
                                    isShowEmailError = true
                                }
                                else {
                                    isShowEmailError = false
                                }
                                if !isPasswordValid {
                                    ispasswordError = true
                                }
                                else {
                                    ispasswordError = false
                                }
                            }
                        }
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .alert(isPresented: $isAlert){
                            Alert(title: Text("Error"), message: Text("\(alertMsg)"), dismissButton: .default(Text("OK")))
                        }
                        NavigationLink(destination: OwnerDetailsView(), isActive:$isOwner, label: {
                            EmptyView()
                        })
                        NavigationLink(destination: CustomerDetailsView(), isActive:$isCustomer, label: {
                            EmptyView()
                        })
                    }
                    Spacer()
                }
            }
            else {
                VStack{
                    Image("Image")
                        .resizable()
                        .scaledToFit()
                }
                .padding()
                VStack {
                    Text("Create an Account")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                    
                    TextField("Enter Email Id", text: $emailId)
                        .onChange(of: emailId){ _ in
                            if isValidEmail(email: emailId) {
                                withAnimation(.easeInOut(duration: 0.5)){
                                    isEmailValid = true
                                    isShowEmailError = false
                                }
                            }
                            else {
                                isEmailValid = false
                            }
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 2)
                                .foregroundColor(.black)
                        )
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .disableAutocorrection(true)
                    
                    if isShowEmailError {
                        Text("Please enter a valid email address.")
                            .foregroundColor(.red)
                    }
                    
                    
                    SecureField("Enter Password", text: $password)
                        .onChange(of: password){ _ in
                            if password.count < 8 {
                                isPasswordValid = false
                            }
                            else {
                                withAnimation(.easeInOut(duration: 0.5)){
                                    isPasswordValid = true
                                    ispasswordError = false
                                }
                            }
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 2)
                                .foregroundColor(.black)
                        )
                    if ispasswordError {
                        Text("Please enter a password greater or equal to than 8 charecters")
                            .foregroundColor(.red)
                    }
                    HStack{
                        RadioButton(title: "Customer", selected: user.userType == "Customer"){
                            withAnimation(.easeInOut(duration: 0.5)){
                                isRadioSelected = true
                                isRadioError = false
                            }
                            user.userType = "Customer"
                        }
                        RadioButton(title: "Owner", selected: user.userType == "Owner"){
                            withAnimation(.easeInOut(duration: 0.5)){
                                isRadioSelected = true
                                isRadioError = false
                            }
                            user.userType = "Owner"
                        }
                    }
                    if isRadioError {
                        Text("Please Select Either Customer Or Owner.")
                            .foregroundColor(.red)
                    }
                    Button("Sign Up"){
                        if isEmailValid && isRadioSelected && isPasswordValid{
                            Task(priority: .background){
                                let (userId, emailId) = try await FirestoreRequests.shared.userSignUP(emailId: emailId, password: password, userType: user.userType)
                                DispatchQueue.main.async {
                                    if userId == "error" {
                                        isAlert = true
                                        alertMsg = emailId
                                    }
                                    else {
                                        isAlert = false
                                        self.user.userId = userId
                                        if user.userType == "Owner"{
                                            self.ownerDetails.emailId = emailId
                                        }
                                        else{
                                            self.customerDetails.emailId = emailId
                                        }
                                        if user.userType == "Owner" {
                                            isOwner = true
                                        }
                                        if user.userType == "Customer" {
                                            isCustomer = true
                                        }
                                    }
                                }
                            }
                        }
                        else {
                            if !isRadioSelected {
                                isRadioError = true
                            }
                            else {
                                isRadioError = false
                            }
                            if !isEmailValid {
                                isShowEmailError = true
                            }
                            else {
                                isShowEmailError = false
                            }
                            if !isPasswordValid {
                                ispasswordError = true
                            }
                            else {
                                ispasswordError = false
                            }
                            
                        }
                    }
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .alert(isPresented: $isAlert){
                        Alert(title: Text("Error"), message: Text("\(alertMsg)"), dismissButton: .default(Text("OK")))
                    }
                                
                    NavigationLink(destination: OwnerDetailsView(), isActive:$isOwner, label: {
                        EmptyView()
                    })
                    NavigationLink(destination: CustomerDetailsView(), isActive:$isCustomer, label: {
                        EmptyView()
                    })
                }
                //Spacer()
            }
            Spacer()
        }
        .padding()
    }
}

func isValidEmail(email: String) -> Bool {
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
}


struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
            .environmentObject(UserSignUp())
            .environmentObject(OwnerDetailsSignUp())
            .environmentObject(CustomerDetailsSignUp())
    }
}


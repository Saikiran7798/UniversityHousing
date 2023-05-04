//
//  ResetPasswordView.swift
//  UniversityHousing
//
//  Created by Chaitanya Makkapati on 5/2/23.
//

import SwiftUI
import Firebase

struct ResetPasswordView: View {
    @State private var email = ""
    @State private var isAlertPresented = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack {
            Text("Reset Password")
                .font(.title)
                .padding()
            
            TextField("Email", text: $email)
                .padding()
                .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 2)
                )
            
            Button(action: resetPassword) {
                Text("Reset Password")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            .alert(isPresented: $isAlertPresented) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            
            Spacer()
        }
        .padding()
    }
    
    private func resetPassword() {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                alertMessage = error.localizedDescription
                isAlertPresented = true
            } else {
                alertMessage = "A password reset email has been sent to your email address."
                isAlertPresented = true
                email = ""
            }
        }
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView()
    }
}


//
//  ThankyouView.swift
//  UniversityHousing
//
//  Created by Saikiran Reddy Doddeni on 4/5/23.
//

import SwiftUI

struct ThankyouView: View {
    @EnvironmentObject var user: UserSignUp
    @EnvironmentObject var ownerDetails: OwnerDetailsSignUp
    @EnvironmentObject var customerDetails: CustomerDetailsSignUp
    @State var isLogin = false
    @State private var isChecked = false
    var body: some View {
        VStack{
            Spacer()
            VerificationTickView(isChecked: $isChecked)
                .padding(.bottom, 20)
            
            Text("Thank you for signing up!")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 30)
            
            NavigationLink(destination: LoginView()){
                Text("Please login by clicking here")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 30)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .onDisappear(){
                user.reset()
                ownerDetails.reset()
                customerDetails.reset()
            }
            Spacer()
        }
        .background(Color.white)
        .navigationBarBackButtonHidden(true)
    }
}

struct ThankyouView_Previews: PreviewProvider {
    static var previews: some View {
        ThankyouView()
            .environmentObject(OwnerDetailsSignUp())
            .environmentObject(UserSignUp())
            .environmentObject(CustomerDetailsSignUp())
    }
}

struct VerificationTickView: View {
    @Binding var isChecked: Bool
    @State var width = CGFloat()
    @State var circleWidth = CGFloat()
    var body: some View {
        ZStack {
            Circle()
                .fill(isChecked ? Color.blue : Color.gray)
                .frame(width: circleWidth, height: 80)
            if isChecked {
                Image(systemName: "checkmark")
                    .foregroundColor(.white)
                    .font(.system(size: width, weight: .bold))
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                isChecked.toggle()
                circleWidth = 100
                width = 60
            }
        }
    }
}


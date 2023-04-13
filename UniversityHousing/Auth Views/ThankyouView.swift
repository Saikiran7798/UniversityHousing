//
//  ThankyouView.swift
//  UniversityHousing
//
//  Created by Saikiran Reddy Doddeni on 4/5/23.
//

import SwiftUI

struct ThankyouView: View {
    @EnvironmentObject var user: UserSignUp
    @EnvironmentObject var ownerDetails : OwnerDetailsSignUp
    @EnvironmentObject var customerDetails : CustomerDetailsSignUp
    @State var isLogin = false
    var body: some View {
            VStack{
                NavigationLink(destination: LoginView()){
                        Text("Please login by clicking here")
                }
                .onDisappear(){
                    user.reset()
                    ownerDetails.reset()
                    customerDetails.reset()
                }
            }
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

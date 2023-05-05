//
//  MainTabbedView.swift
//  UniversityHousing
//
//  Created by Saikiran Reddy Doddeni on 5/4/23.
//

import SwiftUI

struct MainTabbedView: View {
    @State var presentSideMenu = false
    @State var sideMenuTab = 0
    @EnvironmentObject var userSignIn : UserSignin
    @State var profileImage : UIImage = UIImage(systemName: "photo")!
    @State var userName =  ""
    var body: some View {
        ZStack {
            TabView(selection: $sideMenuTab){
                CustomerView(presentSideMenu: $presentSideMenu)
                    .tag(0)
                FavoriteProperties(presentSideMenu: $presentSideMenu)
                    .tag(1)
                ProfileView(presentSideMenu: $presentSideMenu)
                    .tag(2)
            }
            .tabViewStyle(DefaultTabViewStyle())
            SideMenu(isShowing: $presentSideMenu, content: AnyView(SideMenuContent(sideMenutab: $sideMenuTab, presentSidemenu: $presentSideMenu, profileImage: profileImage, userName: userName)))
        }
        .background(presentSideMenu ? .white : .clear)
        .navigationBarBackButtonHidden(true)
        .onAppear(){
            Task(priority: .background){
                let profImage = await CustomerFireStoreRequests.shared.getMenuprofileImage(userId: userSignIn.userId)
                let userName = await CustomerFireStoreRequests.shared.getUserName(userId: userSignIn.userId)
                DispatchQueue.main.async {
                    self.profileImage = profImage
                    self.userName = userName
                }
            }
        }
    }
}

struct MainTabbedView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabbedView()
            .environmentObject(UserSignin())
    }
}

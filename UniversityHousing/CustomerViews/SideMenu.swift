//
//  SideMenu.swift
//  UniversityHousing
//
//  Created by Saikiran Reddy Doddeni on 5/4/23.
//

import SwiftUI

struct SideMenu: View {
    @Binding var isShowing : Bool
    var content : AnyView
    var edgeTransition : AnyTransition = .move(edge: .leading)
    var body: some View {
        ZStack{
            if isShowing {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing.toggle()
                    }
                content
                    .transition(edgeTransition)
                    .background(
                        Color.clear
                    )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .animation(.easeInOut(duration: 0.8), value: isShowing)
    }
}

/*struct SideMenu_Previews: PreviewProvider {
    static var previews: some View {
        SideMenu(isShowing: Binding.constant(false))
    }
}*/

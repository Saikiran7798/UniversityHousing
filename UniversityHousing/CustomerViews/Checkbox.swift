//
//  CheckboxView.swift
//  UniversityHousing
//
//  Created by Saikiran Reddy Doddeni on 4/18/23.
//

import SwiftUI

struct Checkbox: View {
    let title : String
    let selected: Bool
    let action: () -> Void
    var body: some View {
        Button(action : action){
            HStack{
                if selected {
                    Image(systemName: "checkmark.square")
                        .foregroundColor(.blue)
                }
                else {
                    Image(systemName: "square")
                        .foregroundColor(.black)
                }
                Text(title)
                    .foregroundColor(.black)
            }
            
        }
    }
}

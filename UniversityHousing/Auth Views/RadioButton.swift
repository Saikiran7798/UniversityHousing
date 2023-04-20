//
//  RadioButton.swift
//  UniversityHousing
//
//  Created by Saikiran Reddy Doddeni on 4/4/23.
//

import SwiftUI

struct RadioButton: View {
    let title : String
    let selected: Bool
    let action: () -> Void
    var body: some View {
        Button(action : action){
            HStack{
                Image(systemName: selected ? "largecircle.fill.circle" : "circle")
                Text(title)
            }
            
        }
    }
}


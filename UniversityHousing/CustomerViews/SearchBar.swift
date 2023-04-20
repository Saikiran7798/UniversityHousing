//
//  SearchBar.swift
//  UniversityHousing
//
//  Created by Saikiran Reddy Doddeni on 4/19/23.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText : String
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Search", text: $searchText)
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                }
            }
        }
        .padding()
        .padding(.bottom, -5)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(searchText: Binding.constant(""))
    }
}

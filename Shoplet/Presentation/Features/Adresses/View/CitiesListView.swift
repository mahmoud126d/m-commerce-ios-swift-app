//
//  CitiesListView.swift
//  Shoplet
//
//  Created by Macos on 19/06/2025.
//

import SwiftUI

struct CitiesListView: View {
    var cities: [String]
    var selectCity:(_ city: String)-> Void
    var body: some View {
        List(cities, id: \.self){
            item in
            Text(item)
                .onTapGesture {
                    selectCity(item)
                }
        }
    }
}

#Preview {
    CitiesListView(cities: ["ismailia"]) { _ in
        
    }
}

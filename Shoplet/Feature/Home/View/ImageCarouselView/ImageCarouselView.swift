//
//  ImageCarouselView.swift
//  Shoplet
//
//  Created by Farid on 09/06/2025.
//

import SwiftUI

struct ImageCarouselView: View {
    let imageURLs: [String]
    @State private var currentIndex = 0
    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(0..<imageURLs.count, id: \.self) { index in
                AsyncImage(url: URL(string: imageURLs[index])) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .tag(index)
                .frame(width: 200, height: 150)
                .clipped()
                .cornerRadius(10)
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .frame(height: 150)
    }
}
#Preview {
    ImageCarouselView(imageURLs: [
        "https://example.com/image1.jpg",
        "https://example.com/image2.jpg"
    ])
}

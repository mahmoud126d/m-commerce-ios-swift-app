//
//  Color.swift
//  Shoplet
//
//  Created by Macos on 07/06/2025.
//

import SwiftUI


extension Color {
    static let primaryColor = Color(red: 111/255, green: 79/255, blue: 56/255)

        static func adaptiveBackground(for colorScheme: ColorScheme) -> Color {
            colorScheme == .dark ? Color.primaryColor : .white
        }}

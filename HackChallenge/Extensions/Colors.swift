//
//  Colors.swift
//  HackChallenge
//
//  Created by Ben Chen on 12/5/25.
//

import SwiftUI

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

struct GradientBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color(hex: 0xFFC1CB),
                Color(hex: 0xE0F3FF),
                Color(hex: 0xFFF7E6)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

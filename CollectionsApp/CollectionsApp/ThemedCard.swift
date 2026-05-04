//
//  ThemedCard.swift
//  CollectionsApp
//
//  Created by Dominguez, Harley on 4/29/26.
//


import SwiftUI

// MARK: - Brand Colors
extension Color {
    static let brandPurple = Color(red: 0.48, green: 0.38, blue: 1.0)
    static let brandBlue = Color(red: 0.33, green: 0.72, blue: 0.98)
    static let brandPurpleLight = Color(red: 0.93, green: 0.90, blue: 1.0)
    static let brandBluLight = Color(red: 0.88, green: 0.95, blue: 1.0)
    static let cardBackground = Color(red: 0.97, green: 0.96, blue: 1.0)
}

// MARK: - Gradients
extension LinearGradient {
    static let brandGradient = LinearGradient(
        colors: [Color.brandPurple, Color.brandBlue],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    static let brandGradientSubtle = LinearGradient(
        colors: [Color.brandPurpleLight, Color.brandBluLight],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - Reusable Card Modifier
struct ThemedCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.brandPurple.opacity(0.08), radius: 6, x: 0, y: 2)
    }
}

extension View {
    func themedCard() -> some View {
        modifier(ThemedCard())
    }
}

// MARK: - Themed Icon Badge
struct IconBadge: View {
    let systemName: String
    var color: Color = .brandPurple

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(color.opacity(0.15))
                .frame(width: 32, height: 32)
            Image(systemName: systemName)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(color)
        }
    }
}
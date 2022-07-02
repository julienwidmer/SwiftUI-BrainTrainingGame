//
//  CustomModifiers.swift
//  BrainTrainingGame
//
//  Created by Julien Widmer on 2022-07-02.
//

import SwiftUI

struct ItalicTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("AvenirNextCondensed-BoldItalic", size: 35))
            .foregroundStyle(.white)
    }
}

struct ItalicBody: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("AvenirNextCondensed-BoldItalic", size: 20))
            .foregroundStyle(.regularMaterial)
    }
}

struct CustomBody: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("AvenirNextCondensed-Bold", size: 22))
            .foregroundStyle(.regularMaterial)
    }
}

struct AnimatedTextView: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.thinMaterial)
            .cornerRadius(8)
            .transition(.scale)
            .transition(.asymmetric(insertion: .scale, removal: .opacity))
    }
}

struct CustomButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 35))
            .padding(20)
            .background(.white)
            .clipShape(Circle())
            .shadow(radius: 10, x: 8, y: 5)
    }
}

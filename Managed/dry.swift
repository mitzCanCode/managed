//
//  dry.swift
//  Managed
//
//  Created by ΜΙΤΖ on 4/5/24.
//

import SwiftUI

// MARK: Blur Code
struct CustomBlurView: UIViewRepresentable{
    var effect: UIBlurEffect.Style
    var onChange: (UIVisualEffectView) ->()
    
    func makeUIView(context: Context) -> UIVisualEffectView{
        let view = UIVisualEffectView(effect: UIBlurEffect(style: effect))
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        DispatchQueue.main.async {
            onChange(uiView)
        }
    }
}

// MARK: Signature background blur
struct BlurredBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                ZStack{
                    CustomBlurView(effect: .systemUltraThinMaterial) { view in
                        view.backgroundColor = UIColor.clear
                    }
                    // Clipping the blur into the desired shape
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    // Shadows

                    .shadow(color: .black.opacity(0.20), radius: 15)
                }
            )
    }
}


// Extension for adding signature background blur
extension View {
    func blurredBackground() -> some View {
        return self.modifier(BlurredBackgroundModifier())
    }
    
}



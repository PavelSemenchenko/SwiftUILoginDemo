//
//  SplashScreen.swift
//  loginSwiftUIDemo
//
//  Created by Pavel Semenchenko on 13.06.2023.
//

import Foundation
import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var currentColorIndex = 0
    private let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .pink]
    
    var body: some View {
        VStack {
            Text("splash screen")
                .font(.largeTitle)
                .foregroundColor(colors[currentColorIndex])
                .animation(.easeInOut(duration: 1.0))
                .onAppear {
                    withAnimation {
                        startColorAnimation()
                    }
                }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                isActive = true
            }
        }
        .fullScreenCover(isPresented: $isActive, content: {
            SignInScreen()
        })
    }
    
    private func startColorAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
            currentColorIndex = (currentColorIndex + 1) % colors.count
        }
    }
}
/*
struct SplashView: View {
    @State private var isActive = false
    @State private var isColorChanged = false
    
    var body: some View {
        VStack {
            Text("splash screen")
                .font(.largeTitle)
                .foregroundColor(isColorChanged ? .red : .blue)
                .animation(.easeInOut(duration: 1.0))
                .onAppear {
                    withAnimation {
                        isColorChanged.toggle()
                    }            // Ваш логотип или содержимое сплэш-экрана
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
                        isActive = true
                        
                    }
                }
                .fullScreenCover(isPresented: $isActive, content: {
                    SignInScreen()
                })
        }
    }
}*/
struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}

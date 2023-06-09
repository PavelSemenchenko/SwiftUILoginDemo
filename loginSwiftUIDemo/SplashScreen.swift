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
    @Binding var currentRoute: NavigationRoute
    
    private let gradients: [Gradient] = [
        Gradient(colors: [.red, .orange]),
        Gradient(colors: [.red, .orange, .yellow])
    ]
    
    var body: some View {
        VStack {
            Text("loadind world")
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                gradient: gradients[currentColorIndex],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .animation(.easeInOut(duration: 1.0))
        .onAppear {
            withAnimation {
                startColorAnimation()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                isActive = true
            }
        }
        .fullScreenCover(isPresented: $isActive, content: {
            SignInScreen(currentRoute: $currentRoute)
        })
    }
    
    private func startColorAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.7, repeats: true) { timer in
            currentColorIndex = (currentColorIndex + 1) % gradients.count
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
}
struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}*/

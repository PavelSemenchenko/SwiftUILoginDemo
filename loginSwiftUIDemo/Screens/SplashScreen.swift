//
//  SplashScreen.swift
//  loginSwiftUIDemo
//
//  Created by Pavel Semenchenko on 13.06.2023.
//

import Foundation
import SwiftUI

struct SplashView: View {
    @State private var logoOpacity: Double = 0.0
    @EnvironmentObject private var navigationVM: NavigationRouter
    
    var body: some View {
        VStack {
            Image("lw")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .opacity(logoOpacity)
                        
            Text("Lirium")
                //.font(.custom("NinaCTT", size: 24))
                .font(.title)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .opacity(logoOpacity)
                .padding(10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.red)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5)) {
                            logoOpacity = 1.0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                SignInVM.isAuthenticated ? navigationVM.pushTabBar(route: .tabBar)  : navigationVM.popUntilSignInScreen()
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
            .environmentObject(NavigationRouter())
    }
}

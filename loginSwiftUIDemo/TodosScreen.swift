//
//  TodosScreen.swift
//  loginSwiftUIDemo
//
//  Created by mac on 20.06.2023.
//

import SwiftUI

struct TodosScreen: View {
    var body: some View {
        VStack {
            ForEach(1..<20) { id in
                Text("Todo# \(id)")
            }
        }
    }
}

struct TodosScreen_Previews: PreviewProvider {
    static var previews: some View {
        TodosScreen()
    }
}

//
//  SettingsRow.swift
//  loginSwiftUIDemo
//
//  Created by Pavel Semenchenko on 17.09.2023.
//

import SwiftUI

struct SettingsRow: View {
    var settings : Setting
    
    var body: some View {
        HStack {
            /*settings.image
                .resizable()
                .frame(width: 50, height: 50)*/
            Text(settings.name)
        }
    }
}
/*
struct SettingsRow_Previews: PreviewProvider {
    static var previews: some View {
        SettingsRow()
    }
}*/

//
//  CommonUserItem.swift
//  loginSwiftUIDemo
//
//  Created by Pavel Semenchenko on 15.09.2023.
//

import SwiftUI

struct CommonUserItem: View {
    let item: Contact
    var action: (() -> Void)? = nil
    
    var body: some View {
        HStack{
            Text(item.name).padding()
            Spacer()
            FollowButton(userId: item.id!, status: .followed, loading: false) {
                action?()
            }
        }
    }
}
/*
struct CommonUserItem_Previews: PreviewProvider {
    static var previews: some View {
        CommonUserItem()
    }
}*/

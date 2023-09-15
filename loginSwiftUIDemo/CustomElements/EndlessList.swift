//
//  EndlessList.swift
//  loginSwiftUIDemo
//
//  Created by Pavel Semenchenko on 15.09.2023.
//

import SwiftUI

struct EndlessList<Items, ItemBody>: View where Items : RandomAccessCollection, Items.Element: Hashable, ItemBody : View {
    
    @Binding var items: Items?
    @Binding var empty : String?
    @Binding var error: String?
    
    var loadMore: () -> Void
    var refresh: () -> Void
    var content: (Items.Element) -> ItemBody
    
    init(items: Binding<Items?>,
         empty: Binding<String?>,
         error: Binding<String?>,
         loadMore: @escaping () -> Void,
         refresh: @escaping () -> Void,
         content: @escaping (Items.Element) -> ItemBody) {
        _items = items
        _empty = empty
        _error = error
        self.loadMore = loadMore
        self.refresh = refresh
        self.content = content
    }
    
    var body: some View {
        if let error = error {
            ZStack(alignment: .center) {
                Text(error)
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            
        } else if items?.isEmpty == true {
            ZStack(alignment: .center) {
                Text(empty ?? "No items")
            }
            
        } else if let items = items, !items.isEmpty {
            List {
                ForEach(items, id: \.self) { item in
                    content(item)
                        .onAppear {
                            if item == items.last {
                                loadMore()
                            }
                        }
                }
            }
        } else {
            ProgressView()
            
        }
    }
}
/*
 struct EndlessList_Previews: PreviewProvider {
 static var previews: some View {
 EndlessList()
 }
 }*/

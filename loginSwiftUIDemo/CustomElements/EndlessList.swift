//
//  EndlessList.swift
//  loginSwiftUIDemo
//
//  Created by Pavel Semenchenko on 15.09.2023.
//

import SwiftUI

struct EndlessList<Item, ItemBody>: View where Item : Hashable, ItemBody : View {
     
    let vm:BaseListVM<Item>
    
    var content: (Item) -> ItemBody
    
    init(vm: BaseListVM<Item>,
         content: @escaping (Item) -> ItemBody) {
        self.vm = vm
        self.content = content
    }
    
    var body: some View {
        if let error = vm.errorText {
            ZStack(alignment: .center) {
                Text(error)
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            
        } else if vm.items?.isEmpty == true {
            ZStack(alignment: .center) {
                Text(vm.emptyText ?? "No items")
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            
        } else if let items = vm.items, !items.isEmpty {
            List {
                ForEach(items, id: \.self) { item in
                    content(item)
                        .onAppear {
                            if item == items.last {
                                Task {
                                    await vm.loadMore()
                                    print("------- load in appear ------" )
                                }
                            }
                        }
                }
            }.refreshable {
                Task {
                    await vm.load()
                    print("------- refresh ------" )
                }
            }
        } else {
            ZStack(alignment: .center) {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onAppear {
                        Task {
                            await vm.load()
                            print("------- load ------ if something" )
                        }
                    }
            }
        }
    }
}
/*
 struct EndlessList_Previews: PreviewProvider {
 static var previews: some View {
 EndlessList()
 }
 }*/

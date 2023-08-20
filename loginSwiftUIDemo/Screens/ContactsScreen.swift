//
//  ContactsScreen.swift
//  loginSwiftUIDemo
//
//  Created by mac on 02.08.2023.
//

import SwiftUI
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFirestoreCombineSwift


struct ContactsScreen: View {
    //@EnvironmentObject var contactsVM: ContactsVM
    @StateObject var contactsVM: ContactsVM = ContactsVM()
    @State private var keyboardHeight: CGFloat = 0
    @ObservedObject private var keyboardResposder = KeyboardResponder()
    @Environment(\.dismiss) var dismiss
    
    @State var searchItems: [Contact] = []
    
    var body: some View {
        VStack {
            Text("Contacts").font(.headline).padding(5)
            if contactsVM.status == .searching && contactsVM.items.isEmpty {
                Text("No user found with name \(contactsVM.search)")
                    .multilineTextAlignment(.center)
                    .padding(10)
            }
            if contactsVM.status == .loaded && contactsVM.items.isEmpty {
                Text("No people in the app. Invite some one")
                    .multilineTextAlignment(.center)
                    .padding()
            } else if (contactsVM.status == .loaded || contactsVM.status == .searching || contactsVM.status == .moreLoading) && !contactsVM.items.isEmpty {
                ZStack(alignment: .trailing) {
                    TextField("Type term", text: $contactsVM.search)
                        .onReceive(contactsVM.searchItems) {
                            searchItems = $0
                        }
                        .padding(5)
                        .cornerRadius(5)
                        .textFieldStyle(.roundedBorder)
                        .padding(5)
                    
                    // добавить очистку массива и запуск load
                    if !contactsVM.search.isEmpty {
                        Button (action: {
                            contactsVM.search = ""
                           // contactsVM.clearItems()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing, 15)
                    }
                }
                List(contactsVM.search.isEmpty ? contactsVM.items : searchItems) { item in
                    Text(item.name).padding()
                        .onAppear {
                            if contactsVM.items.count
                                - (contactsVM.items.lastIndex(of: item) ?? 0) < 5 {
                                Task {
                                    await contactsVM.loadMore()
                                }
                            }
                        }
                }
            } else if contactsVM.status == .failed {
                Text("Something went wrong")
                Button("Reload") {
                    Task {
                        await contactsVM.load()
                    }
                }
            } else {
                    ForEach(1..<10) { i in
                        HStack(alignment: .center) {
                            Spacer()
                            Image(systemName: "person.circle").padding()
                            Text("Loading template ... \(i)")
                            Spacer()
                        }.border(Color(CGColor(red: 6, green: 0, blue: 9, alpha: 0.6)))
                    }
            }
        }.task {
            await contactsVM.load()
        }
        .onTapGesture {
            keyboardResposder.hideKeyboard()
        }
        .padding(.bottom, keyboardHeight)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onReceive(keyboardResposder.key1boardHeight, perform: { height in
            keyboardHeight = height - 100
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.keyboard)
        .background(Color(red: 0.2, green: 0.0, blue: 0.2,  opacity: 0.4 ))
    }
}

extension ContactsVM {
    func clearItems() {
        items.removeAll()
        //await load()
    }
}

class ContactsVM: ObservableObject {
    @Published private(set) var status: EntityStastus = .initial
    @Published private(set) var items: [Contact] = []
    @Published fileprivate(set) var search: String = ""
    
    private var allLoaded = false
    private var latestDocument: DocumentSnapshot?
    
       /*
    @MainActor func load() async {
        print("\(#function) \(items.count)")
        status = search.isEmpty ? .loading : status
        var ref = Firestore.firestore().collection("people").order(by: "name")
        if !search.isEmpty {
            ref = ref.start(at: [search.lowercased()])
                .end(at: ["\(search.lowercased())~"])
        }
        guard let snapshot = try? await ref.getDocuments() else {
            status = .failed
            return
        }
        let contacts = snapshot.documents.map { doc in
            try! doc.data(as: Contact.self)
        }.compactMap { $0 }
        status = .loaded
        items = contacts
    }
*/
    
    lazy var searchItems: AnyPublisher<[Contact], Never> = {
        $search.eraseToAnyPublisher()
            .throttle(for: .milliseconds(100), scheduler: DispatchQueue.main, latest: true)
            .map { $0.lowercased() }
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .handleEvents(receiveOutput: { _ in
                self.status = .searching
                })
                .flatMap { term in
                    self.searchPublisher(term: term)
                }
                .handleEvents(receiveOutput: { _ in
                    self.status = .loaded
                })
                    .eraseToAnyPublisher()
    } ()
    
    func searchPublisher(term: String) -> AnyPublisher<[Contact], Never> {
        return Firestore.firestore().collection("people")
            .order(by: "name")
            .start(at: [term])
            .end(at: ["\(term)~"])
            .snapshotPublisher()
            .map { $0.documents}
            .map { $0.map { doc in try? doc.data(as: Contact.self)} }
            .map { $0.compactMap {c in c }}
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
                          

    @MainActor func search(term:String) async {
        status = .searching
        var ref = Firestore.firestore().collection("people").order(by: "name")
        if !search.isEmpty {
            ref = ref.start(at: [term])
                    .end(at: ["\(term)~"])
        }
        guard let snapshot = try? await ref.getDocuments(source: .server) else {
            status = .failed
            return
        }
        let contacts = snapshot.documents.map { doc in
            try! doc.data(as: Contact.self)
        }.compactMap { $0 }
        status = .loaded
    }
    /*
    @MainActor func search() async {
        status = .searching
        var ref = Firestore.firestore().collection("people").order(by: "name")
        if !search.isEmpty {
            ref = ref.start(at: [search.lowercased()]).end(at: ["\(search.lowercased())~"])
        }
        guard let snapshot = try? await ref.getDocuments() else {
            status = .failed
            return
        }
        
        let contacts = snapshot.documents.map { doc in
            try! doc.data(as: Contact.self)
        }.compactMap { $0 }
        status = .loaded
        items = contacts
    }*/
    
    @MainActor func load(more: Bool = false) async  {
        /*
        for name in names {
            try? await Firestore.firestore().collection("people").addDocument(data: ["name": name.lowercased()])
        }
        */
        
        if more && (allLoaded || status == .moreLoading) {
            return
        }
        print("\(#function) \(items.count)")
        status = more ? .moreLoading : .loading

        var ref = Firestore.firestore().collection("people").order(by: "name")
                .limit(to: 20)
        if let doc = latestDocument, more {
            ref.start(afterDocument: doc)
        }
        guard let snapshot = try? await ref.getDocuments() else {
            status = .failed
            return
        }
        
        allLoaded = snapshot.documents.last == nil
        latestDocument = snapshot.documents.last
        
        let contacts = snapshot.documents.map { doc in
                    try! doc.data(as: Contact.self)
                }.compactMap {$0}
        status = .loaded
        items.append(contentsOf: contacts)
    }
    
    @MainActor func loadMore() async {
        if status == .moreLoading {
            return
        }
        guard let doc = latestDocument else {
            return
        }
        print("Load \(items.count)")
        status = .moreLoading
        
        let ref = Firestore.firestore().collection("people").order(by: "name").limit(to: 15).start(afterDocument: doc)
        guard let snapshot = try? await ref.getDocuments() else {
            return
        }
        
        latestDocument = snapshot.documents.last
        
        let contacts = snapshot.documents.map { doc in
            try! doc.data(as: Contact.self)
        }.compactMap { $0 }
        status = .loaded
        items.append(contentsOf: contacts)
    }
    
    let names = ["James",
                 "Robert",
                 "John",
                 "Michael",
                 "David",
                 "William",
                 "Richard",
                 "Joseph",
                 "Thomas",
                 "Christopher",
                 "Charles",
                 "Daniel",
                 "Matthew",
                 "Anthony",
                 "Mark",
                 "Donald",
                 "Steven",
                 "Andrew",
                 "Paul",
                 "Joshua",
                 "Kenneth",
                 "Kevin",
                 "Brian",
                 "George",
                 "Timothy",
                 "Ronald",
                 "Jason",
                 "Edward",
                 "Jeffrey",
                 "Ryan",
                 "Jacob",
                 "Gary",
                 "Nicholas",
                 "Eric",
                 "Jonathan",
                 "Stephen",
                 "Larry",
                 "Justin",
                 "Scott",
                 "Brandon",
                 "Benjamin",
                 "Samuel",
                 "Gregory",
                 "Alexander",
                 "Patrick",
                 "Frank",
                 "Raymond",
                 "Jack",
                 "Dennis",
                 "Jerry",
                 "Tyler",
                 "Aaron",
                 "Jose",
                 "Adam",
                 "Nathan",
                 "Henry",
                 "Zachary",
                 "Douglas",
                 "Peter",
                 "Kyle",
                 "Noah",
                 "Ethan",
                 "Jeremy",
                 "Walter",
                 "Christian",
                 "Keith",
                 "Roger",
                 "Terry",
                 "Austin",
                 "Bradley",
                 "Philip",
                 "Eugene"]
     
}

struct ContactsScreen_Previews: PreviewProvider {
    static var previews: some View {
        ContactsScreen()
            .environmentObject(ContactsVM())
    }
}

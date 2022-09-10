//
//  ContentView.swift
//  ExpensesProject
//
//  Created by karpo_dub on 15/08/2022.
//

import SwiftUI

struct ExpensItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Int
}

class Expenses: ObservableObject {
    @Published var items = [ExpensItem]() {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Item")
            }
        }
    }
    init () {
        if let item = UserDefaults.standard.data(forKey: "Item") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ExpensItem].self, from: item) {
                self.items = decoded
                return
            }
        }
    }
}

struct ContentView: View {
    
    @State private var showAddExpense = false
    @ObservedObject var expenses = Expenses()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items) {item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        Spacer()
                        Text("\(item.amount) $")
                            //.foregroundColor(Color(red: 88))
                            //.shadow(color: .orange, radius: 2, x: 0, y: 3)
                    }
                }
                .onDelete(perform: removeItems)
            }
            
            .listStyle(.automatic)
        
            .navigationBarTitle("Expenses", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.showAddExpense = true
            }) {
                Image(systemName: "plus")                    
            }) .sheet(isPresented: $showAddExpense) {
                AddView(expenses: self.expenses)
            }
        }
        
    }
    func removeItems(as offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
    }
}



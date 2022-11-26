//
//  DetailView.swift
//  ICS Parser Example Project
//
//  Created by Carter Hawkins on 11/26/22.
//

import SwiftUI

let special = #"\n"#

struct DetailView: View {
    
    let Assignment: Assignment
    
    var body: some View {
        NavigationStack {
            List {
                Section("Due") {
                    Text(Assignment.startDate.formatted())
                }
                Section("Link") {
                    Link("Open Webpage", destination: Assignment.link)
                }
                Section("Description") {
                    Text(Assignment.description)
                    
                }
                
            }
            .navigationTitle(Assignment.summary)
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(Assignment: Assignment(id: "Random ID", startDate: Date(), endDate: Date(), link: URL(string: "https://google.com")!, description: "Test Description", summary: "Test Summary"))
    }
}

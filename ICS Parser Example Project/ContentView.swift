//
//  ContentView.swift
//  ICS Parser Example Project
//
//  Created by Carter Hawkins on 11/26/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var listOfAssignments = [Assignment]()
    
    
    //Other
    @State private var scroll = false
    @State private var loaded = false
    //
    
        var body: some View {
            NavigationStack {
                ScrollViewReader { proxy in
                    
                    
                    List {
                        ForEach(listOfAssignments) { item in
                            
                            NavigationLink {
                                DetailView(Assignment: item)
                            } label: {
                                HStack {
                                    Text(item.summary)
                                    Text(item.startDate.formatted())
                                }
                                
                            }
                            .id(listOfAssignments.firstIndex(of: item)!)
                            
                            
                            
                        }
                    }
                    .onChange(of: scroll) { _ in
                        proxy.scrollTo(listOfAssignments.count - 1)
                    }
                    .task {
                        await loadData()
                        
                    }
                }
            }
        }
    
    func loadData() async {
       
        guard loaded == false else { return }
        
        let url = URL(string: "https://learn.lcps.org/calendar/feed/ical/1599581327/9336f6d23a186ce170b60460ec33395d/ical.ics")!
       
        
    
        let cals = try! iCal.load(url: url)
        

        for cal in cals {
            for event in cal.subComponents{
               
                let eventItems = event.toCal()
                
                
                let id: String = eventItems["UID"] ?? "Error"
                let startDate: Date = getDate(eventItems["DTSTART"] ?? "Error") ?? Date()
                let endDate: Date = getDate(eventItems["DTEND"] ?? "Error") ?? Date()
                let link: URL = URL(string: eventItems["URL;VALUE=URI"] ?? "Error") ?? URL(string: "https://google.com")!
                let description: String = eventItems["DESCRIPTION"] ?? "Error"
                let summary: String = eventItems["SUMMARY"] ?? "Error"
                
                
                let newAssignment = Assignment(id: id, startDate: startDate, endDate: endDate, link: link, description: description, summary: summary)
                
                listOfAssignments.append(newAssignment)
               
                //Debug Code
                
                
                //Prints all the contents of event
              
                //print(eventItems)
                
                
                
                //Prints Summary and URL of event
                //print(eventItems["SUMMARY"]! + "       " + eventItems["URL;VALUE=URI"]! + "      " +  (getDate(eventItems["DTSTART"] ?? "Error")?.formatted() ?? "No Date"))
                
                
                //
                
                func getDate(_ dateString: String) -> Date? {

                    // Create String
                    let string = dateString

                    // Create Date Formatter
                    let dateFormatter = DateFormatter()

                    // Set Date Format
                    dateFormatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
                    dateFormatter.timeZone = .gmt
                    // Convert String to Date
                    return (dateFormatter.date(from: string))
                    
                }
            }
        }
        scroll.toggle()
        loaded.toggle()
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

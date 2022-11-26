//
//  SchoolAssignment.swift
//  ICS Parser Example Project
//
//  Created by Carter Hawkins on 11/26/22.
//

import Foundation


struct Assignment: Identifiable, Equatable {
    var id: String
    var startDate: Date
    var endDate: Date
    var link: URL
    var description: String
    var summary: String
}

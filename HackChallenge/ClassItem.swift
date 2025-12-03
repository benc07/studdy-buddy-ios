//
//  ClassItem.swift
//  HackChallenge
//
//  Created by Nguyen Huu An Khang  on 12/1/25.
//

import Foundation

struct Class: Identifiable {
    let id = UUID()
    let name: String
    let section: String
    let time: String
    let days: String
    let location: String
    let type: ClassType
}

enum ClassType: String {
    case lec = "LEC"
    case dis = "DIS"
    case lab = "LAB"
}

let sampleClasses: [Class] = [
    Class(name: "CHEM 2070", section: "001", time: "8:00 AM – 8:50 AM", days: "MWF", location: "Baker Laboratory 200", type: .lec),
    Class(name: "CHEM 2070", section: "201", time: "11:20 AM – 12:10 PM", days: "W", location: "Baker Laboratory 102", type: .dis),
    
    Class(name: "MATH 2210", section: "002", time: "9:05 AM – 9:55 AM", days: "MTWRF", location: "Malott Hall 251", type: .lec),
    Class(name: "MATH 2210", section: "205", time: "2:40 PM – 3:30 PM", days: "T", location: "Malott Hall 203", type: .dis),
    
    Class(name: "CS 1110", section: "001", time: "10:10 AM – 11:00 AM", days: "MWF", location: "Uris Hall G01", type: .lec),
    Class(name: "CS 1110", section: "102", time: "3:45 PM – 4:35 PM", days: "R", location: "Phillips Hall 101", type: .dis),
    
    Class(name: "BIOG 1440", section: "001", time: "1:25 PM – 2:15 PM", days: "MWF", location: "Kennedy Hall 116", type: .lec),
    Class(name: "BIOG 1440", section: "301", time: "7:30 PM – 9:25 PM", days: "T", location: "Weill Hall 323", type: .lab),
]

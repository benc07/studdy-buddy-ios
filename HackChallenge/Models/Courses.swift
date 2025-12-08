//
//  Courses.swift
//  HackChallenge
//
//  Created by Nguyen Huu An Khang on 12/4/25.
//

import Foundation

struct Course: nonisolated Decodable, Identifiable {
    let id: Int
    let code: String
    let name: String
    let sessions: [Session]?
}

struct CourseListResponse: nonisolated Decodable {
    let courses: [Course]
}

struct CourseSummary: Codable, Identifiable {
    let id: Int
    let code: String
    let name: String
}

struct ScheduleCourseSummary: Codable {
    let id: Int
    let code: String
    let name: String
}

// Used specifically for /courses/search/?q=
struct CourseSearchResponse: nonisolated Decodable {
    let courses: [CourseSummary]
}

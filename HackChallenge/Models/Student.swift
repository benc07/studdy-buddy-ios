//
//  Student.swift
//  HackChallenge
//
//  Created by Nguyen Huu An Khang on 12/4/25.
//

import Foundation
import Combine

struct Student: Codable, Identifiable {
    let id: Int
    let name: String
}

struct User: nonisolated Decodable, Identifiable {
    let id: Int
    let google_id: String
    let name: String
    let email: String
    let profile_picture: String?
    let major: Major?
    let interests: [Interest]
    let sessions: [SessionSummary]
    let friendships: [Friendship]
}

struct Friendship: nonisolated Decodable, Identifiable {
    var id: Int { friend_id }
    let friend_id: Int
    let status: String
}

struct SearchStudent: Identifiable {
    let id: Int
    let name: String
    let email: String
    let courses: [String]
}

struct Major: Codable {
    let id: Int
    let major: String
}

struct Interest: Codable {
    let id: Int?
    let name: String
    let category_id: Int?
}

struct SessionSummary: Codable {
    let id: Int
    let class_number: String
    let name: String
    let time: String
}

struct InterestInput: Encodable {
    let name: String
    let category: String
}

class CurrentUser: ObservableObject {

    static let shared = CurrentUser()

    private init() {}

    @Published var user: User?
}

struct ScheduleCourseSummary: Codable {
    let id: Int
    let code: String
    let name: String
}

struct ScheduleSession: Codable, Identifiable {
    let id: Int
    let class_number: String
    let name: String
    let time: String
    let course: ScheduleCourseSummary
}

struct ScheduleResponse: nonisolated Decodable {
    let sessions: [ScheduleSession]
}

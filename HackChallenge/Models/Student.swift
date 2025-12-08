//
//  Student.swift
//  HackChallenge
//
//  Created by Nguyen Huu An Khang on 12/4/25.
//

import Foundation
import Combine
import UIKit

struct Student: Codable, Identifiable {
    let id: Int
    let name: String
}

struct Friend: nonisolated Decodable, Identifiable {
    let id: Int
    let name: String
    let email: String
}

struct FriendListResponse: nonisolated Decodable {
    let friends: [Friend]
}

struct Friendship: nonisolated Codable, Identifiable {
    var id: Int { friend_id }
    let friend_id: Int
    let status: String
}

struct StudentListResponse: nonisolated Decodable {
    let students: [SearchStudent]
}

struct SearchStudent: nonisolated Decodable, Identifiable {
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

struct InterestInput: Encodable {
    let name: String
    let category: String
}

struct ScheduleResponse: nonisolated Decodable {
    let sessions: [ScheduleSession]
}

// MARK: - Matching Models

/// A matched student from the /users/<id>/match/ endpoint
struct MatchStudent: nonisolated Decodable, Identifiable {
    let id: Int
    let name: String
    let email: String
}

/// A single match result with score
struct MatchResult: nonisolated Decodable {
    let student: MatchStudent
    let score: Int
}

/// Wrapper for all matches from /match/
struct MatchResponse: nonisolated Decodable {
    let matches: [MatchResult]
}

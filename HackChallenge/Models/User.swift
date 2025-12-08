//
//  User.swift
//  HackChallenge
//
//  Created by Ben Chen on 12/8/25.
//

import Foundation
import Combine
import UIKit

struct User: nonisolated Codable, Identifiable {
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

struct UserListResponse: nonisolated Decodable {
    let users: [User]
}

class CurrentUser: ObservableObject {
    static let shared = CurrentUser()

    @Published var user: User? {
        didSet { saveUser() }
    }

    private var profileImageCache: [Int: UIImage] = [:]

    private init() {
        loadUser()
    }

    // MARK: - USER PERSISTENCE
    private func saveUser() {
        guard let user = user else {
            UserDefaults.standard.removeObject(forKey: "savedUser")
            return
        }

        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            UserDefaults.standard.set(encoded, forKey: "savedUser")
        }
    }

    private func loadUser() {
        guard let data = UserDefaults.standard.data(forKey: "savedUser") else { return }

        let decoder = JSONDecoder()
        if let decoded = try? decoder.decode(User.self, from: data) {
            self.user = decoded
        }
    }

    // MARK: - PROFILE IMAGES
    private func profileImageURL(for userID: Int) -> URL? {
        let fm = FileManager.default
        do {
            let docs = try fm.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            return docs.appendingPathComponent("profile_\(userID).jpg")
        } catch {
            print("❌ Failed to get documents directory:", error)
            return nil
        }
    }

    func profileImage(for userID: Int) -> UIImage? {
        if let cached = profileImageCache[userID] {
            return cached
        }

        guard
            let url = profileImageURL(for: userID),
            FileManager.default.fileExists(atPath: url.path)
        else { return nil }

        do {
            let data = try Data(contentsOf: url)
            if let image = UIImage(data: data) {
                profileImageCache[userID] = image
                return image
            }
        } catch {
            print("❌ Failed to load profile image from disk:", error)
        }
        return nil
    }

    func setProfileImage(_ image: UIImage?, for userID: Int) {
        profileImageCache[userID] = image

        guard let url = profileImageURL(for: userID) else { return }

        let fm = FileManager.default

        guard let image = image else {
            // Delete existing image
            do {
                if fm.fileExists(atPath: url.path) {
                    try fm.removeItem(at: url)
                }
            } catch {
                print("❌ Failed to remove profile image:", error)
            }
            return
        }

        // Save new image
        if let data = image.jpegData(compressionQuality: 0.9) ?? image.pngData() {
            do {
                try data.write(to: url, options: .atomic)
            } catch {
                print("❌ Failed to write profile image to disk:", error)
            }
        }
    }

    // MARK: - LOGOUT
    func logout() {
        self.user = nil
        UserDefaults.standard.removeObject(forKey: "savedUser")
        profileImageCache.removeAll()
    }
}

// MARK: - Onboarding Logic Based on Backend

extension User {
    /// We treat the user as "onboarded" iff they have a non-empty major AND at least one interest.
    var needsOnboarding: Bool {
        let majorString = major?.major.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let hasMajor = !majorString.isEmpty
        let hasInterests = !interests.isEmpty
        return !(hasMajor && hasInterests)
    }
}

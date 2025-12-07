//
//  ScheduleManager.swift
//  HackChallenge
//
//  Created by Nguyen Huu An Khang on 12/5/25.
//

import SwiftUI
import Combine

class ScheduleManager: ObservableObject {
    static let shared = ScheduleManager()
    private init() {}

    @Published var addedSessions: [(session: Session, courseName: String)] = []

    // -----------------------------
    // MARK: LOAD EXISTING SCHEDULE
    // -----------------------------
    func loadSchedule() {
        guard let user = CurrentUser.shared.user else {
            print("No logged-in user")
            return
        }

        NetworkManager.shared.getUserSchedule(userID: user.id) { response in
            DispatchQueue.main.async {
                self.addedSessions = response.sessions.map { sched in

                    // Convert ScheduleSession → Session
                    let session = Session(
                        id: sched.id,
                        class_number: sched.class_number,
                        name: sched.name,
                        time: sched.time
                    )

                    return (
                        session: session,
                        courseName: sched.course.code
                    )
                }
            }
        }
    }

    // -----------------------------
    // MARK: ADD SESSION
    // -----------------------------
    func add(session: Session, courseName: String) {
        guard let user = CurrentUser.shared.user else { return }

        if isAdded(sessionID: session.id) { return }

        // 1. Instant UI update
        addedSessions.append((session: session, courseName: courseName))

        // 2. Send to backend
        NetworkManager.shared.addSessionToUser(
            userID: user.id,
            sessionID: session.id
        ) { updatedUser in

            if let updatedUser = updatedUser {
                print("Backend confirmed add:", updatedUser.sessions)
                CurrentUser.shared.user = updatedUser
            } else {
                print("Backend failed — reverting UI")
                DispatchQueue.main.async {
                    self.addedSessions.removeAll { $0.session.id == session.id }
                }
            }
        }
    }

    // -----------------------------
    // MARK: REMOVE SESSION
    // -----------------------------
    func remove(sessionID: Int) {
        guard let user = CurrentUser.shared.user else { return }

        addedSessions.removeAll { $0.session.id == sessionID }

        NetworkManager.shared.deleteSessionFromUser(
            userID: user.id,
            sessionID: sessionID
        ) { updatedUser in
            if updatedUser != nil {
                print("Backend removed session")
            } else {
                print("Backend failed removal")
            }
        }
    }

    // -----------------------------
    // MARK: CHECK IF ADDED
    // -----------------------------
    func isAdded(sessionID: Int) -> Bool {
        addedSessions.contains { $0.session.id == sessionID }
    }
}


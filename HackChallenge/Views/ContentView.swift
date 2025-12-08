//
//  ContentView.swift
//  HackChallenge
//
//  Created by Nguyen Huu An Khang on 11/30/25.
//

import SwiftUI

enum TopTab {
    case profile
    case search
}

struct ContentView: View {

    // MARK: - Login Bindings
    @Binding var isLoggedIn: Bool
    @Binding var didCompleteOnboarding: Bool

    // MARK: - User State
    @State private var selectedTab: TopTab = .profile
    @State private var userBio = ""
    @State private var userName = ""
    @State private var userEmail = ""
    @State private var userMajor = ""
    @State private var userImage: UIImage? = nil

    @State private var navigateToConnections = false
    @State private var searchCourse = ""
    @State private var showMenu = false

    // MARK: - Search / Matching State (backend powered)
    @State private var matchedStudents: [MatchStudent] = []
    @State private var isSearching = false
    @State private var searchError: String? = nil
    @State private var lastMatchedCourse: CourseSummary? = nil

    // MARK: - Init loads initial user data if exists
    init(isLoggedIn: Binding<Bool>, didCompleteOnboarding: Binding<Bool>) {
        self._isLoggedIn = isLoggedIn
        self._didCompleteOnboarding = didCompleteOnboarding

        if let user = CurrentUser.shared.user {
            _userName = State(initialValue: user.name)
            _userEmail = State(initialValue: user.email)
            if let major = user.major?.major {
                _userMajor = State(initialValue: major)
            }
            if let img = CurrentUser.shared.profileImage(for: user.id) {
                _userImage = State(initialValue: img)
            }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {
                    topBar

                    if selectedTab == .profile {
                        ScrollView { profileView }
                    } else {
                        searchView
                    }
                }

                if showMenu {
                    SideMenuView(
                        onClose: { showMenu = false },
                        onNavigateConnections: {
                            showMenu = false
                            navigateToConnections = true
                        },
                        onLogout: {
                            showMenu = false
                            isLoggedIn = false
                            didCompleteOnboarding = false
                            CurrentUser.shared.logout()
                        }
                    )
                }
            }
            .navigationDestination(isPresented: $navigateToConnections) {
                ConnectionsMainView()
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .animation(.easeInOut, value: showMenu)
        .onAppear {
            refreshUserFromCurrentUser()
        }
        .onReceive(CurrentUser.shared.$user) { newUser in
            guard let user = newUser else { return }
            userName = user.name
            userEmail = user.email
            if let major = user.major?.major { userMajor = major }
            if let image = CurrentUser.shared.profileImage(for: user.id) {
                userImage = image
            }
        }
    }

    // MARK: - Sync local state from CurrentUser
    private func refreshUserFromCurrentUser() {
        guard let user = CurrentUser.shared.user else { return }
        userName = user.name
        userEmail = user.email
        if let major = user.major?.major {
            userMajor = major
        }
        if let image = CurrentUser.shared.profileImage(for: user.id) {
            userImage = image
        }
    }

    // MARK: - Top Bar
    private var topBar: some View {
        VStack(spacing: 0) {
            HStack {
                Button { showMenu = true } label: {
                    Image("3 rows")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(.leading, 15)
                }

                Button { selectedTab = .profile } label: {
                    Image("person")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 60)
                        .foregroundColor(
                            selectedTab == .profile
                            ? Color(hex:0xF7798D)
                            : Color(hex:0xC2C2C2)
                        )
                        .padding(.leading, 30)
                }

                Spacer()

                Button { selectedTab = .search } label: {
                    Image("search")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 60)
                        .foregroundColor(
                            selectedTab == .search
                            ? Color(hex:0xF7798D)
                            : Color(hex:0xC2C2C2)
                        )
                        .padding(.leading, 35)
                }

                Spacer()
            }
            .padding(.top)
            .padding(.bottom, 12)

            HStack(spacing: 0) {
                Rectangle()
                    .fill(selectedTab == .profile ? Color(hex:0xF7798D) : .gray.opacity(0.4))
                    .frame(height: 4)

                Rectangle()
                    .fill(selectedTab == .search ? Color(hex:0xF7798D) : .gray.opacity(0.4))
                    .frame(height: 4)
            }
        }
        .background(Color.white)
    }

    // MARK: - Profile View
    var profileView: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack(alignment: .top, spacing: 30) {

                VStack(spacing: 14) {
                    if let userImage {
                        Image(uiImage: userImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    } else {
                        Image("person")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray.opacity(0.7))
                    }

                    NavigationLink {
                        EditProfileView(
                            name: userName,
                            bio: userBio,
                            email: userEmail,
                            major: userMajor,
                            selectedImage: userImage
                        ) { newName, newBio, newEmail, newMajor, newImage in
                            userName = newName
                            userBio = newBio
                            userEmail = newEmail
                            userMajor = newMajor
                            userImage = newImage

                            if let id = CurrentUser.shared.user?.id {
                                CurrentUser.shared.setProfileImage(newImage, for: id)
                            }
                        }
                    } label: {
                        Text("Edit Profile")
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(Color(hex:0xF7798D))
                            .foregroundColor(.white)
                            .cornerRadius(14)
                    }
                }
                .padding(.top, 20)

                VStack(alignment: .leading, spacing: 10) {
                    Text(userName)
                        .font(.system(size: 20))
                        .fontWeight(.medium)

                    Text(userEmail)
                        .foregroundColor(.gray)

                    Text(userMajor)
                        .foregroundColor(.gray)
                }
                .padding(.top, 20)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 30)

            MyScheduleView()

            NavigationLink {
                ClassSearchView()
            } label: {
                Text("Add classes")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex:0xF7798D))
                    .cornerRadius(20)
                    .padding(.horizontal, 40)
            }
            .padding(.top, 35)

            Spacer(minLength: 30)
        }
    }

    // MARK: - Search + Match Logic

    private func searchAndMatch() {
        let trimmed = searchCourse.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= 3 else { return }
        guard let userID = CurrentUser.shared.user?.id else {
            searchError = "You must be logged in to search."
            return
        }

        isSearching = true
        searchError = nil
        matchedStudents = []
        lastMatchedCourse = nil

        NetworkManager.shared.searchCourses(query: trimmed) { courses in
            guard let firstCourse = courses.first else {
                DispatchQueue.main.async {
                    self.isSearching = false
                    self.searchError = "No courses found matching \"\(trimmed)\"."
                }
                return
            }

            DispatchQueue.main.async {
                self.lastMatchedCourse = firstCourse
            }

            NetworkManager.shared.matchBuddy(userID: userID, courseCode: firstCourse.code) { results in
                DispatchQueue.main.async {
                    self.isSearching = false
                    self.matchedStudents = results.map { $0.student }

                    if self.matchedStudents.isEmpty {
                        self.searchError = "No students found for \(firstCourse.code)."
                    }
                }
            }
        }
    }

    // MARK: - Student Search View

    var searchView: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white)

                TextField("Enter course number", text: $searchCourse)
                    .foregroundColor(.white)
                    .textInputAutocapitalization(.characters)
                    .onSubmit {
                        if searchCourse.count >= 3 {
                            searchAndMatch()
                        }
                    }

                if !searchCourse.isEmpty {
                    Button {
                        searchCourse = ""
                        matchedStudents = []
                        searchError = nil
                        lastMatchedCourse = nil
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.4))
            .cornerRadius(30)
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .onChange(of: searchCourse) { newValue in
                if newValue.count >= 3 {
                    searchAndMatch()
                } else {
                    matchedStudents = []
                    searchError = nil
                    lastMatchedCourse = nil
                }
            }

            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    if searchCourse.count < 3 {
                        Text("Type 3 characters to search for a course.")
                            .foregroundColor(.gray)
                            .padding(.top, 30)
                            .padding(.leading, 30)
                    } else if isSearching {
                        HStack {
                            ProgressView()
                            Text("Searching for courses and matches...")
                        }
                        .padding(.top, 30)
                        .padding(.leading, 30)
                    } else if let error = searchError {
                        Text(error)
                            .foregroundColor(.gray)
                            .padding(.top, 30)
                            .padding(.leading, 30)
                    } else if matchedStudents.isEmpty {
                        Text("No matching students found.")
                            .foregroundColor(.gray)
                            .padding(.top, 30)
                            .padding(.leading, 30)
                    } else {
                        if let course = lastMatchedCourse {
                            Text("Matches for \(course.code) – \(course.name)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding(.top, 20)
                                .padding(.leading, 20)
                        }

                        ForEach(matchedStudents) { student in
                            HStack {
                                Circle()
                                    .fill(Color(hex: 0xF7AFC2))
                                    .frame(width: 50, height: 50)
                                    .overlay(Text(student.name.prefix(1)))

                                VStack(alignment: .leading) {
                                    Text(student.name)
                                        .font(.headline)
                                    Text(student.email)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)

                            Divider()
                                .padding(.leading, 20)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.top, 10)
        }
    }
}

#Preview {
    ContentView(isLoggedIn: .constant(true), didCompleteOnboarding: .constant(true))
}

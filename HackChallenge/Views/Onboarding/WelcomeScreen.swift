//
//  WelcomeScreen.swift
//  HackChallenge
//
//  Created by Ben Chen on 12/5/25.
//

import SwiftUI

struct WelcomeFlowView: View {
    @Binding var didCompleteOnboarding: Bool

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var pronouns = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var profileImage: UIImage? = nil

    var body: some View {
        NavigationStack {
            WelcomeScreen(
                firstName: $firstName,
                lastName: $lastName,
                pronouns: $pronouns,
                email: $email,
                phone: $phone,
                profileImage: $profileImage,
                didCompleteOnboarding: $didCompleteOnboarding
            )
        }
        .ignoresSafeArea()
    }
}

struct WelcomeScreen: View {
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var pronouns: String
    @Binding var email: String
    @Binding var phone: String
    @Binding var profileImage: UIImage?
    @Binding var didCompleteOnboarding: Bool

    var body: some View {
        ZStack {
            GradientBackground()

            VStack(spacing: 40) {
                Spacer()

                Text("Welcome!")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)

                Spacer()

                NavigationLink {
                    NameScreen(
                        firstName: $firstName,
                        lastName: $lastName,
                        pronouns: $pronouns,
                        email: $email,
                        phone: $phone,
                        profileImage: $profileImage,
                        didCompleteOnboarding: $didCompleteOnboarding
                    )
                } label: {
                    Text("Create profile")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: 0xF7798D))
                        .cornerRadius(16)
                        .padding(.horizontal, 40)
                }

                Spacer()
            }
        }
    }
}



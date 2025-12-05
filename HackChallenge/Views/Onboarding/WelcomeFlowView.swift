//
//  WelcomeFlowView.swift
//  HackChallenge
//
//  Created by Ben Chen on 12/5/25.
//

import SwiftUI
import PhotosUI

struct NameScreen: View {
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

            VStack(spacing: 25) {
                Spacer().frame(height: 60)

                Image("logo3")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140)

                CustomTextField("First name", text: $firstName)
                CustomTextField("Last name", text: $lastName)
                CustomTextField("Pronouns", text: $pronouns)

                NavigationLink {
                    ContactScreen(
                        firstName: $firstName,
                        lastName: $lastName,
                        pronouns: $pronouns,
                        email: $email,
                        phone: $phone,
                        profileImage: $profileImage,
                        didCompleteOnboarding: $didCompleteOnboarding
                    )
                } label: {
                    PinkNextButton()
                }

                Spacer()
            }
            .padding(.horizontal, 40)
        }
    }
}


struct ContactScreen: View {
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

            VStack(spacing: 25) {
                Spacer().frame(height: 60)

                Image("logo3")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140)

                CustomTextField("Email", text: $email)
                CustomTextField("Phone number", text: $phone)

                NavigationLink {
                    ProfilePhotoScreen(
                        firstName: $firstName,
                        lastName: $lastName,
                        pronouns: $pronouns,
                        email: $email,
                        phone: $phone,
                        profileImage: $profileImage,
                        didCompleteOnboarding: $didCompleteOnboarding
                    )
                } label: {
                    PinkNextButton()
                }

                Spacer()
            }
            .padding(.horizontal, 40)
        }
    }
}

struct ProfilePhotoScreen: View {
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var pronouns: String
    @Binding var email: String
    @Binding var phone: String
    @Binding var profileImage: UIImage?
    @Binding var didCompleteOnboarding: Bool
    
    @State private var showPicker = false
    @State private var selectedItem: PhotosPickerItem? = nil
    
    var body: some View {
        ZStack {
            GradientBackground()
            
            VStack(spacing: 30) {
                Spacer().frame(height: 40)
                
                // Profile Image Preview
                Group {
                    if let img = profileImage {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 180, height: 180)
                            .clipShape(Circle())
                    } else {
                        Circle()
                            .fill(Color.white.opacity(0.4))
                            .frame(width: 180, height: 180)
                            .overlay(
                                Image(systemName: "person.crop.circle.fill")
                                    .font(.system(size: 80))
                                    .foregroundColor(.white.opacity(0.8))
                            )
                    }
                }
                
                Button("Upload from device") {
                    showPicker = true
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(hex: 0xF7798D))
                .cornerRadius(16)
                .padding(.horizontal, 40)
                
                NavigationLink {
                    ProfileReviewScreen(
                        firstName: firstName,
                        lastName: lastName,
                        pronouns: pronouns,
                        email: email,
                        phone: phone,
                        profileImage: profileImage,
                        didCompleteOnboarding: $didCompleteOnboarding
                    )
                } label: {
                    Text("Skip for now")
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
        }
        
        // MARK: - Photo Picker
        .photosPicker(isPresented: $showPicker, selection: $selectedItem)
        .photosPicker(isPresented: $showPicker, selection: $selectedItem)
        .onChange(of: selectedItem) {
            guard let item = selectedItem else { return }
            
            Task {
                if let data = try? await item.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    profileImage = uiImage
                }
            }
        }
    }
}


struct ProfileReviewScreen: View {
    let firstName: String
    let lastName: String
    let pronouns: String
    let email: String
    let phone: String
    let profileImage: UIImage?

    @Binding var didCompleteOnboarding: Bool

    var body: some View {
        ZStack {
            GradientBackground()

            VStack(spacing: 20) {
                Spacer().frame(height: 40)

                if let img = profileImage {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                } else {
                    Image("person")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                }

                Text("\(firstName) \(lastName)")
                    .font(.title2)
                    .bold()

                Text(pronouns)
                    .foregroundColor(.gray)

                Text(email)
                Text(phone)

                HStack {
                    Button("Cancel") { }
                        .foregroundColor(.gray)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(16)

                    Button("Done") {
                        didCompleteOnboarding = true
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: 0xF7798D))
                    .cornerRadius(16)
                }
                .padding(.horizontal, 40)

                Spacer()
            }
        }
    }
}

// MARK: - Reusable Components

struct PinkNextButton: View {
    var body: some View {
        Text("Next >")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(hex: 0xF7798D))
            .cornerRadius(16)
    }
}

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String

    init(_ placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }

    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 1)
    }
}

# StuddyBuddy

Find your perfect study buddies at Cornell.

<img height="512" alt="demo" src="https://github.com/user-attachments/assets/4277470a-a1a2-4ef4-831a-692745a88855" />


## Features
- Login Authentication
- User Profiles
- Friendships
- Courses and Sessions
- Schedule
- Messaging System
- Matching and Recommendations

[Screenshots](https://drive.google.com/drive/folders/1Dx7OG3t3CFt-TH3o1tlPPHJEZ-2BWDns?usp=sharing)

[Backend](https://github.com/benc07/studdy-buddy)

## User Flow
1. Login Page Using Google
The app begins with a welcome/sign-in screen that prompts the user to sign in using Google. There's a “Continue with Google” button that triggers Google OAuth. Once tapped, the user is redirected to the Google account selection screen, where users can select an existing account already logged in on the device, or users may enter their email and password through the standard Google login pages. After successful authentication, the app returns the user to a personalized welcome screen (e.g., Welcome, John).

2. Setting Up Personal Information (Profile Creation Flow)
After logging in for the first time, the user is guided through a multi-step profile setup.
(1st screen) Basic Info that asks for First name, Last name, Pronouns. Once these fields are validated, and users can proceed using the Next button.
(2nd screen) Contact Info that asks for Email (auto-filled from Google login but still shown), Phone number
(3rd screen) A profile photo screen that allows users to upload a profile picture from their device, or skip the step.
(Final profile preview screen) shows Profile photo, Name, Pronouns, Email, Phone number and they confirm by clicking Done.

3. Choosing Courses From Cornell's Course Roster
The home page displays the user's profile and an empty schedule. When users tap Add classes, they are brought to a course search interface. Users can search by subject or course number. Then they can view matching courses from Cornell’s course roster, with Course number and section (e.g., Chem 2070-001) and tap the course’s plus button to add it to their schedule.

4. Editing Their Schedule (Adding & Deleting Courses)
After selecting courses, the home schedule view updates to show the added classes as large cards. Users can manage their schedule by adding more courses, removing courses, and the app displays the updated schedule immediately.

5. Add Study Buddies
Users can open the side menu and search a course, it will show people who are also in the course, and the user can request to add them as a friend. Besides sending requests to other users, users can also view incoming friend requests and accept/reject them. Users can view current connections(friend list) and remove friends if they want.

### Design
The features designed include a log in page, and then a way for the user to customize their profile. From there, they are able to add their courses to their profile page using a search feature, where the courses are displayed in a calendar type card. There is another tab where the user can search the app for other users that also have the same course as them, and they can choose to connect with that user. Each user’s email and number (optional) is displayed in their profile, so users can easily contact one another. Initially we wanted to include a messaging system, but realized it was too complicated to implement. On the side tab, the user can view the people they already connected with and any requests they made, as well as other people’s requests for them. They can also choose to log out.

For the visual design, I wanted to make an approach that was friendly and easy to read, since there is a bit of text when the user goes to search for their classes. I chose to use SF Pro, because that is the font most apps developed in IOS use, and that is what our front end implementation is. I made my cards and components rounded, for that soft, friendlier look, and also used a pastel color palette. Specifically, I used pink as the main theme, because it is a very fun color that gives of vibes of “caring” and “friendship”. The other colors are all more muted and pastel, to fit in and not seem abrasive on the eye.

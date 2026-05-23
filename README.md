| Full Name       | ID         |
|-----------------|------------|
| Elizabeth Abay  | UGR/3071/16|
| Kidist Meseret  | UGR/9079/16|
| Tsion Kinde     | UGR/2656/16|
| Sosina Zemichael| UGR/4010/16|
| Yadeni Getu     | UGR/7202/16|



# Vibe 


This is our proposed project for the Mobile App Development course.

Vibe is a social media app designed for university students to connect with others based on shared interests.

## Project Idea

In this app, users will create a profile and select their interests.
The system will match users with others who have similar interests, allowing them to connect and interact.

##  Business Features

## 1. User Profile & Interests

Users can:

* Create a profile
* View their profile
* Update their information and interests
* Delete their account

This feature supports full CRUD operations.

## 2. Matching & Connection Requests

Users can:

* Get matched with other users based on interests
* Send connection requests
* View requests
* Accept or reject requests

 This feature also supports CRUD operations.

Note: Chat is a secondary feature available only after connection.

## Authentication & Authorization

* Users will sign up and log in using secure authentication
* Authorization will ensure users can only access their own data and connections

## Backend (REST API)

The system will use a REST API backend that runs locally on our machines.

The backend will:

* Manage user profiles and interests
* Handle matching logic
* Manage connection requests
* Handle saved messages
* Manage blocked users
* Handle authentication and authorization

Note: No external hosting will be used. The backend and database will run locally.

## Tools (Planned)

* Flutter (mobile app)
* Express (REST API backend)
* Local database 

Note: Firebase/Firestore will NOT be used.

## Testing (Planned)

* Widget testing
* Unit testing
* Integration testing

## Project Status

This project is currently in the proposal stage.
Development has not started yet.

##  Goal

The goal is to build a simple offline platform where students can:
*  Find and connect with others who share similar interests 
*  Interact in a controlled and safe environment 
*  Store personal ideas using a built-in saved messages feature

##  Team

This is a group project for our own course.

##  Author

Made by our team 

## Added features

## 1.  Block Users can:
*  Block other users 
*  Unblock users

This feature improves user safety and control, even in an offline environment.
## 2.  Saved Messages (Personal Chat)
Inspired by Saved Messages in Telegram, users can:
*  Send messages to themselves 
*  Save ideas, thoughts, and plans 
*  View messages in a chat-like interface 
*  Delete messages 
This feature works fully offline and provides a personal space for users inside the app.

=======
# VIBE – Social Connection Mobile Application

## Overview
VIBE is a Flutter-based mobile application designed to help users connect with people who share similar interests. The application focuses on creating meaningful friendships, smooth communication, and an engaging social experience through a modern and user-friendly interface.

This project was developed by following the given requirements:
- Implementing Figma designs using Flutter
- Using GoRouter for navigation and routing
- Applying a feature-based folder structure
- Collaborating using GitHub branches

---

# Project Goal
The main goal of VIBE is to create a social platform where users can:
- Create accounts and login
- Find people with similar interests
- Build friendships and connections
- Communicate through chats
- Manage and customize their profiles

---

# Technologies Used
- Flutter
- Dart
- GoRouter
- Git & GitHub
- Figma

---

# Folder Structure

```plaintext
lib/
│
├── core/                     # Shared utilities
│   ├── routing/
│   ├── theme/
│   ├── constants/
│   └── widgets/
│
├── features/
│   ├── auth/
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   ├── widgets/
│   │   │   └── providers/
│   │   ├── domain/
│   │   └── data/
│   │
│   ├── home/
│   ├── profile/
│   ├── chat/
│   ├── onboarding/
│   ├── notification/
│   └── connections/
│
└── main.dart
```

---

# Design Implementation

At the beginning of the project, the team started by following the original Figma design. During development, we improved and modified several parts of the design to create a better user experience, smoother navigation flow, and more consistent UI structure.

We tried to make the application:
- More responsive
- More modern
- Easier to navigate
- Better organized

The final UI design still follows the main concept of the original Figma prototype while improving usability and visual appearance.

---

# Navigation and Routing

The application uses the GoRouter package for navigation and routing.

GoRouter helped us implement:
- Clean screen navigation
- Organized route management
- Smooth transitions between screens
- Better scalability for future development

Navigation flow includes:
- Splash Screen
- Onboarding Screens
- Authentication Screens
- Home Screen
- Chat Screens
- Profile Management
- Notifications and Connections

---

# Team Collaboration

This project was developed collaboratively using GitHub.

Each team member worked on screens that belong to the same feature or functionality. After completing individual tasks, we tried to merge all screens together to create a smooth and connected application flow.

Most of the development work was done inside a GitHub branch called: Screens
After testing and organizing the project properly, the final version was merged and pushed into the:
branch.

This workflow helped us collaborate effectively and manage the project structure properly.

---

# Main Features

## Authentication
- User Registration
- Login System
- Verification Screens

## Profile Management
Users can:
- Edit profile information
- Update account details
- Delete accounts

## Interest Matching
VIBE helps users find and connect with people who share similar interests and preferences.

## Chat System
- Chat List
- Conversation Screens
- Saved Messages

## Notifications
- Connection Requests
- Updates and Activities

---

# Challenges Faced

During development, the team faced several challenges such as:
- Managing navigation flow
- Merging GitHub branches
- Maintaining UI consistency
- Organizing the feature-based structure
- Implementing GoRouter correctly

These challenges were solved through collaboration, testing, and restructuring parts of the application.

---

# Lessons Learned

Through this project, we gained experience in:
- Flutter mobile development
- Implementing UI from Figma
- GitHub collaboration
- Branch management
- GoRouter navigation
- Feature-based architecture
- Teamwork and communication

---

# Future Improvements

Future versions of VIBE may include:
- Real-time messaging
- Backend integration
- Push notifications
- Media sharing
- Advanced matching algorithms
- Dark mode support

---

# Conclusion

VIBE is a social connection mobile application developed using Flutter. The project successfully applied feature-based architecture, GoRouter navigation, Figma UI implementation, and GitHub collaboration practices.

The project helped the team improve both technical and teamwork skills while building a modern and organized mobile application.
>>>>>>> Vibe_Flutter/Screens

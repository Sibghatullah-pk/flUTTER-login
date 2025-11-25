# Firebase Setup Instructions

## 🔥 Steps to Configure Firebase for Your Flutter App

### 1. Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **"Add project"**
3. Enter project name (e.g., "login-app")
4. Follow the setup wizard

### 2. Register Your Web App

1. In Firebase Console, click the **Web icon** (`</>`)
2. Register your app with a nickname
3. Copy the Firebase configuration

### 3. Update Firebase Configuration

Open `lib/main.dart` and replace the placeholder values with your Firebase config:

```dart
await Firebase.initializeApp(
  options: const FirebaseOptions(
    apiKey: "YOUR_API_KEY",                    // From Firebase Console
    authDomain: "YOUR_PROJECT_ID.firebaseapp.com",
    databaseURL: "https://YOUR_PROJECT_ID-default-rtdb.firebaseio.com",
    projectId: "YOUR_PROJECT_ID",
    storageBucket: "YOUR_PROJECT_ID.appspot.com",
    messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
    appId: "YOUR_APP_ID",
  ),
);
```

### 4. Enable Firebase Authentication

1. In Firebase Console, go to **Authentication**
2. Click **"Get Started"**
3. Enable **Email/Password** sign-in method

### 5. Enable Firebase Realtime Database

1. In Firebase Console, go to **Realtime Database**
2. Click **"Create Database"**
3. Choose a location
4. Start in **test mode** (for development)

### 6. Set Database Rules (Important!)

In Realtime Database, go to **Rules** tab and set:

```json
{
  "rules": {
    "users": {
      "$uid": {
        ".read": "$uid === auth.uid",
        ".write": "$uid === auth.uid"
      }
    }
  }
}
```

This ensures users can only read/write their own data.

### 7. Run the App

```bash
flutter pub get
flutter run -d chrome
```

## 📱 App Features

### ✅ Implemented Features

1. **Firebase Authentication**
   - Email/Password sign-in
   - User registration
   - Secure logout

2. **Firebase Realtime Database**
   - Save user profile (name, email, phone)
   - Update profile in real-time
   - Read user data

3. **Screens**
   - **Login Screen** - Authenticate existing users
   - **Register Screen** - Create new accounts
   - **Dashboard Screen** - View profile and quick actions
   - **Edit Profile Screen** - Update user information

4. **Data Structure**
   ```
   users/
     ├── {userId}/
         ├── name: "John Doe"
         ├── email: "john@example.com"
         ├── phone: "+1234567890"
         ├── createdAt: "2025-11-25T10:30:00"
         └── updatedAt: "2025-11-25T11:00:00"
   ```

## 🚀 Usage Flow

1. **Register**: Create account with name, email, phone, and password
2. **Login**: Sign in with email and password
3. **Dashboard**: View your profile information
4. **Edit Profile**: Update name, email, or phone
5. **Logout**: Sign out securely

## ⚠️ Important Notes

- Replace ALL placeholder values in `lib/main.dart` with your actual Firebase config
- For production, update database security rules
- Never commit Firebase config to public repositories
- Use environment variables for sensitive data in production

## 🔧 Troubleshooting

### "Firebase not initialized" error
- Ensure you've added your Firebase config to `main.dart`
- Check that Firebase.initializeApp() completes before app starts

### Authentication errors
- Verify Email/Password is enabled in Firebase Console
- Check Firebase project settings

### Database permission denied
- Update database rules as shown in step 6
- Ensure user is authenticated before database operations

## 📚 Project Structure

```
lib/
├── main.dart                           # App entry & Firebase init
├── services/
│   ├── auth_service.dart              # Firebase Auth operations
│   └── database_service.dart          # Firebase Database operations
└── screens/
    ├── login_screen.dart              # Login UI
    ├── register_screen.dart           # Registration UI
    ├── dashboard_screen.dart          # Main dashboard
    └── edit_profile_screen.dart       # Profile editing
```

## 🎯 Next Steps

1. Add profile photo upload
2. Implement password reset
3. Add email verification
4. Create settings screen
5. Add dark mode support

# 🚀 Quick Start Guide - Firebase Authentication Setup

## ⚡ 5-Minute Setup

### Step 1: Firebase Console Setup (2 minutes)

1. **Create Project:**
   - Go to: https://console.firebase.google.com/
   - Click "Add project"
   - Name: "login-app" → Continue → Create

2. **Add Web App:**
   - Click Web icon `</>`
   - App nickname: "My Login App"
   - Click "Register app"
   - **COPY the config** (important!)

3. **Enable Email Authentication:**
   - Left menu → Authentication → Get Started
   - Sign-in method tab → Email/Password → Enable → Save

4. **Enable Google Authentication:**
   - Sign-in method tab → Google → Enable
   - Choose support email → Save

5. **Create Realtime Database:**
   - Left menu → Realtime Database → Create Database
   - Location: us-central1 → Start in test mode → Enable

6. **Set Database Rules:**
   - Rules tab → Paste this:
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
   - Publish

### Step 2: Update Your App (1 minute)

**Open:** `s:\MBLE CMP\login-android-kotlin\lib\main.dart`

**Find this section (around line 11-18):**
```dart
await Firebase.initializeApp(
  options: const FirebaseOptions(
    apiKey: "YOUR_API_KEY",
    authDomain: "YOUR_PROJECT_ID.firebaseapp.com",
    databaseURL: "https://YOUR_PROJECT_ID-default-rtdb.firebaseio.com",
    projectId: "YOUR_PROJECT_ID",
    storageBucket: "YOUR_PROJECT_ID.appspot.com",
    messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
    appId: "YOUR_APP_ID",
  ),
);
```

**Replace with YOUR Firebase config from Step 1.2**

### Step 3: Run App (1 minute)

```powershell
cd "s:\MBLE CMP\login-android-kotlin"
flutter pub get
flutter run -d chrome
```

## ✅ Test Your App

### Test 1: Register New User
1. Click "Don't have an account? Register"
2. Fill in:
   - Name: "Test User"
   - Email: "test@example.com"
   - Phone: "1234567890"
   - Password: "password123"
3. Click "Register"
4. ✅ Should go to Dashboard

### Test 2: Login with Email
1. Logout (if logged in)
2. Enter:
   - Email: "test@example.com"
   - Password: "password123"
3. Click "Login"
4. ✅ Should go to Dashboard

### Test 3: Google Sign-In
1. Logout
2. Click "Sign in with Google"
3. Select Google account
4. ✅ Should go to Dashboard

### Test 4: Edit Profile
1. In Dashboard, click "Profile" card
2. Update name or phone
3. Click "Save Changes"
4. ✅ Should show "Profile updated successfully!"

### Test 5: View Data in Firebase
1. Go to Firebase Console → Realtime Database
2. ✅ You should see:
   ```
   users/
     └── {user-id}/
         ├── email: "test@example.com"
         ├── name: "Test User"
         ├── phone: "1234567890"
         └── createdAt: "2025-11-25..."
   ```

## 🎯 Your App Features

| Feature | Status | Screen |
|---------|--------|--------|
| Email/Password Login | ✅ Ready | Login Screen |
| Email/Password Register | ✅ Ready | Register Screen |
| Google Sign-In | ✅ Ready | Login Screen |
| View Profile | ✅ Ready | Dashboard |
| Edit Profile | ✅ Ready | Edit Profile Screen |
| Save to Database | ✅ Ready | Automatic |
| Logout | ✅ Ready | Dashboard |

## 📱 How to Use Each Feature

### 1. Register (Create Account)
```
Login Screen → "Don't have an account? Register"
↓
Fill: Name, Email, Phone, Password
↓
Click "Register"
↓
✅ Account created + saved to Firebase
↓
Redirect to Dashboard
```

### 2. Login (Email/Password)
```
Login Screen
↓
Enter: Email + Password
↓
Click "Login"
↓
✅ Firebase authenticates
↓
Redirect to Dashboard
```

### 3. Google Sign-In
```
Login Screen
↓
Click "Sign in with Google"
↓
Select Google Account
↓
✅ Firebase authenticates with Google
↓
Redirect to Dashboard
```

### 4. Edit Profile
```
Dashboard → Click "Profile" card
↓
Update: Name, Email, or Phone
↓
Click "Save Changes"
↓
✅ Data saved to Firebase Realtime Database
```

### 5. Logout
```
Dashboard → Click Logout icon (top right)
↓
✅ Signed out from Firebase
↓
Return to Login Screen
```

## 🔍 Verify Firebase Data

**Check Users:**
- Firebase Console → Authentication → Users
- You should see registered users

**Check Database:**
- Firebase Console → Realtime Database → Data
- You should see: `users/{uid}/name, email, phone`

## ⚠️ Common Issues

| Error | Solution |
|-------|----------|
| "Firebase not initialized" | Update config in `lib/main.dart` |
| "Permission denied" | Update database rules (Step 1.6) |
| "Email already in use" | User exists, try login |
| "Google Sign-In failed" | Enable Google auth (Step 1.4) |
| "Invalid credentials" | Check email/password |

## 📞 Where is Each Feature?

### Files:
- **Firebase Config:** `lib/main.dart` (line 11-18)
- **Login Logic:** `lib/services/auth_service.dart`
- **Database Logic:** `lib/services/database_service.dart`
- **Login UI:** `lib/screens/login_screen.dart`
- **Register UI:** `lib/screens/register_screen.dart`
- **Dashboard UI:** `lib/screens/dashboard_screen.dart`
- **Edit Profile UI:** `lib/screens/edit_profile_screen.dart`

### Functions:
- **Login:** `AuthService.signInWithEmailAndPassword()`
- **Register:** `AuthService.signUpWithEmailAndPassword()`
- **Google Login:** `AuthService.signInWithGoogle()`
- **Logout:** `AuthService.signOut()`
- **Save Profile:** `DatabaseService.saveUserProfile()`
- **Update Profile:** `DatabaseService.updateUserProfile()`
- **Get Profile:** `DatabaseService.getUserProfile()`

## 🎉 You're Done!

Your app now has:
- ✅ Full Firebase Authentication (Email + Google)
- ✅ Firebase Realtime Database
- ✅ Complete user registration flow
- ✅ Profile management
- ✅ Secure logout

**Need help?** Check `FIREBASE_SETUP.md` for detailed instructions.

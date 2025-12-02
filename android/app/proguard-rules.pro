# Firebase Authentication
-keepattributes Signature
-keepattributes *Annotation*

# Firebase Realtime Database
-keepclassmembers class * {
    @com.google.firebase.database.PropertyName *;
}

# Google Sign-In
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# Keep Google Play Services classes
-keep class com.google.android.gms.common.api.** { *; }
-keep class com.google.firebase.** { *; }

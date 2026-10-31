# Flutter deferred components (Play Core split install): optional; app does not use dynamic feature modules
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**

# Stripe (flutter_stripe): optional push provisioning + Parcelize stubs referenced by Stripe SDK
-dontwarn com.stripe.android.pushProvisioning.**
-dontwarn kotlinx.parcelize.Parceler$DefaultImpls
-dontwarn kotlinx.parcelize.Parceler
-dontwarn kotlinx.parcelize.Parcelize

# flutter_inappwebview: consumer rules keep JS bridge; explicit keep for payment webview reliability
-keepclassmembers class com.pichillilorenzo.flutter_inappwebview_android$JavaScriptBridgeInterface {
    <fields>;
    <methods>;
}

# flutter_local_notifications: Gson needs generic signatures; scheduled reminders deserialize model classes
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn sun.misc.**
-keep class * extends com.google.gson.TypeAdapter
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer
-keepclassmembers,allowobfuscation class * {
    @com.google.gson.annotations.SerializedName <fields>;
}
-keep,allowobfuscation,allowshrinking class com.google.gson.reflect.TypeToken
-keep,allowobfuscation,allowshrinking class * extends com.google.gson.reflect.TypeToken
-keep class com.dexterous.flutterlocalnotifications.models.** { *; }

# mobile_scanner ships consumer Proguard rules for ML Kit; no extra rules needed here.

# Firebase Messaging / Crashlytics: Play Services and Firebase ship consumer rules via Gradle deps.

# PostHog Android SDK (posthog_flutter): keep Flutter plugin bridge
-keep class com.posthog.flutter.** { *; }

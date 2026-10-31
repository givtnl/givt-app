# Flutter deferred components (Play Core split install): optional; app does not use dynamic feature modules
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**

# Stripe (flutter_stripe): optional push provisioning + Parcelize stubs referenced by Stripe SDK
-dontwarn com.stripe.android.pushProvisioning.**
-dontwarn kotlinx.parcelize.Parceler$DefaultImpls
-dontwarn kotlinx.parcelize.Parceler
-dontwarn kotlinx.parcelize.Parcelize

# flutter_inappwebview: plugin consumer rules keep com.pichillilorenzo.flutter_inappwebview_android.webview.JavaScriptBridgeInterface

# flutter_local_notifications: keep notification model classes so reminders rescheduled after the update still deserialize
-keep class com.dexterous.flutterlocalnotifications.models.** { *; }

# mobile_scanner ships consumer Proguard rules for ML Kit; no extra rules needed here.

# Firebase Messaging / Crashlytics: Play Services and Firebase ship consumer rules via Gradle deps.

# PostHog Android SDK (posthog_flutter): keep Flutter plugin bridge
-keep class com.posthog.flutter.** { *; }

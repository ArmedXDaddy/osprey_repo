pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        file("local.properties").inputStream().use { properties.load(it) }
        val flutterSdkPath = properties.getProperty("flutter.sdk")
        requireNotNull(flutterSdkPath) { "flutter.sdk not set in local.properties" }
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.7.0" apply false
    id("com.google.gms.google-services") version "4.4.2" apply false // ✅ Updated Google Services Plugin
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false  // ✅ Matches Kotlin version in `build.gradle.kts`
}

include(":app")

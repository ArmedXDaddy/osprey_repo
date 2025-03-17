plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android") version "2.1.0" // ✅ Ensures correct Kotlin version
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.osprey_app"
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.example.osprey_app"
        minSdk = 23
        targetSdk = 35
        versionCode = 1
        versionName = "1.0.0"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11  // ✅ Fixes "Java 8 is obsolete" issue
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    buildTypes {
        release {
            isMinifyEnabled = true  // ✅ Required for `shrinkResources`
            isShrinkResources = true  // ✅ Corrected syntax (not `isShrinkResources`)
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
        debug {
            isMinifyEnabled = false
            isShrinkResources = false  // ✅ Corrected syntax
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // ✅ Firebase BoM (ensures compatible Firebase versions)
    implementation(platform("com.google.firebase:firebase-bom:33.10.0"))

    // ✅ Firebase Dependencies
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-auth-ktx")
    implementation("com.google.firebase:firebase-firestore-ktx")
    implementation("com.google.firebase:firebase-storage-ktx")
    implementation("com.google.android.gms:play-services-auth:20.7.0")

}

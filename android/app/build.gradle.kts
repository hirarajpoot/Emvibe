plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.softedigi.emvibe"
    compileSdk = flutter.compileSdkVersion

    // 🔥 Force correct NDK version (instead of flutter.ndkVersion)
    ndkVersion = "27.0.12077973"

    compileOptions {
        // 🔥 Added for Java 8 desugaring compatibility (Kotlin syntax)
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_1_8.toString() // 🔥 Set JVM target for Kotlin
    }

    defaultConfig {
        applicationId = "com.softedigi.emvibe"
        // YAHAN PE CHANGE KARO: minSdk 23 karo
        minSdk = flutter.minSdkVersion // flutter.minSdkVersion ki jagah directly 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true  // 🔥 Add this line for multidex
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // 🔥 Added for Java 8 desugaring (Kotlin syntax)
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:1.2.2")
    implementation("androidx.multidex:multidex:2.0.1")  // 🔥 Add this line for multidex
}
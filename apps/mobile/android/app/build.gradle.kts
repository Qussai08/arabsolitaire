plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val unityLibraryPresent = project.findProject(":unityLibrary") != null

android {
    // PLACEHOLDER_ORG_ID — replace with approved organization reverse-domain.
    namespace = "com.arabsolitaire.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    buildFeatures {
        buildConfig = true
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // PLACEHOLDER_ORG_ID — not a final store identifier.
        applicationId = "com.arabsolitaire.app"
        minSdk = 26
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        buildConfigField(
            "boolean",
            "UNITY_LIBRARY_AVAILABLE",
            unityLibraryPresent.toString(),
        )
        ndk {
            if (unityLibraryPresent) {
                abiFilters += listOf("arm64-v8a")
            }
        }
    }

    sourceSets {
        getByName("main") {
            if (unityLibraryPresent) {
                kotlin.setSrcDirs(listOf("src/main/kotlin", "src/unity/kotlin"))
            } else {
                kotlin.setSrcDirs(listOf("src/main/kotlin", "src/noUnity/kotlin"))
            }
        }
    }

    flavorDimensions += "environment"
    productFlavors {
        create("dev") {
            dimension = "environment"
            applicationIdSuffix = ".dev"
        }
        create("qa") {
            dimension = "environment"
            // Maps to AppEnvironment.test (Android forbids flavor name "test").
            applicationIdSuffix = ".test"
        }
        create("staging") {
            dimension = "environment"
            applicationIdSuffix = ".staging"
        }
        create("prod") {
            dimension = "environment"
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
            if (unityLibraryPresent) {
                proguardFiles(
                    getDefaultProguardFile("proguard-android-optimize.txt"),
                    "proguard-unity-bridge.pro",
                )
            }
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies {
    if (unityLibraryPresent) {
        implementation(project(":unityLibrary"))
        // unityLibrary uses `implementation` for jars/deps; expose them to the app compile classpath.
        implementation(files("../unityLibrary/libs/unity-classes.jar"))
        implementation("androidx.appcompat:appcompat:1.6.1")
        implementation("androidx.core:core:1.9.0")
        implementation("androidx.games:games-activity:4.4.0")
    }
    testImplementation("junit:junit:4.13.2")
}

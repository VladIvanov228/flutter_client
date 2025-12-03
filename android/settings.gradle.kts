/**
 * SETTINGS: Настройки проекта Gradle
 * 
 * Описание: Определяет структуру проекта и плагины
 * 
 * Ключевые элементы:
 * 1. Указание пути к Flutter SDK
 * 2. Подключение Flutter плагинов
 * 3. Подключение модулей (только :app)
 * 
 * Плагины:
 * - Flutter Plugin Loader
 * - Android Application
 * - Kotlin Android
 */

pluginManagement {
    val flutterSdkPath =
        run {
            val properties = java.util.Properties()
            file("local.properties").inputStream().use { properties.load(it) }
            val flutterSdkPath = properties.getProperty("flutter.sdk")
            require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
            flutterSdkPath
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
    id("com.android.application") version "8.11.1" apply false
    id("org.jetbrains.kotlin.android") version "2.2.20" apply false
}

include(":app")

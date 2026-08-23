-keep class com.arabsolitaire.app.unity.** { *; }
-keep class com.unity3d.player.** { *; }
-keepclassmembers class * {
    @com.unity3d.player.UnityPlayer$* <methods>;
}

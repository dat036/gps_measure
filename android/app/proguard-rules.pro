# LandMeasure R8 rules. Flutter and most plugins ship their own consumer rules;
# only add what they miss.

# Flutter engine references Play Core (deferred components) which we don't use.
-dontwarn com.google.android.play.core.**

# Meta Audience Network (AdMob mediation adapter "gma_mediation_meta").
-keep class com.facebook.ads.** { *; }
-keep interface com.facebook.ads.** { *; }
-dontwarn com.facebook.ads.**
-dontwarn com.facebook.infer.annotation.**

# Google Mobile Ads / UMP are covered by their consumer rules.

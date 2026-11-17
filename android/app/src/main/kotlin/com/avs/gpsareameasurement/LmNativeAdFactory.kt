package com.avs.gpsareameasurement

import android.content.Context
import android.content.res.ColorStateList
import android.graphics.drawable.GradientDrawable
import android.graphics.drawable.RippleDrawable
import android.view.LayoutInflater
import android.view.View
import android.widget.ImageView
import android.widget.TextView
import com.google.android.gms.ads.nativead.MediaView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.NativeAdFactory

/**
 * Builds the native ad layouts (res/layout/lm_native_*.xml) and dresses them
 * with the colors Flutter sends in `customOptions` (see `NativeAdStyle` in
 * `native_ad_controller.dart`), so ads match the app's light/dark theme and
 * their button has the same color as the screen's primary button.
 *
 * [framed]: rounded card with a hairline stroke (compact / medium); the
 * full-screen layout is a plain background.
 */
class LmNativeAdFactory(
    private val context: Context,
    private val layoutRes: Int,
    private val framed: Boolean,
) : NativeAdFactory {

    override fun createNativeAd(
        nativeAd: NativeAd,
        customOptions: MutableMap<String, Any>?,
    ): NativeAdView {
        val options = customOptions ?: emptyMap()
        val adView = LayoutInflater.from(context).inflate(layoutRes, null) as NativeAdView

        fun color(key: String, fallback: Int): Int =
            (options[key] as? Number)?.toInt() ?: fallback

        val background = color("background", 0xFFFFFFFF.toInt())
        val stroke = color("stroke", 0xFFE6EAF0.toInt())
        val titleColor = color("title", 0xFF0E1A2B.toInt())
        val bodyColor = color("body", 0xFF5B6577.toInt())
        val ctaColor = color("cta", 0xFF1E6BFF.toInt())
        val ctaTextColor = color("ctaText", 0xFFFFFFFF.toInt())
        val badgeColor = color("badge", 0xFFE3F5EE.toInt())
        val badgeTextColor = color("badgeText", 0xFF0F8A5F.toInt())

        // Card.
        val container = adView.findViewById<View>(R.id.ad_container)
        container.background = GradientDrawable().apply {
            setColor(background)
            if (framed) {
                cornerRadius = dp(16)
                setStroke(dp(1).toInt(), stroke)
            }
        }

        // Headline.
        val headline = adView.findViewById<TextView>(R.id.ad_headline)
        headline.text = nativeAd.headline
        headline.setTextColor(titleColor)
        adView.headlineView = headline

        // Small "Ad" label (required by AdMob policy).
        val badge = adView.findViewById<TextView>(R.id.ad_badge)
        badge.text = context.getString(R.string.lm_native_ad_label)
        badge.setTextColor(badgeTextColor)
        badge.background = GradientDrawable().apply {
            setColor(badgeColor)
            cornerRadius = dp(4)
        }

        // Body.
        val body = adView.findViewById<TextView>(R.id.ad_body)
        if (nativeAd.body.isNullOrEmpty()) {
            body.visibility = View.GONE
        } else {
            body.visibility = View.VISIBLE
            body.text = nativeAd.body
            body.setTextColor(bodyColor)
        }
        adView.bodyView = body

        // Icon.
        val icon = adView.findViewById<ImageView>(R.id.ad_icon)
        val iconDrawable = nativeAd.icon?.drawable
        if (iconDrawable == null) {
            icon.visibility = View.GONE
        } else {
            icon.visibility = View.VISIBLE
            icon.setImageDrawable(iconDrawable)
            icon.clipToOutline = true
            icon.background = GradientDrawable().apply { cornerRadius = dp(10) }
        }
        adView.iconView = icon

        // Media (absent in the compact layout).
        adView.findViewById<MediaView?>(R.id.ad_media)?.let { media ->
            media.setImageScaleType(ImageView.ScaleType.FIT_CENTER)
            media.clipToOutline = true
            media.background = GradientDrawable().apply { cornerRadius = dp(12) }
            adView.mediaView = media
        }

        // Call to action: same color as the screen's primary button.
        val cta = adView.findViewById<TextView>(R.id.ad_cta)
        if (nativeAd.callToAction.isNullOrEmpty()) {
            cta.visibility = View.INVISIBLE
        } else {
            cta.visibility = View.VISIBLE
            cta.text = nativeAd.callToAction
            cta.setTextColor(ctaTextColor)
            val shape = GradientDrawable().apply {
                setColor(ctaColor)
                cornerRadius = dp(if (framed) 12 else 16)
            }
            cta.background = RippleDrawable(ColorStateList.valueOf(0x33FFFFFF), shape, null)
        }
        adView.callToActionView = cta

        adView.setNativeAd(nativeAd)
        return adView
    }

    private fun dp(value: Int): Float = value * context.resources.displayMetrics.density
}

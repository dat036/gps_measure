import GoogleMobileAds
import UIKit
import google_mobile_ads

/// The factory IDs and ARGB theme colors are shared with NativeLayout in Dart.
final class LmNativeAdFactory: NSObject, FLTNativeAdFactory {
  enum Layout: String, CaseIterable {
    case compact = "lm_native_compact"
    case medium = "lm_native_medium"
    case full = "lm_native_full"
  }

  private let layout: Layout

  init(layout: Layout) {
    self.layout = layout
    super.init()
  }

  func createNativeAd(_ nativeAd: NativeAd, customOptions: [AnyHashable: Any]? = nil)
    -> NativeAdView? {
    let options = customOptions ?? [:]
    func color(_ key: String, _ fallback: UInt32) -> UIColor {
      let value = (options[key] as? NSNumber)?.uint32Value ?? fallback
      return UIColor(
        red: CGFloat((value >> 16) & 0xff) / 255,
        green: CGFloat((value >> 8) & 0xff) / 255,
        blue: CGFloat(value & 0xff) / 255,
        alpha: CGFloat((value >> 24) & 0xff) / 255
      )
    }

    let full = layout == .full
    let adView = NativeAdView(frame: .zero)
    adView.backgroundColor = color("background", 0xffffffff)
    if !full {
      adView.layer.cornerRadius = 16
      adView.layer.borderWidth = 1
      adView.layer.borderColor = color("stroke", 0xffe6eaf0).cgColor
    }

    let content = UIStackView()
    content.axis = .vertical
    content.spacing = full ? 16 : 10
    content.translatesAutoresizingMaskIntoConstraints = false
    adView.addSubview(content)
    NSLayoutConstraint.activate([
      content.leadingAnchor.constraint(equalTo: adView.leadingAnchor, constant: full ? 20 : 12),
      content.trailingAnchor.constraint(equalTo: adView.trailingAnchor, constant: full ? -20 : -12),
      // Reserve the top row for SDK AdChoices and Flutter's close button.
      content.topAnchor.constraint(equalTo: adView.topAnchor, constant: full ? 56 : 12),
      content.bottomAnchor.constraint(equalTo: adView.bottomAnchor, constant: full ? -20 : -12),
    ])

    let icon = UIImageView(image: nativeAd.icon?.image)
    icon.contentMode = .scaleAspectFit
    icon.clipsToBounds = true
    icon.layer.cornerRadius = 10
    icon.isHidden = nativeAd.icon?.image == nil
    let iconWidth = icon.widthAnchor.constraint(equalToConstant: full ? 56 : 44)
    // UIStackView collapses optional, hidden assets to zero size.
    iconWidth.priority = .init(999)
    NSLayoutConstraint.activate([iconWidth, icon.heightAnchor.constraint(equalTo: icon.widthAnchor)])
    adView.iconView = icon

    let badge = UILabel()
    badge.text = "Ad"
    badge.textAlignment = .center
    badge.font = .systemFont(ofSize: 11, weight: .bold)
    badge.textColor = color("badgeText", 0xff0f8a5f)
    badge.backgroundColor = color("badge", 0xffe3f5ee)
    badge.layer.cornerRadius = 4
    badge.clipsToBounds = true
    badge.accessibilityLabel = "Advertisement"
    badge.setContentHuggingPriority(.required, for: .horizontal)
    badge.setContentCompressionResistancePriority(.required, for: .horizontal)
    badge.widthAnchor.constraint(greaterThanOrEqualToConstant: 26).isActive = true

    let headline = UILabel()
    headline.text = nativeAd.headline
    headline.numberOfLines = full ? 2 : 1
    headline.font = .systemFont(ofSize: full ? 20 : 15, weight: .semibold)
    headline.textColor = color("title", 0xff0e1a2b)
    adView.headlineView = headline

    let titleRow = UIStackView(arrangedSubviews: [badge, headline])
    titleRow.spacing = 6
    titleRow.alignment = .center

    let body = UILabel()
    body.text = nativeAd.body
    body.numberOfLines = full ? 3 : 2
    body.font = .systemFont(ofSize: full ? 14 : 13)
    body.textColor = color("body", 0xff5b6577)
    body.isHidden = nativeAd.body?.isEmpty != false
    adView.bodyView = body

    let text = UIStackView(arrangedSubviews: [titleRow, body])
    text.axis = .vertical
    text.spacing = full ? 4 : 2
    let header = UIStackView(arrangedSubviews: [icon, text])
    header.spacing = 12
    header.alignment = .center
    if !full {
      header.isLayoutMarginsRelativeArrangement = true
      header.directionalLayoutMargins = NSDirectionalEdgeInsets(
        top: 0, leading: 0, bottom: 0, trailing: 16
      )
    }
    // Compact uses media beside the text so video creatives remain visible
    // without turning the intro's bottom slot into another full-width card.
    let details = UIStackView()
    details.axis = .vertical
    details.spacing = 6
    if layout == .compact {
      content.axis = .horizontal
      let media = MediaView()
      media.mediaContent = nativeAd.mediaContent
      media.contentMode = .scaleAspectFit
      content.addArrangedSubview(media)
      media.widthAnchor.constraint(equalToConstant: 120).isActive = true
      adView.mediaView = media
      content.addArrangedSubview(details)
      details.addArrangedSubview(header)
    } else {
      content.addArrangedSubview(header)
    }

    if layout != .compact {
      let media = MediaView()
      media.mediaContent = nativeAd.mediaContent
      media.contentMode = .scaleAspectFit
      media.clipsToBounds = true
      media.layer.cornerRadius = 12
      content.addArrangedSubview(media)
      adView.mediaView = media
      if full {
        media.heightAnchor.constraint(greaterThanOrEqualToConstant: 120).isActive = true
      } else {
        media.heightAnchor.constraint(equalToConstant: 120).isActive = true
      }
      // Let the media take the remaining height rather than stretching text.
      media.setContentHuggingPriority(.defaultLow, for: .vertical)
      media.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    } else {
      let spacer = UIView()
      details.addArrangedSubview(spacer)
      spacer.setContentHuggingPriority(.defaultLow, for: .vertical)
    }

    let cta = UIButton(type: .system)
    cta.setTitle(nativeAd.callToAction, for: .normal)
    cta.titleLabel?.font = .systemFont(ofSize: full ? 17 : 15, weight: .semibold)
    cta.setTitleColor(color("ctaText", 0xffffffff), for: .normal)
    cta.backgroundColor = color("cta", 0xff1e6bff)
    cta.layer.cornerRadius = full ? 16 : 12
    cta.isHidden = nativeAd.callToAction?.isEmpty != false
    // Google handles the click through NativeAdView, not a UIButton action.
    cta.isUserInteractionEnabled = false
    let ctaHeight = cta.heightAnchor.constraint(equalToConstant: full ? 56 : 44)
    ctaHeight.priority = .init(999)
    ctaHeight.isActive = true
    if layout == .compact {
      details.addArrangedSubview(cta)
    } else {
      content.addArrangedSubview(cta)
    }
    adView.callToActionView = cta

    // Assign after registering every asset view so the SDK can track clicks.
    adView.nativeAd = nativeAd
    return adView
  }
}

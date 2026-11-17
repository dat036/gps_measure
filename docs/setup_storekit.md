# iOS subscriptions (StoreKit 2)

The existing Premium/paywall UI is shared by Android and iOS. The provider
selects Play Billing on Android and `StoreKitPurchaseService` on iOS. Firebase
is independent of purchases and is not required by this implementation.

## App Store Connect

Production bundle ID: `com.avs.gpsareameasurement`. The screenshot supplied by
the owner on 22/10/2026 shows these case-sensitive IDs in one group:

| Plan | Product ID | Duration |
| --- | --- | --- |
| Monthly | `monthly` | 1 month |
| Yearly | `Yearly` | 1 year |

Both unlock the same Premium entitlement. Put them at **the same subscription
level**, rather than Monthly at level 1 and Yearly at level 2. Levels describe
service tiers, not duration. Keep both in the existing group.

Ready for Review means the products are prepared for review, not approved or
verified by a purchase test. Confirm prices, storefront availability, product
and group localization, review screenshot, Paid Apps Agreement, banking and
tax. Submit the first subscriptions and group with the new app version.

Do not rename the IDs in code to the reference names. No subscription group
ID, shared secret, App Store Connect API key or Firebase key is needed in the
app for these StoreKit 2 purchases.

## Configuration

```json
"IAP_PRODUCT_MONTHLY_IOS": "monthly",
"IAP_PRODUCT_YEARLY_IOS": "Yearly"
```

These are separate from Android's `IAP_PRODUCT_MONTHLY` / `IAP_PRODUCT_YEARLY`.
The Apple IDs also default to the values above when the defines are absent.
The local `env/prod.json` and tracked example have been updated. Use the production
bundle ID to query these products; dev/staging bundle IDs are separate apps
and will not automatically find the production catalog.

## Behavior

- Prices/currency come from StoreKit's localized products, not constants.
- Only verified, current auto-renewable entitlements for the configured IDs
  unlock Premium. Unknown/unverified/revoked/upgraded transactions do not.
- `Transaction.currentEntitlements` handles active subscriptions and billing
  grace periods. Cancelling renewal does not remove already-paid access.
- The native listener handles delayed approvals, renewals and revocations.
  Entitlements refresh at startup, resume, and every minute while executing,
  including when a subscription expires while the app stays open.
- Verified delivered transactions are finished, including active unfinished
  transactions recovered at launch. Pending/cancelled purchases grant no access.
- Restore explicitly calls `AppStore.sync()`. Startup/resume never requests
  this login/synchronization prompt. Restore failures are distinct from an
  account with no purchases.
- The shared Premium cache is used during startup, then reconciled against
  StoreKit. Transactions are verified on-device; there is no backend account
  or server notification integration in this local-data app.
- Day/week free trials are advertised only if configured as a free trial and
  StoreKit reports introductory-offer eligibility. Calendar month/year trials
  are not converted to an inaccurate fixed day count in the shared paywall;
  Apple's purchase sheet still applies the actual introductory offer.

## Device / Sandbox validation still required

```sh
flutter run --release --flavor prod --dart-define-from-file=env/prod.json -d <iphone-device-id>
```

Use a development-signed build with a Sandbox Apple Account, or use TestFlight
(which uses the sandbox). Confirm the Apple sheet is a test purchase before
approving it. A simulator build or mocked channel test does not verify Apple's
catalog, account agreements, transaction signing or real purchases.

Check both products/prices; buy monthly and yearly; cancel the sheet; restore
after reinstall; delayed approval if available; renew/expire/refund in sandbox;
cancel renewal while retaining access until expiry; background/resume; ensure
Premium removes ads and unlocks the existing limits. Use an account that has
already consumed a trial to verify that the app does not promise it again.

Official references:

- [Subscription groups and levels](https://developer.apple.com/help/app-store-connect/manage-subscriptions/offer-auto-renewable-subscriptions/)
- [Current entitlements](https://developer.apple.com/documentation/storekit/transaction/currententitlements)
- [Introductory offer eligibility](https://developer.apple.com/documentation/storekit/product/subscriptioninfo/iseligibleforintrooffer)
- [Submit the first subscriptions](https://developer.apple.com/help/app-store-connect/manage-submissions-to-app-review/submit-an-in-app-purchase/)

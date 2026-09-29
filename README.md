# MikeGyver Studio: The Brave Porch

An illustrated, native iPhone app with a small WidgetKit widget designed for iOS 26+ CarPlay widget stacks. Colin and Luan approach a glowing haunted porch while a friendly ghost, spider, skull, bats and werewolf frame the scene. The small widget shows the number of days until Halloween in America/Chicago. On October 31 it says **TONIGHT!**. After October 31 it counts toward the next year. WidgetKit requests a timeline update at the next Central-time midnight; iOS chooses when the update actually runs.

The source artwork is a **1254 × 1254 RGB PNG**, bundled as `HauntedHouse.png` in both the app and the widget. The app icon is a separate **1024 × 1024 RGB PNG**. The square artwork is suitable for the `systemSmall` widget used by CarPlay. Actual display cropping and available stacks vary by car, so inspect it on the car while parked. MikeGyver Studio is baked into the artwork. Do not use the artwork as a claim that the widget replaces the car's entire dashboard, speedometer, wallpaper or native CarPlay app controls.

## Build with GitHub Actions

1. Create an empty GitHub repository. Unzip this ZIP into its root, including `.github`, then commit and push `main`.
2. Open the **Build Halloween Car Widget IPA** Actions run. Download `HalloweenCarWidget-unsigned-ipa` after a successful build. The packaging step verifies both executable files, matching app/widget versions, the widget extension's `com.apple.widgetkit-extension` declaration, its bundle ID relationship to the app, and the IPA ZIP integrity. These checks validate the unsigned build, not Sideloadly's subsequent signing or the widget's registration on the phone.
3. Extract the artifact ZIP. Install `HalloweenCarWidget-unsigned.ipa` using Sideloadly on Windows with your free Apple Account. Sideloadly must sign and provision both the app and embedded widget extension. A free signature will need refreshing roughly every seven days.
4. With the car parked and connected, on the iPhone open **Settings → General → CarPlay → your car → Widgets → Add Widgets** and look for **The Brave Porch**. Available widget stacks depend on the vehicle display. Also check the iPhone Home Screen widget gallery.

No CarPlay app entitlement is requested: this is a WidgetKit extension. No app group, network access, vehicle telemetry, music playback, or private Apple capability is used. The widget is a glanceable artwork and countdown.

If the app opens but **The Brave Porch** does not appear in the iPhone Home Screen widget picker, first verify that Sideloadly says **Dropping 0 of 1 plug-ins**. The build's validation output is under the **Package unsigned IPA** step. A successful step confirms the unsigned extension is packaged correctly; it does not prove that Sideloadly signed the extension or that iOS registered it. If it remains missing, inspect the signed installation rather than repeatedly rebuilding the same source.

## Version 1.0.4 (build 5)

This build prepares ad-hoc code signatures with Apple's `codesign` on the GitHub macOS runner, signing the widget before the app and verifying both. The IPA is still not provisioned for an iPhone: Sideloadly must replace these signatures with Apple-account signatures and supply a separate provisioning profile for the widget. An ad-hoc signature cannot replace that profile.

The IPA now uses ZIP_STORED for every entry. A September 29 firsthand report describes Sideloadly 0.70 hashing compressed Info.plist ZIP bytes rather than the decompressed file. Keeping the entries uncompressed avoids that reported input condition. The packaging script checks CRCs and verifies the raw and decoded Info.plist hashes match. This is a compatibility workaround, not proof that every Sideloadly extension-signing issue is fixed.

The widget receives a direct WidgetHauntedHouse.png resource in addition to its asset catalog. The view loads that local file first, preserves full-color image rendering, and bounds the image using an overlay. A visible orange moon and MikeGyver Studio label replace a silent missing-image background. The countdown is independent of artwork loading. The host has a generated launch screen to avoid letterboxing.

The supplied device crashes are CODESIGNING / Invalid Page, from builds 1 and 2. They show that iOS killed those widget executables for signature validation, not an ordinary Swift rendering crash. They do not establish the cause of the build-4 placeholder. GitHub must compile these source changes; on-device launch and Sideloadly's final signatures cannot be verified from this source package.

To update your existing repository, extract this source package over its files, then commit and push. Download the newly generated build-5 IPA from Actions and select that file directly in Sideloadly (do not refresh its older cached IPA). Keep the widget extension: Dropping 0 of 1 plug-ins.

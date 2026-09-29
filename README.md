# MikeGyver Studio: The Brave Porch

An illustrated, native iPhone app with a small WidgetKit widget designed for iOS 26+ CarPlay widget stacks. Colin and Luan approach a glowing haunted porch while a friendly ghost, spider, skull, bats and werewolf frame the scene. The small widget shows the number of days until Halloween in America/Chicago. On October 31 it says **TONIGHT!**. After October 31 it counts toward the next year. WidgetKit requests a timeline update at the next Central-time midnight; iOS chooses when the update actually runs.

The source artwork is a **1254 × 1254 RGB PNG**, bundled as `HauntedHouse.png` in both the app and the widget. The app icon is a separate **1024 × 1024 RGB PNG**. The square artwork is suitable for the `systemSmall` widget used by CarPlay. Actual display cropping and available stacks vary by car, so inspect it on the car while parked. MikeGyver Studio is baked into the artwork. Do not use the artwork as a claim that the widget replaces the car's entire dashboard, speedometer, wallpaper or native CarPlay app controls.

## Build with GitHub Actions

1. Create an empty GitHub repository. Unzip this ZIP into its root, including `.github`, then commit and push `main`.
2. Open the **Build Halloween Car Widget IPA** Actions run. Download `HalloweenCarWidget-unsigned-ipa` after a successful build. The packaging step verifies both executable files, matching app/widget versions, the widget extension's `com.apple.widgetkit-extension` declaration, its bundle ID relationship to the app, and the IPA ZIP integrity. These checks validate the unsigned build, not Sideloadly's subsequent signing or the widget's registration on the phone.
3. Extract the artifact ZIP. Install `HalloweenCarWidget-unsigned.ipa` using Sideloadly on Windows with your free Apple Account. Sideloadly must sign both the app and embedded widget extension. Verify installation on the iPhone; if signing rejects the extension, send the exact log. A free signature will need refreshing roughly every seven days.
4. With the car parked and connected, on the iPhone open **Settings → General → CarPlay → your car → Widgets → Add Widgets** and look for **The Brave Porch**. Available widget stacks depend on the vehicle display. Also check the iPhone Home Screen widget gallery.

No CarPlay app entitlement is requested: this is a WidgetKit extension. No app group, network access, vehicle telemetry, music playback, or private Apple capability is used. The widget is a glanceable artwork and countdown.

If the app opens but **The Brave Porch** does not appear in the iPhone Home Screen widget picker, first verify that Sideloadly says **Dropping 0 of 1 plug-ins**. The build's validation output is under the **Package unsigned IPA** step. A successful step confirms the unsigned extension is packaged correctly; it does not prove that Sideloadly signed the extension or that iOS registered it. If it remains missing, inspect the signed installation rather than repeatedly rebuilding the same source.

The initial IPA had `CFBundleVersion` and `CFBundleShortVersionString` only on the widget, not on its containing app. Version 1.0.1 (build 2) gives both bundles explicit matching values and the GitHub build now rejects mismatches. Whether that resolves the iPhone widget picker is still to be tested after rebuilding and installing. The initial build completed on GitHub; CarPlay appearance has not yet been tested.

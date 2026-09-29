import SwiftUI

@main
struct HalloweenCarWidgetApp: App {
    var body: some Scene {
        WindowGroup {
            HalloweenHomeView()
        }
    }
}

struct HalloweenHomeView: View {
    @State private var diagnostic = WidgetInstallDiagnostic.report()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Image("HauntedHouse")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .accessibilityLabel("Colin and Luan approach a glowing haunted house, surrounded by friendly Halloween characters. MikeGyver Studio.")

                Text("The Brave Porch")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.orange)
                Text("Colin and Luan have made it to the haunted house. One more step, one deep breath, and then: Trick or treat!")
                    .font(.title3)
                Text("A MikeGyver Studio Halloween countdown widget")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.75))

                VStack(alignment: .leading, spacing: 10) {
                    Text("Add it to CarPlay").font(.title2.bold())
                    Text("With your car parked and connected, open iPhone Settings → General → CarPlay → your car → Widgets → Add Widgets. Select The Brave Porch. The number of widget stacks depends on your car’s screen.")
                    Text("The small artwork widget also works on your iPhone Home Screen. CarPlay controls its size and placement; this app does not replace the car’s dashboard or speedometer.")
                        .foregroundStyle(.white.opacity(0.65))
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 20))

                VStack(alignment: .leading, spacing: 12) {
                    Text("Widget installation check").font(.title2.bold())
                    Text("If The Brave Porch is missing from the iPhone widget picker, tap Check again and share these results.")
                        .foregroundStyle(.white.opacity(0.75))
                    Text(diagnostic)
                        .font(.system(.footnote, design: .monospaced))
                        .textSelection(.enabled)
                    Button("Check again") {
                        diagnostic = WidgetInstallDiagnostic.report()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 20))
            }
            .padding(20)
        }
        .background(Color(red: 0.055, green: 0.035, blue: 0.13).ignoresSafeArea())
        .preferredColorScheme(.dark)
    }
}

private enum WidgetInstallDiagnostic {
    static func report() -> String {
        let app = Bundle.main
        let appID = app.bundleIdentifier ?? "missing"
        let pluginURL = app.bundleURL.appendingPathComponent("PlugIns/HalloweenHouseWidget.appex", isDirectory: true)
        let infoURL = pluginURL.appendingPathComponent("Info.plist")
        let info: [String: Any]? = (try? Data(contentsOf: infoURL)).flatMap { data in
            (try? PropertyListSerialization.propertyList(from: data, options: [], format: nil)) as? [String: Any]
        }
        let widgetID = info?["CFBundleIdentifier"] as? String ?? "missing"
        let extensionInfo = info?["NSExtension"] as? [String: Any]
        let point = extensionInfo?["NSExtensionPointIdentifier"] as? String ?? "missing"
        let executable = info?["CFBundleExecutable"] as? String ?? "missing"
        let present = FileManager.default.fileExists(atPath: pluginURL.path)
        let binaryPresent = FileManager.default.fileExists(atPath: pluginURL.appendingPathComponent(executable).path)
        let codeResources = FileManager.default.fileExists(atPath: pluginURL.appendingPathComponent("_CodeSignature/CodeResources").path)
        let profile = FileManager.default.fileExists(atPath: pluginURL.appendingPathComponent("embedded.mobileprovision").path)
        return """
        App: \(appID)
        App version: \(app.infoDictionary?["CFBundleShortVersionString"] as? String ?? "missing") (\(app.infoDictionary?["CFBundleVersion"] as? String ?? "missing"))
        Widget folder: \(present ? "present" : "MISSING")
        Widget executable: \(binaryPresent ? "present" : "MISSING")
        Widget ID: \(widgetID)
        ID prefix matches: \(widgetID.hasPrefix(appID + ".") ? "yes" : "NO")
        Extension point: \(point)
        Widget version: \(info?["CFBundleShortVersionString"] as? String ?? "missing") (\(info?["CFBundleVersion"] as? String ?? "missing"))
        Signature resources: \(codeResources ? "present" : "missing")
        Widget profile: \(profile ? "present" : "missing")
        """
    }
}

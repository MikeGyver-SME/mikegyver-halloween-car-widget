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
            }
            .padding(20)
        }
        .background(Color(red: 0.055, green: 0.035, blue: 0.13).ignoresSafeArea())
        .preferredColorScheme(.dark)
    }
}

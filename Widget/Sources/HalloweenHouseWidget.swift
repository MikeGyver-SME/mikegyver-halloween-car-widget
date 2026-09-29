import WidgetKit
import SwiftUI
import UIKit

struct HouseEntry: TimelineEntry {
    let date: Date
    let daysUntilHalloween: Int
}

struct HouseProvider: TimelineProvider {
    private var chicago: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "America/Chicago") ?? .current
        return calendar
    }

    private func entry(at date: Date) -> HouseEntry {
        let today = chicago.startOfDay(for: date)
        let year = chicago.component(.year, from: today)
        guard var halloween = chicago.date(from: DateComponents(year: year, month: 10, day: 31)) else {
            return HouseEntry(date: date, daysUntilHalloween: 0)
        }
        if today > halloween {
            halloween = chicago.date(from: DateComponents(year: year + 1, month: 10, day: 31)) ?? halloween
        }
        let days = chicago.dateComponents([.day], from: today, to: halloween).day ?? 0
        return HouseEntry(date: date, daysUntilHalloween: max(0, days))
    }

    func placeholder(in context: Context) -> HouseEntry { entry(at: Date()) }
    func getSnapshot(in context: Context, completion: @escaping (HouseEntry) -> Void) {
        completion(entry(at: Date()))
    }
    func getTimeline(in context: Context, completion: @escaping (Timeline<HouseEntry>) -> Void) {
        let now = Date()
        let tomorrow = chicago.date(byAdding: .day, value: 1, to: chicago.startOfDay(for: now)) ?? now.addingTimeInterval(86_400)
        completion(Timeline(entries: [entry(at: now)], policy: .after(tomorrow)))
    }
}

struct HouseWidgetView: View {
    let entry: HouseEntry

    var body: some View {
        ZStack(alignment: .top) {
            Color(red: 0.055, green: 0.035, blue: 0.13)
            if let house = UIImage(named: "HauntedHouse", in: Bundle.main, compatibleWith: nil) {
                Image(uiImage: house)
                    .resizable()
                    .scaledToFill()
                    .accessibilityLabel("MikeGyver Studio Halloween haunted house with Colin and Luan")
            }
            VStack(spacing: 0) {
                Text(entry.daysUntilHalloween == 0 ? "TONIGHT!" : "\(entry.daysUntilHalloween) DAYS")
                    .font(.system(size: 23, weight: .black, design: .rounded))
                    .minimumScaleFactor(0.65)
                    .lineLimit(1)
                Text("UNTIL HALLOWEEN")
                    .font(.system(size: 9, weight: .bold, design: .rounded))
                    .tracking(0.6)
                    .lineLimit(1)
            }
            .foregroundStyle(.white)
            .shadow(color: .black, radius: 3)
            .padding(.horizontal, 7)
            .padding(.vertical, 6)
            .frame(maxWidth: .infinity)
            .background(LinearGradient(colors: [.black.opacity(0.85), .clear], startPoint: .top, endPoint: .bottom))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
        .containerBackground(for: .widget) { Color(red: 0.055, green: 0.035, blue: 0.13) }
    }
}

struct HalloweenHouseWidget: Widget {
    let kind = "MikeGyverHalloweenHouse"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HouseProvider()) { entry in
            HouseWidgetView(entry: entry)
        }
        .configurationDisplayName("The Brave Porch")
        .description("Countdown to Halloween with Colin and Luan at the MikeGyver Studio haunted house.")
        .supportedFamilies([.systemSmall])
    }
}

@main
struct HalloweenWidgetBundle: WidgetBundle {
    var body: some Widget {
        HalloweenHouseWidget()
    }
}

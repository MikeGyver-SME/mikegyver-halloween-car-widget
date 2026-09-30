import WidgetKit
import SwiftUI
import UIKit

struct HouseEntry: TimelineEntry {
    let date: Date
    let daysUntilHalloween: Int
    /// Which provider method produced this entry: "P" placeholder, "S" snapshot, "T" timeline.
    let source: String
}

struct HouseProvider: TimelineProvider {
    private var chicago: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "America/Chicago") ?? .current
        return calendar
    }

    private func entry(at date: Date, source: String) -> HouseEntry {
        let today = chicago.startOfDay(for: date)
        let year = chicago.component(.year, from: today)
        guard var halloween = chicago.date(from: DateComponents(year: year, month: 10, day: 31)) else {
            return HouseEntry(date: date, daysUntilHalloween: 0, source: source)
        }
        if today > halloween {
            halloween = chicago.date(from: DateComponents(year: year + 1, month: 10, day: 31)) ?? halloween
        }
        let days = chicago.dateComponents([.day], from: today, to: halloween).day ?? 0
        return HouseEntry(date: date, daysUntilHalloween: max(0, days), source: source)
    }

    func placeholder(in context: Context) -> HouseEntry { entry(at: Date(), source: "P") }
    func getSnapshot(in context: Context, completion: @escaping (HouseEntry) -> Void) {
        completion(entry(at: Date(), source: "S"))
    }
    func getTimeline(in context: Context, completion: @escaping (Timeline<HouseEntry>) -> Void) {
        let now = Date()
        let tomorrow = chicago.date(byAdding: .day, value: 1, to: chicago.startOfDay(for: now)) ?? now.addingTimeInterval(86_400)
        completion(Timeline(entries: [entry(at: now, source: "T")], policy: .after(tomorrow)))
    }
}

/// Build 7 diagnostic view: text only, no artwork. The big SRC letter names the
/// provider method that produced the visible entry, so the Home Screen itself
/// tells us whether the timeline is being delivered ("T") or only the
/// placeholder ("P") ever shows up.
struct HouseWidgetView: View {
    let entry: HouseEntry

    private var stamped: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "America/Chicago")
        return formatter.string(from: entry.date)
    }

    var body: some View {
        VStack(spacing: 4) {
            Text("SRC: \(entry.source)")
                .font(.system(size: 34, weight: .black, design: .rounded))
            Text(entry.daysUntilHalloween == 0 ? "TONIGHT!" : "\(entry.daysUntilHalloween) DAYS")
                .font(.system(size: 20, weight: .bold, design: .rounded))
            Text(stamped)
                .font(.system(size: 11, design: .monospaced))
            Text("build 7 diag")
                .font(.system(size: 11, design: .rounded))
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
        .contentMarginsDisabled()
    }
}

@main
struct HalloweenWidgetBundle: WidgetBundle {
    var body: some Widget {
        HalloweenHouseWidget()
    }
}

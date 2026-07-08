import WidgetKit
import SwiftUI

// MARK: - Models

struct RaceSession: Identifiable {
    var id: String { name }
    let name: String
    let dateStr: String // e.g. "Jul 3, Fri"
    let timeStr: String // e.g. "17:00"
}

struct RaceEvent {
    let name: String
    let location: String
    let countryCode: String
    let round: Int
    let sessions: [RaceSession]
}

struct DriverStanding {
    let position: Int
    let name: String
    let number: Int
    let team: String
    let points: Int
}

struct ConstructorStanding {
    let position: Int
    let name: String
    let points: Int
    let baseLocation: String
}

struct MotoGPData {
    static let mockEvent = RaceEvent(
        name: "BRITISH",
        location: "Silverstone",
        countryCode: "GB",
        round: 11,
        sessions: [
            RaceSession(name: "Practice 1", dateStr: "Jul 3, Fri", timeStr: "17:00"),
            RaceSession(name: "Sprint Q", dateStr: "Jul 3, Fri", timeStr: "21:00"),
            RaceSession(name: "Sprint", dateStr: "Jul 4, Sat", timeStr: "16:30"),
            RaceSession(name: "Qualifying", dateStr: "Jul 4, Sat", timeStr: "20:30"),
            RaceSession(name: "Grand Prix", dateStr: "Jul 5, Sun", timeStr: "19:30")
        ]
    )
    
    static let mockDrivers = [
        DriverStanding(position: 1, name: "Pecco Bagnaia", number: 1, team: "Ducati Lenovo", points: 250),
        DriverStanding(position: 2, name: "Jorge Martin", number: 89, team: "Prima Pramac", points: 240),
        DriverStanding(position: 3, name: "Marco Bezzecchi", number: 72, team: "VR46 Racing", points: 190)
    ]
    
    static let mockConstructors = [
        ConstructorStanding(position: 1, name: "Ducati", points: 400, baseLocation: "Bologna, Italy"),
        ConstructorStanding(position: 2, name: "KTM", points: 250, baseLocation: "Mattighofen, Austria"),
        ConstructorStanding(position: 3, name: "Aprilia", points: 210, baseLocation: "Noale, Italy")
    ]
}

// MARK: - Providers

struct CalendarEntry: TimelineEntry {
    let date: Date
    let event: RaceEvent
}

struct CalendarProvider: TimelineProvider {
    func placeholder(in context: Context) -> CalendarEntry {
        CalendarEntry(date: Date(), event: MotoGPData.mockEvent)
    }

    func getSnapshot(in context: Context, completion: @escaping (CalendarEntry) -> ()) {
        completion(CalendarEntry(date: Date(), event: MotoGPData.mockEvent))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<CalendarEntry>) -> ()) {
        let entry = CalendarEntry(date: Date(), event: MotoGPData.mockEvent)
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

// MARK: - Shared Views

struct RedBar: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(Color(red: 0.9, green: 0.1, blue: 0.1))
            .frame(width: 3)
    }
}

struct FlagView: View {
    let countryCode: String
    var body: some View {
        Text("🇬🇧")
            .font(.system(size: 14))
    }
}

struct SessionRow: View {
    let session: RaceSession
    var showDate: Bool = true
    
    var body: some View {
        HStack(alignment: .top, spacing: 6) {
            RedBar()
                .padding(.top, 2)
                .padding(.bottom, showDate ? 14 : 2)
            
            VStack(alignment: .leading, spacing: 2) {
                HStack(alignment: .top) {
                    Text(session.name)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                    Text(session.timeStr)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.white)
                }
                if showDate {
                    Text(session.dateStr)
                        .font(.system(size: 9))
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

struct CountdownBadge: View {
    let hours: Int
    var body: some View {
        Text("\(hours) HOURS")
            .font(.system(size: 9, weight: .bold))
            .foregroundColor(Color(red: 1.0, green: 0.2, blue: 0.2))
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(Color(red: 0.3, green: 0.05, blue: 0.05))
            .cornerRadius(4)
    }
}

// MARK: - Calendar Widget Views

struct CalendarWidgetEntryView : View {
    var entry: CalendarProvider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        Group {
            switch family {
            case .systemSmall:
                SmallCalendarView(event: entry.event)
            case .systemMedium:
                MediumCalendarView(event: entry.event)
            case .systemLarge:
                LargeCalendarView(event: entry.event)
            default:
                Text("Unsupported")
            }
        }
    }
}

struct SmallCalendarView: View {
    let event: RaceEvent
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(alignment: .top) {
                Text(event.name.uppercased())
                    .font(.system(size: 13, weight: .heavy))
                    .foregroundColor(.white)
                Spacer()
                FlagView(countryCode: event.countryCode)
            }
            Text(event.location)
                .font(.system(size: 10))
                .foregroundColor(.gray)
            
            Spacer()
            
            HStack {
                Spacer()
                Image(systemName: "point.topleft.down.curvedto.point.bottomright.up")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(height: 40)
                    .padding(.bottom, 8)
                Spacer()
            }
            
            Spacer()
            
            if let firstSession = event.sessions.first {
                SessionRow(session: firstSession, showDate: true)
            }
        }
    }
}

struct MediumCalendarView: View {
    let event: RaceEvent
    var body: some View {
        HStack(spacing: 12) {
            // Left side
            VStack(alignment: .leading, spacing: 2) {
                HStack(alignment: .top) {
                    Text(event.name.uppercased())
                        .font(.system(size: 14, weight: .heavy))
                        .foregroundColor(.white)
                    Spacer()
                    FlagView(countryCode: event.countryCode)
                }
                Text(event.location)
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
                
                Spacer()
                
                HStack {
                    Spacer()
                    Image(systemName: "point.topleft.down.curvedto.point.bottomright.up")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(height: 45)
                    Spacer()
                }
                
                Spacer()
                
                HStack {
                    Text("R\(event.round)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                    CountdownBadge(hours: 52)
                }
            }
            .frame(maxWidth: .infinity)
            
            Divider()
                .background(Color.gray.opacity(0.3))
                .padding(.vertical, 4)
            
            // Right side
            VStack(spacing: 8) {
                ForEach(event.sessions.prefix(3)) { session in
                    SessionRow(session: session)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct LargeCalendarView: View {
    let event: RaceEvent
    var body: some View {
        VStack(spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("British GP")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    Text("Round \(event.round)")
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                }
                Spacer()
                FlagView(countryCode: event.countryCode)
            }
            
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 70)
                    .overlay(Text("Map Satellite").font(.system(size: 10)).foregroundColor(.gray))
                
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.black.opacity(0.4))
                    .frame(height: 70)
                    .overlay(
                        Image(systemName: "point.topleft.down.curvedto.point.bottomright.up")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(height: 40)
                    )
            }
            
            HStack {
                Text(event.location)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white)
                Image(systemName: "cloud.sun.fill")
                    .foregroundColor(.yellow)
                    .font(.system(size: 10))
                Text("12°C")
                    .font(.system(size: 12))
                    .foregroundColor(.white)
                Spacer()
            }
            
            VStack(spacing: 6) {
                ForEach(event.sessions) { session in
                    SessionRow(session: session)
                }
            }
        }
    }
}

struct CalendarWidget: Widget {
    let kind: String = "CalendarWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CalendarProvider()) { entry in
            if #available(macOS 14.0, *) {
                CalendarWidgetEntryView(entry: entry)
                    .containerBackground(Color(red: 0.1, green: 0.1, blue: 0.12), for: .widget)
            } else {
                CalendarWidgetEntryView(entry: entry)
                    .background(Color(red: 0.1, green: 0.1, blue: 0.12))
            }
        }
        .configurationDisplayName("MotoGP Calendar")
        .description("Track all upcoming races and results.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

// MARK: - Driver Widget Views

struct DriverWidgetEntryView : View {
    var entry: CalendarProvider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("Driver Standings")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: "flag.checkered")
                    .foregroundColor(Color(red: 0.9, green: 0.1, blue: 0.1))
                    .font(.system(size: 12))
            }
            .padding(.bottom, 4)
            
            ForEach(MotoGPData.mockDrivers, id: \.position) { driver in
                HStack(alignment: .center) {
                    Text("\(driver.position)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.gray)
                        .frame(width: 16, alignment: .leading)
                    VStack(alignment: .leading, spacing: 1) {
                        Text(driver.name)
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.white)
                        Text(driver.team)
                            .font(.system(size: 9))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Text("\(driver.points)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color(red: 0.9, green: 0.1, blue: 0.1))
                }
                .padding(.vertical, 2)
            }
            Spacer()
        }
    }
}

struct DriverWidget: Widget {
    let kind: String = "DriverWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CalendarProvider()) { entry in
            if #available(macOS 14.0, *) {
                DriverWidgetEntryView(entry: entry)
                    .containerBackground(Color(red: 0.1, green: 0.1, blue: 0.12), for: .widget)
            } else {
                DriverWidgetEntryView(entry: entry)
                    .background(Color(red: 0.1, green: 0.1, blue: 0.12))
            }
        }
        .configurationDisplayName("MotoGP Drivers")
        .description("Track driver standings.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

// MARK: - Constructor Widget Views

struct ConstructorWidgetEntryView : View {
    var entry: CalendarProvider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("Constructors")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: "wrench.and.screwdriver.fill")
                    .foregroundColor(Color(red: 0.9, green: 0.1, blue: 0.1))
                    .font(.system(size: 12))
            }
            .padding(.bottom, 4)
            
            ForEach(MotoGPData.mockConstructors, id: \.position) { constructor in
                HStack(alignment: .center) {
                    Text("\(constructor.position)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.gray)
                        .frame(width: 16, alignment: .leading)
                    VStack(alignment: .leading, spacing: 1) {
                        Text(constructor.name)
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.white)
                        Text(constructor.baseLocation)
                            .font(.system(size: 9))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Text("\(constructor.points)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color(red: 0.9, green: 0.1, blue: 0.1))
                }
                .padding(.vertical, 2)
            }
            Spacer()
        }
    }
}

struct ConstructorWidget: Widget {
    let kind: String = "ConstructorWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CalendarProvider()) { entry in
            if #available(macOS 14.0, *) {
                ConstructorWidgetEntryView(entry: entry)
                    .containerBackground(Color(red: 0.1, green: 0.1, blue: 0.12), for: .widget)
            } else {
                ConstructorWidgetEntryView(entry: entry)
                    .background(Color(red: 0.1, green: 0.1, blue: 0.12))
            }
        }
        .configurationDisplayName("MotoGP Constructors")
        .description("Track constructor standings.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

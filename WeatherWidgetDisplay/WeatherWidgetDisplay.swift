//
//  WeatherWidgetDisplay.swift
//  WeatherWidgetDisplay
//
//  Created by Daud Sandy Christianto on 12/01/24.
//

import WidgetKit
import SwiftUI
import Intents

struct WeatherEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let weather: WeatherResponse
    var image: UIImage?
    var backgroundPhoto: UIImage?
}

struct WeatherWidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    
    var entry: WeatherProvider.Entry
    
    init (entry: WeatherEntry) {
        self.entry = entry
    }
    
    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(weatherConfig: entry.weather, weatherImage: entry.image, backgroundPhoto: entry.backgroundPhoto)
        case .systemMedium:
            MediumWidgetView(weatherConfig: entry.weather, weatherImage: entry.image, backgroundPhoto: entry.backgroundPhoto)
        case .systemLarge:
            LargeWidgetView(weatherConfig: entry.weather, weatherImage: entry.image, backgroundPhoto: entry.backgroundPhoto)
        default:
            SmallWidgetView(weatherConfig: entry.weather, weatherImage: entry.image, backgroundPhoto: entry.backgroundPhoto)
        }
    }
}

@main
struct WeatherWidget: Widget {
    let kind: String = "WeatherWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: WeatherProvider()) { entry in
            WeatherWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("New Weather Widget")
        .description("Choose your weather widget")
    }
}

struct WeatherWidget_Previews: PreviewProvider {
    static var previews: some View {
        WeatherWidgetEntryView(entry: WeatherEntry(
            date: Date(),
            configuration: ConfigurationIntent(),
            weather: WeatherResponse.exampleData()
        ))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}

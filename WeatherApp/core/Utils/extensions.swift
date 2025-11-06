//
//  extensions.swift
//  WeatherApp
//
//  Created by Augustus Onyekachi on 06/11/2025.
//

import Foundation

//extension ForecastResponse {
//    /// Returns 7 daily summaries (today + next 6 days). If the API gave < 40 items we still fill what we have.
//    var dailySummaries: [DailySummary] {
//        // 1. Group 3-hour items by calendar day
//        var dayDict: [Date: [ForecastItem]] = [:]
//        let calendar = Calendar.current
//        for item in list {
//            let dt = Date(timeIntervalSince1970: TimeInterval(item.dt))
//            let day = calendar.startOfDay(for: dt)
//            dayDict[day, default: []].append(item)
//        }
//
//        // 2. Sort days
//        let sortedDays = dayDict.keys.sorted()
//
//        // 3. Build exactly 7 entries (fill missing with placeholders)
//        var result: [DailySummary] = []
//        for i in 0..<7 {
//            guard i < sortedDays.count else {
//                // future day without data – placeholder
//                result.append(DailySummary(
//                    date: calendar.date(byAdding: .day, value: i, to: sortedDays.first ?? Date())!,
//                    high: 0, low: 0, description: "–", icon: "01d", pop: 0))
//                continue
//            }
//
//            let day = sortedDays[i]
//            let items = dayDict[day]!
//
//            // temps
//            let temps = items.map { $0.main.temp }
//            let high = temps.max()!
//            let low  = temps.min()!
//
//            // dominant weather
//            let weatherCounts = Dictionary(grouping: items.flatMap { $0.weather }, by: { $0.id })
//            let dominant = weatherCounts.max(by: { $0.value.count < $1.value.count })?.value.first!
//
//            // max precipitation probability
//            let pop = items.map { $0.pop }.max()!
//
//            result.append(DailySummary(
//                date: day,
//                high: high,
//                low: low,
//                description: dominant?.description.capitalized ?? "–",
//                icon: dominant?.icon ?? "01d",
//                pop: pop))
//        }
//        return result
//    }
//}


extension ForecastResponse {
    var dailySummaries: [DailySummary] {
        let calendar = Calendar.current
        var dayGroups: [Date: [ForecastItem]] = [:]
        
        // Group by calendar day (start of day)
        for item in list {
            let date = Date(timeIntervalSince1970: TimeInterval(item.dt))
            let dayStart = calendar.startOfDay(for: date)
            dayGroups[dayStart, default: []].append(item)
        }
        
        // Sort days
        let sortedDays = dayGroups.keys.sorted()
        
        // Generate up to 7 days
        return (0..<7).map { index in
            guard index < sortedDays.count else {
                // Future day with no data
                let futureDate = calendar.date(byAdding: .day, value: index, to: sortedDays.first ?? Date())!
                return DailySummary(
                    date: futureDate,
                    high: 0,
                    low: 0,
                    description: "–",
                    icon: "01d",
                    pop: 0
                )
            }
            
            let day = sortedDays[index]
            let items = dayGroups[day]!
            
            // Safely extract temps
            let temps = items.compactMap { $0.main.temp }
            guard !temps.isEmpty else {
                return DailySummary(date: day, high: 0, low: 0, description: "–", icon: "01d", pop: 0)
            }
            
            let high = temps.max()!
            let low = temps.min()!
            
            // Dominant weather
            let allWeather = items.flatMap { $0.weather }
            let weatherCounts = Dictionary(grouping: allWeather, by: { $0.id })
            let dominant = weatherCounts.max(by: { $0.value.count < $1.value.count })?.value.first
            
            // Max precipitation probability
            let maxPop = items.compactMap { $0.pop }.max() ?? 0
            
            return DailySummary(
                date: day,
                high: high,
                low: low,
                description: (dominant?.description ?? "unknown").capitalized,
                icon: dominant?.icon ?? "01d",
                pop: maxPop
            )
        }
    }
}

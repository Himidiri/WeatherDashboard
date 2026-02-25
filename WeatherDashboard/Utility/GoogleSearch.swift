//
//  GoogleSearch.swift
//  WeatherDashboard
//
//  Created by Himidiri Himakanika on 2026-02-26.
//

import Foundation

enum GoogleSearch {
    static func url(for query: String) -> URL? {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        
        var comps = URLComponents(string: "https://www.google.com/search")
        comps?.queryItems = [
            URLQueryItem(name: "q", value: trimmed)
        ]
        return comps?.url
    }
}

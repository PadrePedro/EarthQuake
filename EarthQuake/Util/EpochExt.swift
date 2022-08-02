//
//  IntExt.swift
//  EarthQuake
//
//  Created by Peter Liaw on 7/29/22.
//

import Foundation

/// Epoch is the number of milliseconds since 1970
typealias Epoch = Int

extension Epoch {
    
    /// Returns current time
    static func now() -> Epoch {
        return Epoch(Date().timeIntervalSince1970*1000)
    }
        
    /// Returns time in ISO8601 string format
    func iso8601() -> String {
        let iso8601DateFormatter = ISO8601DateFormatter()
        iso8601DateFormatter.formatOptions = [.withInternetDateTime]
        let string = iso8601DateFormatter.string(from: Date(timeIntervalSince1970: Double(self)/1000.0))
        return string
    }

    /// Returns time with offset in days
    func delta(days: Int) -> Epoch {
        let msSecondsInADay = 60 * 60 * 24 * 1000
        return self + (days * msSecondsInADay)
    }
    
    /// Returns time with offset in hours
    func delta(hours: Int) -> Epoch {
        let msSecondInHour = 60 * 60 * 1000
        return self + (hours * msSecondInHour)
    }
    
    /// Returns time of `days` ago
    func daysAgo(days: Int) -> Epoch {
        let msSecondsInADay = 60 * 60 * 24 * 1000
        return self - (days * msSecondsInADay)
    }
}

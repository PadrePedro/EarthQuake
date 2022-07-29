//
//  IntExt.swift
//  EarthQuake
//
//  Created by Peter Liaw on 7/29/22.
//

import Foundation

/// Number of seconds since 1970
typealias Epoch = Int

extension Epoch {
    
    static func now() -> Epoch {
        return Epoch(Date().timeIntervalSince1970)
    }
        
    func iso8601() -> String {
        let iso8601DateFormatter = ISO8601DateFormatter()
        iso8601DateFormatter.formatOptions = [.withInternetDateTime]
        let string = iso8601DateFormatter.string(from: Date(timeIntervalSince1970: Double(self)))
        return string
    }
    
    func daysAgo(days: Int) -> Epoch {
        let secondsInADay = 60 * 60 * 24
        return self - (days * secondsInADay)
    }
}

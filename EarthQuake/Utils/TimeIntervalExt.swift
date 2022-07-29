//
//  TimeIntervalExt.swift
//  EarthQuake
//
//  Created by Peter Liaw on 7/29/22.
//

import Foundation

extension TimeInterval {
    
    func toEpoch() -> Epoch {
        return Epoch(self)
    }
}

//
//  EarthQuakeData.swift
//  EarthQuake
//
//  Created by Peter Liaw on 7/29/22.
//

import Foundation

/// Top-level json returned by https://earthquake.usgs.gov/fdsnws/event/1/
struct EarthQuakeData: Decodable {
    let type: String
    let metadata: MetaData
    let features: [Feature]
}

struct MetaData: Decodable {
    
}

struct Feature: Decodable {
    let type: String
    let properties: Properties
    
}

struct Properties: Decodable {
    let mag: Float
    let place: String?
    let time: Int
    let updated: Int
    let tz: String?
    let url: String
    let title: String
    let detail: String
}

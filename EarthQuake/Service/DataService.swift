//
//  DataService.swift
//  EarthQuake
//
//  Created by Peter Liaw on 7/29/22.
//

import Foundation

typealias DataServiceResult = (Result<EarthQuakeData,Error>)->Void

/// The `DataService` class is responsible for retrieving data from the earthquake REST API.
/// The resulting data is provided in `DataServiceResult`.
/// This class not does hold onto any data.
class DataService {
    
    /// global shared instance
    static let shared = DataService()
    
    lazy var configuration = URLSessionConfiguration.default
    lazy var session = URLSession(configuration: configuration)
    
    // prevent direct instantiation
    private init() {}

    /// Gets earthquake data for the given time parameters
    func getData(startTime: Epoch, endTime: Epoch, completion: @escaping DataServiceResult) {
        let url = makeUrl(startTime: startTime, endTime: endTime)
        print("getData: \(url.absoluteString)")
        session.dataTask(with: url) { data, resp, error in
            // ensure response is HTTPURLResponse
            guard let resp = resp as? HTTPURLResponse else {
                if let error = error {
                    completion(.failure(error))
                }
                else {
                    completion(.failure(NSError(domain: "Unexpected error", code: 0)))
                }
                return
            }
            // check that response code is HTTP 200
            if resp.statusCode != 200 {
                completion(.failure(NSError(domain: "Unexpected HTTP error code", code: resp.statusCode)))
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0)))
                return
            }
            do {
                let result = try JSONDecoder().decode(EarthQuakeData.self, from: data)
                print ("retrieved \(result.features.count) records")
                completion(.success(result))
            }
            catch {
                // json decoding failed for some reason
                print(error)
                completion(.failure(error))
            }
        }.resume()
    }
    
    /// Returns URL with given time filters
    private func makeUrl(startTime: Epoch, endTime: Epoch) -> URL {
        // for now, requesting just 3.0 or higher magnitude quakes 
        let url = "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=\(startTime.iso8601())&endtime=\(endTime.iso8601())&minmagnitude=3.0"
        return URL(string: url)!
    }
    
    
}

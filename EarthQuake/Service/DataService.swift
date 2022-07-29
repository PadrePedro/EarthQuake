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

    /// 
    func getData(startTime: Epoch, endTime: Epoch, completion: @escaping DataServiceResult) {
        let url = makeUrl(startTime: startTime, endTime: endTime)
        session.dataTask(with: url) { data, resp, error in
            print("complete")
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(EarthQuakeData.self, from: data)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    private func makeUrl(startTime: Int, endTime: Int) -> URL {
        let url = "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=2014-01-01&endtime=2014-01-02"
        return URL(string: url)!
    }
}

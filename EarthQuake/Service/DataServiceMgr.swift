//
//  DataServiceMgr.swift
//  EarthQuake
//
//  Created by Peter Liaw on 7/29/22.
//

import Foundation

typealias DataServiceMgrResult = (Result<[Feature],Error>)->Void

/// Manager class to tracks the earthquake events records queried.
/// To keep return data sizes manageable and UI more responsive, queries are limited to 24 hours per request.
class DataServiceMgr {
    
    static let shared = DataServiceMgr()
    
    /// eartquake records
    private var features = [Feature]()

    /// Retrieve initial data set when app is launched.
    func getInitialData(completion: @escaping DataServiceMgrResult) {
        let now = Epoch.now()
        DataService.shared.getData(startTime: now.delta(days: -1), endTime: now) { result in
            switch result {
            case .success(let data):
                self.features = data.features
                completion(.success(self.features))
            case .failure(let error):
                print("mgr: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    /// Retrieve older dataset. This can be used to retrieve more data when user has scrolled to the end of the current list.
    func getOlderData(completion: @escaping DataServiceMgrResult) {
        let endTime: Epoch = {
            if let oldest = features.last {
                return oldest.properties.time - 1
            }
            return Epoch.now()
        }()
        let startTime = endTime.delta(days: -1)
        
        DataService.shared.getData(startTime: startTime, endTime: endTime) { result in
            switch result {
            case .success(let data):
                self.features += data.features
                completion(.success(self.features))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Retrieve newer dataset. This can be used to retrieve recently added data after app has already been launched.
    func getNewerData(completion: @escaping DataServiceMgrResult) {
        guard let mostRecentTime = features.first?.properties.time else {
            // no data currently exists, so just call getInitialData
            getInitialData(completion: completion)
            return
        }
        let endTime = Epoch.now()
        DataService.shared.getData(startTime: mostRecentTime + 1, endTime: endTime) { result in
            switch result {
            case .success(let data):
                self.features = data.features + self.features
                completion(.success(self.features))
            case .failure(let error):
                completion(.failure(error))
            }
        }        
    }
}

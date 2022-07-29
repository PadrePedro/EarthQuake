//
//  DataServiceMgr.swift
//  EarthQuake
//
//  Created by Peter Liaw on 7/29/22.
//

import Foundation

typealias DataServiceMgrResult = (Result<[Feature],Error>)->Void

class DataServiceMgr {
    
    static let shared = DataServiceMgr()
    
    var features = [Feature]()
    
    func getInitialData(completion: @escaping DataServiceMgrResult) {
        let now = Epoch.now()
        DataService.shared.getData(startTime: now.daysAgo(days: 1), endTime: now) { result in
            switch result {
            case .success(let data):
                self.features = data.features
                completion(.success(self.features))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getOlderData(completion: @escaping DataServiceMgrResult) {
        let endTime: Epoch = {
            if let oldest = features.first {
                return oldest.properties.time - 1
            }
            return Epoch.now()
        }()
        let startTime = endTime.daysAgo(days: 1)
        
        DataService.shared.getData(startTime: startTime, endTime: endTime) { result in
            switch result {
            case .success(let data):
                self.features = data.features
                completion(.success(self.features))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getNewerData(completion: DataServiceMgrResult) {
        
    }
}

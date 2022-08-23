//
//  EarthQuakeViewModel.swift
//  EarthQuake
//
//  Created by Peter Liaw on 8/4/22.
//

import Foundation

/// View Model
class EarthQuakeViewModel {

    /// earthquake data
    var features: LiveData<[Feature]> = LiveData([Feature]())
    /// error message from failed REST call
    var errorMessage: LiveData<String?> = LiveData(nil)
    
    /// Returns initial dataset upon app launch.  Currently returning data up to one day ago
    func getInitialData() {
        let now = Epoch.now()
        DataService.shared.getData(startTime: now.delta(days: -1), endTime: now) { [weak self] result in
            switch result {
            case .success(let resp):
                self?.features.value = resp.features
            case .failure(let error):
                self?.errorMessage.value = error.localizedDescription
            }
        }
    }
    
    /// Retrieves up to another day of data, based on oldest record currently in buffer.
    func getOlderData() {
        let endTime: Epoch = {
            if let oldest = features.value.last {
                return oldest.properties.time - 1
            }
            return Epoch.now()
        }()
        let startTime = endTime.delta(days: -1)
        DataService.shared.getData(startTime: startTime, endTime: endTime) { [weak self] result in
            switch result {
            case .success(let resp):
                self?.features.value += resp.features
            case .failure(let error):
                self?.errorMessage.value = error.localizedDescription
            }
        }
    }
    
    /// Retrieve newer records available, if any.
    func getNewerData() {
        guard let mostRecentTime = features.value.first?.properties.time else {
            // no data currently exists, so just call getInitialData
            getInitialData()
            return
        }
        let endTime = Epoch.now()
        DataService.shared.getData(startTime: mostRecentTime + 1000, endTime: endTime) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.features.value = data.features + self.features.value
            case .failure(let error):
                self.errorMessage.value = error.localizedDescription
            }
        }

    }
    
    func getDateString(date: Date) -> String? {
        let df: DateFormatter = {
            let df = DateFormatter()
            df.dateStyle = .medium
            df.timeStyle = .medium
            return df
        }()
        return df.string(for: date)
    }
}

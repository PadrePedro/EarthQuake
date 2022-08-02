//
//  ViewController.swift
//  EarthQuake
//
//  Created by Peter Liaw on 7/29/22.
//

import UIKit
import SafariServices

/// App view controller
class ViewController: UIViewController {

    let tableView = UITableView()
    let refreshControl = UIRefreshControl()
    var eqData = [Feature]()
    let df: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .medium
        return df
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        refreshControl.beginRefreshing()
        DataServiceMgr.shared.getInitialData { result in
            self.handleResult(result: result)
        }
    }
    
    func setupView() {
        navigationItem.title = "Earth Quake!!"
        view = tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "EventCell", bundle: nil), forCellReuseIdentifier: EventCell.reuseId)
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
    }
    
    @objc func pullToRefresh() {
        print("pulling to refresh")
        DataServiceMgr.shared.getNewerData { result in
            self.handleResult(result: result)
        }
    }
    
    func handleResult(result: Result<[Feature],Error>) {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            switch result {
            case .success(let resp):
                self.eqData = resp
                self.tableView.reloadData()
            case .failure(let error):
                print("handle: \(error)")
                let alert = UIAlertController(title: "Failed to retrieve data", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    alert.dismiss(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }

    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eqData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventCell.reuseId, for: indexPath) as! EventCell
        let date = Date(timeIntervalSince1970: Double(eqData[indexPath.row].properties.time)/1000.0)
        cell.timeLabel.text = df.string(for: date)
        cell.locationLabel.text = eqData[indexPath.row].properties.title
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: eqData[indexPath.row].properties.url) {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == eqData.count {
            // user scrolled to last row, so get more data
            self.refreshControl.beginRefreshing()
            DataServiceMgr.shared.getOlderData { result in
                self.handleResult(result: result)
            }
        }
    }
    

}


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
    var viewModel = EarthQuakeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        viewModel.features.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
                self?.tableView.reloadData()
            }
        }
        viewModel.errorMessage.bind { [weak self] error in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
                self?.showErrorMessage(error)
            }
        }
        viewModel.getInitialData()
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
        viewModel.getNewerData()
    }
    
    func showErrorMessage(_ mesg: String?) {
        let ac = UIAlertController(title: "Error", message: mesg, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            ac.dismiss(animated: true)
        }))
        present(ac, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.features.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventCell.reuseId, for: indexPath) as! EventCell
        let date = Date(timeIntervalSince1970: Double(viewModel.features.value[indexPath.row].properties.time)/1000.0)
        cell.timeLabel.text = viewModel.getDateString(date: date)
        cell.locationLabel.text = viewModel.features.value[indexPath.row].properties.title
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: viewModel.features.value[indexPath.row].properties.url) {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == viewModel.features.value.count {
            // user scrolled to last row, so get more data
            self.refreshControl.beginRefreshing()
            viewModel.getOlderData()
        }
    }
    
}


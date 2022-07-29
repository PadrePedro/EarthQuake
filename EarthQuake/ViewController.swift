//
//  ViewController.swift
//  EarthQuake
//
//  Created by Peter Liaw on 7/29/22.
//

import UIKit

class ViewController: UIViewController {

    let tableView = UITableView()
    var eqData = [Feature]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        DataService.shared.getData(startTime: 0, endTime: 0) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.eqData = data.features
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func setupView() {
        view = tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eqData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = eqData[indexPath.row].properties.place
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}


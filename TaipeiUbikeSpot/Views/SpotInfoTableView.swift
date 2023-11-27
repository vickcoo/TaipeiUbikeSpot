//
//  SpotInfoTableView.swift
//  TaipeiUbikeSpot
//
//  Created by Vickcoo on 2023/11/24.
//

import UIKit

class SpotInfoTableView: UIView {
    var tableView: UITableView!
    var activityIndicatorView: UIActivityIndicatorView!
    var refreshControl: UIRefreshControl!
    
    var searchTerm: String?
    var spots: [UbikeSpot] = []
    var filteredSpots: [UbikeSpot] {
        if let searchTerm = searchTerm {
            return spots.filter({
                $0.sarea == searchTerm
            })
        } else {
            return spots
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeUserInterface()
    }
}

extension SpotInfoTableView {
    func initializeUserInterface() {
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.borderGray.cgColor
        self.clipsToBounds = true
                                    
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(SpotTableViewCell.self, forCellReuseIdentifier: "\(SpotTableViewCell.self)")
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableView)
        
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = .primaryGreen
        
        let countryLabel = UILabel()
        countryLabel.translatesAutoresizingMaskIntoConstraints = false
        countryLabel.text = String(localized: "縣市")
        countryLabel.textAlignment = .center
        countryLabel.textColor = .white
        countryLabel.font = .systemFont(ofSize: 18, weight: .medium)
        
        let areaLabel = UILabel()
        areaLabel.translatesAutoresizingMaskIntoConstraints = false
        areaLabel.text = String(localized: "區域")
        areaLabel.textAlignment = .center
        areaLabel.textColor = .white
        areaLabel.font = .systemFont(ofSize: 18, weight: .medium)
        
        let spotLabel = UILabel()
        spotLabel.translatesAutoresizingMaskIntoConstraints = false
        spotLabel.text = String(localized: "站點")
        spotLabel.textAlignment = .center
        spotLabel.textColor = .white
        spotLabel.font = .systemFont(ofSize: 18, weight: .medium)
        
        self.addSubview(headerView)
        headerView.addSubview(countryLabel)
        headerView.addSubview(areaLabel)
        headerView.addSubview(spotLabel)
        
        activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        tableView.addSubview(activityIndicatorView)
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        tableView.addSubview(refreshControl)

        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 66),

            countryLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            countryLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            countryLabel.widthAnchor.constraint(equalToConstant: 60),
            
            areaLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            areaLabel.leadingAnchor.constraint(equalTo: countryLabel.trailingAnchor, constant: 15),
            areaLabel.widthAnchor.constraint(equalToConstant: 60),
            
            spotLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            spotLabel.leadingAnchor.constraint(equalTo: areaLabel.trailingAnchor, constant: 15),
            spotLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            activityIndicatorView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
        ])
    }
    
    @objc private func fetchData() {
        loadData { [weak self] _ in
            self?.refreshControl.endRefreshing()
        }
    }
    
    func loadData(completion: @escaping ([UbikeSpot]) -> ()) {
        activityIndicatorView.startAnimating()
        DataManager.shared.fetchData(urlString: ApiUrl.taipeiUbikeSpot.rawValue) { [weak self] result in
            switch result {
            case .success(let spots):
                DispatchQueue.main.async {
                    self?.activityIndicatorView.stopAnimating()
                    self?.spots = spots
                    self?.tableView.reloadData()
                    completion(spots)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension SpotInfoTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredSpots.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(SpotTableViewCell.self)", for: indexPath) as! SpotTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = (indexPath.row % 2 == 0) ? .white : .systemGray6
        
        let spot = filteredSpots[indexPath.row]
        cell.countryLabel.text = spot.country
        cell.areaLabel.text = spot.sarea
        cell.spotLabel.text = spot.sna
        
        return cell
    }
}

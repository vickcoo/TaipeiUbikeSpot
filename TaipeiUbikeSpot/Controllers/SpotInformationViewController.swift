//
//  SpotInformationView.swift
//  TaipeiUbikeSpot
//
//  Created by Vickcoo on 2023/11/24.
//

import UIKit

class SpotInformationViewController: UIViewController {
    var spotInfoTableView: SpotInfoTableView!
    var areaPopoverViewController: AreaPopoverViewController!
    var searchButton: UIButton!
    var titleLabel: UILabel!
    var areas = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeUserInterface()
        spotInfoTableView.loadData { spots in
            var areas = spots.map({ $0.sarea }).uniqued()
            areas.insert(String(localized: "全部"), at: 0)
            self.areas = areas
        }
    }
}

extension SpotInformationViewController {
    func initializeUserInterface() {
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: .ubikeLogo, style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .menu, style: .plain, target: self, action: #selector(showMenuView))

        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = .white
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.compactAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .primaryGreen
        titleLabel.text = String(localized: "站點資訊")
        titleLabel.font = .systemFont(ofSize: 18, weight: .medium)
        
        let searchButtonImage = UIImageView(image: .search)
        searchButtonImage.translatesAutoresizingMaskIntoConstraints = false
        searchButtonImage.sizeToFit()
        
        searchButton = UIButton(configuration: .plain())
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.setTitle(String(localized: "搜尋站點"), for: .normal)
        searchButton.contentHorizontalAlignment = .leading
        searchButton.layer.cornerRadius = 8
        searchButton.backgroundColor = .searchBarGray
        searchButton.tintColor = .gray
        searchButton.addTarget(self, action: #selector(popoverAreaTableView), for: .touchUpInside)
        searchButton.addSubview(searchButtonImage)

        spotInfoTableView = SpotInfoTableView()
        spotInfoTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        view.addSubview(searchButton)
        view.addSubview(spotInfoTableView)
        
        NSLayoutConstraint.activate([
            searchButtonImage.widthAnchor.constraint(equalTo: searchButtonImage.heightAnchor),
            searchButtonImage.topAnchor.constraint(equalTo: searchButton.topAnchor, constant: 8),
            searchButtonImage.bottomAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: -8),
            searchButtonImage.trailingAnchor.constraint(equalTo: searchButton.trailingAnchor, constant: -16),
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 20),
            
            searchButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            searchButton.heightAnchor.constraint(equalToConstant: 40),
            searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            spotInfoTableView.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 20),
            spotInfoTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            spotInfoTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            spotInfoTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    func loadData() {
        spotInfoTableView.activityIndicatorView.startAnimating()
        DataManager.shared.fetchData(urlString: ApiUrl.taipeiUbikeSpot.rawValue) { [weak self] result in
            switch result {
            case .success(let spots):
                DispatchQueue.main.async {
                    self?.spotInfoTableView.activityIndicatorView.stopAnimating()
                    var areas = spots.map({ $0.sarea }).uniqued()
                    areas.insert(String(localized: "全部"), at: 0)
                    self?.areas = areas
                    self?.spotInfoTableView.spots = spots
                    self?.spotInfoTableView.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func showMenuView() {
        guard let navigationController = navigationController else { return }
        navigationController.pushViewController(MenuViewController(), animated: true)
    }
    
    @objc func popoverAreaTableView() {
        areaPopoverViewController = AreaPopoverViewController()
        areaPopoverViewController.delegate = self
        areaPopoverViewController.sourceView = searchButton
        areaPopoverViewController.modalPresentationStyle = .popover
        areaPopoverViewController.popoverPresentationController?.delegate = self
        areaPopoverViewController.popoverPresentationController?.sourceView = searchButton
        areaPopoverViewController.popoverPresentationController?.sourceRect = searchButton.bounds
        areaPopoverViewController.popoverPresentationController?.permittedArrowDirections = .up
        areaPopoverViewController.areas = areas
        present(areaPopoverViewController, animated: true)
    }
}

extension SpotInformationViewController: UIPopoverPresentationControllerDelegate, AreaPopoverViewControllerDelegate {
    func didSelectRow(itemString: String, index: Int) {
        if index == 0 {
            // Search all
            spotInfoTableView.searchTerm = nil
            searchButton.setTitle(String(localized: "搜尋站點"), for: .normal)
        } else {
            spotInfoTableView.searchTerm = itemString
            searchButton.setTitle(itemString, for: .normal)
        }
        spotInfoTableView.tableView.reloadData()
    }
    
    // For present popover view.
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

#Preview {
    let rootViewController = UINavigationController(rootViewController: SpotInformationViewController())
    return rootViewController
}

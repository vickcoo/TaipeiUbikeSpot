//
//  MainViewController.swift
//  TaipeiUbikeSpot
//
//  Created by Vickcoo on 2023/11/24.
//

import UIKit

enum FeaturePage: String,CaseIterable {
    case usage = "使用說明"
    case payment = "收費方式"
    case spotInfo = "站點資訊"
    case news = "最新消息"
    case activity = "活動專區"
}

class MenuViewController: UIViewController {
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUserInterface()
    }
}

extension MenuViewController {
    func initializeUserInterface() {
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: .ubikeLogo, style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .close, style: .plain, target: self, action: #selector(showPreviousView))

        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = .white
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.compactAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "FeatureCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .primaryGreen
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    @objc func showPreviousView() {
        guard let navigationController = navigationController else {
            navigationController?.pushViewController(SpotInformationViewController(), animated: true)
            return
        }
        
        navigationController.popViewController(animated: true)
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.popViewController(animated: true)
        let viewController = LabelViewController()
        let featurePages = FeaturePage.allCases
        let featurePage = featurePages[indexPath.row]
        
        switch featurePage {
        case .usage:
            viewController.text = featurePage.rawValue
            navigationController?.pushViewController(viewController, animated: false)
        case .payment:
            viewController.text = featurePage.rawValue
            navigationController?.pushViewController(viewController, animated: false)
        case .spotInfo:
            navigationController?.pushViewController(SpotInformationViewController(), animated: false)
        case .news:
            viewController.text = featurePage.rawValue
            navigationController?.pushViewController(viewController, animated: false)
        case .activity:
            viewController.text = featurePage.rawValue
            navigationController?.pushViewController(viewController, animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FeaturePage.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeatureCell", for: indexPath)
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = FeaturePage.allCases[indexPath.row].rawValue
        contentConfiguration.textProperties.font = .systemFont(ofSize: 18, weight: .semibold)
        contentConfiguration.textProperties.color = .white
        cell.contentConfiguration = contentConfiguration
        cell.backgroundColor = .primaryGreen
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}

#Preview {
    let rootViewController = UINavigationController(rootViewController: MenuViewController())
    return rootViewController
}

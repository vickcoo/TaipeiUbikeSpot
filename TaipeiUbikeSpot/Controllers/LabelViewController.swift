//
//  LabelViewController.swift
//  TaipeiUbikeSpot
//
//  Created by Vickcoo on 2023/11/27.
//

import UIKit

class LabelViewController: UIViewController {

    var titleLabel: UILabel!
    var text: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUserInterface()
    }
    
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
        titleLabel.text = text
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    @objc func showMenuView() {
        guard let navigationController = navigationController else { return }
        navigationController.pushViewController(MenuViewController(), animated: true)
    }
}

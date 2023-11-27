//
//  SpotTableViewCell.swift
//  TaipeiUbikeSpot
//
//  Created by Vickcoo on 2023/11/24.
//

import UIKit

class SpotTableViewCell: UITableViewCell {

    var countryLabel: UILabel!
    var areaLabel: UILabel!
    var spotLabel: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initializeUserInterface()
    }
        
    func initializeUserInterface() {
        
        countryLabel = UILabel()
        countryLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(countryLabel)
        areaLabel = UILabel()
        areaLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(areaLabel)
        spotLabel = UILabel()
        spotLabel.translatesAutoresizingMaskIntoConstraints = false
        spotLabel.numberOfLines = 0
        contentView.addSubview(spotLabel)
        
        NSLayoutConstraint.activate([
            countryLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            countryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            countryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            countryLabel.widthAnchor.constraint(equalToConstant: 60),
            
            areaLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            areaLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            areaLabel.leadingAnchor.constraint(equalTo: countryLabel.trailingAnchor, constant: 15),
            areaLabel.widthAnchor.constraint(equalToConstant: 60),
            
            spotLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            spotLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            spotLabel.leadingAnchor.constraint(equalTo: areaLabel.trailingAnchor, constant: 15),
            spotLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
    }
}

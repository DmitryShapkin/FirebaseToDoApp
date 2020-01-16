//
//  CustomCell.swift
//  ToDoFIRE
//
//  Created by Dmitry Shapkin on 14/12/2019.
//  Copyright © 2019 ShapkinDev. All rights reserved.
//


import Foundation
import UIKit

class CustomCell: UITableViewCell {
    
    var mainView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .yellow
        view.layer.cornerRadius = 5.0
        return view
    }()
    
    var labelView: UILabel = {
        var labelView = UILabel()
        labelView.text = "Label"
        labelView.translatesAutoresizingMaskIntoConstraints = false
        labelView.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 25)
        labelView.textAlignment = .center
        labelView.lineBreakMode = .byWordWrapping
        labelView.numberOfLines = 0
        labelView.isUserInteractionEnabled = false
        return labelView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        
        self.addSubview(mainView)
        self.mainView.addSubview(labelView)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: self.topAnchor),
            mainView.leftAnchor.constraint(equalTo: self.leftAnchor),
            mainView.rightAnchor.constraint(equalTo: self.rightAnchor),
            mainView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            labelView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 20),
            labelView.leftAnchor.constraint(equalTo: mainView.leftAnchor),
            labelView.rightAnchor.constraint(equalTo: mainView.rightAnchor),
            labelView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -10)
        ])
    }
}

extension CustomCell {
    
}

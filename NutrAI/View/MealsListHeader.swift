//
//  MealsListHeader.swift
//  NutrAI
//
//  Created by Vinicius Mangueira on 02/07/19.
//  Copyright © 2019 Vinicius Mangueira. All rights reserved.
//

import UIKit


class MealsListHeader: UIView, ConfigurableView {
    
    var schedule: Schedule! {
        didSet {
            nameSection.text = schedule.name
            iconSection.image = UIImage(named: schedule.imageNamed)
        }
    }
    
    lazy var nameSection = UILabel(text: "Breakfast", font: UIFont.init(name: "Futura", size: 16), textColor: .black)
    
    lazy var iconSection: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "toaster"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(displayP3Red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
        buildViewHierarchy()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildViewHierarchy() {
        addSubview(nameSection)
        addSubview(iconSection)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            self.iconSection.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            self.iconSection.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            self.iconSection.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
        ])
        
        NSLayoutConstraint.activate([
            self.nameSection.leadingAnchor.constraint(equalTo: self.iconSection.trailingAnchor, constant: 10),
            self.nameSection.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            self.nameSection.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
        ])
    }

}


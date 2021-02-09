//
//  RoundedShadowBtn.swift
//  CareHome
//
//  Created by Oscar on 24/10/2019.
//  Copyright © 2019 OscarSanz. All rights reserved.
//

import UIKit

class RoundedShadowBtn: UIButton {

    var originalSize: CGRect?
    let color1 = UIColor(red: 255, green: 67, blue: 86, alpha: 1.0)
    
    override func awakeFromNib() {
        setupView()
    }
    
    func setupView(){
        originalSize = self.frame
        self.layer.cornerRadius = 5.0
        self.layer.shadowRadius = 10.0
        self.layer.shadowColor = color1.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize.zero
        
        
        
    }

}

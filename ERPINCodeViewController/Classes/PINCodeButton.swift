//
//  PINCodeButton.swift
//  MetalPay
//
//  Created by Ephraim Russo on 5/24/19.
//  Copyright © 2019 Metallicus Inc. All rights reserved.
//

import UIKit

class PINCodeButton: UIButton {
    
    //**************************************************//
    
    // MARK: Public Variables
    
    public var value: Int { return tag }
    
    //**************************************************//
    
    // MARK: Private Variables
    
    //**************************************************//
    
    // MARK: IBOutlets
    
    //**************************************************//
    
    // MARK: IBActions
    
    //**************************************************//
    
    // MARK: Load Subviews
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.masksToBounds = true
        layer.borderColor = PINCodeViewController.theme.primaryColor.withAlphaComponent(0.75).cgColor
        layer.borderWidth = 2
        titleLabel?.font = PINCodeViewController.theme.pinKeyfont
        setTitleColor(PINCodeViewController.theme.primaryColor, for: .normal)
        setTitle("\(tag)", for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.midX
    }
    
    //**************************************************//
    
    // MARK: Configuration
    
    //**************************************************//
}


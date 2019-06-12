//
//  PINCodeView.swift
//  MetalPay
//
//  Created by Ephraim Russo on 5/24/19.
//  Copyright © 2019 Metallicus Inc. All rights reserved.
//

import UIKit

class PINCodeInputView: UIView {
    
    enum State {
        
        case filled
        case empty
    }
    
    //**************************************************//
    
    // MARK: Public Variables
    
    var currentState: State = .empty
    
    //**************************************************//
    
    // MARK: Private Variables
    
    private let animationDuration: TimeInterval = 0.25
    
    //**************************************************//
    
    // MARK: IBOutlets
    
    //**************************************************//
    
    // MARK: IBActions
    
    //**************************************************//
    
    // MARK: Load Subviews
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.masksToBounds = true
        
        layer.borderWidth = 1
        layer.borderColor = PINCodeViewController.theme.primaryColor.cgColor
        
        setState(.empty, animated: false)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.midX
    }
    
    //**************************************************//
    
    // MARK: Configuration
    
    func setState(_ state: State, animated: Bool) {

        guard state != currentState else { return }
        
        let block = { [weak self] in
          
            switch state {
            case .empty:
                self?.backgroundColor = .clear
            case .filled:
                self?.backgroundColor = PINCodeViewController.theme.primaryColor
            }
        }
        
        if animated { UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut, animations: block, completion: nil) }
        
        else { block() }
        
        currentState = state
    }
    
    //**************************************************//
}


//
//  PINCodeView.swift
//  MetalPay
//
//  Created by Ephraim Russo on 5/26/19.
//  Copyright © 2019 Metallicus Inc. All rights reserved.
//

import UIKit

class PINCodeView: UIView {
    
    //**************************************************//
    
    // MARK: Public Variables
    
//    var numberOfDigits = 4 {
//
//        didSet {
//
//            currentInput = ""
//
//            let subviews = stackView.arrangedSubviews
//            for view in subviews {
//                stackView.removeArrangedSubview(view)
//                view.removeFromSuperview()
//            }
//
//            for _ in 0..<numberOfDigits {
//
//
//            }
//
//        }
//    }
        
    //**************************************************//
    
    // MARK: Private Variables
    
    //**************************************************//
    
    // MARK: IBOutlets
    
    @IBOutlet fileprivate weak var stackView: UIStackView!
    
    //**************************************************//
    
    // MARK: IBActions
    
    //**************************************************//
    
    // MARK: Load Subviews
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //**************************************************//
    
    // MARK: Configuration
    
    func handlePINCodeFailure() {
        
        shake()
    }
    
    func update(for input: String) {
                
        guard let pinCodeViews = stackView.arrangedSubviews as? [PINCodeInputView] else { return }
        
        for (i, view) in pinCodeViews.enumerated() {
            
            let isFilled = i < input.count
            
            view.setState( isFilled ? .filled : .empty, animated: !isFilled)
        }
    }
    
    //**************************************************//
}

private extension UIView {
    
    func shake(count : Float = 4,for duration : TimeInterval = 0.07,withTranslation translation : CGFloat = 10) {
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = duration
        animation.repeatCount = count
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - translation, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + translation, y: self.center.y))
        
        self.layer.add(animation, forKey: "position")
    }
}


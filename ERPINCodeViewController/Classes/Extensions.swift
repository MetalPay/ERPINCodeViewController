//
//  Extensions.swift
//  ERPINCodeViewController
//
//  Created by Ephraim Russo on 6/12/19.
//

import Foundation
import UIKit
import CryptoSwift

extension Bundle {
    
    static var resources: Bundle? {
        
        guard let url = Bundle(for: PINCodeViewController.self).url(forResource: "ERPINCodeViewController_Resources", withExtension: "bundle") else { return nil }
        
        return Bundle(url: url)
    }
}

extension DispatchQueue {
    
    func after(_ delay: TimeInterval? = nil, execute work: @escaping () -> Void) {
        
        if let delay = delay { asyncAfter(deadline: .now() + delay, execute: work) }
            
        else { async(execute: work)  }
    }
}

extension String {
    
    /// Returns a hashed string by applying the `sha512` hashing algorithm to the receiver.
    func hashed() -> String {
        
        guard !isEmpty else {return ""}
        
        guard let data = data(using: .utf8) else {return ""}
        
        let digest = Digest.sha512(data.bytes)
        
        let output = digest.map({String(format: "%02x", $0)}).joined().uppercased()
        
        return output
    }
}

extension NSLayoutConstraint {
    /**
     Change multiplier constraint
     
     - parameter multiplier: CGFloat
     - returns: NSLayoutConstraint
     */
    @discardableResult func setMultiplier(multiplier:CGFloat) -> NSLayoutConstraint {
        
        NSLayoutConstraint.deactivate([self])
        
        let newConstraint = NSLayoutConstraint(
            item: firstItem as Any,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
}

extension UILabel {
    
    func setTextAnimated(_ text:String?, duration:TimeInterval=0.25) {
        
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.type = .fade
        animation.duration = duration
        self.layer.add(animation, forKey: "kCATransitionFade")
        self.text = text
    }
}

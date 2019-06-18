//
//  PINCodeTheme.swift
//  ERPINCodeViewController
//
//  Created by Ephraim Russo on 6/12/19.
//

import Foundation
import UIKit

public struct PINCodeTheme {
    
    public let appName: String
    
    public let primaryColor: UIColor
    
    public let nameLabelFont: UIFont
    
    public let nameLabelText: String
    
    public let pinKeyfont: UIFont
    
    public let captionFont: UIFont
    
    public let buttonFont: UIFont
    
    public init(appName: String, primaryColor: UIColor = .black, nameLabelText: String, nameLabelFont: UIFont = .boldSystemFont(ofSize: 18), titleFont: UIFont = .boldSystemFont(ofSize: 18), captionFont: UIFont = .systemFont(ofSize: 14),  buttonFont: UIFont = .systemFont(ofSize: 14)) {
        
        self.appName = appName
        self.primaryColor = primaryColor
        self.nameLabelFont = nameLabelFont
        self.nameLabelText = nameLabelText
        self.pinKeyfont = titleFont
        self.captionFont = captionFont
        self.buttonFont = buttonFont
    }
}

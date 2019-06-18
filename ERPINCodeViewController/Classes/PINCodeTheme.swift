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
    
    public init(appName: String, primaryColor: UIColor = .black, nameLabelText: String, nameLabelFont: UIFont = .boldSystemFont(ofSize: UIFont.labelFontSize), titleFont: UIFont = .boldSystemFont(ofSize: UIFont.labelFontSize), captionFont: UIFont = .systemFont(ofSize: UIFont.labelFontSize), buttonFont: UIFont = .systemFont(ofSize: UIFont.buttonFontSize)) {
        
        self.appName = appName
        self.primaryColor = primaryColor
        self.nameLabelFont = nameLabelFont
        self.nameLabelText = nameLabelText
        self.pinKeyfont = titleFont
        self.captionFont = captionFont
        self.buttonFont = buttonFont
    }
}

//
//  PinCodeViewController.swift
//  MetalPay
//
//  Created by Ephraim Russo on 5/24/19.
//  Copyright © 2019 Metallicus Inc. All rights reserved.
//

import Foundation
import UIKit
import KeychainAccess

public protocol PINCodeViewControllerDelegate: NSObjectProtocol {
    
    func pinCodeViewControllerDidCancel(_ viewController: PINCodeViewController)
    
    func pinCodeViewControllerDidSucceed(_ viewController: PINCodeViewController)
    
    func pinCodeViewController(_ viewController: PINCodeViewController, didFailWithError error: PINCodeValidationError)
}

public enum PINCodeValidationError: Error {
    
    case weakPINStrength
    case incorrectPIN
    case sameAsExistingPIN
    case notSameAsNewPIN
    
    var displayCopy: (title: String, caption: String)? {
        
        switch self {
            
        case .weakPINStrength: return (title: "Invalid passcode", caption: "The passcode you entered is too easy to guess and connot be used.")
        case .sameAsExistingPIN: return (title: "Invalid passcode", caption: "Enter a passcode that is different than the current one.")
        case .incorrectPIN: return nil
        case .notSameAsNewPIN: return nil
        }
    }
}

public final class PINCodeViewController: UIViewController {
    
    public enum Mode {
        
        case create
        case verify
        case change
        case disable
        
        fileprivate var canCancel: Bool {
            
            switch self {
            default: return true
            }
        }
        
        fileprivate var states: [State] {
            
            switch self {
                
            case .create: return [.inputNewPIN, .verifyNewPIN]
            case .verify: return [.inputExistingPIN]
            case .change: return [.inputExistingPIN, .inputNewPIN, .verifyNewPIN]
            case .disable: return [.inputExistingPIN]
            }
        }
    }
    
    fileprivate enum State: String {
        
        case inputExistingPIN
        case inputNewPIN
        case verifyNewPIN
        
        fileprivate var captionText: String {
            
            switch self {
            case .inputExistingPIN: return "Enter your \(PINCodeViewController.theme.appName) Passcode"
            case .inputNewPIN: return "Create your new \(PINCodeViewController.theme.appName) Passcode"
            case .verifyNewPIN: return "Verify your new \(PINCodeViewController.theme.appName) Passcode"
            }
        }
    }
    
    //**************************************************//
    
    // MARK: Static Variables
    
    public static func present(for mode: Mode, in viewController: UIViewController, delegate: PINCodeViewControllerDelegate, after delay: TimeInterval? = nil) {
        
        //if mode == .create && didSetPINCode { return }
        
        switch mode {
        case .create: guard !didSetPINCode else { return }
        case .change,
             .verify,
             .disable: guard didSetPINCode else { return }
        }
        
        DispatchQueue.main.after(delay) {
         
            let instance: PINCodeViewController = UIStoryboard(name: "PINCode", bundle: .resources).instantiateInitialViewController() as! PINCodeViewController
            instance.mode = mode
            instance.delegate = delegate
            viewController.present(instance, animated: true, completion: nil)
        }
    }
    
    public static func use(theme: PINCodeTheme, profileImage: UIImage?, keychainService: String?, keychainAccessGroup: String?) {
        
        self.theme = theme
        self.profileImage = profileImage
        
        if let service = keychainService, let accessGroup = keychainAccessGroup {
            
            self.keychain = Keychain(service: service, accessGroup: accessGroup)
        }
    }
    
    public static func removePINCode() {
        
        try? keychain.remove(keychainPINCodeKey)
    }
    
    public static var didSetPINCode: Bool { return savedPINCode != nil }
    
    static var theme = PINCodeTheme(appName: "Default App Name", nameLabelText: "Default User")
    
    private static var keychain = Keychain()
    
    private static var profileImage: UIImage?

    private static let keychainPINCodeKey = "PINCodeViewController-PINCode"
    
    private static var savedPINCode: String? { return try? keychain.getString(keychainPINCodeKey) }

    
    //**************************************************//
    
    // MARK: Public Variables
    
    private weak var delegate: PINCodeViewControllerDelegate?
    
    private var mode: Mode! {
        
        didSet {
            
            currentState = mode.states.first
        }
    }
    
    private var currentState: State!
    
    private let maxPINLength = 4
    
    //**************************************************//
    
    // MARK: Private Variables
    
    private var inputMap: [State : String] = [ : ] {
        
        didSet {
            
            print("Input map set: \(inputMap)")

            currentPINCodeView.update(for: currentInput)
            updateDeleteButtonEnabled()
            checkForValidPINCode()
        }
    }
    
    //**************************************************//
    
    // MARK: Computed Variables
    
    private var currentInput: String {
        
        get { return inputMap[currentState!] ?? "" }
        
        set { inputMap[currentState!] = newValue }
    }
    
    private var currentPINCodeView: PINCodeView {
        
        let index = self.mode!.states.firstIndex(of: currentState!)!
        
        return pinCodeStackView.arrangedSubviews[index] as! PINCodeView
    }

    //**************************************************//
    
    // MARK: Manager
    
    //**************************************************//
    
    // MARK: IBOutlets
    
    @IBOutlet fileprivate weak var profileImageView: UIImageView! {
        
        didSet {
            
            profileImageView.layer.cornerRadius = profileImageView.bounds.midX
            profileImageView.layer.borderColor = UIColor(white: 0.85, alpha: 1).cgColor
            profileImageView.layer.borderWidth = 1.5
            profileImageView.layer.masksToBounds = true
        }
    }
    
    @IBOutlet fileprivate weak var nameLabel: UILabel! {
        
        didSet {
            
            if #available(iOS 11.0, *) {
                nameLabel.font = UIFontMetrics(forTextStyle: .callout).scaledFont(for: PINCodeViewController.theme.nameLabelFont)
                nameLabel.adjustsFontForContentSizeCategory = true
            }
            
            else { nameLabel.font = PINCodeViewController.theme.nameLabelFont }
            
            nameLabel.text = PINCodeViewController.theme.nameLabelText
        }
    }
    
    @IBOutlet fileprivate weak var captionLabel: UILabel! {
        
        didSet {
         
            if #available(iOS 11.0, *) {
                captionLabel.font = UIFontMetrics(forTextStyle: .callout).scaledFont(for: PINCodeViewController.theme.captionFont)
                captionLabel.adjustsFontForContentSizeCategory = true
            }
            
            else { captionLabel.font = PINCodeViewController.theme.captionFont }
        }
    }
    
    @IBOutlet fileprivate weak var pinCodeScrollView: UIScrollView!
    
    @IBOutlet fileprivate weak var pinCodeStackView: UIStackView!
    
    @IBOutlet fileprivate weak var pinCodeViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet fileprivate weak var cancelButton: UIButton! {
        
        didSet {
            
            if #available(iOS 11.0, *) {
                cancelButton.titleLabel?.font = UIFontMetrics(forTextStyle: .callout).scaledFont(for: PINCodeViewController.theme.buttonFont)
                cancelButton.titleLabel?.adjustsFontForContentSizeCategory = true
            }
                
            else { cancelButton.titleLabel?.font = PINCodeViewController.theme.buttonFont }
            
            cancelButton.setTitleColor(PINCodeViewController.theme.primaryColor, for: .normal)
        }
    }

    @IBOutlet fileprivate weak var deleteButton: UIButton! {
        
        didSet {
            
            if #available(iOS 11.0, *) {
                deleteButton.titleLabel?.font = UIFontMetrics(forTextStyle: .callout).scaledFont(for: PINCodeViewController.theme.buttonFont)
                deleteButton.titleLabel?.adjustsFontForContentSizeCategory = true
            }
                
            else { deleteButton.titleLabel?.font = PINCodeViewController.theme.buttonFont }
            
            deleteButton.setTitleColor(PINCodeViewController.theme.primaryColor, for: .normal)
        }
    }
    
    //**************************************************//
    
    // MARK: IBActions
    
    @IBAction fileprivate func cancelButtonPressed(_ sender: UIButton) {
        
        delegate?.pinCodeViewControllerDidCancel(self)
    }
    
    @IBAction fileprivate func deleteButtonPressed(_ sender: UIButton) {
        
        deleteInput()
    }
    
    @IBAction fileprivate func PINCodeButtonPressed(_ sender: PINCodeButton) {
        
        appendInput(value: sender.value)
    }
    
    //**************************************************//
    
    // MARK: View Loading
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        loadCaptionLabel()
        loadProfileImage()
        loadPINCodeViews()
        loadCancelButton()
        
        clearCurrentInput()
    }
    
    private func loadProfileImage() {
    
        if let image = PINCodeViewController.profileImage {
            
            profileImageView.image = image
            profileImageView.isHidden = false
        }
        
        else {
            profileImageView.isHidden = true
        }
    }
    
    private func loadCaptionLabel() {
        
        captionLabel.text = currentState.captionText
    }
    
    private func loadPINCodeViews() {
        
        let numStates = mode!.states.count
        
        pinCodeViewWidthConstraint.setMultiplier(multiplier: CGFloat(numStates))
        
        for _ in 0..<numStates {
            
            guard let pinCodeView = Bundle.resources?.loadNibNamed("PINCodeView", owner: nil, options: nil)?.first as? PINCodeView else { return }
            
            pinCodeStackView.addArrangedSubview(pinCodeView)
        }
    }
    
    private func loadCancelButton() {
        
        cancelButton.alpha = mode.canCancel ? 1 : 0
        cancelButton.isUserInteractionEnabled = mode.canCancel
    }
    
    //**************************************************//
    
    // MARK: View Appearance
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    //**************************************************//
    
    // MARK: Prepare for Segue
    
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Override point to pass data to the destination view controller.
        super.prepare(for: segue, sender: sender)
    }
    
    //**************************************************//
    
    // MARK: View Disappearance
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Override point to customize time before presentation or push.
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Override point to customize time after presentation or push.
    }
    
    //**************************************************//
    
    // MARK: UI Updates
    
    private func updateDeleteButtonEnabled() {
        
        //print(#function)

        deleteButton.isEnabled = !currentInput.isEmpty
        
        deleteButton.layer.removeAllAnimations()
        
        UIView.animate(withDuration: 0.25) {
            
            self.deleteButton.alpha = self.deleteButton.isEnabled ? 1 : 0.35
        }
    }
    
    //**************************************************//
    
    // MARK: Append / Delete Input
    
    private func appendInput(value: Int) {
        
        //print(#function)

        var input = self.currentInput
        input += "\(value)"
        currentInput = input
    }
    
    private func deleteInput() {
        
        //print(#function)
        
        guard !currentInput.isEmpty else { return }
        
        var input = self.currentInput
        input.removeLast()
        currentInput = input
    }
    
    //**************************************************//
    
    // MARK: Validation
    
    private func checkForValidPINCode() {
        
        //print(#function, currentState!)

        guard currentInput.count == maxPINLength else { return }
        
        switch currentState! {
            
        case .inputExistingPIN:
            
            guard currentInput.hashed() == PINCodeViewController.savedPINCode else { handlePINCodeFailure(error: .incorrectPIN); return }
            
        case .inputNewPIN:
            
            guard currentInput.hashed() != PINCodeViewController.savedPINCode else { handlePINCodeFailure(error: .sameAsExistingPIN); return }
            
            // Check if all values are the same. Set is an easy way to remove duplicates.
            guard Set(currentInput).count > 1 else { handlePINCodeFailure(error: .weakPINStrength); return }
            
            // Check if all values are in sequence. (i.e. 1,2,3,4...)
            guard isCurrentInputSequential() == false else { handlePINCodeFailure(error: .weakPINStrength); return }
            
        case .verifyNewPIN:
            
            guard currentInput.hashed() == inputMap[.inputNewPIN]?.hashed() else { handlePINCodeFailure(error: .notSameAsNewPIN); return }
        }
        
        if currentState == self.mode.states.last { handlePINCodeSuccess() }
            
        else { showNextState() }
    }
    
    //**************************************************//
    
    // MARK: State Transitions
    
    private func showNextState(animated: Bool = true) {
        
        //print(#function)

        guard currentState != self.mode.states.last else { return }
        
        let index = self.mode.states.firstIndex(of: currentState!)!
        let nextIndex = index+1
        
        self.currentState = self.mode.states[nextIndex]
        
        currentPINCodeView.update(for: currentInput)
        updateDeleteButtonEnabled()
        checkForValidPINCode()

        let block = {
            
            let width = self.pinCodeScrollView.bounds.width
            let offset = CGPoint(x: CGFloat(nextIndex)*width, y: 0)
            self.pinCodeScrollView.setContentOffset(offset, animated: false)
        }
        
        if animated {
            
            captionLabel.setTextAnimated(currentState.captionText)
            
            UIView.animate(withDuration: 0.32, delay: 0, options: .curveEaseInOut, animations: block)
        }
        
        else {
         
            block()
            captionLabel.text = currentState.captionText
        }
    }
    
    private func showPreviousState(animated: Bool = true) {
        
        //print(#function)

        guard currentState != self.mode.states.first else { return }

    }
    
    //**************************************************//
    
    // MARK: Sucess / Failure Handlers
    
    private func handlePINCodeSuccess() {
        
        //print(#function)
        
        switch self.mode! {
        case .create,
             .change: saveCurrentPINCode()
        case .verify: break
        case .disable: PINCodeViewController.removePINCode()
        }

        DispatchQueue.main.after(0.5) { [weak self] in
            
            guard let strongSelf = self else { return }
            
            strongSelf.delegate?.pinCodeViewControllerDidSucceed(strongSelf)
            
        }
    }
    
    private func handlePINCodeFailure(error: PINCodeValidationError) {
        
        //print(#function)
        
        clearCurrentInput()
        currentPINCodeView.handlePINCodeFailure()
        
        self.delegate?.pinCodeViewController(self, didFailWithError: error)
    }

    //**************************************************//
    
    // MARK∂: MISC
    
    private func isCurrentInputSequential() -> Bool {
        
        let list = currentInput.compactMap { Int(String($0)) }
        return list.map { $0 - 1 }.dropFirst() == list.dropLast()
    }
    
    private func clearCurrentInput() {
        
        currentInput = ""
    }
    
    private func saveCurrentPINCode() {
        
        //print(#function)
        
        guard currentInput.count == maxPINLength else { return }

        guard currentState == .verifyNewPIN else { return }
        
        do {
            
            try PINCodeViewController.keychain.set(currentInput.hashed(), key: PINCodeViewController.keychainPINCodeKey)
        }
        
        catch {
            
            print(error)
        }
    }
    
    //**************************************************//
}

//
//  ViewController.swift
//  ERPINCodeViewController
//
//  Created by erusso1 on 06/12/2019.
//  Copyright (c) 2019 erusso1. All rights reserved.
//

import UIKit
import ERPINCodeViewController

class ViewController: UIViewController {

    @IBAction func buttonPressed(_ sender: UIButton) {
        
        switch sender.tag {
        case 0: PINCodeViewController.present(for: .create, in: self)
        case 1: PINCodeViewController.present(for: .verify, in: self)
        case 2: PINCodeViewController.present(for: .change, in: self)
        case 3: PINCodeViewController.present(for: .disable, in: self)
        default: break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        PINCodeViewController.use(
            theme: .init(appName: "Apply", nameLabelText: "John Harrington"),
            profileImage: UIImage(named: "profile")!,
            keychainService: nil,
            keychainAccessGroup: nil
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: PINCodeViewControllerDelegate {

    func pinCodeViewControllerDidCancel(_ viewController: PINCodeViewController) {
        
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func pinCodeViewControllerDidSucceed(_ viewController: PINCodeViewController) {
        
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func pinCodeViewController(_ viewController: PINCodeViewController, didFailWithError error: PINCodeValidationError) {
     
        
    }
}


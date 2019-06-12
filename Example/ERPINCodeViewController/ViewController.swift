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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //PINCodeViewController.present(for: .create, theme: .init(nameLabelText: "John Harrington"), in: self)
        
        PINCodeViewController.use(theme: .init(appName: "Apply", nameLabelText: "John Harrington"))
        PINCodeViewController.use(profileImage: UIImage(named: "profile")!)
        PINCodeViewController.present(for: .change, in: self)
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


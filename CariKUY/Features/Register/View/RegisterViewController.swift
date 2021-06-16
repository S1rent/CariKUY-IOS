//
//  RegisterViewController.swift
//  CariKUY
//
//  Created by IT Division on 16/06/21.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var buttonRegister: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var coverView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        buttonRegister.layer.cornerRadius = 6
        emailField.layer.cornerRadius = 6
        passwordField.layer.cornerRadius = 6
    }
    
    @IBAction func fieldEditingBegin(_ sender: Any) {
        coverView.isHidden = false
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        self.navigateAndSetRootViewController(viewController: LoginViewController())
    }
    
    @IBAction func coverViewTapped(_ sender: Any) {
        coverView.isHidden = true
        self.view.endEditing(true)
    }
}

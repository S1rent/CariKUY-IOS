//
//  LoginViewController.swift
//  CariKUY
//
//  Created by IT Division on 16/06/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var coverView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    private func setupView() {
        self.buttonLogin.layer.cornerRadius = 6
        self.emailField.layer.cornerRadius = 6
        self.passwordField.layer.cornerRadius = 6
    }
    
    @IBAction func buttonLoginTapped(_ sender: Any) {
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        self.navigateAndSetRootViewController(viewController: RegisterViewController())
    }
    
    @IBAction func fieldBeginEditing(_ sender: Any) {
        coverView.isHidden = false
    }
    
    @IBAction func coverViewTapped(_ sender: Any) {
        coverView.isHidden = true
        self.view.endEditing(true)
    }
}

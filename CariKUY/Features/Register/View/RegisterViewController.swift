//
//  RegisterViewController.swift
//  CariKUY
//
//  Created by IT Division on 16/06/21.
//

import UIKit
import RxSwift
import RxCocoa

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var buttonRegister: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var seekerCheckBox: UIImageView!
    @IBOutlet weak var creatorCheckBox: UIImageView!
    
    let viewModel = RegisterViewModel()
    let disposeBag = DisposeBag()
    
    let registerRelay = PublishRelay<Void>()
    let roleRelay = BehaviorRelay<String>(value: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bindUI()
    }
    
    private func bindUI() {
        let output = viewModel.transform(
            input: RegisterViewModel.Input(
                registerTrigger: registerRelay.asDriverOnErrorJustComplete(),
                emailRelay: self.emailField.rx.text.orEmpty.asDriverOnErrorJustComplete().debounce(RxTimeInterval.milliseconds(300)),
                passwordRelay: self.passwordField.rx.text.orEmpty.asDriverOnErrorJustComplete().debounce(RxTimeInterval.milliseconds(300)),
                roleRelay: self.roleRelay.asDriverOnErrorJustComplete(),
                nameRelay: self.nameField.rx.text.orEmpty.asDriverOnErrorJustComplete().debounce(RxTimeInterval.milliseconds(300))
            )
        )
        
        disposeBag.insert(
            output.success.drive(onNext: { [weak self] success in
                guard let self = self else { return }
                
                if success {
                    self.presentViewController(title: "Success", message: "Successfully created an account.", actions: [UIAlertAction(title: "OK", style: .default, handler: { _ in
                        self.navigateAndSetRootViewController(viewController: HomeTabBarViewController())
                    })], completion: nil)
                }
            }),
            output.errorMessage.drive(onNext: { [weak self] message in
                guard let self = self else { return }
                
                self.presentViewController(title: "Error", message: message, actions: [UIAlertAction(title: "OK", style: .default, handler: nil)], completion: nil)
            })
        )
    }
    
    private func setupView() {
        buttonRegister.layer.cornerRadius = 6
        emailField.layer.cornerRadius = 6
        passwordField.layer.cornerRadius = 6
        nameField.layer.cornerRadius = 6
    }
    
    @IBAction func fieldEditingBegin(_ sender: Any) {
        coverView.isHidden = false
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        self.registerRelay.accept(())
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        self.navigateAndSetRootViewController(viewController: LoginViewController())
    }
    
    @IBAction func coverViewTapped(_ sender: Any) {
        coverView.isHidden = true
        self.view.endEditing(true)
    }
    
    @IBAction func seekerTapped(_ sender: Any) {
        resetCheckBox()
        seekerCheckBox.image = UIImage(systemName: "circle.fill")
        
        self.roleRelay.accept("Seeker")
    }
        
    @IBAction func creatorTapped(_ sender: Any) {
        resetCheckBox()
        creatorCheckBox.image = UIImage(systemName: "circle.fill")
        
        self.roleRelay.accept("Creator")
    }
    
    private func resetCheckBox() {
        seekerCheckBox.image = UIImage(systemName: "circle")
        creatorCheckBox.image = UIImage(systemName: "circle")
    }
    
}

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
    @IBOutlet weak var maleCheckBox: UIImageView!
    @IBOutlet weak var femaleCheckBox: UIImageView!
    
    let viewModel = RegisterViewModel()
    let disposeBag = DisposeBag()
    
    let registerRelay = PublishRelay<Void>()
    let genderRelay = BehaviorRelay<String>(value: "")
    
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
                genderRelay: self.genderRelay.asDriverOnErrorJustComplete(),
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
    
    
    @IBAction func maleTapped(_ sender: Any) {
        resetCheckBox()
        maleCheckBox.image = UIImage(systemName: "circle.fill")
        
        self.genderRelay.accept("Male")
    }
    
    @IBAction func femaleTapped(_ sender: Any) {
        resetCheckBox()
        femaleCheckBox.image = UIImage(systemName: "circle.fill")
        
        self.genderRelay.accept("Female")
    }
    
    private func resetCheckBox() {
        maleCheckBox.image = UIImage(systemName: "circle")
        femaleCheckBox.image = UIImage(systemName: "circle")
    }
    
}

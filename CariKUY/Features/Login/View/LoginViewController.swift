//
//  LoginViewController.swift
//  CariKUY
//
//  Created by IT Division on 16/06/21.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var coverView: UIView!
    
    let viewModel = LoginViewModel()
    let submitTrigger = PublishRelay<Void>()
    let userDataTrigger = PublishRelay<String>()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        bindUI()
        setupUserData()
    }
    
    private func bindUI() {
        let output = viewModel.transform(
            input: LoginViewModel.Input(
                submitTrigger: self.submitTrigger.asDriverOnErrorJustComplete(),
                emailRelay: self.emailField.rx.text.orEmpty.asDriver().debounce(RxTimeInterval.milliseconds(300)),
                passwordRelay: self.passwordField.rx.text.orEmpty.asDriver().debounce(RxTimeInterval.milliseconds(300)),
                userDataRelay: self.userDataTrigger.asDriverOnErrorJustComplete()
            )
        )
        
        self.disposeBag.insert(
            output.isSuccess.drive(onNext: { [weak self] success in
                guard let self = self else { return }
                
                if success == .successSeeker {
                    self.navigateAndSetRootViewController(viewController: HomeTabBarViewController())
                } else if success == .successCreator {
                    self.navigateAndSetRootViewController(viewController: HomeCreatorTabBarViewController())
                }
            }),
            output.errorMessage.drive(onNext: { [weak self] message in
                guard let self = self else { return }
                
                self.presentPopUp(title: "Error", message: message, actions: [UIAlertAction(title: "OK", style: .default, handler: nil)], completion: nil)
            }),
            output.isValid.drive(onNext: { [weak self] valid in
                guard let self = self else { return }
                print("VALID \(valid)")
                switch valid {
                case 0:
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: { [weak self] in
                        guard let self = self else { return }
                        self.navigateAndSetRootViewController(viewController: HomeTabBarViewController())
                    })
                case 1:
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: { [weak self] in
                        guard let self = self else { return }
                        self.navigateAndSetRootViewController(viewController: HomeCreatorTabBarViewController())
                    })
                default:
                    return
                }
            })
        )
    }
    
    private func setupUserData() {
        let user = UserService.shared.getUser()
        
        if let userData = user {
            print("EMAIL \(userData.userEmail)")
            self.userDataTrigger.accept(userData.userEmail ?? "")
        }
    }
    
    private func setupView() {
        self.buttonLogin.layer.cornerRadius = 6
        self.emailField.layer.cornerRadius = 6
        self.passwordField.layer.cornerRadius = 6
    }
    
    @IBAction func buttonLoginTapped(_ sender: Any) {
        self.submitTrigger.accept(())
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

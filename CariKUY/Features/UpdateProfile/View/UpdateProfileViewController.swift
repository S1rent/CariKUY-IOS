//
//  UpdateProfileViewController.swift
//  CariKUY
//
//  Created by IT Division on 17/06/21.
//

import UIKit
import RxSwift
import RxCocoa

class UpdateProfileViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var profileImageField: UITextField!
    
    @IBOutlet weak var maleCheckBox: UIImageView!
    @IBOutlet weak var femaleCheckBox: UIImageView!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var currentPasswordField: UITextField!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var genderView: UIView!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var birthDateView: UIView!
    
    let datePicker = UIDatePicker()
    let viewModel = UpdateProfileViewModel()
    
    let disposeBag = DisposeBag()
    
    let loadTrigger = BehaviorRelay<Void>(value: ())
    let editTrigger = PublishRelay<Void>()
    
    let dateSelected = PublishRelay<String>()
    let genderTrigger = PublishRelay<String>()
    let imageTrigger = PublishRelay<String>()
    let emailTrigger = PublishRelay<String>()
    let nameTrigger = PublishRelay<String>()
    let descTrigger = PublishRelay<String>()
    let numberTrigger = PublishRelay<String>()
    let newPasswordTrigger = PublishRelay<String>()
    let passwordTrigger = PublishRelay<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.title = "Update Profile"
        
        setupView()
        bindUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func bindUI() {
        
        let output = viewModel.transform(
            input: UpdateProfileViewModel.Input(
                loadTrigger: self.loadTrigger.asDriverOnErrorJustComplete(),
                emailTrigger: self.emailTrigger.asDriverOnErrorJustComplete(),
                nameTrigger: self.nameTrigger.asDriverOnErrorJustComplete(),
                descriptionTrigger: self.descTrigger.asDriverOnErrorJustComplete(),
                phoneNumberTrigger: self.numberTrigger.asDriverOnErrorJustComplete(),
                newPasswordTrigger: self.newPasswordTrigger.asDriverOnErrorJustComplete(),
                passwordTrigger: self.passwordTrigger.asDriverOnErrorJustComplete(),
                imageTrigger: self.imageTrigger.asDriverOnErrorJustComplete(),
                genderTrigger: self.genderTrigger.asDriverOnErrorJustComplete(),
                birthDateTrigger: self.dateSelected.asDriverOnErrorJustComplete(),
                editTrigger: self.editButton.rx.tap.asDriverOnErrorJustComplete()
            )
        )
        
            self.emailTrigger.accept("")
            self.nameTrigger.accept("")
            self.descTrigger.accept("")
            self.numberTrigger.accept("")
            self.newPasswordTrigger.accept("")
            self.passwordTrigger.accept("")
            self.imageTrigger.accept("")
            self.genderTrigger.accept("")
            self.dateSelected.accept("")
        
        datePicker.rx.date.asDriver().drive(onNext:{ date in
            self.dateField.text = date.formatDate(format: "dd MMMM yyyy")
            self.dateSelected.accept(date.formatDate(format: "dd MMMM yyyy"))
        }).disposed(by: self.rx.disposeBag)
        
        self.disposeBag.insert(
            output.data.drive(onNext: { [weak self] data in
                guard let self = self else { return }
                
                self.setData(data)
            }),
            output.success.drive(onNext: { [weak self] success in
                guard let self = self else { return }
                
                self.presentPopUp(title: "Success", message: "Successfully edited your account.", actions: [UIAlertAction(title: "OK", style: .default, handler: { _ in 
                    self.dismiss(animated: true, completion: nil)
                })], completion: nil)
            }),
            output.erorr.drive(onNext: { [weak self] message in
                guard let self = self else { return }
                
                self.presentPopUp(title: "Error", message: message, actions: [UIAlertAction(title: "OK", style: .default, handler: nil)], completion: nil)
            })
        )
    }
    
    private func setupView() {
        self.profileImage.layer.cornerRadius = self.profileImage.bounds.width / 2
        editButton.layer.cornerRadius = 6
        datePicker.maximumDate = Date()
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        self.dateField.inputView = datePicker
    }
    
    private func setData(_ data: ProfileModel) {
        let role = viewModel.checkUserRole(data.profileEmail)
        if role == 1 {
            self.genderView.isHidden = true
            self.phoneView.isHidden = true
            self.birthDateView.isHidden = true
        }
        self.profileImage.sd_setImage(with: URL(string: data.profileImageURL), placeholderImage: #imageLiteral(resourceName: "ic-user"))
        self.emailField.text = data.profileEmail
        self.emailTrigger.accept(data.profileEmail)
        self.nameField.text = data.profileName
        self.nameTrigger.accept(data.profileName)
        self.descriptionField.text = data.profileDescription
        self.descTrigger.accept(data.profileDescription)
        
        if data.profileOtherItems.count != 0 {
            if data.profileOtherItems[0].1.lowercased() == "male" {
                self.maleCheckBox.image = UIImage(systemName: "circle.fill")
            } else if data.profileOtherItems[0].1.lowercased() == "female" {
                self.femaleCheckBox.image = UIImage(systemName: "circle.fill")
            }
            self.genderTrigger.accept(data.profileOtherItems[0].1)
            self.phoneNumberField.text = data.profileOtherItems[2].1
            self.numberTrigger.accept(data.profileOtherItems[2].1)
            self.dateField.text = data.profileOtherItems[1].1
            self.dateSelected.accept(data.profileOtherItems[1].1)
        }
        self.profileImageField.text = data.profileImageURL
        self.imageTrigger.accept(data.profileImageURL)
    }
    
    @IBAction func maleTapped(_ sender: Any) {
        resetCheckbox()
        maleCheckBox.image = UIImage(systemName: "circle.fill")
        genderTrigger.accept("Male")
    }
    
    @IBAction func femaleTapped(_ sender: Any) {
        resetCheckbox()
        femaleCheckBox.image = UIImage(systemName: "circle.fill")
        genderTrigger.accept("Female")
    }
    
    @IBAction func editTapped(_ sender: Any) {
        self.editTrigger.accept(())
    }
    
    @IBAction func pasteTapepd(_ sender: Any) {
        self.scrollView.scrollToTop(animated: true)
        profileImageField.text = UIPasteboard.general.string
        self.profileImage.sd_setImage(with: URL(string: UIPasteboard.general.string ?? ""), placeholderImage: #imageLiteral(resourceName: "ic-user"))
        self.imageTrigger.accept(UIPasteboard.general.string ?? "")
    }
    
    @IBAction func profileImageEdit(_ sender: Any) {
        self.imageTrigger.accept(self.profileImageField.text ?? "")
    }
    
    @IBAction func currentPasswordEdit(_ sender: Any) {
        self.passwordTrigger.accept(self.currentPasswordField.text ?? "")
    }
    
    @IBAction func newPasswordEdit(_ sender: Any) {
        self.newPasswordTrigger.accept(self.passwordField.text ?? "")
    }
    
    @IBAction func phoneNumberEdit(_ sender: Any) {
        self.numberTrigger.accept(self.phoneNumberField.text ?? "")
    }
    
    @IBAction func descEdit(_ sender: Any) {
        self.descTrigger.accept(self.descriptionField.text ?? "")
    }
    
    @IBAction func nameEdit(_ sender: Any) {
        self.nameTrigger.accept(self.nameField.text ?? "")
    }
    
    @IBAction func emailEdit(_ sender: Any) {
        self.emailTrigger.accept(self.emailField.text ?? "")
    }
    
    func resetCheckbox() {
        maleCheckBox.image = UIImage(systemName: "circle")
        femaleCheckBox.image = UIImage(systemName: "circle")
    }
}

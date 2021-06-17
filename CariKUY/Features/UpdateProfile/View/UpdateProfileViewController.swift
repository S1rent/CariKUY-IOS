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
    @IBOutlet weak var currentPasswordField: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    let datePicker = UIDatePicker()
    let viewModel = UpdateProfileViewModel()
    
    let loadTrigger = BehaviorRelay<Void>(value: ())
    let editTrigger = PublishRelay<Void>()
    let dateSelected = PublishRelay<String>()
    let genderTrigger = PublishRelay<String>()
    let imageTrigger = PublishRelay<String>()
    
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
                emailTrigger: self.emailField.rx.text.orEmpty.asDriverOnErrorJustComplete().debounce(RxTimeInterval.milliseconds(300)),
                nameTrigger: self.nameField.rx.text.orEmpty.asDriverOnErrorJustComplete().debounce(RxTimeInterval.milliseconds(300)),
                descriptionTrigger: self.descriptionField.rx.text.orEmpty.asDriverOnErrorJustComplete().debounce(RxTimeInterval.milliseconds(300)),
                phoneNumberTrigger: self.phoneNumberField.rx.text.orEmpty.asDriverOnErrorJustComplete().debounce(RxTimeInterval.milliseconds(300)),
                newPasswordTrigger: self.passwordField.rx.text.orEmpty.asDriverOnErrorJustComplete().debounce(RxTimeInterval.milliseconds(300)),
                passwordTrigger: self.currentPasswordField.rx.text.orEmpty.asDriverOnErrorJustComplete().debounce(RxTimeInterval.milliseconds(300)),
                imageTrigger: self.imageTrigger.asDriverOnErrorJustComplete(),
                genderTrigger: self.genderTrigger.asDriverOnErrorJustComplete(),
                birthDateTrigger: self.dateSelected.asDriverOnErrorJustComplete(),
                editTrigger: self.editTrigger.asDriverOnErrorJustComplete()
            )
        )
        
        self.disposeBag.insert(
            output.data.drive(onNext: { [weak self] data in
                guard let self = self else { return }
                
                self.setData(data)
            }),
            output.success.drive(onNext: { [weak self] success in
                guard let self = self else { return }
                
                if succ
            }),
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
        
        datePicker.rx.date.asDriver().skip(1).drive(onNext:{ date in
            self.dateField.text = date.formatDate(format: "dd MMMM yyyy")
            self.dateSelected.accept(date.formatDate(format: "dd MMMM yyyy"))
        }).disposed(by: self.rx.disposeBag)
    }
    
    private func setData(_ data: ProfileModel) {
        self.emailField.text = data.profileEmail
        self.nameField.text = data.profileName
        self.descriptionField.text = data.profileDescription
        if data.profileOtherItems.count != 0 {
            if data.profileOtherItems[0].1.lowercased() == "male" {
                self.maleCheckBox.image = UIImage(systemName: "circle.fill")
            } else if data.profileOtherItems[0].1.lowercased() == "female" {
                self.femaleCheckBox.image = UIImage(systemName: "circle.fill")
            }
            self.phoneNumberField.text = data.profileOtherItems[2].1
            self.dateField.text = data.profileOtherItems[1].1
        }
        self.profileImageField.text = data.profileImageURL
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
    
    
    func resetCheckbox() {
        maleCheckBox.image = UIImage(systemName: "circle")
        femaleCheckBox.image = UIImage(systemName: "circle")
    }
}

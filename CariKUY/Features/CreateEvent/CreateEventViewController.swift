//
//  CreateEventViewController.swift
//  CariKUY
//
//  Created by IT Division on 18/06/21.
//

import UIKit
import RxSwift
import RxCocoa

class CreateEventViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imagePicture: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var pictureField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var requirementField: UITextView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var eventTypeField: UITextField!
    
    let datePicker = UIDatePicker()
    let pictureTrigger = PublishRelay<String>()
    let requirementTrigger = PublishRelay<String>()
    let dateTrigger = PublishRelay<String>()
    let nameTrigger = PublishRelay<String>()
    let descriptionTrigger = PublishRelay<String>()
    let typeTrigger = PublishRelay<String>()
    
    let disposeBag = DisposeBag()
    let viewModel = CreateEventViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Create Event"
        
        setupView()
        bindUI()
    }
    
    func bindUI() {
        datePicker.rx.date.asDriver().drive(onNext:{ date in
            self.dateField.text = date.formatDate(format: "dd MMMM yyyy")
            self.dateTrigger.accept(date.formatDate(format: "dd MMMM yyyy"))
        }).disposed(by: self.rx.disposeBag)
        
        let output = viewModel.transform(input: CreateEventViewModel.Input(
            submitTrigger: self.createButton.rx.tap.asDriverOnErrorJustComplete(),
            pictureTrigger: self.pictureTrigger.asDriverOnErrorJustComplete(),
            requirementTrigger: self.requirementTrigger.asDriverOnErrorJustComplete(),
            dateTrigger: self.dateTrigger.asDriverOnErrorJustComplete(),
            nameTrigger: self.nameTrigger.asDriverOnErrorJustComplete(),
            descriptionTrigger: self.descriptionTrigger.asDriverOnErrorJustComplete(),
            typeTrigger: self.typeTrigger.asDriverOnErrorJustComplete()
        ))
        
        pictureTrigger.accept("")
        requirementTrigger.accept("")
        dateTrigger.accept("")
        nameTrigger.accept("")
        descriptionTrigger.accept("")
        typeTrigger.accept("")
        
        self.disposeBag.insert(
            output.success.drive(onNext: { [weak self] success in
                guard let self = self else { return }
                
                self.presentPopUp(title: "Success", message: success.rawValue, actions: [UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.dismiss(animated: true, completion: nil)
                    DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                        self.navigationController?.popViewController(animated: true)
                    })
                })], completion: nil)
            }),
            output.error.drive(onNext: { [weak self] message in
                guard let self = self else { return }
                
                self.presentPopUp(title: "Error", message: message, actions: [UIAlertAction(title: "OK", style: .default, handler: nil)], completion: nil)
            })
        )
    }
    
    func setupView() {
        self.editButtonItem.title = "Edit"
        self.createButton.layer.cornerRadius = 6
        self.descriptionField.layer.borderWidth = 0.5
        self.descriptionField.layer.borderColor = UIColor.lightGray.cgColor
        self.descriptionField.layer.cornerRadius = 6
        self.requirementField.layer.borderWidth = 0.5
        self.requirementField.layer.borderColor = UIColor.lightGray.cgColor
        self.requirementField.layer.cornerRadius = 6
        
        self.descriptionField.delegate = self
        self.requirementField.delegate = self
        
        datePicker.minimumDate = Date()
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        self.dateField.inputView = datePicker
    }
    
    @IBAction func pasteTapped(_ sender: Any) {
        self.scrollView.scrollToTop(animated: true)
        self.imagePicture.sd_setImage(with: URL(string: UIPasteboard.general.string ?? ""), placeholderImage: UIImage(systemName: "camera"))
        self.pictureTrigger.accept(UIPasteboard.general.string ?? "")
        self.pictureField.text = UIPasteboard.general.string
    }
    
    
    @IBAction func typeChanged(_ sender: Any) {
        self.typeTrigger.accept(self.eventTypeField.text ?? "")
    }
    
    @IBAction func nameChanged(_ sender: Any) {
        self.nameTrigger.accept(self.nameField.text ?? "")
    }
    
}

extension CreateEventViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView == self.descriptionField {
            self.descriptionTrigger.accept(self.descriptionField.text)
        } else {
            self.requirementTrigger.accept(self.requirementField.text)
        }
    }
}

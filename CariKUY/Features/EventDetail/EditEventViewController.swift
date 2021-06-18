//
//  EditEventViewController.swift
//  CariKUY
//
//  Created by IT Division on 18/06/21.
//

import UIKit

class EditEventViewController: UIViewController {
    
    @IBOutlet weak var imgEventPictur: UIImageView!
    @IBOutlet weak var tvRequirement: UITextView!
    @IBOutlet weak var tvDate: UITextField!
    @IBOutlet weak var tvPicture: UITextField!
    @IBOutlet weak var tvDesc: UITextView!
    @IBOutlet weak var tvType: UITextField!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var tvName: UITextField!
    
    let datePicker = UIDatePicker()
    let data: EventModel
    let callback: () -> Void
    
    init(_ data: EventModel, _ callback: @escaping (() -> Void)) {
        self.data = data
        self.callback = callback
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupView()
        bindUI()
    }
    
    func setupView() {
        datePicker.minimumDate = Date()
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        tvDate.inputView = datePicker
        
        self.imgEventPictur.sd_setImage(with: URL(string: self.data.eventPicture), placeholderImage: UIImage(systemName: "camera"))
        self.tvName.text = data.eventName
        tvType.text = data.eventType
        tvDesc.text = data.eventDesc
        tvPicture.text = data.eventPicture
        tvRequirement.text = data.eventReq
        tvDate.text = data.eventDate
        tvDesc.layer.cornerRadius = 6
        tvRequirement.layer.cornerRadius = 6
        editButton.layer.cornerRadius = 6
    }
    
    func bindUI() {
        datePicker.rx.date.asDriver().drive(onNext:{ date in
            self.tvDate.text = date.formatDate(format: "dd MMMM yyyy")
        }).disposed(by: self.rx.disposeBag)
        
        self.editButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            guard let self = self else { return }
            
            let result = EventRepository.shared.editEvent(eventID: self.data.eventID, date: self.tvDate.text ?? "")
            
            if result == .success {
                self.presentPopUp(title: "Success", message: "Successfully edit event.", actions: [UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.dismiss(animated: true, completion: nil)
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                            self.callback()
                        })
                        self.navigationController?.popViewController(animated: true)
                    })
                })], completion: nil)
            }
        }).disposed(by: self.rx.disposeBag)
    }

}

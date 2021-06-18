//
//  EventDetailViewController.swift
//  CariKUY
//
//  Created by IT Division on 18/06/21.
//

import UIKit
import RxSwift
import RxCocoa

class EventDetailViewController: UIViewController {
    
    @IBOutlet weak var labelParticipants: UILabel!
    @IBOutlet weak var imgEventPicture: UIImageView!
    @IBOutlet weak var labelEventDate: UILabel!
    @IBOutlet weak var labelEventType: UILabel!
    @IBOutlet weak var buttonDelete: UIButton!
    @IBOutlet weak var buttonEdit: UIButton!
    @IBOutlet weak var buttonRegister: UIButton!
    @IBOutlet weak var creatorActionView: UIStackView!
    @IBOutlet weak var registerView: UIView!
    @IBOutlet weak var participantInitView: UIView!
    @IBOutlet weak var participantStackView: UIStackView!
    @IBOutlet weak var participantsView: UIView!
    @IBOutlet weak var creatorView: UIView!
    @IBOutlet weak var textViewCreatorDescription: UITextView!
    @IBOutlet weak var labelCreatorName: UILabel!
    @IBOutlet weak var textViewRequirement: UITextView!
    @IBOutlet weak var textViewDescription: UITextView!
    @IBOutlet weak var labelEventTitle: UILabel!
    @IBOutlet weak var imgCreatorPicture: UIImageView!
    
    let data: EventModel
    let viewModel: EventDetailViewModel
    let loadTrigger = BehaviorRelay<Void>(value: ())
    
    init(data: EventModel) {
        self.data = data
        self.viewModel = EventDetailViewModel(data: data)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = data.eventName

        self.setupView()
        self.setupData(self.data)
        self.bindUI()
    }
    
    private func bindUI() {
        let output = viewModel.transform(input: EventDetailViewModel.Input(loadTrigger: self.loadTrigger.asDriverOnErrorJustComplete(), participateTrigger: self.buttonRegister.rx.tap.asDriverOnErrorJustComplete()
        ))
        
        self.rx.disposeBag.insert(
            output.creatorData.drive(onNext: { [weak self] data in
                guard let self = self else { return }
                
                if data.count != 0 {
                    self.labelCreatorName.text = data[0].userName
                    self.textViewCreatorDescription.text = data[0].userDescription
                    self.imgCreatorPicture.sd_setImage(with: URL(string: data[0].userProfilePicture), placeholderImage: #imageLiteral(resourceName: "ic-user"))
                }
            }),
            output.successParticipate.drive(onNext: { [weak self] success in
                guard let self = self else { return }
                let user = UserService.shared.getUser()
                if success.0 == .success {
                    if success.1 {
                        self.presentPopUp(title: "Information", message: "Success\nWe will send you a proper invitation to your email (\(user?.userEmail ?? "")).", actions: [UIAlertAction(title: "OK", style: .default, handler: nil)], completion: nil)
                        self.buttonRegister.setTitle("Cancel Participation", for: .normal)
                        self.buttonRegister.backgroundColor = UIColor.red
                    } else {
                        self.presentPopUp(title: "Information", message: "Success.", actions: [UIAlertAction(title: "OK", style: .default, handler: nil)], completion: nil)
                        self.buttonRegister.setTitle("Participate", for: .normal)
                        self.buttonRegister.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.7490196078, blue: 0.1411764706, alpha: 1)
                    }
                }
            }),
            output.participants.drive(onNext: { [weak self] data in
                guard let self = self else { return }
                
                self.setParticipant(data)
            }),
            self.buttonDelete.rx.tap.asDriver().drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                let participantList = ParticipationRepository.shared.getParticipationListByEventID(id: self.data.eventID)
                if participantList.count != 0 {
                    self.presentPopUp(title: "Error", message: "You cannot delete an event that already have a participants.", actions: [UIAlertAction(title: "OK", style: .default, handler: nil)], completion: nil)
                } else {
                    let result = EventRepository.shared.deleteEventByID(eventID: self.data.eventID)
                    if result == .success {
                        self.presentPopUp(title: "Success", message: "Successfully delete event.", actions: [UIAlertAction(title: "OK", style: .default, handler: { _ in
                            self.dismiss(animated: true, completion: nil)
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                                self.navigationController?.popViewController(animated: true)
                            })
                        })], completion: nil)
                    }
                }
            })
        )
    }
    
    private func setupData(_ data: EventModel) {
        self.imgEventPicture.sd_setImage(with: URL(string: data.eventPicture), placeholderImage: UIImage(systemName: "camera"))
        self.labelEventTitle.text = data.eventName
        self.labelEventType.text = data.eventType
        self.labelEventDate.text = "Event Date: \(data.eventDate)"
        self.textViewDescription.text = data.eventDesc
        self.textViewRequirement.text = data.eventReq
    }
    
    func setupView() {
        self.imgCreatorPicture.layer.cornerRadius = self.imgCreatorPicture.bounds.width / 2
        self.participantStackView.safelyRemoveAllArrangedSubviews()
        self.textViewRequirement.layer.borderColor = UIColor.black.cgColor
        self.textViewRequirement.layer.borderWidth = 2
        self.textViewRequirement.layer.cornerRadius = 6
        
        self.textViewDescription.layer.borderColor = UIColor.black.cgColor
        self.textViewDescription.layer.borderWidth = 2
        self.textViewDescription.layer.cornerRadius = 6
        
        self.creatorView.layer.borderColor = UIColor.black.cgColor
        self.creatorView.layer.borderWidth = 2
        self.creatorView.layer.cornerRadius = 6
        
        self.participantsView.layer.borderColor = UIColor.black.cgColor
        self.participantsView.layer.borderWidth = 2
        self.participantsView.layer.cornerRadius = 6
        
        let user = UserService.shared.getUser()
        let role = self.viewModel.checkUserRole(user?.userEmail ?? "")
        if role == 0 {
            self.creatorActionView.isHidden = true
            self.buttonRegister.layer.cornerRadius = 6
            self.labelParticipants.snp.remakeConstraints { remake in
                remake.height.equalTo(0)
            }
            
            let results = ParticipationRepository.shared.getParticipationListBySeekerID(id: user?.userID ?? "")
            
            for result in results {
                if result.eventID == self.data.eventID {
                    self.buttonRegister.setTitle("Cancel Participation", for: .normal)
                    self.buttonRegister.backgroundColor = UIColor.red
                    return
                }
            }
            self.buttonRegister.setTitle("Participate", for: .normal)
            self.buttonRegister.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.7490196078, blue: 0.1411764706, alpha: 1)
            
        } else if role == 1 && self.data.creatorID == (user?.userID ?? "") {
            self.registerView.isHidden = true
            self.buttonEdit.layer.cornerRadius = 6
            self.buttonDelete.layer.cornerRadius = 6
        } else {
            return
        }
    }
    
    func setParticipant(_ data: [Seeker]) {
        self.participantStackView.safelyRemoveAllArrangedSubviews()
        
        for seeker in data {
            let itemView = ParticipantItemView(data: seeker, callBack: self.navigateToParticipantDetail)
            itemView.labelUserName.text = seeker.userName
            itemView.imageUser.sd_setImage(with: URL(string: seeker.userProfilePicture), placeholderImage: #imageLiteral(resourceName: "ic-user"))
            self.participantStackView.addArrangedSubview(itemView)
        }
        
        if data.isEmpty {
            let view = UIView()
            let label = UILabel()
            label.text = "No participants yet."
            label.font = .systemFont(ofSize: 16)
            view.addSubview(label)
            label.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()
            }
            self.participantStackView.addArrangedSubview(view)
            view.snp.makeConstraints { make in
                make.height.equalTo(30)
            }
        }
    }
    
    func navigateToParticipantDetail(_ data: Seeker) {
        let vc = ParticipantDetailViewController(data: data)
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

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
    
    let data: EventModel
    let viewModel = EventDetailViewModel()
    
    init(data: EventModel) {
        self.data = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
        self.setupData(self.data)
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
        
        
        let role = self.viewModel.checkUserRole()
        
    }

}

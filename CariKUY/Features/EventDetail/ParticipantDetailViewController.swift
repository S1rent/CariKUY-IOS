//
//  ParticipantDetailViewController.swift
//  CariKUY
//
//  Created by IT Division on 18/06/21.
//

import UIKit
import RxSwift
import RxCocoa

class ParticipantDetailViewController: UIViewController {
    
    
    @IBOutlet weak var stackViewWrapper: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var tvDesc: UITextView!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    
    let data: Seeker
    
    init(data: Seeker){
        self.data = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Participant Detail"
        
        setupView()
        setData()
    }
    
    func setupView() {
        tvDesc.layer.cornerRadius = 6
        tvDesc.layer.borderWidth = 2
        tvDesc.layer.borderColor = UIColor.black.cgColor
        imageProfile.layer.cornerRadius = imageProfile.layer.bounds.width / 2
        stackViewWrapper.layer.borderColor = UIColor.black.cgColor
        stackViewWrapper.layer.borderWidth = 2
        stackViewWrapper.layer.cornerRadius = 6
    }

    func setData() {
        stackView.safelyRemoveAllArrangedSubviews()
        
        labelName.text = data.userName
        labelEmail.text = data.userEmail
        imageProfile.sd_setImage(with: URL(string: data.userProfilePicture), placeholderImage: #imageLiteral(resourceName: "ic-user"))
        tvDesc.text = ((data.userDescription) == "-") ? "\"Short description about user.\"" :
            """
            \"\(data.userDescription)\"
            """
        let otherItems = [("Gender", data.seekerGender), ("Birth date", data.seekerBirthDate), ("Phone number", data.seekerPhoneNumber)]
        
        for item in otherItems {
            let itemView = ProfileItemView()
            
            itemView.labelTitle.text = item.0
            itemView.labelDescription.text = item.1
            
            self.stackView.addArrangedSubview(itemView)
            itemView.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(16)
                make.trailing.equalToSuperview().offset(-16)
            }
        }
    }
    
}

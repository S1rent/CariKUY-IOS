//
//  ProfileViewController.swift
//  CariKUY
//
//  Created by IT Division on 17/06/21.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var buttonLogout: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var initView: UIView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLable: UILabel!
    
    let changeTitle: ((_ title: String) -> Void)
    
    init(callback: @escaping ((_ title: String) -> Void)) {
        self.changeTitle = callback
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupData() {
        if let user = UserService.shared.getUser() {
            nameLabel.text = user.userName ?? "-"
            emailLable.text = user.userEmail ?? "-"
            imageProfile.sd_setImage(with: URL(string: user.userProfilePicture ?? ""), placeholderImage: #imageLiteral(resourceName: "ic-user"))
            descriptionTextView.text = ((user.userDescription ?? "-") == "-") ? "\"Short description about yourself\"" :
                """
                \"\(user.userDescription ?? "-")\"
                """
        } else {
            logout()
        }
    }
    
    private func setupView() {
        buttonLogout.layer.cornerRadius = 6
        descriptionTextView.layer.cornerRadius = 6
        descriptionTextView.layer.borderWidth = 2
        descriptionTextView.layer.borderColor = UIColor.black.cgColor
        imageProfile.layer.cornerRadius = imageProfile.layer.bounds.width / 2
    }
    
    @IBAction func settingTapped(_ sender: Any) {
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        logout()
    }
    
    private func logout() {
        UserService.shared.logout()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
            guard let self = self else { return }
            self.navigateAndSetRootViewController(viewController: LoginViewController())
        })
    }
}

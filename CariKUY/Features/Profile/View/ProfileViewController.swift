//
//  ProfileViewController.swift
//  CariKUY
//
//  Created by IT Division on 17/06/21.
//

import UIKit
import SDWebImage
import RxSwift
import RxCocoa
import SnapKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var buttonLogout: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var initView: UIView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLable: UILabel!
    @IBOutlet weak var stackViewWrapperView: UIView!
    
    let changeTitle: ((_ title: String) -> Void)
    let loadTrigger = BehaviorRelay<Void>(value: ())
    let viewModel = ProfileViewModel()
    let disposeBag = DisposeBag()
    
    init(callback: @escaping ((_ title: String) -> Void)) {
        self.changeTitle = callback
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.changeTitle("Profile")
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        self.loadTrigger.accept(())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bindUI()
    }
    
    private func bindUI() {
        let output = viewModel.transform(
            input: ProfileViewModel.Input(
                loadTrigger: self.loadTrigger.asDriverOnErrorJustComplete()
            )
        )
        
        self.disposeBag.insert(
            output.data.drive(onNext: { [weak self] data in
                guard let self = self else { return }
                
                self.setupData(data)
            })
        )
    }
    
    private func setupData(_ data: ProfileModel) {
        stackView.safelyRemoveAllArrangedSubviews()
        
        nameLabel.text = data.profileName
        emailLable.text = data.profileEmail
        imageProfile.sd_setImage(with: URL(string: data.profileImageURL), placeholderImage: #imageLiteral(resourceName: "ic-user"))
        descriptionTextView.text = ((data.profileDescription) == "-") ? "\"Short description about yourself\"" :
            """
            \"\(data.profileDescription)\"
            """
        
        for item in data.profileOtherItems {
            let itemView = ProfileItemView()
            
            itemView.labelTitle.text = item.0
            itemView.labelDescription.text = item.1
            
            self.stackView.addArrangedSubview(itemView)
            itemView.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(16)
                make.trailing.equalToSuperview().offset(-16)
            }
        }
        
        if data.profileOtherItems.count == 0 {
            self.stackView.isHidden = true
        }
    }
    
    private func setupView() {
        buttonLogout.layer.cornerRadius = 6
        descriptionTextView.layer.cornerRadius = 6
        descriptionTextView.layer.borderWidth = 2
        descriptionTextView.layer.borderColor = UIColor.black.cgColor
        imageProfile.layer.cornerRadius = imageProfile.layer.bounds.width / 2
        stackViewWrapperView.layer.borderColor = UIColor.black.cgColor
        stackViewWrapperView.layer.borderWidth = 2
        stackViewWrapperView.layer.cornerRadius = 6
    }
    
    @IBAction func settingTapped(_ sender: Any) {
        
        let viewController = UpdateProfileViewController()
        UIApplication.topViewController()?.navigationController?.pushViewController(viewController, animated: true)
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

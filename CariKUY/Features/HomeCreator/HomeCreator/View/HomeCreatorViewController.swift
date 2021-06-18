//
//  HomeCreatorViewController.swift
//  CariKUY
//
//  Created by IT Division on 17/06/21.
//

import UIKit
import RxSwift
import RxCocoa

class HomeCreatorViewController: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var initView: UIView!
    
    let viewModel = HomeCreatorViewModel()
    let loadTrigger = PublishRelay<Void>()

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
        self.changeTitle("Home")
        navigationController?.setNavigationBarHidden(false, animated: animated)
        self.loadTrigger.accept(())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bindUI()
    }
    
    func bindUI() {
        let output = viewModel.transform(
            input: HomeCreatorViewModel.Input(
                loadTrigger: self.loadTrigger.asDriverOnErrorJustComplete()
            )
        )
        
        self.rx.disposeBag.insert(
            output.data.drive(onNext: { [weak self] data in
                guard let self = self else { return }
                
                self.setData(data)
            })
        )
    }
    
    func setData(_ eventList: [EventModel]) {
        self.stackView.safelyRemoveAllArrangedSubviews()
        for event in eventList {
            let itemView = EventItemView(data: event, callBack: self.navigateToEventDetail)
            itemView.imgCamera.sd_setImage(with: URL(string: event.eventPicture), placeholderImage: UIImage(systemName: "camera"))
            itemView.labelTitle.text = event.eventName
            itemView.labelType.text = event.eventType
            itemView.labelDate.text = event.eventDate
            self.stackView.addArrangedSubview(itemView)
            itemView.snp.makeConstraints { make in
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
            }
        }
    }
    
    func setupView() {
        self.stackView.safelyRemoveAllArrangedSubviews()
    }
    
    func navigateToEventDetail(_ eventData: EventModel) {
        let viewController = EventDetailViewController(data: eventData)
        UIApplication.topViewController()?.navigationController?.pushViewController(viewController, animated: true)
    }

}

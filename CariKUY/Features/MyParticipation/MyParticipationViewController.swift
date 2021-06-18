//
//  MyParticipationViewController.swift
//  CariKUY
//
//  Created by IT Division on 18/06/21.
//

import UIKit
import RxSwift
import RxCocoa

class MyParticipationViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var initView: UIView!
    
    let viewModel = MyParticipationViewModel()
    let loadTrigger = BehaviorRelay<Void>(value: ())
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
        self.changeTitle("My Participation")
        
        self.loadTrigger.accept(())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindUI()
        setupView()
    }
    
    func bindUI() {
        let output = viewModel.transform(input: MyParticipationViewModel.Input(loadTrigger: self.loadTrigger.asDriverOnErrorJustComplete()
        ))
        
        self.rx.disposeBag.insert(
            output.data.drive(onNext: { [weak self] data in
                guard let self = self else { return }
                
                self.setupData(data)
            })
        )
    }
    
    func setupView() {
        self.stackView.safelyRemoveAllArrangedSubviews()
    }
    
    func setupData(_ data: [EventModel]) {
        self.stackView.safelyRemoveAllArrangedSubviews()
        
        for event in data {
            let itemView = EventItemView(data: event, callBack: self.navigateToDetail)
            itemView.labelTitle.text = event.eventName
            itemView.labelType.text = event.eventType
            itemView.labelDate.text = event.eventDate
            itemView.imgCamera.sd_setImage(with: URL(string: event.eventPicture), placeholderImage: UIImage(systemName: "camera"))
            self.stackView.addArrangedSubview(itemView)
        }
    }
    
    func navigateToDetail(_ eventData: EventModel) {
        let viewController = EventDetailViewController(data: eventData)
        UIApplication.topViewController()?.navigationController?.pushViewController(viewController, animated: true)
    }

}

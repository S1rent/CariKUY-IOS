//
//  SearchViewController.swift
//  CariKUY
//
//  Created by IT Division on 18/06/21.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    
    let query: String
    let type: String
    
    @IBOutlet weak var labelResult: UILabel!
    @IBOutlet weak var initView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    
    let loadTrigger = BehaviorRelay<Void>(value: ())
    let viewModel: SearchViewModel
    
    init(query: String, type: String) {
        self.query = query
        self.type = type
        viewModel = SearchViewModel(query: query, type: type)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Event List"
        
        setupView()
        bindUI()
    }
    
    func bindUI() {
        let output = viewModel.transform(input: SearchViewModel.Input(loadTrigger: self.loadTrigger.asDriverOnErrorJustComplete()))
        self.rx.disposeBag.insert(
            output.data.drive(onNext: { [weak self] data in
                guard let self = self else { return }
                
                self.setData(data)
            })
        )
    }
    
    func setData(_ data: [EventModel]) {
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
    
    func setupView(){
        self.stackView.safelyRemoveAllArrangedSubviews()
        if self.query != "" {
            self.labelResult.text = "Search result for \(self.query)"
        } else {
            self.labelResult.snp.remakeConstraints { remake in
                remake.height.equalTo(0)
            }
            self.stackView.snp.remakeConstraints { remake in
                remake.top.equalToSuperview().offset(16)
            }
        }
    }
    
    func navigateToDetail(_ eventData: EventModel) {
        let viewController = EventDetailViewController(data: eventData)
        UIApplication.topViewController()?.navigationController?.pushViewController(viewController, animated: true)
    }

}

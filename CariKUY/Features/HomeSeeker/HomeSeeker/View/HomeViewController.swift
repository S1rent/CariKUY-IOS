//
//  HomeViewController.swift
//  CariKUY
//
//  Created by IT Division on 17/06/21.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
    @IBOutlet weak var scholarButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var jobCollectionVIew: UICollectionView!
    @IBOutlet weak var otherCollectionView: UICollectionView!
    @IBOutlet weak var competitionCollectionView: UICollectionView!
    @IBOutlet weak var scholarshipCollectionView: UICollectionView!
    @IBOutlet weak var otherButton: UIButton!
    @IBOutlet weak var competitionButton: UIButton!
    @IBOutlet weak var jobButton: UIButton!
    
    var string = ""
    let viewModel = HomeViewModel()
    let changeTitle: ((_ title: String) -> Void)
    
    let loadTrigger = BehaviorRelay<Void>(value: ())
    
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
        
        self.setupView()
        self.setupCollectionView(self.jobCollectionVIew)
        self.setupCollectionView(self.competitionCollectionView)
        self.setupCollectionView(self.otherCollectionView)
        self.setupCollectionView(self.scholarshipCollectionView)
        self.bindUI()
    }
    
    func bindUI() {
        let output = viewModel.transform(
            input: HomeViewModel.Input(
                loadTrigger: self.loadTrigger.asDriverOnErrorJustComplete()
            )
        )
        
        self.rx.disposeBag.insert(
            output.jobs.drive(self.jobCollectionVIew.rx.items(cellIdentifier: HomeCollectionViewCell.identifier, cellType: HomeCollectionViewCell.self)) { (_, data, cell) in
                cell.setData(data)
            },
            output.competitions.drive(self.competitionCollectionView.rx.items(cellIdentifier: HomeCollectionViewCell.identifier, cellType: HomeCollectionViewCell.self)) { (_, data, cell) in
                cell.setData(data)
            },
            output.otherEvents.drive(self.otherCollectionView.rx.items(cellIdentifier: HomeCollectionViewCell.identifier, cellType: HomeCollectionViewCell.self)) { (_, data, cell) in
                cell.setData(data)
            },
            output.scholars.drive(self.scholarshipCollectionView.rx.items(cellIdentifier: HomeCollectionViewCell.identifier, cellType: HomeCollectionViewCell.self)) { (_, data, cell) in
                cell.setData(data)
            },
            searchBar.rx.text.asDriver().skip(1).debounce(RxTimeInterval.milliseconds(300)).drive(onNext: { [weak self] text in
                guard let self = self else { return }
                
                if text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                    if let query = text {
                        if self.string != query {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                                let viewController = SearchViewController(query: query.trimmingCharacters(in: .whitespacesAndNewlines), type: "")
                                self.navigationController?.pushViewController(viewController, animated: true)
                            })
                        }
                        
                        self.string = query
                    }
                }
            }),
            jobButton.rx.tap.asDriver().drive(onNext: { [weak self] text in
                guard let self = self else { return }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    let viewController = SearchViewController(query: "", type: "Job")
                    self.navigationController?.pushViewController(viewController, animated: true)
                })
            }),
            scholarButton.rx.tap.asDriver().drive(onNext: { [weak self] text in
                guard let self = self else { return }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    let viewController = SearchViewController(query: "", type: "Scholarship")
                    self.navigationController?.pushViewController(viewController, animated: true)
                })
            }),
            competitionButton.rx.tap.asDriver().drive(onNext: { [weak self] text in
                guard let self = self else { return }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    let viewController = SearchViewController(query: "", type: "Competition")
                    self.navigationController?.pushViewController(viewController, animated: true)
                })
            }),
            otherButton.rx.tap.asDriver().drive(onNext: { [weak self] text in
                guard let self = self else { return }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    let viewController = SearchViewController(query: "", type: "Other")
                    self.navigationController?.pushViewController(viewController, animated: true)
                })
            })
        )
    }
    
    func setupView() {
        self.jobButton.layer.cornerRadius = 6
        self.otherButton.layer.cornerRadius = 6
        self.scholarButton.layer.cornerRadius = 6
        self.competitionButton.layer.cornerRadius = 6
    }
    
    private func setupCollectionView(_ collectionView: UICollectionView) {
        collectionView.register(HomeCollectionViewCell.uiNib, forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        
        let layout: UICollectionViewFlowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout ?? UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 300, height: 205)
        collectionView.setCollectionViewLayout(layout, animated: true)
        
        collectionView.rx.modelSelected(Any.self)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { data in
                if let event = data as? EventModel {
                    let viewController = EventDetailViewController(data: event)
                    UIApplication.topViewController()?.navigationController?.pushViewController(viewController, animated: true)
                }
                self.deselectCollectionItem(collectionView: collectionView)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.rx.disposeBag)
    }
    
    private func deselectCollectionItem(collectionView: UICollectionView) {
        if let index = collectionView.indexPathsForSelectedItems {
            collectionView.deselectItem(at: index[0], animated: true)
        }
    }

}

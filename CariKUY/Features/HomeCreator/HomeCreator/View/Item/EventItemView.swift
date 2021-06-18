//
//  EventItemView.swift
//  CariKUY
//
//  Created by IT Division on 18/06/21.
//

import UIKit

class EventItemView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var wrapView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var imgCamera: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelType: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        self.bindNib()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindNib() {
        Bundle.main.loadNibNamed(EventItemView.identifier, owner: self, options: nil)
        self.addSubview(self.contentView)
        
        self.contentView.frame = self.bounds
        self.contentView.layer.masksToBounds = true
        
        setupView()
    }
    
    func setupView() {
        headerView.clipsToBounds = true
        headerView.layer.cornerRadius = 6
        headerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        wrapView.layer.cornerRadius = 6
        wrapView.layer.borderWidth = 2
        wrapView.layer.borderColor = UIColor.black.cgColor
        
        bottomView.clipsToBounds = true
        bottomView.layer.cornerRadius = 6
        bottomView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
}



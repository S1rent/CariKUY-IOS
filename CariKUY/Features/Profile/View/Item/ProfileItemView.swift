//
//  ProfileItemView.swift
//  CariKUY
//
//  Created by IT Division on 17/06/21.
//

import UIKit

class ProfileItemView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        self.bindNib()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindNib() {
        Bundle.main.loadNibNamed(ProfileItemView.identifier, owner: self, options: nil)
        self.addSubview(self.contentView)
        
        self.contentView.frame = self.bounds
        self.contentView.layer.masksToBounds = true
    }
}


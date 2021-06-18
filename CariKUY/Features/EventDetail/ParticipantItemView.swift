//
//  ParticipantItemView.swift
//  CariKUY
//
//  Created by IT Division on 18/06/21.
//

import UIKit

class ParticipantItemView: UIView {
    
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet var contentView: UIView!
    
    let data: Seeker
    let callBack: ((_ data: Seeker) -> Void)
    
    init(data: Seeker, callBack: @escaping ((_ data: Seeker) -> Void)) {
        self.data = data
        self.callBack = callBack
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        self.bindNib()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindNib() {
        Bundle.main.loadNibNamed(ParticipantItemView.identifier, owner: self, options: nil)
        self.addSubview(self.contentView)
        
        self.contentView.frame = self.bounds
        self.contentView.layer.masksToBounds = true
        
        self.imageUser.layer.cornerRadius = self.imageUser.bounds.width / 2
    }
    
    @IBAction func viewTapped(_ sender: Any) {
        self.callBack(self.data)
    }
}

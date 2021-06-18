//
//  HomeCollectionViewCell.swift
//  CariKUY
//
//  Created by IT Division on 18/06/21.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var wrapView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var imageEvent: UIImageView!
    @IBOutlet weak var labelEventTitle: UILabel!
    @IBOutlet weak var labelEventDate: UILabel!
    @IBOutlet weak var labelCreatorName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupView()
    }
    
    private func setupView() {
        bottomView.clipsToBounds = true
        bottomView.layer.cornerRadius = 6
        bottomView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        self.wrapView.layer.borderWidth = 4
        self.wrapView.layer.borderColor = UIColor.black.cgColor
        self.wrapView.layer.cornerRadius = 10
        
        imageEvent.clipsToBounds = true
        imageEvent.layer.cornerRadius = 6
        imageEvent.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    public func setData(_ data: EventModel) {
        self.imageEvent.sd_setImage(with: URL(string: data.eventPicture), placeholderImage: UIImage(systemName: "camera"))
        self.labelEventDate.text = "Event Date: \(data.eventDate)"
        self.labelEventTitle.text = data.eventName
        
        let result = CreatorRepository.shared.getCreatorsByID(id: data.creatorID)
        if result.count != 0 {
            self.labelCreatorName.text = result[0].userName
        }
    }

}

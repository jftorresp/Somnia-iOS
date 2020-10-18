//
//  AlarmElement.swift
//  Somnia
//
//  Created by Juan Felipe Torres on 18/10/20.
//

import UIKit

class AlarmElement: UIView {
    
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descRepeatLabel: UILabel!
    
    @IBOutlet weak var onOffSwitch: UISwitch!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: [.topLeft, .topRight], radius: 12.0)
    }
}

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

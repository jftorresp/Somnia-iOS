//
//  AlarmCell.swift
//  Somnia
//
//  Created by Juan Felipe Torres on 28/10/20.
//

import UIKit

class AlarmCell: UITableViewCell {

    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var amLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var isActive: UISwitch!
    @IBOutlet weak var alarmView: UIView!
    @IBOutlet weak var goButton: UIButton!
    
    @IBOutlet weak var trashButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        trashButton.isHidden=true
        goButton.isHidden=true
        trashButton.tintColor = UIColor.red
        alarmView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

    }
    func hola()
    {
        
    }
    
}

//
//  ViewParkingTableViewCell.swift
//  SpotMyParking
//
//  Created by Amandeep Bhavra on 2022-01-25.
//

import UIKit

class ViewParkingTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var carPlateNo: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setParkingHour(hour:Int){
        
        let text = "Parked for"
        
        if hour > 1 {
            self.hoursLabel.text = "\(text) \(hour) hrs"
        } else {
            self.hoursLabel.text = "\(text) \(hour) hr"
        }
    }
}

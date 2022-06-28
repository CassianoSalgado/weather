//
//  CityTableViewCell.swift
//  WeatherApp
//
//  Created by Cassiano Carradore Salgado on 27/06/22.
//

import UIKit

class CityTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

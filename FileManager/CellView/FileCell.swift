//
//  FileCell.swift
//  FileManager
//
//  Created by Sergey on 04.02.2022.
//

import UIKit

class FileCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var cellImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  PersonCell.swift
//  DynamitSampleProject
//
//  Created by Ryan Sjoquist on 4/28/16.
//  Copyright © 2016 Ryan Sjoquist. All rights reserved.
//

import UIKit

class PersonCell: UITableViewCell {

    @IBOutlet var cellImageView: UIImageView?
    @IBOutlet var nameLabel:UILabel?
    
    func setUpCell(name:String, imageURL:NSURL){
        
        nameLabel?.adjustsFontSizeToFitWidth = true
        cellImageView?.hnk_setImageFromURL(imageURL)
        nameLabel?.text = name
    }
    
    
}

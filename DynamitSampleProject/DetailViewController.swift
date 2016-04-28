//
//  DetailViewController.swift
//  DynamitSampleProject
//
//  Created by Ryan Sjoquist on 4/27/16.
//  Copyright © 2016 Ryan Sjoquist. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var nameLabel: UILabel?
    @IBOutlet var phoneLabel:UILabel?
    @IBOutlet var emailLabel:UILabel?
    @IBOutlet var loginLabel:UILabel?
    @IBOutlet var locationLabel:UILabel?
    @IBOutlet var stateLabel:UILabel?
    @IBOutlet var personImageView:UIImageView?
    
    var person:Person? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let person = self.person {
                personImageView?.hnk_setImageFromURL(person.largeImageURL)
                nameLabel?.text = person.firstName + " " + person.lastName
                phoneLabel?.text = "Cell: "+person.phoneNumber
                emailLabel?.text = "email: " + person.email
                loginLabel?.text = "User: "+person.loginUsername+" Password: "+person.loginPassword
                locationLabel?.text = "Address: "+person.streetLocation+", "+person.cityLocation
                stateLabel?.text = person.stateLocation+" "+person.nationality
                nameLabel?.adjustsFontSizeToFitWidth
                phoneLabel?.adjustsFontSizeToFitWidth
                emailLabel?.adjustsFontSizeToFitWidth
                loginLabel?.adjustsFontSizeToFitWidth
                locationLabel?.adjustsFontSizeToFitWidth
                stateLabel?.adjustsFontSizeToFitWidth
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }
    
}


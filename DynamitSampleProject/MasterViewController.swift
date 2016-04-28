//
//  MasterViewController.swift
//  DynamitSampleProject
//
//  Created by Ryan Sjoquist on 4/27/16.
//  Copyright © 2016 Ryan Sjoquist. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController,NSURLSessionDelegate {
    
    let jsonURL = NSURL(string: "http://api.randomuser.me/?results=15")!
    var detailViewController: DetailViewController? = nil
    
    var personData:[Person] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        httpGet(NSMutableURLRequest(URL: jsonURL))
        
        // Do any additional setup after loading the view, typically from a nib.
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }


    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personData.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let person = personData[indexPath.row]
        cell.textLabel?.text = String(person.firstName + "," + person.lastName)
        return cell
    }
    
    func do_refresh() {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView?.reloadData()
        })
    }
    
//MARK : - JSON Parsing
    
    func parseJSON(json:[String:AnyObject]) {
        guard let personArrayJson = json["results"] as? [[String:AnyObject]] else{
            print("invalid result json")
            return
        }
        personData = []
        for personJson in personArrayJson {
            
            if let gender = personJson["gender"] as? String,
                email = personJson["email"] as? String,
                cellNumber = personJson["cell"] as? String,
                phoneNumber = personJson["phone"] as? String,
                pictureJson = personJson["picture"] as? [String:AnyObject],
                loginJson = personJson["login"] as? [String:AnyObject],
                nameJson = personJson["name"] as? [String:AnyObject],
                firstName = nameJson["first"] as? String,
                lastName = nameJson["last"] as? String,
                title = nameJson["title"] as? String,
                locationJson = personJson["location"] as? [String:AnyObject],
                street = locationJson["street"] as? String,
                city = locationJson["city"] as? String,
                state = locationJson["state"] as? String,
                postcodeValue = locationJson["postcode"],
                username = loginJson["username"] as? String,
                password = loginJson["password"] as? String,
                sha256 = loginJson["sha256"] as? String,
                largeImageURLString = pictureJson["large"] as? String,
                mediumImageURLString = pictureJson["medium"] as? String,
                thumbnailImageURLString = pictureJson["thumbnail"] as? String,
                nationality = personJson["nat"] as? String,
                largeImageURL = NSURL(string:largeImageURLString),
                mediumImageURL = NSURL(string:mediumImageURLString),
                thumbnailImageURL = NSURL(string: thumbnailImageURLString)
            {
                let postcode = String(postcodeValue)
                let newPerson = Person(gender: gender,
                                       firstName: firstName,
                                       lastName: lastName,
                                       title: title,
                                       streetLocation: street,
                                       cityLocation: city,
                                       stateLocation: state,
                                       postcode: postcode,
                                       email: email,
                                       loginUsername: username,
                                       loginPassword: password,
                                       loginSHA256: sha256,
                                       phoneNumber: phoneNumber,
                                       cellNumber: cellNumber,
                                       largeImageURL: largeImageURL,
                                       mediumImageURL: mediumImageURL,
                                       thumbnailImageURL: thumbnailImageURL,
                                       nationality: nationality)
                personData.append(newPerson)
            }
            else{
                print("error invalid person entry: \(personJson)")
            }
        }
    }
    
    func httpGet(request:NSMutableURLRequest!) {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config,
                                   delegate: self,
                                   delegateQueue: NSOperationQueue.mainQueue())
        
        let task = session.dataTaskWithRequest(request){
            (data,response,error) -> Void in
            if error == nil{
                let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                self.parseJSON(json as! [String:AnyObject])
                self.do_refresh()
            }
        }
        task.resume()
    }
}


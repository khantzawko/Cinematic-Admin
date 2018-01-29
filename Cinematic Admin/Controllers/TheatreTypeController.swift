//
//  TheatreTypeController.swift
//  Cinematic Admin
//
//  Created by Khant Zaw Ko on 29/1/18.
//  Copyright © 2018 Khant Zaw Ko. All rights reserved.
//

import UIKit
import Firebase

class TheatreTypeController: UITableViewController, UIPopoverPresentationControllerDelegate {
        
    var theatreTypeKeys = [String]()
    var theatreTypeNames = [String]()
    var theatreTypescripts = [String]()
    
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        getTheatreTypeData()
    }

    @IBAction func pressedTheatreType(_ sender: Any) {
        let theatreTypePopoverController = storyboard?.instantiateViewController(withIdentifier: "TheatreTypePopoverController") as! TheatreTypePopoverController
        theatreTypePopoverController.modalPresentationStyle = .popover
        if let popoverController = theatreTypePopoverController.popoverPresentationController {
            popoverController.permittedArrowDirections = .any
            popoverController.delegate = self
        }
        present(theatreTypePopoverController, animated: true, completion: nil)
    }
    
    func getTheatreTypeData() {
        ref = Database.database().reference().child("theatretype")
        ref.observe(DataEventType.childAdded, with: {(snapshot) in
            
            var theatreTypeDict = snapshot.value as! [String : AnyObject]
            
            if  let theatreTypeName = theatreTypeDict["name"],
                let theatreTypescript = theatreTypeDict["typescript"]{
                
                self.theatreTypeKeys.append(snapshot.key)
                self.theatreTypeNames.append(theatreTypeName as! String)
                self.theatreTypescripts.append(theatreTypescript as! String)
            }
            self.tableView.reloadData()
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theatreTypeNames.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TheatreCell", for: indexPath) as! TheatreCell
        cell.theatreType.text = theatreTypeNames[indexPath.row]
        return cell
    }
}

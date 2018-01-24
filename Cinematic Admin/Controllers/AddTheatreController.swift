//
//  AddTheatreController.swift
//  Cinematic Admin
//
//  Created by Khant Zaw Ko on 24/1/18.
//  Copyright © 2018 Khant Zaw Ko. All rights reserved.
//

import UIKit

class AddTheatreController: UITableViewController {
    
    var theatreArray = ["E", "F", "G"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    @IBAction func pressedAddTheatre(_ sender: Any) {
        let alertController = UIAlertController(title: "Add Theatre", message: "Please type in the name of theatre", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: {(_ textField: UITextField) -> () in
            textField.placeholder = "Theatre Name"
        })
        let addAction = UIAlertAction(title: "Add", style: .default, handler: {(_ action: UIAlertAction) -> () in
            self.theatreArray.append(alertController.textFields![0].text!)
            self.tableView.reloadData()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return theatreArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TheatreCell", for: indexPath) as! TheatreCell
        cell.theatreName.text = theatreArray[indexPath.row]
        return cell
    }
}

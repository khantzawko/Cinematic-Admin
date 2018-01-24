//
//  AddCinemaController.swift
//  Cinematic Admin
//
//  Created by Khant Zaw Ko on 24/1/18.
//  Copyright © 2018 Khant Zaw Ko. All rights reserved.
//

import UIKit

class AddCinemaController: UITableViewController {
    
     var cinemaArray = ["A", "B", "C"]

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    @IBAction func pressedAddCinema(_ sender: Any) {
        let alertController = UIAlertController(title: "Add Cinema", message: "Please type in the name of cinema", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: {(_ textField: UITextField) -> () in
            textField.placeholder = "Cinema Name"
        })
        let addAction = UIAlertAction(title: "Add", style: .default, handler: {(_ action: UIAlertAction) -> () in
            self.cinemaArray.append(alertController.textFields![0].text!)
            self.tableView.reloadData()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cinemaArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CinemaCell", for: indexPath) as! CinemaCell
        cell.cinemaName.text = cinemaArray[indexPath.row]
        return cell
    }
    
}

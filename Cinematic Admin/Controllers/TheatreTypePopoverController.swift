//
//  TheatreTypePopoverController.swift
//  Cinematic Admin
//
//  Created by Khant Zaw Ko on 29/1/18.
//  Copyright © 2018 Khant Zaw Ko. All rights reserved.
//

import UIKit
import Firebase

class TheatreTypePopoverController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    let heights: [CGFloat] = [78,300]
    
    var theatreTypeName = String()
    var theatreTypescript = String()
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
    }

    @IBAction func pressedCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressedDone(_ sender: Any) {
        checkTextFields()
    }
    
    func checkTextFields() {
        if theatreTypeName.isEmpty || theatreTypescript.isEmpty {
            alertMessage(title: "Warning!", message: "Incomplete Textfields!")
        } else {
            putTheatreTypeData(name: theatreTypeName, typescript: theatreTypescript)
            dismiss(animated: true, completion: nil)
        }
    }
    
    func alertMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func putTheatreTypeData(name: String, typescript: String) {
        ref = Database.database().reference()
        let key = ref.childByAutoId().key
        
        let path = "theatretype/\(key)"
        let post = ["name": name,
                    "typescript": typescript] as [String : Any]
        
        let updateData = [path:post]
        self.ref.updateChildValues(updateData)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heights.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heights[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TheatreTypeName", for: indexPath) as! PopoverTheatreTypeCell
            cell.theatreTypeNameLabel.text = "Theatre Name"
            cell.theatreTypeName.tag = 100
            cell.theatreTypeName.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
            cell.theatreTypeName.addTarget(self, action: #selector(textFieldShouldReturn), for: .editingDidEndOnExit)
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TheatreTypescript", for: indexPath) as! PopoverTheatreTypeCell
            cell.theatreTypescriptLabel.text = "Theatre Typescript"
            cell.theatreTypescript.tag = 101
            cell.theatreTypescript.delegate = self
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.tag == 100 {
            theatreTypeName = textField.text!
        } else {
            
        }
    }
    
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.tag == 101 {
            theatreTypescript = textView.text!
        } else {
            
        }
    }
}

//
//  MovieTableViewController.swift
//  Cinematic Admin
//
//  Created by Khant Zaw Ko on 18/1/18.
//  Copyright © 2018 Khant Zaw Ko. All rights reserved.
//

import UIKit
import Firebase

class MovieTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
        
    @IBOutlet weak var movieName: UITextField!
    @IBOutlet weak var movieGenre: UITextField!
    @IBOutlet weak var movieDuration: UIPickerView!
    @IBOutlet weak var movieRating: UITextField!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieInfo: UITextView!
    @IBOutlet weak var movieTrailer: UITextField!

    let identifiers = ["Name", "Genre", "Duration", "Rating", "Image", "Info", "Trailer"]
    let heights: [CGFloat] = [75,75,140,75,167,167,75]
    var durationStringArray: [String] = [String]()
    var durationNumberArray: [Int] = [Int]()
    var selectedDuration: Int = Int()
    var downloadURL: String = String()
    var textFields: [UITextField] = [UITextField]()

    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        movieDuration.delegate = self
        movieDuration.dataSource = self
        movieName.delegate = self
        movieGenre.delegate = self
        movieRating.delegate = self
        movieInfo.delegate = self
        movieTrailer.delegate = self
        
        movieImage.layer.cornerRadius = 10
        movieRating.keyboardType = .decimalPad
        movieTrailer.keyboardType = .URL
        
        textFields = [movieName, movieGenre, movieRating, movieTrailer]
        
        setUp()
    }
    
    func setUp(){
        for index in 1...500 {
            if index == 1 {
                durationStringArray.append(String(index) + " minute")
                durationNumberArray.append(index)
            } else {
                durationStringArray.append(String(index) + " minutes")
                durationNumberArray.append(index)
            }
        }
    }
    
    
    // hide textfield and textview
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    // pressed action functions
    
    @IBAction func pressedAddImage(_ sender: Any) {
        
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = .photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true, completion: nil)
    }
    
    @IBAction func pressedDone(_ sender: Any) {
        checkData()
    }
    
    func checkData() {
        
        var isTextFieldEmpty: Bool = false
        
        for textfield in textFields {
            if (textfield.text?.isEmpty)! {
                isTextFieldEmpty = true
            }
        }
        
        if isTextFieldEmpty || (movieInfo.text?.isEmpty)! {
            alertMessage(title: "Warning!", message: "Incomplete Textfields!")
        } else if movieImage.image == nil {
            alertMessage(title: "Warning!", message: "Please add image!")
        } else if Double(movieRating.text!)! > 5.0 {
            alertMessage(title: "Warning!", message: "Rating must be equal or less than 5.0")
        } else {
            alertMessage(title: "Complete!", message: "Uploaded Movie Data")
            putMovieData()
        }
    }
    
    @IBAction func pressedClear(_ sender: Any) {
        clearData()
    }
    
    func clearData() {
        for textfield in textFields {
            textfield.text = ""
        }
        
        movieImage.image = nil
        movieInfo.text = ""
        movieDuration.selectRow(0, inComponent: 0, animated: true)
    }
    
    func alertMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    // firebase function
    
    func putMovieData() {
        ref = Database.database().reference()
        let key = ref.childByAutoId().key
        let storageRef = Storage.storage().reference()
        let fileName = "\(key).jpg"
        let imageRef = storageRef.child("images").child(fileName)
        
        if let uploadData = UIImagePNGRepresentation(movieImage.image!) {
            imageRef.putData(uploadData, metadata: nil, completion: {(metadata, error) in
                if error != nil {
                    print("error")
                    return
                } else {
                    self.downloadURL = (metadata?.downloadURL()?.absoluteString)!
                    let path = "movies/\(key)"
                    let post = ["name": self.movieName.text!,
                                "genre": self.movieGenre.text!,
                                "duration": self.selectedDuration,
                                "rating": Double(self.movieRating.text!)!,
                                "image": self.downloadURL,
                                "info": self.movieInfo.text!,
                                "trailer": self.movieTrailer.text!] as [String : Any]
                    
                    let updateData = [path:post]
                    self.ref.updateChildValues(updateData)
                }
            })
        }
    }

    
    
    // imagepickerview function
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            movieImage.image = image
        } else {
            
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // tableview delegates
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heights[indexPath.row]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    
    // pickerview functions
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return durationStringArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return durationStringArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDuration = durationNumberArray[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}

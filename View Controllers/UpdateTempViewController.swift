//
//  UpdateTempViewController.swift
//  COBSCCOMP191p-022-IOS
//
//  Created by User on 9/20/20.
//  Copyright © 2020 User. All rights reserved.
//

import UIKit
import Firebase

class UpdateTempViewController: UIViewController {
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var tempTextField: UITextField!
    
    let db = Firestore.firestore()
    var documentId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUser()

        // Do any additional setup after loading the view.
    }
    
    func loadUser() {
        tempLabel.text = "Fetching....."
        
        if let uid = Auth.auth().currentUser?.uid {
            db.collection("users").whereField("uid", isEqualTo: uid)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        let document = querySnapshot!.documents[0]
                        
                        self.documentId = document.documentID
                        
                        if let temp = document.data()["temp"] {
                            if let tempC = temp as? String {
                                self.tempLabel.text = "\(tempC) C"
                            }
                        } else {
                            self.tempLabel.text = "Not Updated"
                        }
                    }
            }
        }
    }
    
    @IBAction func updateTemp(_ sender: UIButton) {
        if documentId != "", let temp = tempTextField.text {
            db.collection("users").document(documentId).updateData(["temp": temp, "lastModified": Date()]) {error in
                if let err = error {
                    print(err)
                    return
                }
                self.tempLabel.text = "\(temp) C"
                self.tempTextField.text = ""
            }
        }
    }
}

//
//  UpdateProfileViewController.swift
//  COBSCCOMP191p-022-IOS
//
//  Created by Alwin on 9/26/20.
//  Copyright © 2020 User. All rights reserved.
//

import UIKit
import Firebase

class UpdateProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imgProPic: UIImageView!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    
    var documentId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let profileImageViewAction = UITapGestureRecognizer(target: self, action: #selector(imageUIViewAction(_:)))
        imgProPic.isUserInteractionEnabled = true
        imgProPic.addGestureRecognizer(profileImageViewAction)
    }
    
    func loadUser() {
        if let uid = Auth.auth().currentUser?.uid {
            db.collection("users").whereField("uid", isEqualTo: uid)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        let document = querySnapshot!.documents[0]
                        
                        self.documentId = document.documentID
                        
                        if let firstname = document.data()["firstname"] as? String, let lastname = document.data()["lastname"] as? String {
                            print(document.data())
                            
                            self.txtFirstName.text = firstname
                            self.txtLastName.text = lastname
                            
                        }
                    }
            }
        }
    }
    
    
    @IBAction func profileUpdateButton(_ sender: UIButton) {
        if documentId != "", let firstname = txtFirstName.text, let lastname = txtLastName.text {
            db.collection("users").document(documentId).updateData(["firstname": firstname, "lastname": lastname]) {error in
                if let err = error {
                    print(err)
                    
                    self.txtFirstName.text = ""
                    self.txtLastName.text = ""
                    
                    return
                }
            }
        }
    }
    
    @objc func imageUIViewAction(_ sender:UITapGestureRecognizer){
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        guard let imageData = image.pngData() else {
            return
        }
        
        if let uid = Auth.auth().currentUser?.uid {
            
            let ref = "images/\(uid).png"
            
            storage.child(ref).putData(imageData, metadata: nil, completion: { _, error in
                if let e = error {
                    print(e)
                }
                self.storage.child(ref).downloadURL { (url, error) in
                guard let url = url, error == nil else {
                    return
                }
                
                let urlString = url.absoluteString
                    
                    self.db.collection("users").document(self.documentId).updateData(["profileImage": urlString])
                    
                    let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
                        guard let data = data, error == nil else {
                            return
                        }
                        
                        DispatchQueue.main.async {
                            let image = UIImage(data: data)
                            self.imgProPic.image = image
                        }
                    }
                    
                    task.resume()
                }
            })
        }
    }
}

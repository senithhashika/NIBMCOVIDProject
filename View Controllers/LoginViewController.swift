//
//  LoginViewController.swift
//  COBSCCOMP191p-022-IOS
//
//  Created by User on 9/17/20.
//  Copyright © 2020 User. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController {
     var db: Firestore!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
   
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         setUpElements()
    }
     func setUpElements() {
           
           errorLabel.alpha = 0
           
           // Style the elements
          // Utilities.styleTextField(emailTextField)
         //  Utilities.styleTextField(passwordTextField)
         //  Utilities.styleFilledButton(loginButton)
           
       }
   

    @IBAction func loginTapped(_ sender: Any) {
     
        
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
    
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                
                if error != nil {
                    // Couldn't sign in
                    self.errorLabel.text = error!.localizedDescription
                    self.errorLabel.alpha = 1
                }
                else {
                   //let user =  result?.user.uid
                 //   let userRef = self.db.collection("user")
                 //   let query = userRef.whereField("userrole", isEqualTo: "A")
                    
                 
              
                    
                    let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
                    
                    self.view.window?.rootViewController = homeViewController
                    self.view.window?.makeKeyAndVisible()
                }
            }
        }
        
        
        
        
        
    }
    
     
    


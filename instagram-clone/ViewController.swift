//
//  ViewController.swift
//  instagram-clone
//
//  Created by Edanur Oner on 11.04.2023.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
    }


    @IBAction func signInClicked(_ sender: Any) {
        if emailLabel.text != "" && passwordLabel.text != "" {
            Auth.auth().signIn(withEmail: emailLabel.text!, password: passwordLabel.text!) {
                (authdata, error) in
                
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                }
                else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
                
            }
             
        
        }
        else {
            makeAlert(title: "Error", message: "Username or password!")
        }
            
    }
    
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        
        if emailLabel.text != "" && passwordLabel.text != "" {
            Auth.auth().createUser(withEmail: emailLabel.text!, password: passwordLabel.text!) {
                (authdata, error) in
                
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                }
                else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
                
            }
             
        
        }
        else {
            makeAlert(title: "Error", message: "Username or password!")
        }
        
    }
    
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
}


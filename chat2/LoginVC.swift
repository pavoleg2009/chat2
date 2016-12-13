//
//  LoginVC.swift
//  chat2
//
//  Created by Oleg Pavlichenkov on 12/12/2016.
//  Copyright © 2016 Oleg Pavlichenkov. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    
    @IBOutlet weak var emailField: RoundTextField!
    @IBOutlet weak var passwordField: RoundTextField!

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    deinit {
        AuthService.instance.logout()
    }

    @IBAction func loginPressed(_ sender: Any) {
        
        guard let email = emailField.text, email != "" else {
            let alert = UIAlertController(title: "Username (email) required", message: "Please enter email", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        guard let password = passwordField.text, password != "" else {
            let alert = UIAlertController(title: "Password required", message: "Please enter password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)

            return
        }
        
        // call the login
        AuthService.instance.login(email: email, password: password){ (errMsg, data) in
            guard errMsg == nil else {
                let alert = UIAlertController(title: "Error Authentication", message: errMsg, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        }
        
    }

}

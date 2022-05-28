//
//  ViewController.swift
//  Snapchat
//
//  Created by Mijael Cama on 27/05/22.
//

import UIKit
import FirebaseAuth
class iniciarSesionViewController: UIViewController {

    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func loginTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: userTextField.text!, password: passwordTextField.text!) {(user, error) in
            print("intentando iniciar sesion")
            if error != nil{
                print("se presento el siguiente error \(error)")
            }else{
                print("inicio de sesion exitoso")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}


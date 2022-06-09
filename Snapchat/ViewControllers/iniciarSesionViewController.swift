//
//  ViewController.swift
//  Snapchat
//
//  Created by Mijael Cama on 27/05/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class iniciarSesionViewController: UIViewController {

    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func loginTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: userTextField.text!, password: passwordTextField.text!) {(user, error) in
            print("intentando iniciar sesion")
            if error != nil{
                print("se presento el siguiente error \(error)")
                let alertacarga = UIAlertController(title: "Usuario no encontrado", message: "Para continuar debe registrarse", preferredStyle: .alert)
                let btnok = UIAlertAction(title: "aceptar", style: .default,handler: {(action) in
                    self.performSegue(withIdentifier: "registerSegue", sender: nil)
                })
                let btncancelar = UIAlertAction(title: "cancelar", style: .default)
                alertacarga.addAction(btnok)
                alertacarga.addAction(btncancelar)
                self.present(alertacarga, animated: true,completion: nil)
            }else{
                print("inicio de sesion exitoso")
                self.performSegue(withIdentifier: "iniciarsesionSegue", sender: nil)
            }
        }
    }
    @IBAction func anonimousTapped(_ sender: Any) {
        Auth.auth().signInAnonymously {
            authResult, error in
            print("autenticando como anonimo")
            if error != nil{
                print("se presento el siguiente error \(error)")
            }else{
                print("inicio de sesion como anonimo exitoso")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}


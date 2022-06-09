//
//  RegisterViewController.swift
//  Snapchat
//
//  Created by Mijael Cama on 8/06/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class RegisterViewController: UIViewController {

    
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func registerTapped(_ sender: Any) {
        createUser()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func createUser() {
        Auth.auth().createUser(withEmail: self.userTextField.text!, password: self.passwordTextField.text!,completion:{ (user,error) in
            print("intentando crear un usuario")
            if error != nil {
            print("se presento el siguiente error mientas se creaba el usuario: \(error)")
            }else{
                print("usuario creado")
                Database.database().reference().child("usuarios").child(user!.user.uid).child("email").setValue(user!.user.email)
                let alerta = UIAlertController(title: "creacion de usuario", message: "usuario: \(self.userTextField.text!)", preferredStyle: .alert)
                let btnok = UIAlertAction(title: "aceptar", style: .default,handler: {(action) in
                    self.dismiss(animated: true, completion: nil)
                })
                alerta.addAction(btnok)
                self.present(alerta, animated: true,completion: nil)
            }
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

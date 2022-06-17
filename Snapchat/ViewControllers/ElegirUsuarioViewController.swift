//
//  ElegirUsuarioViewController.swift
//  Snapchat
//
//  Created by Mijael Cama on 6/06/22.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ElegirUsuarioViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usuarios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let usuario = usuarios[indexPath.row]
        cell.textLabel?.text = usuario.email
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let usuario = usuarios[indexPath.row]
        let currentuser = Auth.auth().currentUser?.email
        let snap = ["from" : currentuser , "descripcion" : descrip, "imagenURL" : imagenURL,"imagenID" : imagenID,"audioURL":audioURL,"audioID": audioID]
        Database.database().reference().child("usuarios").child(usuario.uid).child("snaps").childByAutoId().setValue(snap)
        navigationController?.popViewController(animated: true)
    }

    @IBOutlet weak var listaUsuarios: UITableView!
    var usuarios:[Usuario] = []
    var imagenURL = ""
    var descrip = ""
    var imagenID = ""
    var audioID = ""
    var audioURL = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        listaUsuarios.delegate = self
        listaUsuarios.dataSource = self
        // Do any additional setup after loading the view.\
        Database.database().reference().child("usuarios").observe(DataEventType.childAdded, with: {(snapshot) in
                let usuario = Usuario()
            usuario.email = (snapshot.value as! NSDictionary)["email"] as! String
            usuario.uid = snapshot.key
            self.usuarios.append(usuario)
            self.listaUsuarios.reloadData()
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

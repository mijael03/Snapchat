//
//  ImagenViewController.swift
//  Snapchat
//
//  Created by Mijael Cama on 6/06/22.
//

import UIKit
import FirebaseStorage

class ImagenViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var imagePicker = UIImagePickerController()
    @IBAction func camaraTapped(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        present(imagePicker,animated: true,completion: nil)
    }
    @IBAction func elegirContactoTapped(_ sender: Any) {
        self.elegirContactoBoton.isEnabled = false
        let imagenesFolder = Storage.storage().reference().child("imagenes")
        let imagenData = imagenView.image?.jpegData(compressionQuality: 0.50)
        let cargarImagen = imagenesFolder.child("\(NSUUID().uuidString).jpg").putData(imagenData!,metadata: nil)
            {(metadata,error) in
                if error != nil {
                    self.mostrarAlerta(titulo: "error", mensaje: "se produjo un error verifique su conexion a internet", accion: "Aceptar")
                    self.elegirContactoBoton.isEnabled = true
                    print("ocurrio un error al ubir imagen: \(error)")
                }else{
                    self.performSegue(withIdentifier: "seleccionarContactoSegue", sender: nil)
                }
            }
        let alertacarga = UIAlertController(title: "cargando imagen ...", message: "0%", preferredStyle: .alert)
        let progresocarga:UIProgressView = UIProgressView(progressViewStyle: .default)
        cargarImagen.observe(.progress) {
            (snapshot) in
            let porcentaje = Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            print(porcentaje)
            progresocarga.setProgress(Float(porcentaje), animated: true)
            progresocarga.frame = CGRect(x:10,y:70,width: 250,height: 0)
            alertacarga.message = String(round(porcentaje*100.00)) + " %"
            if porcentaje>1.0 {
                alertacarga.dismiss(animated: true)
            }
        }
        let btnok = UIAlertAction(title: "aceptar", style: .default)
        alertacarga.addAction(btnok)
        alertacarga.view.addSubview(progresocarga)
        present(alertacarga, animated: true,completion: nil)

    }
    @IBOutlet weak var imagenView: UIImageView!
    @IBOutlet weak var descripcionTextField: UITextField!
    @IBOutlet weak var elegirContactoBoton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        elegirContactoBoton.isEnabled = false
        // Do any additional setup after loading the view.
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imagenView.image = image
        imagenView.backgroundColor = UIColor.clear
        elegirContactoBoton.isEnabled = true
        imagePicker.dismiss(animated: true)
    }
    func mostrarAlerta(titulo: String,mensaje: String, accion: String){
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btncancelok = UIAlertAction(title: accion, style: .default,handler: nil)
        alerta.addAction(btncancelok)
        present(alerta,animated: true,completion: nil)
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

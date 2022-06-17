//
//  ImagenViewController.swift
//  Snapchat
//
//  Created by Mijael Cama on 6/06/22.
//

import UIKit
import FirebaseStorage
import AVFoundation

class ImagenViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var imagePicker = UIImagePickerController()
    var imagenID = "image-\(NSUUID().uuidString)"
    var audioID = "audio-\(NSUUID().uuidString)"
    var audioURL:URL?
    var firebaseAudioUrl:String = ""
    var grabarAudio:AVAudioRecorder?
    @IBAction func camaraTapped(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        present(imagePicker,animated: true,completion: nil)
    }
    @IBAction func elegirContactoTapped(_ sender: Any) {
        self.elegirContactoBoton.isEnabled = false
        let imagenesFolder = Storage.storage().reference().child("imagenes")
        let imagenData = imagenView.image?.jpegData(compressionQuality: 0.50)
        let cargarImagen = imagenesFolder.child("\(imagenID).jpg")
            cargarImagen.putData(imagenData!,metadata: nil)
            {(metadata,error) in
                if error != nil {
                    self.mostrarAlerta(titulo: "error", mensaje: "se produjo un error verifique su conexion a internet", accion: "Aceptar")
                    self.elegirContactoBoton.isEnabled = true
                    print("ocurrio un error al subir imagen: \(error)")
                    return
                }else{
                    cargarImagen.downloadURL(completion: {(url,error) in
                        guard let enlaceUrl = url else{
                            self.mostrarAlerta(titulo: "error", mensaje: "se produjo un error al obtener informacion de imagen", accion: "cancelar")
                            self.elegirContactoBoton.isEnabled = true
                            print("ocurrio un error \(error)")
                            return
                        }
                        self.performSegue(withIdentifier: "seleccionarContactoSegue", sender: url?.absoluteString)
                    })
                    
                }
            }
//        let alertacarga = UIAlertController(title: "cargando imagen ...", message: "0%", preferredStyle: .alert)
//        let progresocarga:UIProgressView = UIProgressView(progressViewStyle: .default)
//        cargarImagen.observe(.progress) {
//            (snapshot) in
//            let porcentaje = Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
//            print(porcentaje)
//            progresocarga.setProgress(Float(porcentaje), animated: true)
//            progresocarga.frame = CGRect(x:10,y:70,width: 250,height: 0)
//            alertacarga.message = String(round(porcentaje*100.00)) + " %"
//            if porcentaje>1.0 {
//                alertacarga.dismiss(animated: true)
//            }
//        }
//        let btnok = UIAlertAction(title: "aceptar", style: .default)
//        alertacarga.addAction(btnok)
//        alertacarga.view.addSubview(progresocarga)
//        present(alertacarga, animated: true,completion: nil)

    }
    
    @IBAction func recordAudioTapped(_ sender: Any) {
        if grabarAudio!.isRecording {
            grabarAudio?.stop()
            uploadToFirebase()
            recordAudioButton.isEnabled = false
        }else{
            grabarAudio?.record()
            recordAudioButton.setTitle("parar grbacion", for: .normal)
        }
    }
    @IBOutlet weak var imagenView: UIImageView!
    @IBOutlet weak var descripcionTextField: UITextField!
    @IBOutlet weak var elegirContactoBoton: UIButton!
    @IBOutlet weak var recordAudioButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        configGrabacion()
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
    func configGrabacion(){
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default,options: [])
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            let basePath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath,"audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            
            print("*************************")
            print(audioURL!)
            print("*************************")
            
            var settings:[String:AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
            settings[AVSampleRateKey] = 44100.0 as AnyObject?
            settings[AVNumberOfChannelsKey] = 2 as AnyObject?
            
            grabarAudio = try AVAudioRecorder(url: audioURL!, settings: settings)
            grabarAudio!.prepareToRecord()
        }catch let error as NSError{
            print(error)
        }
    }
    func uploadToFirebase(){
        var audiofile:Data?
        do{
            audiofile = try Data(contentsOf: audioURL!)
        }catch{
            print(error)
        }
        let audiosFolder = Storage.storage().reference().child("audios")
        let cargarAudio = audiosFolder.child("\(audioID).m4a")
        elegirContactoBoton.isEnabled = false
        cargarAudio.putData(audiofile!,metadata: nil)
            {(metadata,error) in
                if error != nil {
                    self.mostrarAlerta(titulo: "error", mensaje: "se produjo un error verifique su conexion a internet", accion: "Aceptar")
                    self.recordAudioButton.isEnabled = true
                    print("ocurrio un error al subir audio: \(error)")
                    return
                }else{
                    cargarAudio.downloadURL(completion: {(url,error) in
                        guard let enlaceUrl = url else{
                            self.mostrarAlerta(titulo: "error", mensaje: "se produjo un error al obtener informacion del audio", accion: "cancelar")
                            print("ocurrio un error \(error)")
                            return
                        }
                        self.firebaseAudioUrl = url!.absoluteString
                        self.elegirContactoBoton.isEnabled = true
                    })
                    
                }
            }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let siguienteVc = segue.destination as! ElegirUsuarioViewController
        siguienteVc.imagenURL = sender as! String
        siguienteVc.descrip = descripcionTextField.text!
        siguienteVc.imagenID = imagenID
        siguienteVc.audioID = audioID
        siguienteVc.audioURL = firebaseAudioUrl
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

//
//  VerSnapViewController.swift
//  Snapchat
//
//  Created by Mijael Cama on 10/06/22.
//

import UIKit
import SDWebImage
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import AVKit
class VerSnapViewController: UIViewController {
    var player = AVPlayer()
    @IBOutlet weak var lblMensaje: UILabel!
    @IBOutlet weak var imageSnap: UIImageView!
    @IBOutlet weak var playAudioButton: UIButton!
    @IBAction func playAudioTapped(_ sender: Any) {
        playAudioButton.isEnabled = false
        loadRadio(radioURL: snap.audioURL)
    }
    var snap = Snap()
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMensaje.text = snap.descrip
        imageSnap.sd_setImage(with: URL(string: snap.imagenURL))
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").child(snap.id).removeValue()
        Storage.storage().reference().child("imagenes").child("\(snap.imagenID).jpg").delete(completion: {(error) in
            print("se elimino correctamente")
        })
    }
    func loadRadio(radioURL: String) {

            guard let url = URL.init(string: radioURL) else { return }
            let playerItem = AVPlayerItem.init(url: url)
            player = AVPlayer.init(playerItem: playerItem)
            player.play()
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

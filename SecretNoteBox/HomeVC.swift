//
//  HomeVC.swift
//  SecretNoteBox
//
//  Created by Apple on 13/03/24.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var imgGif: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imgGif.image = UIImage.gifImageWithName("SecretNoteBox")
        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnMenu(_ sender: Any) {
        
    }
    
}

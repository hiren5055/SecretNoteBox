//
//  HomeVC.swift
//  SecretNoteBox
//
//  Created by Apple on 13/03/24.
//

import UIKit
import SideMenu

class HomeVC: UIViewController {

    @IBOutlet weak var imgGif: UIImageView!
    
    var menu: SideMenuNavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imgGif.image = UIImage.gifImageWithName("SecretNoteBox")
        
        
        let menuViewController = storyboard?.instantiateViewController(withIdentifier: "SideMenuVC")as! SideMenuVC

        menu = SideMenuNavigationController(rootViewController: menuViewController)
        SideMenuManager.default.leftMenuNavigationController = menu
        menu?.leftSide = true
        menu?.setNavigationBarHidden(true, animated: false)
        menu?.presentationStyle = .menuSlideIn
        menu?.menuWidth = max(round(min((UIScreen.main.bounds.width), (UIScreen.main.bounds.height)) * 0.8), 240)
        
    }
    

    @IBAction func btnMenu(_ sender: Any) {
        present(menu!, animated: true)
    }
    
}

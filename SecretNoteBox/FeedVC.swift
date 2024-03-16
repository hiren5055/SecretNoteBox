//
//  FeedVC.swift
//  SecretNoteBox
//
//  Created by Hiren_iDev on 16/03/24.
//

import Foundation
import UIKit

class FeedVC: UIViewController{
    
    @IBOutlet weak var fieldInput: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    @IBAction func btnBack(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btnSend(_ sender: Any) {
        
        guard fieldInput.text.count > 3 else{
            fieldInput.text = "\(["good", "Nice", "Cool", "Amazing"].randomElement()!) App."
            return
        }
        
        let alertController = UIAlertController(title: "Thank You For Feedback.", message: "Go Back To Home Page.", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "OK", style: .default, handler: { alert -> Void in
            self.navigationController?.popToRootViewController(animated: true)
        })
        alertController.addAction(saveAction)
        present(alertController, animated: true, completion: nil)
    }
   

}


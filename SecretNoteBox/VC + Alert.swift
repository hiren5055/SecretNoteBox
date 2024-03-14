//
//  VC + Alert.swift
//  SecretNoteBox
//
//  Created by Apple on 13/03/24.
//

import Foundation
import UIKit

extension UIViewController{
    
    func ShowAlert(title: String, desc: String, btn: (String, UIAlertAction.Style) = ("OK" , .default)){
        
        let alertController = UIAlertController(title: title, message: desc, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: btn.0 , style: btn.1 , handler: { alert -> Void in
            
        })
        alertController.addAction(saveAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
}

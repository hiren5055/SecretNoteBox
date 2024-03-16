//
//  ShareNoteVC.swift
//  SecretNoteBox
//
//  Created by Hiren_iDev on 15/03/24.
//

import UIKit

class ShareNoteVC: UIViewController {

    @IBOutlet weak var viewCard: UIView!
    @IBOutlet weak var viewShare: UIView!
    @IBOutlet var viewEdit: UIVisualEffectView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    
    var initialTransform = CATransform3DIdentity
    var finalTransform = CATransform3DIdentity
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
                view.addGestureRecognizer(panGesture)
        
        viewEdit.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        self.view.addSubview(viewEdit)
        
    }
 
    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
            guard let view = viewCard else { return }

            let translation = sender.translation(in: view.superview)
            let progressX = translation.x / view.bounds.width
            let progressY = translation.y / view.bounds.height

            switch sender.state {
            case .began:
                initialTransform = view.layer.transform

            case .changed:
                let angleX = CGFloat.pi * progressX
                let angleY = CGFloat.pi * progressY
                let rotationTransform = CATransform3DRotate(initialTransform, angleX, 0, 1, 0)
                view.layer.transform = CATransform3DRotate(rotationTransform, angleY, 1, 0, 0)

            case .ended:
                let isHorizontal = abs(translation.x) > abs(translation.y)

                if isHorizontal {
                    let angle = (translation.x > 0) ? CGFloat.pi : -CGFloat.pi
                    finalTransform = CATransform3DRotate(initialTransform, angle, 0, 1, 0)
                } else {
                    let angle = (translation.y > 0) ? CGFloat.pi : -CGFloat.pi
                    finalTransform = CATransform3DRotate(initialTransform, angle, 1, 0, 0)
                }

                
//                UIView.animate(withDuration: 0.3) {
//                    view.layer.transform = self.finalTransform
//                }
                

            default:
                break
            }
        }
    
    
    @IBAction func btnBack(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btnShare(_ sender: Any) {
        
        let img = viewShare.toImage()
        let activityViewController = UIActivityViewController(activityItems: [img!], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func btnEdit(_ sender: Any) {
       
        UIView.animate(withDuration: 0.3) {
            self.viewCard.layer.transform = self.finalTransform
        }
        
        self.view.addSubview(viewEdit)
        
    }
    
    
    @IBAction func btnImg(_ sender: UIButton) {
        
        if sender.tag == 0{
            
            openCamera()
            
        }else{
            
            openGallery()
            
        }
        
        
    }
    
    
    @IBAction func btnCloaseEdit(_ sender: Any) {
        
        viewEdit.removeFromSuperview()
        
    }
    
    @IBAction func btnEditTitle(_ sender: UIButton) {
        
        showAlertWithTextInput { str in
            
            guard let str else{
                return
            }
            
            if sender.tag == 0{
                
                self.lblTitle.text = str
                
            }else{
                
                self.lblDesc.text = str
                
            }
            
        }
        
    }
    
    
    //MARK: Alert With Text Input
    
    func showAlertWithTextInput(completion: @escaping (String?) -> Void) {
        let alertController = UIAlertController(title: "Enter Text", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Enter text"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completion(nil)
        }
        
        let okayAction = UIAlertAction(title: "Okay", style: .default) { _ in
            let textField = alertController.textFields?.first
            let enteredText = textField?.text
            completion(enteredText)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okayAction)
        
        // Present the alert controller
        // Replace `viewController` with the appropriate view controller to present the alert from
        self.present(alertController, animated: true, completion: nil)
    }

    
}


import UIKit

extension ShareNoteVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            
            img.image = pickedImage
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

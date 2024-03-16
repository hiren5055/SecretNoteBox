//
//  ScannerVC.swift
//  SecretNoteBox
//
//  Created by Hiren_iDev on 15/03/24.
//

import UIKit
import AVFoundation

class ScannerVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    @IBOutlet weak var cameraview: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    var captureSession: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var img: UIImage?{
        didSet{
            imageView.image = img
        }
    }
    
    var uId: String? {
        
        didSet{
            
            guard let uId else{
                return
            }
            
            if uId == "demo"{
                
                let vc =  self.storyboard?.instantiateViewController(withIdentifier: "NoteDescVC")as! NoteDescVC
                self.navigationController?.pushViewController(vc, animated: true)
                
                return
                
            }
            
            if #available(iOS 13.0, *) {
                
                DBManager().GetNoteById(id: uId) { note in
                    guard let note else{
                        
                        self.showAlert(title: "This QR is Private Try To Scan Your Note QR.", message: "Try Again.")
                        
                        return
                        
                    }
                    
                    let vc =  self.storyboard?.instantiateViewController(withIdentifier: "NoteDescVC")as! NoteDescVC
                    vc.note = note
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                
            } else {
                
                showAlert(title: "Device OS version is below supported version", message: "")
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupCamera()
    }
    
    func setupCamera() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            showAlert(title: "No Camera", message: "This device does not have a camera.")
            print("No Camera")
            return
        }
        
        guard let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice) else {
            showAlert(title: "Camera Input Failed", message: "Failed to create input from camera.")
            return
        }
        
        let captureSession = AVCaptureSession()
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            showAlert(title: "Camera Input Failed", message: "Failed to add input to capture session.")
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            showAlert(title: "Metadata Output Failed", message: "Failed to add metadata output to capture session.")
            return
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = cameraview.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        cameraview.layer.addSublayer(previewLayer)
        
        self.captureSession = captureSession
        self.previewLayer = previewLayer
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession?.startRunning()
            
        }
        
        
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession?.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            uId = stringValue
            print("Scanned QR Code Text:", stringValue)
        }else{
            showAlert(title: "Scan Fail.", message: "Scan Again.")
        }
    }
    
    func detectQRCode(from image: UIImage) {
        guard let ciImage = CIImage(image: image) else {
            print("Failed to create CIImage from UIImage.")
            return
        }
        
        let options: [String: Any] = [CIDetectorAccuracy: CIDetectorAccuracyHigh]

        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: options)
        
        guard let features = detector?.features(in: ciImage) as? [CIQRCodeFeature] else {
            print("Failed to detect QR code features.")
            return
        }
        
        if let firstFeature = features.first {
            if let qrCodeText = firstFeature.messageString {
                uId = qrCodeText
            } else {
                print("No message string found in QR code feature.")
                showAlert(title: "Scan Fail.", message: "Scan Again.")
            }
        } else {
            print("No QR code found in the image.")
        }
    }
    
    
    @IBAction func scanFromGallery(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func scan(_ sender: Any) {
        if let image = img?.ToJpgData() {
            detectQRCode(from: UIImage(data: image) ?? UIImage())
        } else {
            print("No image found in the image view.")
        }
    }
    
    @IBAction func btnReload(_ sender: Any) {
        setupCamera()
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.originalImage] as? UIImage else { return }
        
        img = image
        
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    #warning("Implement Demo QR For Approvel")
    
    
    
    
    
}



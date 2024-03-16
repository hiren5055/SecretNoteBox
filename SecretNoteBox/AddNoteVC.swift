//
//  AddNoteVC.swift
//  SecretNoteBox
//
//  Created by Hiren_iDev on 14/03/24.
//

import UIKit

class AddNoteVC: UIViewController {

    @IBOutlet weak var lbl1: UILabel!
    
    @IBOutlet weak var lbl2: UILabel!
    
    @IBOutlet weak var lbl3: UILabel!
    
    @IBOutlet weak var lbl4: UILabel!
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var fieldTitle: UITextField!
    
    @IBOutlet weak var fieldDesc: UITextView!
    
    @IBOutlet weak var btnRemove: UIButton!
    
    @IBOutlet weak var btnRecorder: UIButton!
    
    @IBOutlet weak var btnPlayer: UIButton!
    
    @IBOutlet weak var lblCurruntTime: UILabel!
    
    @IBOutlet weak var lblTotalTime: UILabel!
    
    @IBOutlet weak var sldrAudPlay: UISlider!
    
    @IBOutlet weak var imgF1: UIImageView!
    
    @IBOutlet weak var scrl: UIScrollView!
    
    //image picker
    
    let imagePicker = UIImagePickerController()

    var imgSelected: UIImage?{
        
        didSet{
            
            img.image = imgSelected
            
            if imgSelected == nil{
                
                img.isHidden = true
                
                btnRemove.isHidden = true
                
            }else{
                
                img.isHidden = false
                
                btnRemove.isHidden = false
                
            }
        }
    }
    
    //audio recorder
    
    private var recorder: AVAudioRecorder!
    
    private let recorderSetting = [
        
        AVSampleRateKey :
            NSNumber(
            value: 
                Float(44100.0)
            ),
        AVFormatIDKey :
            NSNumber(
            value: Int32(kAudioFormatMPEG4AAC)
            ),
        AVNumberOfChannelsKey :
            NSNumber(
            value: 1
            ),
        AVEncoderAudioQualityKey :
            NSNumber(
            value: Int32(AVAudioQuality.medium.rawValue)
            )
        
    ]
    
    //audio player
    
    var audioPlayer: AVAudioPlayer?
    
    private var timer: Timer?
    
    
    
    //MARK: did load
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        
        configRecord()
        
        sldrAudPlay.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        
        imgF1.image = UIImage.gifImageWithName("f1")
        
        sldrAudPlay.value = 0
    }
    
    
    @IBAction func btnImgActions(_ sender: UIButton) {
        
        switch sender.tag{
            
        case 1:
            openCamera()
            break
            
        case 2:
            openGallery()
            break
            
        default:
            imgSelected = nil
            break
            
        }
        
    }
    
    @IBAction func btnRecordAction(_ sender: UIButton) {
        
        sender.isSelected.toggle()
        
        if sender.isSelected{
            
//            configRecord()
            
            recorder.record()
            
        }else{
            
            recorder.stop()
            
        }
        
        
    }
    
    @IBAction func btnAudioAction(_ sender: UIButton) {
        
        sender.isSelected.toggle()
        
        if sender.isSelected{
            
            do{
                
                audioPlayer = try AVAudioPlayer(contentsOf: recorder.url)
                
                audioPlayer?.delegate = self
                
                audioPlayer?.play()
                
                sldrAudPlay.maximumValue = Float(audioPlayer?.duration ?? 0)
                
                startTimer()
                
            }catch{
                
                ShowAlert(title: "Player Error.", desc: "")
                
            }
            
        }else{
            
            audioPlayer?.pause()
            
        }
        
    }
    
    @IBAction func btnGoTop(_ sender: Any) {
        scrl.setContentOffset(.zero, animated: true)

    }
    
    @IBAction func btnBack(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btnAddNote(_ sender: Any) {
        
        guard let title = fieldTitle.text, title != "" else{
            
            ShowAlert(title: "Add Note Title", desc: "")
            fieldTitle.setNeedsDisplay()
            return
        }
        
        guard let desc = fieldDesc.text, desc != "" else{
            
            ShowAlert(title: "Add Note Description", desc: "")
            fieldDesc.setNeedsDisplay()
            return
        }
        
        if #available(iOS 13.0, *) {
            
            DBManager().AddSimpleNote(title: title, description: desc, images: imgSelected, audio: recorder.url) { str in
                
                self.ShowAlert(title: str, desc: "")
                
            }
            
        } else {
            
            ShowAlert(title: "Update OS To Use This Feature.", desc: "OS version is below supported version.")
            
        }
        
    }
    
    
    deinit {
        
        recorder.stop()
        
        audioPlayer?.stop()
    }
    

}

//MARK: Image Selection

extension AddNoteVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func openGallery() {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            imagePicker.sourceType = .photoLibrary
            
            present(imagePicker, animated: true, completion: nil)
            
        } else {
            
            print("Photo library is not available.")
            
            ShowAlert(title: "No Photo library Available or Allowed To Use.", desc: "Try Another Way or Allow From Settings.")
        }
    }
    
    func openCamera() {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            imagePicker.sourceType = .camera
            
            present(imagePicker, animated: true, completion: nil)
            
        } else {
            
            print("Camera is not available.")
            
            ShowAlert(title: "No Camera Available or Allowed To Use.", desc: "Try Another Way or Allow From Settings.")
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[.editedImage]as? UIImage{
            
            imgSelected = selectedImage
            
        }else if let selectedImage = info[.originalImage] as? UIImage {
        
            imgSelected = selectedImage
            
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
        
    }
}



//MARK: Audio Recorder

import AVFoundation

extension AddNoteVC: AVAudioRecorderDelegate{
    
    private func configRecord() {
        
        AVAudioSession.sharedInstance().requestRecordPermission { (allowed) in
            
            if !allowed {
                
                return
            }
            
        }
        
        let session = AVAudioSession.sharedInstance()
        
        do { 
            
            try session.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker) }
        
        catch {
            
            print("session config failed")
        }
        
        do {
            
            self.recorder = try AVAudioRecorder(url: self.directoryURL()!, settings: self.recorderSetting)
            self.recorder.delegate = self
            self.recorder.prepareToRecord()
            self.recorder.isMeteringEnabled = true
            
        } catch {
            
            print(error.localizedDescription)
            
        }
        
        do {
            
            try AVAudioSession.sharedInstance().setActive(true) }
        
        catch {
            
            print("session active failed")
        }
        
    }
    
    private func directoryURL() -> URL? {
        
        let format = DateFormatter()
        format.dateFormat="yyyy-MM-dd-HH-mm-ss"
        
        let currentFileName = "recording-\(format.string(from: Date())).m4a"
        
        print("Record At This Location:- ",currentFileName)
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let soundFileURL = documentsDirectory.appendingPathComponent(currentFileName)
        
        return soundFileURL
    }
    
    
}

//MARK: Audio Player

extension AddNoteVC: AVAudioPlayerDelegate{
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        audioPlayer?.stop()
        btnPlayer.isSelected = false
        
        timer?.invalidate()
        timer = nil
        sldrAudPlay.value = 0
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        
        if let player = audioPlayer {
            
            player.currentTime = TimeInterval(sender.value)
            
            lblCurruntTime.text = updateTimerLabel(currentTime: player.currentTime)
            
        }
    }
    
    private func startTimer() {
        
        timer?.invalidate()
        
        guard let player = self.audioPlayer else { return }

        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            
            self?.sldrAudPlay.value = Float(player.currentTime)
            self?.lblCurruntTime.text = self?.updateTimerLabel(currentTime: player.currentTime)
        }
        
        lblTotalTime.text = updateTimerLabel(currentTime: player.duration)
        
    }
    
    
    private func updateTimerLabel(currentTime: TimeInterval) -> String{
        
        let minutes = Int(currentTime) / 60
        let seconds = Int(currentTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
        
    }
    
    
}

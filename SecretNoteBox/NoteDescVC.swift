//
//  NoteDescVC.swift
//  SecretNoteBox
//
//  Created by Hiren_iDev on 14/03/24.
//

import UIKit
import AVFoundation

class NoteDescVC: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblDesc: UILabel!
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var sldrAudPlay: UISlider!
    
    @IBOutlet weak var btnPlayer: UIButton!
    
    @IBOutlet weak var lblCurruntTime: UILabel!
    
    @IBOutlet weak var lblTotalTime: UILabel!
    
    @IBOutlet weak var viewPlayer: UIView!
    
    //audio player
    var audioPlayer: AVAudioPlayer?
    
    private var timer: Timer?
    
    var note: Notes?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if note?.audio?.isEmpty ?? false{
            
            sldrAudPlay.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
            
            sldrAudPlay.value = 0
            
        }else{
            
            viewPlayer.isHidden = true
            
        }
        
        if let iData = note?.img, let i = UIImage(data: iData){
            
            img.image = i
            
        }else{
            
            img.isHidden = true
            
        }
        
        lblTitle.text = note?.title
        lblDesc.text = note?.desc
        
    }
    
    
    @IBAction func btnAudioAction(_ sender: UIButton) {
        
        sender.isSelected.toggle()
        
        if sender.isSelected{
            
            do{
                if let audioData = note?.audio{
                    
                    audioPlayer = try AVAudioPlayer(data: audioData)
                    
                }else{
                    
                    ShowAlert(title: "No Audio File To Play.", desc: "")
                    
                }
                
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
    
    @IBAction func btnBack(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
}

//MARK: Audio Player

extension NoteDescVC: AVAudioPlayerDelegate{
    
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


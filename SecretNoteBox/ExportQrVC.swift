//
//  ExportQrVC.swift
//  SecretNoteBox
//
//  Created by Hiren_iDev on 16/03/24.
//

import UIKit

class ExportQrVC: UIViewController {
    
    @IBOutlet weak var tbl: UITableView!
    
    var arrNotes: [Notes] = []{
        didSet{
            tbl.reloadData()
        }
    }
    
    
    //MARK: did load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tbl.delegate = self
        tbl.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if #available(iOS 13.0, *) {
            arrNotes = DBManager().GetSimpleNotes()
        }else{
            ShowAlert(title: "Not Supported OS Version.", desc: "Update OS.")
        }
        
    }
    
    @IBAction func btnBack(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
}

extension ExportQrVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        arrNotes.isEmpty ? 1 : arrNotes.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if arrNotes.isEmpty{
            return tbl.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        }
        
        let cell = tbl.dequeueReusableCell(withIdentifier: "QrNotesCell")as! QrNotesCell
        
        cell.lblTitle.text = arrNotes[indexPath.item].title
        cell.lblDesc.text = arrNotes[indexPath.item].desc
        
        cell.img.image = QrFromStr(from: arrNotes[indexPath.item].id?.uuidString ?? "hiren")
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if arrNotes.isEmpty{
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "AddNoteVC")as! AddNoteVC
            
            navigationController?.pushViewController(vc, animated: true)
            
        }else{
            
            guard let id = arrNotes[indexPath.row].id else{
                self.ShowAlert(title: "QR generating Fail.", desc: "")
                return
            }
            
            guard let img = QrFromStr(from: id.uuidString) else{
                self.ShowAlert(title: "QR generating Fail.", desc: "")
                return
            }
            
            let activityViewController = UIActivityViewController(activityItems: [img], applicationActivities: nil)
            present(activityViewController, animated: true, completion: nil)
        }
        
    }
    
   
    //MARK: Swipe Action
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let actDel = UIContextualAction(style: .normal, title: "DELETE") { _, vie, _ in
            
            vie.backgroundColor = .red
            
        }
        
        let context = UISwipeActionsConfiguration(actions: [actDel])
        
        return context
    }
    
    
    //MARK: QR from id
    
    func QrFromStr(from string: String) -> UIImage?{
        let data = string.data(using: String.Encoding.ascii)
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            if let output = filter.outputImage?.transformed(by: transform) {
                let qrCodeImage = UIImage(ciImage: output)
                return qrCodeImage
            }else{
                print("QR fail")
                return nil
            }
        }else{
            print("QR fail")
            return nil
        }
    }
    
    
}


//MARK: Note Cell

class QrNotesCell: UITableViewCell{
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblDesc: UILabel!
    
}

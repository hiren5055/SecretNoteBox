//
//  MyNotesVC.swift
//  SecretNoteBox
//
//  Created by Apple on 13/03/24.
//

import UIKit

class MyNotesVC: UIViewController {

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


//MARK: Table Manager

extension MyNotesVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        arrNotes.isEmpty ? 1 : arrNotes.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if arrNotes.isEmpty{
            return tbl.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        }
        
        let cell = tbl.dequeueReusableCell(withIdentifier: "NotesCell")as! NotesCell
        
        cell.lblTitle.text = arrNotes[indexPath.item].title
        cell.lblDesc.text = arrNotes[indexPath.item].desc
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if arrNotes.isEmpty{
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "AddNoteVC")as! AddNoteVC
            
            navigationController?.pushViewController(vc, animated: true)
            
        }else{
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "NoteDescVC")as! NoteDescVC
            vc.note = arrNotes[indexPath.item]
            navigationController?.pushViewController(vc, animated: true)
            
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
    
    
}

//MARK: Note Cell

class NotesCell: UITableViewCell{
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblDesc: UILabel!
    
}

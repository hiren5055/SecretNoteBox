//
//  DBManager.swift
//  SecretNoteBox
//
//  Created by Apple on 13/03/24.
//

import Foundation
import CoreData
import UIKit

@available(iOS 13.0, *)

class DBManager {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: Get Simple Notes
    
    func GetSimpleNotes() -> [Notes] {
        
        let arrList = [Notes]()
        
        do{
            let catchdata = try context.fetch(Notes.fetchRequest())as! [Notes]
            return catchdata
        }catch{
            print(error.localizedDescription)
        }
        
        return arrList
        
    }
    
    //MARK: Add PicPin
    
    func AddSimpleNote(title:String, description: String, images: UIImage?, audio: URL?, completion: @escaping (String) -> Void) {
        
        let newNote = Notes(context: context)
        
        newNote.setValue(UUID(), forKey: "id")
        
        newNote.setValue(title, forKey: "title")
        
        newNote.setValue(description, forKey: "desc")
        
        newNote.setValue(images?.pngData(), forKey: "img")
        
        newNote.setValue(Date(), forKey: "time")
        
        
        if let audio = audio, let audioData = try? Data(contentsOf: audio){
            
            newNote.setValue(audioData, forKey: "audio")
            
        }
        
        
        do{
            
            try context.save()
            
            completion("Note Added Successfully.")
            
        }catch{
            
            completion("Note Add Fail.")
        }
        
    }
    
    
    //MARK: Delete Note
    
    func DeleteSimpleNote(note: Notes) -> String{
        
        do{
            
            context.delete(note)
            try context.save()
            
            return "Note Removed Successfully."
            
        }catch{
            
            return "Note Remove Failed."
            
        }
        
    }
    
    //MARK: Get Note By Scanner
    
    func GetNoteById(id: String, completion: @escaping (Notes?) -> Void) {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        
        request.predicate = NSPredicate(format:"id = %@", "\(id)")
        
        do {
            
            let results = try context.fetch(request)
            
            completion(results.first as? Notes)
            
        } catch let error as NSError {
            
            completion(nil)
            print(error.localizedDescription)
            
        }
        
    }
    
    
    func samplecode(id: UUID, completion: @escaping (String) -> Void) {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PicPin")
        request.predicate = NSPredicate(format:"id = %@", "\(id)")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try context.execute(deleteRequest)
            completion("Deleted.")
            print("deleted")
        } catch let error as NSError {
            completion("Delete problem, Try Later.")
            print(error.localizedDescription)
        }
        
    }
    
    
}

//
//  Img + Ext.swift
//  SecretNoteBox
//
//  Created by Hiren_iDev on 16/03/24.
//

import Foundation
import UIKit

extension UIImage{
    func ToJpgData() -> Data? {
        
        guard let jpgData = self.jpegData(compressionQuality: 1.0) else {
            return nil
        }
        
        return jpgData
    }

}

//
//  AlertManager.swift
//  ToDoList
//
//  Created by Dongik Song on 3/22/24.
//

import Foundation
import UIKit

class AlertManager {
    
    var completionHandlers : [() -> Void] = []
    
    func makingAlert(title : String, message: String) -> UIAlertController{
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        return alert
    }
            
    func makingCancel (title: String) -> UIAlertAction {
        
        let cancel = UIAlertAction(title: title, style: .cancel)
        
        return cancel
    }
    
    func makingOK (title: String, completionHander : @escaping () -> Void) -> UIAlertAction {
        let ok = UIAlertAction(title: title, style: .default) { _ in
                self.completionHandlers.append(completionHander)
        }
        return ok
    }
}

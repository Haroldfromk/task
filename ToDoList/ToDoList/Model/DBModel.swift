

import Foundation
import FirebaseFirestore

struct DBModel {
    
    let db = Firestore.firestore()
    var lists : [ToDoModel] = []
   
}

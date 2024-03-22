
protocol sendLists {
    func sendDB (data : [ToDoModel])
}

import Foundation
import FirebaseFirestore

class DBManager {
    
    var dbModel = DBModel()
    var delegate : sendLists?
    
    // MARK: - DB로부터 값을 가져온다.
    func getData () {
        
        dbModel.db.collection(Constants.collectionName).order(by: Constants.Fire.fireId)
            .addSnapshotListener { (querySnapshot, error) in
                
                self.dbModel.lists = []
                
                if let e = error {
                    print("error : \(e)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let listId = data[Constants.Fire.fireId] as? Int
                                , let listTitle = data[Constants.Fire.fireTitle] as? String
                                , let listBool = data[Constants.Fire.fireBool] as? Bool
                                , let listFav = data[Constants.Fire.favBool] as? Bool {
                                let list = ToDoModel(id: listId, title: listTitle, isComplete: listBool, isFav: listFav)
                                
                                self.dbModel.lists.append(list)
                                self.delegate?.sendDB(data: self.dbModel.lists)
                            }
                            
                        }
                    }
                }
            }
    }
    
    // MARK: - id 최댓값을 가져온다.
    func getID () -> Int {
        
        if dbModel.lists.count != 0 {
            return self.dbModel.lists[dbModel.lists.count-1].id + 1
        } else {
            return 0
        }
        
    }
    
    // MARK: - DB입력 시
    
    func addDB (textfield : String ) {
        dbModel.db.collection(Constants.collectionName).addDocument(data: [Constants.Fire.fireId : self.getID(), Constants.Fire.fireTitle : textfield, Constants.Fire.fireBool : false, Constants.Fire.favBool : false]) { (error) in
            if let e = error { // DB에 업로드중 에러 발생시
                print("error : \(e.localizedDescription)")
            } else { // 업로드가 성공하면 콘솔로 알려준다.
                print("Upload Done")
            }
        }
    }
    
    // MARK: - Switch On/Off시 변경
    func editSwitch (number : Int, isOn:Bool) {
        dbModel.db.collection(Constants.collectionName).whereField(Constants.Fire.fireId,isEqualTo: number).getDocuments { (querySnapshot, error) in
            if let e = error {
                print(e)
            } else {
                if let documents = querySnapshot?.documents {
                    for doc in documents {
                        let docuId = doc.documentID
                        self.dbModel.db.collection(Constants.collectionName).document(docuId).setData([Constants.Fire.fireBool : isOn],merge: true)
                    }
                }
            }
        }
    }
    
    // MARK: - DB 제거
    func deleteCell (number : Int) {
        dbModel.db.collection(Constants.collectionName).whereField(Constants.Fire.fireId,isEqualTo : number).getDocuments { (querySnapshot, error) in
            if let e = error {
                print(e)
            } else {
                if let documents = querySnapshot?.documents {
                    for doc in documents {
                        let docuId = doc.documentID
                        self.dbModel.db.collection(Constants.collectionName).document(docuId).delete()
                    }
                }
            }
        }
    }
    
    
    func editTitle (number : Int , title : String) {
        dbModel.db.collection(Constants.collectionName).whereField(Constants.Fire.fireId, isEqualTo: number).getDocuments { (querySnapshot,error) in
            if let e = error {
                print(e)
            } else {
                if let documents = querySnapshot?.documents {
                    for doc in documents {
                        let docuId = doc.documentID
                        self.dbModel.db.collection(Constants.collectionName).document(docuId).setData([Constants.Fire.fireTitle : title], merge: true)
                    }
                }
            }
        }
    }
    
    // MARK: - fav 변경
    func editFav (number : Int, isFav:Bool) {
        dbModel.db.collection(Constants.collectionName).whereField(Constants.Fire.fireId,isEqualTo: number).getDocuments { (querySnapshot, error) in
            if let e = error {
                print(e)
            } else {
                if let documents = querySnapshot?.documents {
                    for doc in documents {
                        let docuId = doc.documentID
                        self.dbModel.db.collection(Constants.collectionName).document(docuId).setData([Constants.Fire.favBool : isFav],merge: true)
                    }
                }
            }
        }
    }
}

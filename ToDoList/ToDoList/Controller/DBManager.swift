
protocol sendLists {
    func sendDB (data : [ToDoModel])
}

import Foundation
import FirebaseFirestore

class DBManager {
    
    var dbModel = DBModel()
    var delegate : sendLists?
    let dateFormat = DateFormatter()
    
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
                                , let listFav = data[Constants.Fire.favBool] as? Bool
                                , let listImage = data[Constants.Fire.fireImageTitle] as? String,
                               let listDate = data[Constants.Fire.fireDate] as? String {
                                
                                let list = ToDoModel(id: listId, title: listTitle, isComplete: listBool, isFav: listFav, imageTitle: listImage, date: listDate)
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
        
        dateFormat.dateFormat = "yyyy-MM-dd"
        dbModel.db.collection(Constants.collectionName).addDocument(data: [Constants.Fire.fireId : self.getID()
                                                                           , Constants.Fire.fireTitle : textfield
                                                                           , Constants.Fire.fireBool : false, Constants.Fire.favBool : false
                                                                           , Constants.Fire.fireImageTitle : ""
                                                                           , Constants.Fire.fireDate : dateFormat.string(from: Date())]) { (error) in
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
    
    // MARK: - Title 수정
    
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
    
    // MARK: - 특정 조건에 해당하는 db가져오기
    func getSpecificData(whereCondition : String, condition : Any) {
        
        //dateFormat.dateFormat = "yyyy-MM-dd" // 일부러 2024-03-25 이런식으로 표현하려고 format을 설정.
        
        //let todayDate = dateFormat.string(from: Date())
        
        dbModel.db.collection(Constants.collectionName).whereField(whereCondition,isEqualTo: condition).order(by: Constants.Fire.fireId).getDocuments { (querySnapshot, error) in
            
            self.dbModel.lists = []
            
            if let e = error {
                print(e)
            } else {
                
                if let snapshotDocuments = querySnapshot?.documents {
                    if snapshotDocuments != [] {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let listId = data[Constants.Fire.fireId] as? Int
                                , let listTitle = data[Constants.Fire.fireTitle] as? String
                                , let listBool = data[Constants.Fire.fireBool] as? Bool
                                , let listFav = data[Constants.Fire.favBool] as? Bool
                                ,let listImage = data[Constants.Fire.fireImageTitle] as? String
                                , let listDate = data[Constants.Fire.fireDate] as? String {
                                
                                let list = ToDoModel(id: listId, title: listTitle, isComplete: listBool, isFav: listFav, imageTitle: listImage, date: listDate)
                                
                                self.dbModel.lists.append(list)
                                self.delegate?.sendDB(data: self.dbModel.lists)
                                
                            }
                            
                        }
                    } else {
                        self.dbModel.lists = [ToDoModel(id: 0, title: "조건에 일치하는 데이터가 없습니다", isComplete: false, isFav: false, imageTitle: "https://firebasestorage.googleapis.com/v0/b/todolist-1a790.appspot.com/o/O9IY1C0.jpg?alt=media&token=7e07e023-daf8-422d-a4ce-cdf43137e9cd", date: "2024-01-01")]
                        self.delegate?.sendDB(data: self.dbModel.lists)
                    }
                }
            }
        }
    }
    
    // MARK: - 조건에 해당하는 값추가
    func addCellDetailFeature (title: String, field : String ,feature : String) {
        dbModel.db.collection(Constants.collectionName).whereField(Constants.Fire.fireTitle, isEqualTo: title).getDocuments { (querySnapshot,error) in
            if let e = error {
                print(e)
            } else {
                if let documents = querySnapshot?.documents {
                    for doc in documents {
                        let docuId = doc.documentID
                        self.dbModel.db.collection(Constants.collectionName).document(docuId).setData([field : feature], merge: true)
                    }
                }
                else {
                    self.dbModel.lists = []
                }
            }
        }
    }
    // MARK: - 이전 값 가져오기
    func getMultiQueryData(whereCondition : String, condition : Any, anotherWhereCondition : String, anotherCondtion:Any) {
        
        dbModel.db.collection(Constants.collectionName).whereField(whereCondition, isEqualTo: condition).whereField(anotherWhereCondition, isEqualTo : anotherCondtion).order(by: Constants.Fire.fireId).getDocuments { (querySnapshot, error) in
            
            self.dbModel.lists = []
            
            if let e = error {
                print(e)
            } else {
                
                if let snapshotDocuments = querySnapshot?.documents {
                    if snapshotDocuments != [] {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let listId = data[Constants.Fire.fireId] as? Int
                                , let listTitle = data[Constants.Fire.fireTitle] as? String
                                , let listBool = data[Constants.Fire.fireBool] as? Bool
                                , let listFav = data[Constants.Fire.favBool] as? Bool
                                ,let listImage = data[Constants.Fire.fireImageTitle] as? String
                                , let listDate = data[Constants.Fire.fireDate] as? String {
                                
                                let list = ToDoModel(id: listId, title: listTitle, isComplete: listBool, isFav: listFav, imageTitle: listImage, date: listDate)
                                
                                self.dbModel.lists.append(list)
                                
                                self.delegate?.sendDB(data: self.dbModel.lists)
                                
                            }
                            
                        }
                    } else {
                        self.dbModel.lists = [ToDoModel(id: 0, title: "조건에 일치하는 데이터가 없습니다", isComplete: false, isFav: false, imageTitle: "https://firebasestorage.googleapis.com/v0/b/todolist-1a790.appspot.com/o/O9IY1C0.jpg?alt=media&token=7e07e023-daf8-422d-a4ce-cdf43137e9cd", date: "2024-01-01")]
                        self.delegate?.sendDB(data: self.dbModel.lists)
                    }
                }
            }
        }
    }
}



protocol MakingAlert {
    func makeAlert()
}


import UIKit
import FirebaseFirestore


class TableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    
    var lists : [ToDoModel] = []
    
    
    let alert = UIAlertController(title: "ToDoList 추가", message: "간단하게 입력해주세요", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: Constants.cellName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        getData()
    }
    
    @IBAction func addListBtn(_ sender: UIBarButtonItem) {
        makeAlert()
    }
    
    // MARK: - DB로부터 값을 가져온다.
    func getData () {
        
        db.collection(Constants.collectionName).order(by: Constants.Fire.fireId)
            .addSnapshotListener { (querySnapshot, error) in
                
                self.lists = []
                
                if let e = error {
                    print("error : \(e)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let listId = data[Constants.Fire.fireId] as? Int
                                , let listTitle = data[Constants.Fire.fireTitle] as? String
                                , let listBool = data[Constants.Fire.fireBool] as? Bool {
                                let list = ToDoModel(id: listId, title: listTitle, isComplete: listBool)
                                
                                self.lists.append(list)
                                
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                }
                            }
                            
                        }
                    }
                }
            }
    }
    
    // MARK: - id 최댓값을 가져온다.
    func getID () -> Int {
        
        if lists.count != 0 {
            return self.lists[lists.count-1].id + 1
        } else {
            return 0
        }
        
    }
    
}

// MARK: - Alert 구현

extension TableViewController : MakingAlert {
    
    func makeAlert () {
        
        let alert = UIAlertController(title: "할일 등록", message: "내용을 간단하게 입력해주세요.", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { _ in // ok를 눌렀을때 내가 텍스트 필드에 입력한 내용을 등록하게 한다.
            
            self.db.collection(Constants.collectionName).addDocument(data: [Constants.Fire.fireId : self.getID(), Constants.Fire.fireTitle : alert.textFields?[0].text ?? "Sample", Constants.Fire.fireBool : false]) { (error) in
                if let e = error { // DB에 업로드중 에러 발생시
                    print("error : \(e.localizedDescription)")
                } else { // 업로드가 성공하면 콘솔로 알려준다.
                    print("Upload Done")
                }
            }
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addTextField { (textField: UITextField!) in // textField 추가
            textField.placeholder = "여기에 입력해주세요"
            textField.autocorrectionType = .no
            textField.spellCheckingType = .no
        }
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert,animated: false)
    }
}


// MARK: - TableView 구현
extension TableViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! ToDoListCell
        let cellTitle = lists[indexPath.row].title
        
        cell.toDoLabel.text = cellTitle
        cell.finSwitch.isOn = lists[indexPath.row].isComplete
        cell.finSwitch.tag = indexPath.row
        
        cell.finSwitch.addTarget(self, action: #selector(changeMode), for: .valueChanged)
        
        if cell.finSwitch.isOn == true {
            cell.toDoLabel.attributedText = cell.toDoLabel.text?.strikeThrough()
        } else {
            cell.toDoLabel.attributedText = cell.toDoLabel.text?.removeStrike()
        }
        
        return cell
    }
    
    // MARK: - Switch On/Off에 따른 Event 구현
    @objc func changeMode (sender : UISwitch) {
        guard let currentCell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? ToDoListCell else { return }
        
        // switch를 조작했을때의 cell을 가져온다.
        if sender.isOn {
            db.collection(Constants.collectionName).whereField("id",isEqualTo: lists[sender.tag].id).getDocuments { (querySnapshot, error) in
                if let e = error {
                    print(e)
                } else {
                    if let documents = querySnapshot?.documents {
                        for doc in documents {
                            let docuId = doc.documentID
                            self.db.collection(Constants.collectionName).document(docuId).setData([Constants.Fire.fireBool : sender.isOn],merge: true)
                        }
                    }
                }
            }
            currentCell.toDoLabel.attributedText = currentCell.toDoLabel.text?.strikeThrough() // 취소선
            lists[sender.tag].isComplete = sender.isOn // DB를 로컬에 저장한 lists에도 반영
        } else {
            db.collection(Constants.collectionName).whereField("id",isEqualTo: lists[sender.tag].id).getDocuments { (querySnapshot, error) in
                if let e = error {
                    print(e)
                } else {
                    if let documents = querySnapshot?.documents {
                        for doc in documents {
                            let docuId = doc.documentID
                            self.db.collection(Constants.collectionName).document(docuId).setData([Constants.Fire.fireBool : sender.isOn],merge: true)
                        }
                    }
                }
            }
            currentCell.toDoLabel.attributedText = currentCell.toDoLabel.text?.removeStrike()
            lists[sender.tag].isComplete = sender.isOn
        }
        
    }
    
    // MARK: - swipe시 삭제 버튼 구현
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteBtn = UIContextualAction(style: .normal, title: "Delete") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            
            self.db.collection(Constants.collectionName).whereField("id",isEqualTo:self.lists[indexPath.row].id).getDocuments { (querySnapshot, error) in
                if let e = error {
                    print(e)
                } else {
                    if let documents = querySnapshot?.documents {
                        for doc in documents {
                            let docuId = doc.documentID
                            self.db.collection(Constants.collectionName).document(docuId).delete()
                        }
                    }
                }
            }
            
            tableView.beginUpdates()
            self.lists.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            success(true)
            
        }
        
        deleteBtn.backgroundColor = UIColor.systemRed
        return UISwipeActionsConfiguration(actions: [deleteBtn])
    }
    
    
}

// MARK: - Cell을 클릭했을때 이벤트 발생
extension TableViewController : UITableViewDelegate {
    
}

// MARK: - 취소선
extension String {
    func strikeThrough() -> NSAttributedString { // 취소선 만들기
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
        return attributeString
    }
    
    func removeStrike () -> NSAttributedString { // 취소선 제거
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
}

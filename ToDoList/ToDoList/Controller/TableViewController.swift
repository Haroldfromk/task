
protocol MakingAlert {
    func makeAlert()
}


import UIKit

class TableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBtn: UIBarButtonItem!
    @IBOutlet weak var segmentView: UISegmentedControl!
    @IBOutlet weak var searchBar: UITableView!
    
    @IBOutlet weak var sideButton: UIBarButtonItem!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    
    @IBOutlet weak var todayBtn: UIButton!
    @IBOutlet weak var totalBtn: UIButton!
    
    
    var dimmingView: UIView?
    var sideBarViewController = SideBarViewController()
    
    let dbManager = DBManager()
    let alertManager = AlertManager()
    let dateFormat = DateFormatter()
    
    var lists : [ToDoModel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dbManager.delegate = self
        self.navigationItem.setHidesBackButton(true, animated: true) // back 버튼 숨기기
        
        tableView.register(UINib(nibName: Constants.cellName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier) // Custom 셀 사용하기
        tableView.dataSource = self
        tableView.delegate = self
        
        searchBar.delegate = self
        
        dbManager.getData()
        totalBtn.isSelected = true
        
        addDimmingView()
        
    }
    
    @IBAction func backBtn(_ sender: UIBarButtonItem) { // back버튼을 구현
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction func showTotalBtn(_ sender: UIButton) {
        dbManager.getData()
        
        todayBtn.isSelected = false
        totalBtn.isSelected = true
        
    }
    
    @IBAction func showTodayBtn(_ sender: UIButton) {
        dateFormat.dateFormat = "yyyy-MM-dd"
        dbManager.getSpecificData(whereCondition: Constants.Fire.fireDate, condition: dateFormat.string(from: Date()))
        todayBtn.isSelected = true
        totalBtn.isSelected = false
    }
    
    
    
    // MARK: - SideBar 구현
    
    private func addDimmingView() {
        dimmingView = UIView(frame: self.view.bounds)
        dimmingView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        dimmingView?.isHidden = true
        view.addSubview(dimmingView!)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDimmingViewTap))
        dimmingView?.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleDimmingViewTap() {
        let sideBarVC = self.sideBarViewController
        
        UIView.animate(withDuration: 0.3, animations: {
            // 사이드 메뉴를 원래 위치로 되돌림.
            sideBarVC.view.frame = CGRect(x: -self.view.frame.width, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            // 어두운 배경 뷰를 숨김.
            self.dimmingView?.alpha = 0
        }) { (finished) in
            // 애니메이션이 완료된 후 사이드 메뉴를 뷰 계층 구조에서 제거.
            sideBarVC.view.removeFromSuperview()
            sideBarVC.removeFromParent()
            self.dimmingView?.isHidden = true
            self.backButton.isHidden = false
            self.sideButton.isHidden = false
        }
    }
    
    @IBAction func openSideBtn(_ sender: UIBarButtonItem) {
        let sideBarVC = self.sideBarViewController
        
        // 사이드 메뉴 뷰 컨트롤러를 자식으로 추가하고 뷰 계층 구조에 추가.
        self.addChild(sideBarVC)
        self.view.addSubview(sideBarVC.view)
        
        // 사이드 메뉴의 너비를 화면 너비의 70%로 설정.
        let menuWidth = self.view.frame.width * 0.70
        let menuHeight = self.view.frame.height
        let yPos = (self.view.frame.height / 2) - (menuHeight / 2) // 중앙에 위치하도록 yPos 계산
        
        
        // 사이드 메뉴의 시작 위치를 화면 왼쪽 바깥으로 설정.
        sideBarVC.view.frame = CGRect(x: -menuWidth, y: yPos, width: menuWidth, height: menuHeight)
        
        // 어두운 배경 뷰를 보이게 합니다.
        self.dimmingView?.isHidden = false
        self.dimmingView?.alpha = 0
        
        UIView.animate(withDuration: 0.3, animations: {
            // 사이드 메뉴를 화면에 표시.
            sideBarVC.view.frame = CGRect(x: 0, y: yPos, width: menuWidth, height: menuHeight)
            // 어두운 배경 뷰의 투명도를 조절.
            self.dimmingView?.alpha = 0.5
        })
        
        backButton.isHidden = true
        sideButton.isHidden = true
    }
    
    // MARK: - SegControl 탭할때마다 다른 값 보여주게 구현
    
    @IBAction func changeSegAction(_ sender: UISegmentedControl) {
        
        
        
        let selectedIndex = sender.selectedSegmentIndex
        dateFormat.dateFormat = "yyyy-MM-dd"
        
        switch selectedIndex {
            
        case 0 : // 전체
            if totalBtn.isSelected {
                dbManager.getData()
            } else {
                dbManager.getSpecificData(whereCondition: Constants.Fire.fireDate, condition: dateFormat.string(from: Date()))
            }
            
            
            
        case 1 : // 진행중
            if totalBtn.isSelected {
                dbManager.getSpecificData(whereCondition: Constants.Fire.fireBool, condition: false)
            } else {
                dbManager.getMultiQueryData(whereCondition: Constants.Fire.fireDate, condition: dateFormat.string(from: Date()), anotherWhereCondition: Constants.Fire.fireBool, anotherCondtion: false)
            }
            
            
        case 2 : // 완료
            if totalBtn.isSelected {
                dbManager.getSpecificData(whereCondition: Constants.Fire.fireBool, condition: true)
            } else {
                dbManager.getMultiQueryData(whereCondition: Constants.Fire.fireDate, condition: dateFormat.string(from: Date()), anotherWhereCondition: Constants.Fire.fireBool, anotherCondtion: true)
            }
            
            
        default : // 즐겨찾기
            if totalBtn.isSelected {
                dbManager.getSpecificData(whereCondition: Constants.Fire.favBool, condition: true)
            } else {
                dbManager.getMultiQueryData(whereCondition: Constants.Fire.fireDate, condition: dateFormat.string(from: Date()), anotherWhereCondition: Constants.Fire.favBool, anotherCondtion: true)
            }
            
        }
        
        
    }
    
    @IBAction func addListBtn(_ sender: UIBarButtonItem) {
        
        makeAlert()
    }
    
}

// MARK: - DBManager로 부터 받아온 DB를 lists에 저장 및 화면에 표시

extension TableViewController : sendLists {
    
    func sendDB(data: [ToDoModel]) {
        
        lists = data
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        
    }
    
}

// MARK: - Alert 구현

extension TableViewController : MakingAlert {
    
    func makeAlert () {
        
        let alert = alertManager.makingAlert(title: "할일 등록", message: "내용을 간단하게 입력해주세요.")
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { _ in // ok를 눌렀을때 내가 텍스트 필드에 입력한 내용을 등록하게 한다.
            
            self.dbManager.addDB(textfield: alert.textFields?[0].text ?? "Sample")
            self.totalBtn.isEnabled = true
        })
        
        let cancel = alertManager.makingCancel(title: "Cancel")
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
        let favBool = lists[indexPath.row].isFav
        
        cell.toDoLabel.text = cellTitle
        cell.finSwitch.isOn = lists[indexPath.row].isComplete
        cell.finSwitch.tag = indexPath.row
        cell.finSwitch.addTarget(self, action: #selector(changeMode), for: .valueChanged)
        cell.backgroundColor = UIColor(hexCode: "FEA0A5",alpha: 0)
        
        
        if cell.finSwitch.isOn == true {
            cell.toDoLabel.attributedText = cell.toDoLabel.text?.strikeThrough()
        } else {
            cell.toDoLabel.attributedText = cell.toDoLabel.text?.removeStrike()
        }
        
        if favBool == true {
            cell.favView.image = UIImage(systemName: Constants.Symbol.fillStar)
        } else {
            cell.favView.image = UIImage(systemName: Constants.Symbol.star)
        }
        
        
        return cell
    }
    
    // MARK: - Switch On/Off에 따른 Event 구현
    @objc func changeMode (sender : UISwitch) {
        guard let currentCell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? ToDoListCell else { return }
        
        // switch를 조작했을때의 cell을 가져온다.
        if sender.isOn {
            dbManager.editSwitch(number: lists[sender.tag].id, isOn: sender.isOn)
            currentCell.toDoLabel.attributedText = currentCell.toDoLabel.text?.strikeThrough() // 취소선
            totalBtn.isEnabled = true
            
        } else {
            dbManager.editSwitch(number: lists[sender.tag].id, isOn: sender.isOn)
            currentCell.toDoLabel.attributedText = currentCell.toDoLabel.text?.removeStrike()
            totalBtn.isEnabled = true
            
        }
        
    }
    
    // MARK: - swipe 구현 (삭제, title 변경)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteBtn = UIContextualAction(style: .normal, title: "Delete") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            
            let alert = self.alertManager.makingAlert(title: "삭제하기", message: "정말 삭제하실 건가요?")
            
            let ok = UIAlertAction(title: "OK", style: .destructive, handler: { _ in
                
                self.dbManager.deleteCell(number: self.lists[indexPath.row].id)
                tableView.beginUpdates()
                self.lists.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
                self.totalBtn.isEnabled = true
                
            })
            
            let cancel = self.alertManager.makingCancel(title: "Cancel")
            
            alert.addAction(ok)
            alert.addAction(cancel)
            self.present(alert,animated: false)
            
            success(true)
            
        }
        
        let editBtn = UIContextualAction(style: .normal, title: "Edit") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            
            let alert = self.alertManager.makingAlert(title: "수정하기", message: "수정할 내용을 간단하게 입력해주세요")
            
            let ok = UIAlertAction(title: "OK", style: .default, handler: { _ in // ok를 눌렀을때 내가 텍스트 필드에 입력한 내용을 등록하게 한다.
                
                self.dbManager.editTitle(number: self.lists[indexPath.row].id, title: alert.textFields?[0].text ?? "Sample")
                tableView.beginUpdates()
                tableView.endUpdates()
                self.totalBtn.isEnabled = true
            })
            
            let cancel = self.alertManager.makingCancel(title: "Cancel")
            alert.addTextField { (textField: UITextField!) in // textField 추가
                textField.placeholder = "수정할 내용을 입력하세요."
                textField.autocorrectionType = .no
                textField.spellCheckingType = .no
            }
            alert.addAction(ok)
            alert.addAction(cancel)
            self.present(alert,animated: false)
            
            success(true)
        }
        
        deleteBtn.image = UIImage(named: "deleteCalendar")
        deleteBtn.backgroundColor = UIColor.systemRed
        editBtn.image = UIImage(named: "editcalendar")
        editBtn.backgroundColor = UIColor.systemGreen
        
        return UISwipeActionsConfiguration(actions: [deleteBtn,editBtn])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let favBtn = UIContextualAction(style: .normal, title: "") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            
            if self.lists[indexPath.row].isFav == false {
                self.dbManager.editFav(number: self.lists[indexPath.row].id, isFav : true)
            } else {
                self.dbManager.editFav(number: self.lists[indexPath.row].id, isFav : false)
            }
            tableView.beginUpdates()
            tableView.endUpdates()
            self.totalBtn.isEnabled = true
            success(true)
        }
        
        favBtn.image = UIImage(named: "favorite")
        favBtn.backgroundColor = .systemYellow
        return UISwipeActionsConfiguration(actions: [favBtn])
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let duration = 0.7
        let delayFactor = 0.005
        cell.transform = CGAffineTransform(scaleX: 0.4, y: 0.8)
        UIView.animate(withDuration: duration
                       ,delay:  delayFactor * Double(indexPath.row)
                       ,usingSpringWithDamping: 0.9
                       ,initialSpringVelocity:  0.1
                       ,options: [.beginFromCurrentState]
                       , animations: {
            cell.transform = CGAffineTransform(translationX: 0, y: 0)
        })
    }
}

// MARK: - Cell을 클릭했을때 이벤트 발생
extension TableViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 프로퍼티를 통해 화면전달하면서 필요한 데이터 전송
        if let CellDetailVC = self.storyboard?.instantiateViewController(identifier: "CellDetailViewController") as? CellDetailViewController {
            
            
            CellDetailVC.titleString = lists[indexPath.row].title
            CellDetailVC.selectedDate = lists[indexPath.row].date
            
            if lists[indexPath.row].imageTitle != "" { // 이미지 파일을 업로드 한 경우
                CellDetailVC.imageUrl = lists[indexPath.row].imageTitle
            } else { // 이미지 파일을 업로드 하지 않은 경우
                CellDetailVC.imageUrl = "https://firebasestorage.googleapis.com/v0/b/todolist-1a790.appspot.com/o/upload-image-icon.png?alt=media&token=52da5077-bebf-4f39-8692-14b376f6f7a6"
            }
            
            self.present(CellDetailVC, animated: true)
        }
        
        
    }
    
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

// MARK: - 검색기능구현. (정확히 일치해야 가져옴...)
extension TableViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dbManager.getSpecificData(whereCondition: Constants.Fire.fireTitle, condition: searchBar.text!)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 { // 입력안했을때
            dbManager.getData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}

// MARK: - 색상을 HEX로 사용하기위해 가져온 기능.
extension UIColor {
    
    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}

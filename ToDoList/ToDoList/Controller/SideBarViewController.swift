
import UIKit

class SideBarViewController: UIViewController  {
    
    let dbManager = DBManager()
    
    var dateView : UICalendarView = {
        var view = UICalendarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.wantsDateDecorations = true // custom하기위해 설정해야 하는 속성
        
        return view
    }()
    
    var titleLabel : UIView = { // label생성
        var label = UILabel()
        label.text = "Calendar"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    var dateLabel : UILabel = {
        var label = UILabel()
        label.text = "List"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    var tableView : UITableView = {
        var view = UITableView()
        view.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    

    var lists : [ToDoModel] = []
    let dateFormat = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layer.cornerRadius = 20
        self.view.clipsToBounds = true
        
        self.view.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        tableView.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        applyConstraints()
        
        dateFormat.dateFormat = "yyyy-MM-dd"
        dbManager.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        let selection = UICalendarSelectionSingleDate(delegate: self)
        dateView.selectionBehavior = selection
        
        dbManager.getSpecificData(whereCondition: Constants.Fire.fireDate, condition: dateFormat.string(from: Date()))
        
    }
    
    
    func applyConstraints() {
        view.addSubview(titleLabel)
        view.addSubview(dateView)
        view.addSubview(dateLabel)
        view.addSubview(tableView)
        
        
        let titleLabelConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 10),
            
        ]
        
        let dateViewConstraints = [
            dateView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            dateView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            dateView.topAnchor.constraint(equalTo: titleLabel.safeAreaLayoutGuide.bottomAnchor,constant: 20),
        ]
        
        let dateLabelConstraints = [
            dateLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            dateLabel.topAnchor.constraint(equalTo: dateView.safeAreaLayoutGuide.bottomAnchor,constant: 10)
        ]
        
        let tableViewConstraints = [
            tableView.leadingAnchor.constraint(equalTo: dateView.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: dateView.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: dateLabel.safeAreaLayoutGuide.bottomAnchor,constant: 40),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ]
        
        NSLayoutConstraint.activate(dateViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(dateLabelConstraints)
        NSLayoutConstraint.activate(tableViewConstraints)
    }
    
    
}

extension SideBarViewController : UICalendarSelectionSingleDateDelegate {
    
    
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        
        let selectedDate = dateComponents
        let calendar = Calendar.current
        let myDate = calendar.date(from: selectedDate!)
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        
        dbManager.getSpecificData(whereCondition: Constants.Fire.fireDate, condition: dateFormat.string(from: myDate!))
        
        
    }
    
    
}


extension SideBarViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel!.text = lists[indexPath.row].title
        cell.textLabel?.textAlignment = .center
        cell.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    
}

extension SideBarViewController : sendLists {
    func sendDB(data: [ToDoModel]) {
        
        lists = data

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
}


#Preview{
    SideBarViewController()
}


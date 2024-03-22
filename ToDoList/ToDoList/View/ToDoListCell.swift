

import UIKit

class ToDoListCell: UITableViewCell {
    

    @IBOutlet weak var toDoView: UIView!
    @IBOutlet weak var toDoLabel: UILabel!
    
    @IBOutlet weak var finSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        finSwitch.setOn(false, animated: true)
        selectionStyle = .none
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        finSwitch.setOn(false, animated: false)
        toDoLabel.attributedText = nil
        
    }
}

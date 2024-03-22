
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var displayLabel: UILabel!
    
    var value = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayLabel.text = String(value)
    }
    
    
    @IBAction func upBtn(_ sender: UIButton) {
        value += 1
        displayLabel.text = String(value)
    }
    
    
    
    @IBAction func downBtn(_ sender: UIButton) {
        value -= 1
        displayLabel.text = String(value)
    }
    
}

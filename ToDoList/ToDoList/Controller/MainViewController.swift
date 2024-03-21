

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        titleLabel.text = ""
        
        let titleText = "📂MyList📋"
        
        var index = 0.0
        
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * index, repeats: false) { timer in
                self.titleLabel.text?.append(letter)
            }
                index += 1
            }
        
        }
   
}



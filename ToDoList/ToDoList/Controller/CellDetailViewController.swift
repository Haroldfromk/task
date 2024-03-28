

import UIKit
import FirebaseAuth
import FirebaseStorage

class CellDetailViewController: UIViewController  {
    
    let dbManager = DBManager()
    let imageManager = ImageManager()
    
    let storage = Storage.storage().reference()
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var detailBody: UITextView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var uploadBtn: UIButton!
    var titleString : String = ""
    var imageUrl : String? = ""
    var selectedDate : String = ""
    
    let dateFormat = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormat.dateFormat = "yyyy-MM-dd"
        
        let date = dateFormat.date(from:selectedDate)
        
        datePicker.setDate(date!, animated: false) // picker에 화면전환시, 전달 받은 값을 표현
        
        if titleString != "조건에 일치하는 데이터가 없습니다" {
            
            titleLabel.text = titleString
        } else { // 아무것도 해당하지 않는 경우 기능을 숨기기위해 구현
            titleLabel.text = titleString
            datePicker.isHidden = true
            uploadBtn.isHidden = true
            deadlineLabel.isHidden = true
            dateLabel.isHidden = true
        }
        if selectedDate != dateFormat.string(from: Date()) { // 날짜가 같지않을땐 해당 label을 숨겨버린다.
            deadlineLabel.isHidden = true
        }
        
        
        getImage()
   
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // 오늘날짜와 내가 지정해준 날짜가 같을때 강조하기위해서.
        if selectedDate == dateFormat.string(from: Date()) {
            deadlineLabel.blink()
        }
        
    }

    
    // MARK: - 원하는 날짜 지정후, 지정한 Date값을 DB에 올리는 작업.
    
    @IBAction func setDate(_ sender: UIDatePicker) {
        
        let datePicker = sender
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd" // 일부러 2024-03-25 이런식으로 표현하려고 format을 설정.
        
        let selectedDate = dateFormat.string(from: datePicker.date)
        dbManager.addCellDetailFeature(title: titleLabel.text!, field: Constants.Fire.fireDate, feature: selectedDate)
    }
    
}

// MARK: - 이미지 업로드

extension CellDetailViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func uploadImageBtn(_ sender: UIButton) {
        
        let pickerController = UIImagePickerController ()
        
        pickerController.sourceType = .photoLibrary
        pickerController.allowsEditing = true
        
        pickerController.delegate = self
        
        self.present(pickerController, animated: true)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        imageManager.uploadImage(image: selectedImage) { url in
            if let url = url {
                self.dbManager.addCellDetailFeature(title: self.titleLabel.text!, field: Constants.Fire.fireImageTitle, feature: url.absoluteString)
            }
        }
        
        self.detailImageView.image = selectedImage
        
        picker.dismiss(animated: true)
        
    }
    
    
    func getImage() {
        guard let urlString = imageUrl else { return }
        
        imageManager.downloadImage(urlString: urlString) { [weak self] image in
            self?.detailImageView.image = image
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true)
        
    }
    
}

extension UIView {
    func blink() {
        self.alpha = 0.5;
        UIView.animate(withDuration: 0.5, //Time duration you want,
                       delay: 0.0,
                       options: [.curveEaseInOut, .autoreverse, .repeat],
                       animations: { [weak self] in self?.alpha = 0.0 },
                       completion: { [weak self] _ in self?.alpha = 1.0 })
    }
    
    func stopBlink() {
        layer.removeAllAnimations()
        alpha = 1
    }
}


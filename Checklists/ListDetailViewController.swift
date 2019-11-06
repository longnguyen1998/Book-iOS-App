import UIKit

protocol ListDetailViewControllerDelegate: class {
  func listDetailViewControllerDidCancel(controller: ListDetailViewController)
  func listDetailViewController(controller: ListDetailViewController, didFinishAddingChecklist checklist: Checklist)
  func listDetailViewController(controller: ListDetailViewController, didFinishEditingChecklist checklist: Checklist)
}

class ListDetailViewController: UITableViewController, UITextFieldDelegate, IconPickerViewControllerDelegate {
  
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var doneBarButton: UIBarButtonItem!
  
  @IBOutlet weak var iconImageView: UIImageView!
  weak var delegate: ListDetailViewControllerDelegate?
  
  var checklistToEdit: Checklist?
  var iconName = "Folder"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.rowHeight = 44
    if let checklist = checklistToEdit {
      title = "Edit Checklist"
      textField.text = checklist.name
        doneBarButton.isEnabled = true
      iconName = checklist.iconName
    }
    iconImageView.image = UIImage(named: iconName)
  }
  
//  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//    if segue.identifier == "PickIcon" {
//        let controller = segue.destination as! IconPickerViewController
//      controller.delegate = self
//    }
//  }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickIcon" {
            let controller = segue.destination as! IconPickerViewController
            controller.delegate = self
        }
    }
  
  func iconPicker(picker: IconPickerViewController, didPickIcon iconName: String) {
    self.iconName = iconName
    iconImageView.image = UIImage(named: iconName)
    navigationController?.popViewController(animated: true)
  }
  
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    textField.becomeFirstResponder()
  }
  
  @IBAction func cancel() {
    delegate?.listDetailViewControllerDidCancel(controller: self)
  }
  
  @IBAction func done() {
      if let checklist = checklistToEdit {
        checklist.name = textField.text!
        checklist.iconName = iconName
//      delegate?.listDetailViewController(self, didFinishEditingChecklist: checklist)
        delegate?.listDetailViewController(controller: self, didFinishEditingChecklist: checklist)
    } else {
        let checklist = Checklist(name: textField.text!)
        checklist.iconName = iconName
//      delegate?.listDetailViewController(self, didFinishAddingChecklist: checklist)
        delegate?.listDetailViewController(controller: self, didFinishAddingChecklist: checklist)
      }
  }
  
//  override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
//    if indexPath.section == 1 {
//      return indexPath
//    } else {
//      return nil
//    }
//  }
  
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let oldText: NSString = textField.text! as NSString
    let newText: NSString = oldText.replacingCharacters(in: range, with: string) as NSString
    doneBarButton.isEnabled = (newText.length > 0)
    return true
  }
}

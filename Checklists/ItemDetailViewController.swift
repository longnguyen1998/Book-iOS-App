import UIKit

protocol ItemDetailViewControllerDelegate: class {
  func itemDetailViewControllerDidCancel(controller: ItemDetailViewController)
  func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem)
  func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
  
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var doneBarButton: UIBarButtonItem!
  @IBOutlet weak var shouldRemindSwitch: UISwitch!
  @IBOutlet weak var dueDateLabel: UILabel!
  
  @IBAction func shouldRemindToggled(switchControl: UISwitch) {
//    textField.resignFirstResponder()
//    if switchControl.isOn {
//      let notificationSettings = UIUserNotificationSettings(forTypes: .Alert | .Sound, categories: nil)
//      UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
//    }
  }
  
  weak var delegate: ItemDetailViewControllerDelegate?
  
  var dueDate = NSDate()
  var datePickerVisible = false
  var itemToEdit: ChecklistItem?
  
    
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.rowHeight = 44
    
    if let item = itemToEdit {
      title = "Edit Item"
      textField.text = item.text
        doneBarButton.isEnabled = true
        shouldRemindSwitch.isOn = item.shouldRemind
      dueDate = item.dueDate
    }
    updateDueDateLabel()
  }
  
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    textField.becomeFirstResponder()
  }
  
  @IBAction func cancel() {
    delegate?.itemDetailViewControllerDidCancel(controller: self)
  }
  
  @IBAction func done() {
    
    // Edit Item
    if let item = itemToEdit {
        item.text = textField.text!
        item.shouldRemind = shouldRemindSwitch.isOn
        item.dueDate = dueDate
        item.scheduleNotification()
//      delegate?.itemDetailViewController(self, didFinishEditingItem: item)
        delegate?.itemDetailViewController(controller: self, didFinishEditingItem: item)
    } else {
        // Add Item
      let item = ChecklistItem()
        item.text = textField.text!
        item.checked = false
        item.shouldRemind = shouldRemindSwitch.isOn
        item.dueDate = dueDate
        item.scheduleNotification()
//        delegate?.itemDetailViewController(self, didFinishAddingItem: item)
        delegate?.itemDetailViewController(controller: self, didFinishAddingItem: item)
        self.dismiss(animated: true, completion: nil)
    }
  }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 && indexPath.row == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    
    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool {
    
    let oldText: NSString = textField.text! as NSString
    let newText: NSString = oldText.replacingCharacters(in: range, with: string) as NSString
    
    doneBarButton.isEnabled = (newText.length > 0)
    return true
  }
  
  func updateDueDateLabel() {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    dueDateLabel.text = formatter.string(from: dueDate as Date)
  }
  
  func showDatePicker() {
    datePickerVisible = true
    let indexPathDateRow = NSIndexPath(row: 1, section: 1)
    let indexPathDatePicker = NSIndexPath(row: 2, section: 1)
    if let dateCell = tableView.cellForRow(at: indexPathDateRow as IndexPath) {
      dateCell.detailTextLabel!.textColor = dateCell.detailTextLabel!.tintColor
    }
    
    tableView.beginUpdates()
    tableView.insertRows(at: [(indexPathDatePicker as IndexPath)], with: .fade)
    tableView.reloadRows(at: [(indexPathDateRow as IndexPath)], with: .none)
    tableView.endUpdates()
    
    if let pickerCell = tableView.cellForRow( at: indexPathDatePicker as IndexPath) {
        let datePicker = pickerCell.viewWithTag(100) as! UIDatePicker
        datePicker.setDate(dueDate as Date, animated: false)
    }
  }
  
  func hideDatePicker() {
      if datePickerVisible {
        datePickerVisible = false
        let indexPathDateRow = NSIndexPath(row: 1, section: 1)
        let indexPathDatePicker = NSIndexPath(row: 2, section: 1)
        if let cell = tableView.cellForRow(at: indexPathDateRow as IndexPath) {
          cell.detailTextLabel!.textColor = UIColor(white: 0, alpha: 0.5)
        }
        tableView.beginUpdates()
        tableView.reloadRows(at: [(indexPathDateRow as IndexPath)], with: .none)
        tableView.deleteRows(at: [(indexPathDatePicker as IndexPath)], with: .fade)
        tableView.endUpdates() }
  }
  
  
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 && indexPath.row == 2 {
            var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "DatePickerCell")
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "DatePickerCell")
                cell.selectionStyle = .none
                let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 320, height: 216))
                datePicker.tag = 100
                cell.contentView.addSubview(datePicker)
                datePicker.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
            }
              return cell
        
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 1 && datePickerVisible {
      return 3
    } else {
      return super.tableView(tableView, numberOfRowsInSection: section)
    }
  }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2 {
            return 217
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        textField.resignFirstResponder()
        if indexPath.section == 1 && indexPath.row == 1 {
            if !datePickerVisible {
                showDatePicker()
            } else {
                hideDatePicker()
            }
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
    hideDatePicker()
  }
  
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        if indexPath.section == 1 && indexPath.row == 2 {
//            indexPath = NSIndexPath(forRow: 0, inSection: indexPath.section)
//            indexPath = NSIndexPath(row: 0, section: indexPath)
        }
        return super.tableView(tableView, indentationLevelForRowAt: indexPath)
    }
  
  @objc func dateChanged(datePicker: UIDatePicker) {
    dueDate = datePicker.date as NSDate
    updateDueDateLabel()
  }



}

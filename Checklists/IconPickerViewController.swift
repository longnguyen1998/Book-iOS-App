import UIKit

protocol IconPickerViewControllerDelegate: class {
  func iconPicker(picker: IconPickerViewController, didPickIcon iconName: String)
}

class IconPickerViewController: UITableViewController {
  
  weak var delegate: IconPickerViewControllerDelegate?
  
  let icons = ["No Icon", "Appointments", "Birthdays", "Chores", "Drinks", "Folder", "Groceries", "Inbox", "Photos", "Trips"]
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return icons.count
  }
  
//  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//
//    let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell")!
//
//    let iconName = icons[indexPath.row]
//    cell.textLabel!.text = iconName
//    cell.imageView!.image = UIImage(named: iconName)
//
//    return cell
//  }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell")!
        
        let iconName = icons[indexPath.row]
        cell.textLabel!.text = iconName
        cell.imageView!.image = UIImage(named: iconName)
        return cell
    }
  
//  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//    if let delegate = delegate {
//      let iconName = icons[indexPath.row]
//        delegate.iconPicker(picker: self, didPickIcon: iconName)
//    }
//  }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = delegate{
            let iconName = icons[indexPath.row]
            delegate.iconPicker(picker: self, didPickIcon: iconName)
        }
    }
    
}

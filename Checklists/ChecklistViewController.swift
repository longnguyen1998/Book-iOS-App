import UIKit

class ChecklistViewController: UITableViewController {
  
  var checklist: Checklist!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.rowHeight = 44
    title = checklist.name
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return checklist.items.count
  }
  
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem")!
        
            let item = checklist.items[indexPath.row]
        
            configureTextForCell(cell: cell, withChecklistItem: item)
            configureCheckmarkForCell(cell: cell, withChecklistItem: item)
        
            return cell

    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
              let item = checklist.items[indexPath.row]
              item.toggleChecked()
        
                configureCheckmarkForCell(cell: cell, withChecklistItem: item)
            }
            tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
  
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        checklist.items.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths as [IndexPath], with: .automatic)
    }
    
    
    
  func configureCheckmarkForCell(cell: UITableViewCell, withChecklistItem item: ChecklistItem) {
    let label = cell.viewWithTag(1001) as! UILabel
    label.textColor = view.tintColor
    
    if item.checked {
      label.text = "√"
    } else {
      label.text = ""
    }
  }
  
  func configureTextForCell(cell: UITableViewCell, withChecklistItem item: ChecklistItem) {
    let label = cell.viewWithTag(1000) as! UILabel
    label.text = item.text
//    label.text = "\(item.itemID): \(item.text)"
  }
  

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "AddItem" {
                let navigationController = segue.destination as! UINavigationController
                let controller = navigationController.topViewController as! ItemDetailViewController
                controller.delegate = self
            } else if segue.identifier == "EditItem" {
                let navigationController = segue.destination as! UINavigationController
                let controller = navigationController.topViewController as! ItemDetailViewController
                controller.delegate = self
        
                if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = checklist.items[indexPath.row]
              }
            }
    }
    
}

extension ChecklistViewController: ItemDetailViewControllerDelegate {
      func itemDetailViewControllerDidCancel(controller: ItemDetailViewController) {
        dismiss(animated: true, completion: nil)
      }
      
      func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem) {
        let newRowIndex = checklist.items.count
        
        checklist.items.append(item)
        
        let indexPath = NSIndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths as [IndexPath], with: .automatic)
        
        dismiss(animated: true, completion: nil)
      }
      
      func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem) {
    //    if let index = find(checklist.items, item) {
    //      let indexPath = NSIndexPath(forRow: index, inSection: 0)
    //      if let cell = tableView.cellForRowAtIndexPath(indexPath) {
    //        configureTextForCell(cell, withChecklistItem: item)
    //      }
    //    }
    //    dismiss(animated: true, completion: nil)
      }

}

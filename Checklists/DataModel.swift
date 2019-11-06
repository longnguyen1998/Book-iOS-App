import Foundation

class DataModel {
  
  var lists = [Checklist]()
  
  var indexOfSelectedChecklist: Int {
    get {
        return UserDefaults.standard.integer(forKey: "ChecklistIndex")
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
    }
  }
  
  init() {
    loadChecklists()
    registerDefaults()
    handleFirstTime()
    print("Documents folder is \(documentsDirectory())")
  }
  
  func registerDefaults() {
    let dictionary = ["Checklist Index": -1, "FirstTime": true, "ChecklistItemID": 0] as [String : Any]
    UserDefaults.standard.register(defaults: dictionary)
  }
  
  func documentsDirectory() -> URL {
//    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [String]
//    return paths[0]
    let paths = FileManager.default.urls(for: .documentDirectory,
    in: .userDomainMask)
    return paths[0]
  }
  
  func dataFilePath() -> URL {
//    return documentsDirectory().stringByAppendingPathComponent("Checklists.plist")
    return documentsDirectory().appendingPathComponent("Checklists.plist")
  }
  
  func saveChecklists() {
//    let data = NSMutableData()
//    let archiver = NSKeyedArchiver(forWritingWith: data)
//    archiver.encode(lists, forKey: "Checklists")
//    archiver.finishEncoding()
//    data.write(toFile: dataFilePath(), atomically: true)
        let encoder = PropertyListEncoder()
        do {
//            let data = try encoder.encode(lists)
//            try data.write(to: dataFilePath(),
//            options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding item array: \(error.localizedDescription)")
    }
  }
  
  func loadChecklists() {
//    let path = dataFilePath()
//    if FileManager.default.fileExists(atPath: path) {
//      if let data = NSData(contentsOfFile: path) {
//        let unarchiver = NSKeyedUnarchiver(forReadingWith: data as Data)
//        lists = unarchiver.decodeObject(forKey: "Checklists") as! [Checklist]
//        unarchiver.finishDecoding()
//        sortChecklists()
//      }
//    }
    
       let path = dataFilePath()

       if let data = try? Data(contentsOf: path) {
           let decoder = PropertyListDecoder()
           do {
//            lists = try decoder.decode([Checklist].self, from: data)
           } catch {
               print("Error decoding item array: \(error.localizedDescription)")
           }
       }
  }
  
  func handleFirstTime() {
    let userDefaults = UserDefaults.standard
    let firstTime = userDefaults.bool(forKey: "FirstTime")
    if firstTime {
      let checklist = Checklist(name: "List")
      lists.append(checklist)
      indexOfSelectedChecklist = 0
        userDefaults.set(false, forKey: "FirstTime")
    }
  }
  
  func sortChecklists() {
    lists.sort(by: { checklist1, checklist2 in return
        checklist1.name.localizedStandardCompare(checklist2.name) == ComparisonResult.orderedAscending })
  }
  
  class func nextChecklistItemID() -> Int {
    let userDefaults = UserDefaults.standard
    let itemID = userDefaults.integer(forKey: "ChecklistItemID")
    userDefaults.set(itemID + 1, forKey: "ChecklistItemID")
    userDefaults.synchronize()
    return itemID
  }
}

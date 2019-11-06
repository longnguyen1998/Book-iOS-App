import Foundation
import UIKit

class ChecklistItem: NSObject, NSCoding {
    func encode(with coder: NSCoder) {
        //
    }
    

  var text = ""
  var checked = false
  var dueDate = NSDate()
  var shouldRemind = false
  var itemID: Int
  
  func toggleChecked() {
    checked = !checked
  }

  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encode(text, forKey: "Text")
    aCoder.encode(checked, forKey: "Checked")
    aCoder.encode(dueDate, forKey: "DueDate")
    aCoder.encode(shouldRemind, forKey: "ShouldRemind")
    aCoder.encode(itemID, forKey: "ItemID")
  }
  
  required init(coder aDecoder: NSCoder) {
    text = aDecoder.decodeObject(forKey: "Text") as! String
    checked = aDecoder.decodeBool(forKey: "Checked")
    dueDate = aDecoder.decodeObject(forKey: "DueDate") as! NSDate
    shouldRemind = aDecoder.decodeBool(forKey: "ShouldRemind")
    itemID = aDecoder.decodeInteger(forKey: "ItemID")
    super.init()
  }
  
  override init() {
    itemID = DataModel.nextChecklistItemID()
    super.init()
  }
  
  func scheduleNotification() {
    let existingNotification = notificationForThisItem()
    if let notification = existingNotification {
        print("Found an existing notification \(notification)")
        UIApplication.shared.cancelLocalNotification(notification)
    }
    if shouldRemind && dueDate.compare(NSDate() as Date) != ComparisonResult.orderedAscending {
      let localNotification = UILocalNotification()
        localNotification.fireDate = dueDate as Date
        localNotification.timeZone = NSTimeZone.default
      localNotification.alertBody = text
      localNotification.soundName = UILocalNotificationDefaultSoundName
      localNotification.userInfo = ["ItemID": itemID]
        UIApplication.shared.scheduleLocalNotification(localNotification)
      print("Scheduled notification \(localNotification) for itemID \(itemID)")
    }
  }
  
  func notificationForThisItem() -> UILocalNotification? {
    if let allNotifications = UIApplication.shared.scheduledLocalNotifications {
        for notification in allNotifications {
          if let number = notification.userInfo?["ItemID"] as? NSNumber {
            if number.intValue == itemID {
              return notification
            }
          }
        }

    }
    return nil
  }
  
  deinit {
    let existingNotification = notificationForThisItem()
    if let notification = existingNotification {
      print("Removing existing notification \(notification)")
        UIApplication.shared.cancelLocalNotification(notification)
    }
  }

}

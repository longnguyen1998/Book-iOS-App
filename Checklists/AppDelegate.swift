import UIKit

let appDelegate = UIApplication.shared.delegate as! AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  let dataModel = DataModel()
  
    private func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    let navigationController = window!.rootViewController as! UINavigationController
    let controller = navigationController.viewControllers[0] as! AllListsViewController
    controller.dataModel = dataModel
    
//    let notificationSettings = UIUserNotificationSettings(forTypes: .Alert || .Sound, categories: nil)
//    UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
    
        
        
    return true
  }
  
    func applicationWillResignActive(_ application: UIApplication) {
  }
  
    func applicationDidEnterBackground(_ application: UIApplication) {
    saveData()
  }
  
    func applicationWillEnterForeground(_ application: UIApplication) {
  }
  
    func applicationDidBecomeActive(_ application: UIApplication) {
  }
  
    func applicationWillTerminate(_ application: UIApplication) {
    saveData()
  }
  
  func saveData() {
    dataModel.saveChecklists()
  }
}

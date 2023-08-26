import SwiftUI
import UIKit
import CoreData
import WidgetKit
import PartialSheet

@main
struct Golgi_SplashApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
   @StateObject var data = DayData()
    private let cloudKitManager = CloudKitManager()
    @Environment(\.managedObjectContext) var moc
    let persistenceController = PersistenceController.shared
   @State var pushed = true
    
    var body: some Scene {
        WindowGroup {
            BHome()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(data)
                .environmentObject(NYHAQuestions())
                .environmentObject(PartialSheetManager())
                .navigationBarHidden(true)
        }
    }

}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
                        launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        if UserDefaults.standard.bool(forKey: "didLaunchBefore") == false{
                   UserDefaults.standard.set(true, forKey: "didLaunchBefore")
                   let now = Calendar.current.dateComponents(in: .current, from: Date())
                   let tomorrow = DateComponents(year: now.year, month: now.month, day: now.day! + 1, hour: now.hour, minute: now.minute, second: now.second)
                   let date = Calendar.current.date(from: tomorrow)
                   UserDefaults.standard.set(date, forKey: "tomorrow")
               }
               if UserDefaults.standard.object(forKey: "tomorrow") != nil{//makes sure tomorrow is not nil
                   if Date() > UserDefaults.standard.object(forKey: "tomorrow") as! Date {// if todays date is after(greater than) the 24 hour period you set last time you reset your values this will run
         // reseting "tomorrow" to the actual tomorrow
                       let now = Calendar.current.dateComponents(in: .current, from: Date())
                       let tomorrow = DateComponents(year: now.year, month: now.month, day: now.day!, hour: now.hour, minute: now.minute, second: now.second! + 5)
                       let date = Calendar.current.date(from: tomorrow)
                       UserDefaults.standard.set(date, forKey: "tomorrow")
                       //reset your values here
                    UserDefaults.standard.set(0, forKey: "Drank")
                   }
               }
        return true
    }

}

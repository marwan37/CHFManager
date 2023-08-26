//
//  OnboardOne.swift
//  Golgi-Splash
//
//  Created by Marwan Zaarab on 2021-01-02.
//
import UIKit
import SwiftUI


struct PageView: View {
    var title: String
    var imageName: String
    var header: String
    var content: String
    var textColor: Color

    let imageWidth: CGFloat = 150
    let textWidth: CGFloat = 350
//    let size = UIImage(named: imageName)!.size
//    let aspect = size.width / size.height

    var body: some View {
            VStack(alignment: .center, spacing: 50) {
                Text(title)
                    .font(Font.system(size: 40, weight: .light, design: .rounded))
                    .foregroundColor(textColor)
                    .frame(width: textWidth)
                    .multilineTextAlignment(.center)
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: imageWidth, height: imageWidth)
                    .cornerRadius(40)
                    .clipped()
                VStack(alignment: .center, spacing: 5) {
                    Text(header)
                        .font(Font.system(size: 25, weight: .thin, design: .rounded))
                        .foregroundColor(textColor)
                        .frame(width: 300, alignment: .center)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 20)
                    HStack{
                        Spacer()
                        Text(content)
                        .font(Font.system(size: 18, weight: .light, design: .rounded))
                        .foregroundColor(textColor)
                        .frame(width: 300, alignment: .leading)
                        .multilineTextAlignment(.leading)
                        Spacer()
                    }
                }
            }.padding(60)
    }
}

struct MockData {
    
    static let title = "Rising over CHF"
    static let headers = [
        "1. What is Heart Failure?",
        "2. Living with Heart Failure",
        "3. Managing Heart Failure",
        "4. Creating the best Care Plan for You",
    ]
    static let contentStrings = [
        "Heart failure occurs when your heart isn’t pumping as well as it should be. This means you may feel tired or short of breath because your heart can’t deliver enough oxygen and nutrients to your body. Heart failure can also cause fluid to build up in your lungs and in other places, like your ankles.",
        "Heart failure is a serious condition with no cure. Learning you have heart failure can feel scary, and living with heart failure can be hard on you and your family and caregivers, both physically and emotionally.",
        "But you and your family don’t have to manage it alone. There are things you can do to help feel in control of your condition and improve your quality of life. This app is designed to help support you along the way and minimize hospitalizations and readmissions by having professional caregivers monitoring your well-being at all time.",
        "Your Goals.\nYour Treatment\nYour Well-Being\nSymptoms\nHospitalization\nPalliative care\nHelp for caregivers"
    ]
    static let imageNames = [
        "heartBandage",
        "aha",
        "heartAnatomy",
        "heartPulse"
    ]

    static let colors = [
        "f4f4f2",
        "f4f4f2",
        "f4f4f2",
        "f4f4f2"
        ].map{ Color(hex: $0) }

    static let textColors = [
        "2c3e50",
        "2c3e50",
        "2c3e50",
        "2c3e50"
        ].map{ Color(hex: $0) }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff


        self.init(red: Double(r) / 0xff, green: Double(g) / 0xff, blue: Double(b) / 0xff)
    }
}

//
//lazy var persistentContainer: NSPersistentContainer = {
//    let container = NSPersistentContainer(name: "MyApp")
//    let storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.my.app")!.appendingPathComponent("MyApp.sqlite")
//
//    var defaultURL: URL?
//    if let storeDescription = container.persistentStoreDescriptions.first, let url = storeDescription.url {
//        defaultURL = FileManager.default.fileExists(atPath: url.path) ? url : nil
//    }
//
//    if defaultURL == nil {
//        container.persistentStoreDescriptions = [NSPersistentStoreDescription(url: storeURL)]
//    }
//    container.loadPersistentStores(completionHandler: { [unowned container] (storeDescription, error) in
//        if let error = error as NSError? {
//            fatalError("Unresolved error \(error), \(error.userInfo)")
//        }
//
//        if let url = defaultURL, url.absoluteString != storeURL.absoluteString {
//            let coordinator = container.persistentStoreCoordinator
//            if let oldStore = coordinator.persistentStore(for: url) {
//                do {
//                    try coordinator.migratePersistentStore(oldStore, to: storeURL, options: nil, withType: NSSQLiteStoreType)
//                } catch {
//                    print(error.localizedDescription)
//                }
//
//                // delete old store
//                let fileCoordinator = NSFileCoordinator(filePresenter: nil)
//                fileCoordinator.coordinate(writingItemAt: url, options: .forDeleting, error: nil, byAccessor: { url in
//                    do {
//                        try FileManager.default.removeItem(at: url)
//                    } catch {
//                        print(error.localizedDescription)
//                    }
//                })
//            }
//        }
//    })
//    return container
//}()

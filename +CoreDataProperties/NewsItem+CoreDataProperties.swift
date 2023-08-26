//
//  NewsItem+CoreDataProperties.swift
//  CHFManager
//
//  Created by Marwan Zaarab on 2021-01-03.
//
//

import Foundation
import CoreData


extension NewsItem {
    
    @nonobjc public class func getNewsFeed() -> NSFetchRequest<NewsItem> {
        let request:NSFetchRequest<NewsItem> = NewsItem.fetchRequest() as! NSFetchRequest<NewsItem>
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
  
        request.sortDescriptors = [sortDescriptor]
    
        return request

    }

    @NSManaged public var id: String
    @NSManaged public var title: String
    @NSManaged public var subtitle: String
    @NSManaged public var date: Date
    

    
    

}

extension NewsItem : Identifiable {

    @discardableResult
    static func makeNewsItem(_ notification: [String: AnyObject]) -> NewsItem? {
      guard
        let news = notification["alert"] as? String,
        let subtitle = notification["subtitle"] as? String
      else {
        return nil
      }
        let newItem = NewsItem()
        newItem.makeNews(title: news, subtitle: subtitle)
        print("NEW ITEM FROM TERMINAL: \(newItem)")
        return newItem

  }
    


    func makeNews(title: String, subtitle: String) {
        let context = PersistenceController.shared.container.viewContext
        let item = NewsItem(context: context)
        item.id = UUID().uuidString
        item.title = title
        item.subtitle = subtitle
        item.date = Date()
        saveContext()
    }
    
    func saveContext() {
      // 1
      let context = PersistenceController.shared.container.viewContext
      // 2
      if context.hasChanges {
        do {
          // 3
          try context.save()
        } catch {
          // 4
          // The context couldn't be saved.
          // You should add your own error handling here.
          let nserror = error as NSError
          fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
      }
    }
}

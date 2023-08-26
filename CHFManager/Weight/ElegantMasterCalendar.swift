//
//  WeightCalendar.swift
//  CHFManager
//
//  Created by Deeb Zaarab on 2021-01-31.
//

import SwiftUI
import ElegantCalendar
import CoreData

struct ElegantMasterCalendar: View {
    @FetchRequest(fetchRequest : MasterData.getDayData()) var dayItems:FetchedResults<MasterData>
    let currentCalendar = Calendar.current
    var dateFormat = "EEEE, MMM d"
    @Environment(\.managedObjectContext) var moc
    @State var docID = ""
    @State var isPresented = false
    @State var masterDate = Date()
    @ObservedObject var calendarManager: MonthlyCalendarManager
    @State var dateArray = [String?]()
    init(initialMonth: Date?) {
           let configuration = CalendarConfiguration(
            calendar: currentCalendar,
            startDate: Date().addingTimeInterval(TimeInterval(60 * 60 * 24 * (-2 * 30))),
            endDate: Date().addingTimeInterval(TimeInterval(60 * 60 * 24 * (30 * 36))))
    
        calendarManager = MonthlyCalendarManager(
            configuration: configuration,
            initialMonth: initialMonth)
        
        calendarManager.datasource = self
        calendarManager.delegate = self
    }
        
    var body: some View {
        MonthlyCalendarView(calendarManager: calendarManager)
        
    }
    
    func fetchTheGuestList() {
        let fetchRequest = NSFetchRequest<MasterData>(entityName: "MasterData")
        do{
            let result = try moc.fetch(fetchRequest)
            let dateArray = result.map{$0.date?.string(format: self.dateFormat)}
            self.dateArray = dateArray
            
        } catch {
            print("Could not fetch. \(error)")
        }
        
        
    }
    
}

struct ElegantMasterCalendar_Previews: PreviewProvider {
    static var previews: some View {
        ElegantMasterCalendar(initialMonth: Date())
    }
}

extension ElegantMasterCalendar: ElegantCalendarDataSource {
    func calendar(backgroundColorOpacityForDate date: Date) -> Double {
        var opacity: Double = 1
        let startOfDay = currentCalendar.startOfDay(for: date)
        let startOfDayString = startOfDay.string(format: "EEEE, MMM d")
        if self.dateArray.contains(date.string(format: self.dateFormat)) || self.dateArray.contains(startOfDayString) {
            opacity = 0.8
        } else {
            opacity = 0.3
        }
        return opacity
        
    }

    func calendar(canSelectDate date: Date) -> Bool {
        let day = currentCalendar.dateComponents([.day], from: date).day!
        return day != 4
    }

    func calendar(viewForSelectedDate date: Date, dimensions size: CGSize) -> AnyView {
        let startOfDay = currentCalendar.startOfDay(for: date)
        return AnyView(Master(docID: $docID, isPresented: $isPresented, masterDate: startOfDay)
                            .environmentObject(DayData())
                            .environment(\.managedObjectContext, self.moc))
    }
    
    func docID(forDate date: Date)  {
        
        for i in 0..<dayItems.count {
            let dateSt = date.string(format: self.dateFormat)
            let daySt = dayItems[i].date?.string(format: self.dateFormat)
            if dateSt == daySt {
                self.docID = dayItems[i].id!
            }
        }
      
    }
    
    
    
}

extension ElegantMasterCalendar: ElegantCalendarDelegate {

    
    func calendar(didSelectDay date: Date) {
        isPresented.toggle()
        docID(forDate: date)
        print("Selected date: \(date)")
    }

    func calendar(willDisplayMonth date: Date) {
        print("Month displayed: \(date)")
    }

    func calendar(didSelectMonth date: Date) {
        print("Selected month: \(date)")
    }

    func calendar(willDisplayYear date: Date) {
        print("Year displayed: \(date)")
    }

}

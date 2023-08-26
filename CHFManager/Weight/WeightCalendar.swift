//
//  WeightCalendar.swift
//  CHFManager
//
//  Created by Deeb Zaarab on 2021-01-31.
//

import SwiftUI
import ElegantCalendar
import CoreData

struct WeightCalendar: View {
    @Binding var pushed: Bool
    @FetchRequest(fetchRequest : Weight.getWeightData()) var dayItems:FetchedResults<Weight>
    @FetchRequest(fetchRequest : MasterData.getDayData()) var masterItems:FetchedResults<MasterData>
    @EnvironmentObject var data : DayData

    let currentCalendar = Calendar.current
    var dateFormat = "EEEE, MMM d"
    @State var weight: Double = 0
    @State var monthDisplayed = ""
    @State var index: Int = 0
    @ObservedObject var wmd = WeightModel()
    @State var dryMonth = Date()
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var calendarManager: MonthlyCalendarManager
    @State var dateArray = [String]()
    @State var indexes = [Int]()
    @State var weights = [Double]()
    @State var day = 1
    @State var docID = ""
    init(initialMonth: Date?, pushed: Binding<Bool>) {
           let configuration = CalendarConfiguration(
            calendar: currentCalendar,
            startDate: Date().addingTimeInterval(TimeInterval(60 * 60 * 24 * (-2 * 30))),
            endDate: Date().addingTimeInterval(TimeInterval(60 * 60 * 24 * (30 * 36))))
    
        calendarManager = MonthlyCalendarManager(
            configuration: configuration,
            initialMonth: initialMonth)
        self._pushed = pushed
        calendarManager.datasource = self
        calendarManager.delegate = self
      
    }
        
    var body: some View {
//        VStack{
        MonthlyCalendarView(calendarManager: calendarManager)
//            Spacer()
          
//        }
    }
    

 
    
    func calendar(viewForSelectedDate date: Date, dimensions size: CGSize) -> AnyView {
        return AnyView(
                ScrollView(.vertical, showsIndicators: false) {
                VStack{
                    MasterDataView(dateOG: date, date: date.string(format: self.dateFormat))

                }.padding(.trailing, 55)
                .padding(.vertical, 15)
            
        })
            
            }
  
}

extension WeightCalendar: MonthlyCalendarDataSource {
    func calendar(backgroundColorOpacityForDate date: Date) -> Double {
        var opacity: Double = 0
        let masterDateString = date.string(format: "EEEE, MMM d")
        for i in 0..<masterItems.count {
            let tempDate = masterItems[i].date?.string(format: self.dateFormat)
            if tempDate == masterDateString {
                opacity = 0.8
            }
        }
    
        return opacity

    }

    func calendar(canSelectDate date: Date) -> Bool {
        let day = currentCalendar.dateComponents([.day], from: date).day!
        return day != 4
    }

  
    
    
}

extension WeightCalendar: MonthlyCalendarDelegate {

    
    func calendar(didSelectDay date: Date) {
        let components = currentCalendar.dateComponents([.day], from: date)
        self.index = components.day!
        print("Selected date: \(date) index = \(index) weight = \(weight)")
    }

    func calendar(willDisplayMonth date: Date) {
        self.dryMonth = date
        print("Month displayed: \(date) monthDis = \(date.string(format: "MMM"))")
    }

    func calendar(didSelectMonth date: Date) {
        print("Month displayed: \(date)")
    }

    func calendar(willDisplayYear date: Date) {
        print("Year displayed: \(date)")
    }

}


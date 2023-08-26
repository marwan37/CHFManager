//Orginal code from: https://gist.github.com/mecid/f8859ea4bdbd02cf5d440d58e936faec
//I just made some modification in appearnce, show monthly navigator and weekdays.


import SwiftUI
import CoreData
import Grid
import CloudKit

//import PartialSheet
enum MSheets: Identifiable {
    var id : Int {
        self.hashValue
    }
    case master
}

struct MasterCalendarView: View {
   
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.calendar) var calendar
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var data : DayData
    @FetchRequest(fetchRequest : MasterData.getDayData()) var dayItems:FetchedResults<MasterData>
    
    @State var showingAlert = false
    @State var docID = ""
   @State var heart = false
    @State private var activeSheet : MSheets?
    var dateFormat = "EEEE, MMM d"
  
      private var year: DateInterval {
          calendar.dateInterval(of: .month, for: Date())!
      }
    @State var month = Date()
    @State var completedArray = [String?]()
    @State var dateIntArray: [Int?] = []
    @State var dateArray: [String?] = []
    @State var dateQuery = ""
    @State var modalIsPresented = false
    @State var dateMonth: String? = ""
    @State var dateNumber: Int? = 0
    @State var dateString: String = ""
    @State private var actionState: Int? = 0
    @State var masterDate = Date()
    @State var nyhaNumber : String = "NYHA Questionnaire Week"
    @State var selectedLink : Int = 0
    @State var numbers = [0,1,2,3,4,5,6,7]
    @State var day : Int = 0
      var body: some View {
        ZStack{
            LinearGradient.overall(for: colorScheme).edgesIgnoringSafeArea(.all)
        VStack{
            VStack(spacing:0){
                HStack{
                    (Text("Daily ").bold() + Text("Completion"))
                    .padding(.leading, 20)
                    .opacity(0.7)
                    .font(.system(size: 25, weight: .thin, design: .rounded))
                    
                    Spacer()
                    
                }
           

                CalendarView(interval : self.year) { date in
                let masterDate = self.calendar.date(byAdding: .month, value: 0, to: date)
                let masterDateString = masterDate?.string(format: "EEEE, MMM d")
//                let masterMonth = masterDateString?.subStringAfterLastComma.components(separatedBy: CharacterSet.decimalDigits).joined()
                let masterNumber = String(self.calendar.component(.day, from: date))
                Button(action:{
                                DispatchQueue.main.async {
                                    self.masterDate = masterDate ?? Date()

                                    if self.dateArray.contains(masterDateString){
                                        print("should show alert")
                                        self.showingAlert = true

                                    } else {
                                        self.modalIsPresented = true
                                    }
                                }
                            }){
                                 Text("30")
                                     .hidden()
                                     .padding(8)
                                     .background(
                                         masterDateString == Date().string(format:self.dateFormat) ?
                                            (colorScheme == .light ? Color.neonBlue : Color.red) : Color.clear)
                                     .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding(4)
                                   
                                    .padding(.vertical, ultra > 380 ? 1 : 2)
                                    .padding(.horizontal, 1)
                                    .shadow(color: Color.lairShadowGray.opacity(colorScheme == .light ? 0.8 : 0), radius: 2, x: 3, y: 3)
                                     .overlay(
                                         ZStack{
                                        
                                            if colorScheme == .light {
                                        LinearGradient.lairHorizontalDark
                                            .mask(Image(systemName: dateArray.contains(masterDateString) ? "xmark" : "").font(.system(size: 35, weight: .light)))
                                            } else {
                                                LinearGradient.init(Color(hex: "a3d2ca").opacity(0.5))
                                                    .mask(Image(systemName: dateArray.contains(masterDateString) ? "xmark" : "").font(.system(size: 35, weight: .light)))
                                            }
                                            
                                         Text(masterNumber)
                                            .font(.system(size: 16, weight: .regular, design: .rounded))
                                            .foregroundColor(colorScheme == .light ? .lairDarkGray : .lairWhite)
                                             .underline()
                                             .shadow(color: .lairShadowGray, radius: 2, x: 3, y: 3)
                                         }
                                     )
                                }
                }
//                .offset(y: hulk > 700 ? -180 : 0)
                .padding(.vertical, 25)
            .padding(.horizontal, 20)
//
                Spacer(minLength: hulk > 700 ? ultra / 2 : ultra / 5)
            }
                    .onAppear{
                            self.dateArray = []
                            self.fetchDateCompletion()
                print("dateArray = \(dateArray)")

                            }
            .navigationTitle("")
            .navigationBarHidden(true)
                .padding(.top, 20)
           
//            Divider().padding()
            
            
            
                    }
        .alert(isPresented: $showingAlert) {
                Alert(title: Text("Already Completed"), message: Text("You've already submitted a completion for this day. Replace old one with new one?"), primaryButton: .default(Text("Create New")) {
                    self.verifyDates(masterDate: masterDate)
                    self.modalIsPresented = true
                }, secondaryButton: .cancel() {
                    self.modalIsPresented = false
                    self.fetchDateCompletion()
                })
            }
                .sheet(isPresented: $modalIsPresented) {
                  Master(docID: $docID,
                           masterDate: masterDate)
                          .environmentObject(DayData())
                          .environment(\.managedObjectContext, self.moc)
                }
        }
                
        }
        



    
    func verifyDates(masterDate: Date){
        let masterDateStr = masterDate.string(format: self.dateFormat)
        for collection in dayItems {
            let collectionDateString = collection.date?.string(format: self.dateFormat)
            if collectionDateString == masterDateStr{
               
                    DispatchQueue.main.async {
//                        let db = Firestore.firestore()
//                        db.collection("dayDatas").document(docID).delete()
                        moc.delete(collection)
                        saveMoc()
                        
                    }
                }
        }
        
        // MARK: - delete from CloudKit
        for item in self.data.items {
            let itemDateString = item.date.string(format: self.dateFormat)
            if itemDateString == masterDateStr {
                guard let recordID = item.recordID else { return }
                
                // MARK: - delete from CloudKit
                CloudKitHelper.delete(recordID: recordID) { (result) in
                    switch result {
                    case .success(let recordID):
                        self.data.items.removeAll { (listElement) -> Bool in
                            return listElement.recordID == recordID
                        }
                        print("Successfully deleted item")
                    case .failure(let err):
                        print(err.localizedDescription)
                    }
                }
            }
        }
    }

    func saveMoc() {
        do {
            try moc.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved Error: \(error)")
        }
    }
    func fetchMonthCompletion(month: String?) {
        for i in 0..<dateArray.count {
            if dateArray[i]?.subStringAfterLastComma.components(separatedBy: CharacterSet.decimalDigits).joined() == month {
                self.completedArray.append(dateArray[i])
            }
        }
    }
    func fetchDateCompletion() {
        let fetchRequest = NSFetchRequest<MasterData>(entityName: "MasterData")
        do{
            let result = try moc.fetch(fetchRequest)
            let dateArray = result.map{$0.date?.string(format: self.dateFormat)}
            
            self.dateArray = dateArray
           
            
           
            for i in 0..<dateArray.count {
                let dateInt = Int(self.dateArray[i]!.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
                self.dateIntArray.append(dateInt)
            }
        } catch {
            print("Could not fetch. \(error)")
        }
        

    }
    

    
}



struct MasterCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        MasterCalendarView().preferredColorScheme(.dark)
    }
}

struct MonthView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar
    @State var monthString : String
    @State var month: Date
    @State var index: Int = 0
    let showHeader: Bool
    let content: (Date) -> DateView

    init(
        month: Date,
        monthString: String = "",
        showHeader: Bool = true,
        localizedWeekdays: [String] = [],
        @ViewBuilder content: @escaping (Date) -> DateView
    ) {
        self._month = State(initialValue: month)
        self.content = content
        self.showHeader = showHeader
        self._monthString = State(initialValue: month.string(format: "MMM"))
    }
    @Environment(\.colorScheme) var cs
    private var weeks: [Date] {
        guard
            let monthInterval = calendar.dateInterval(of: .month, for: month)
            else { return [] }
        return calendar.generateDates(
            inside: monthInterval,
            matching: DateComponents(hour: 0, minute: 0, second: 0, weekday: calendar.firstWeekday)
        )
    }

    func changeDateBy(_ months: Int) {
        if let date = Calendar.current.date(byAdding: .month, value: months, to: month) {
            self.month = date

        }
    }


    private var header: some View {
       
        let component = calendar.component(.month, from: month)
        let formatter = component == 1 ? DateFormatter.monthAndYear : .month
        return HStack{
            HStack(spacing: 15){
                Group{
                    Button(action: {
                        self.changeDateBy(-1)


                    }) {
                    Image(systemName: "chevron.left.square") //
                        .font(.system(size: 30, weight: .ultraLight))
                        .foregroundColor(Color.textColor(for: cs))
                        .shadow(color: cs == .dark ? Color.white.opacity(0.3) : Color.black.opacity(0.3), radius: 2, x: 2, y: 2)
                    }
                    Button(action: {
                        self.month = Date()

                    }) {
                    Image(systemName: "dot.square")
                        .font(.system(size: 30, weight: .ultraLight))
                        .foregroundColor(Color.textColor(for:cs))
                        .shadow(color: cs == .dark ? Color.white.opacity(0.3) : Color.black.opacity(0.3), radius: 2, x: 2, y: 2)
                    }
                    Button(action: {
                        self.changeDateBy(1)
                        self.monthString = month.string(format: "MMM")
                    }) {
                    Image(systemName: "chevron.right.square") //"chevron.right.square"
                        .font(.system(size: 30, weight: .ultraLight))
                      
                                .foregroundColor(Color.textColor(for:cs))
                                .shadow(color: cs == .dark ? Color.white.opacity(0.3) : Color.black.opacity(0.3), radius: 2, x: 2, y: 2)
                    }
                }
                .foregroundColor(Color.blue)
                .frame(width: 25, height: 25)

            }.padding(.leading, 5)
            Spacer()
            (Text(self.month.string(format: "MMMM")).bold() + Text(" \(self.month.string(format: "Y"))").font(.system(size: 18, weight: .thin)))
            .padding(.trailing, 5)
            .opacity(0.7)
            .font(.system(size: 23, weight: .thin, design: .rounded))
            .padding(.trailing, 5)
          
        }
    }
   //MARK: CODE FOR MONTH VIEW + QUESTIONNAURE
    var body: some View {

        VStack {
            if showHeader {
                    header
            }
            HStack{
                ForEach(0..<7, id: \.self) {index in
                    Text("30")
                        .hidden()
                        .padding(ultra > 400 ? 8 : 7)
                        .clipShape(Circle())
                        .padding(.horizontal, 4)
                        .overlay(
                            
                            Text(getWeekDaysSorted()[index].lowercased())
                                .font(.system(size: hulk > 700 ? 17 : 15, weight: .semibold, design: .rounded))
                                .foregroundColor(Color.textColor(for:cs))
                                .opacity(0.3)
                                .shadow(color: cs == .dark ? Color.white.opacity(0.3) : Color.black.opacity(0.3), radius: 2, x: 2, y: 2)
                            
                    )
                        .padding(.horizontal, ultra > 400 ? 2 : 0)
                }
            }

            ForEach(weeks, id: \.self) { week in
                WeekView(week: week, content: self.content)
            }

        }

    }
    func getWeekDaysSorted() -> [String]{
        let weekDays = Calendar.current.shortWeekdaySymbols
        let sortedWeekDays = Array(weekDays[Calendar.current.firstWeekday - 1 ..< Calendar.current.shortWeekdaySymbols.count] + weekDays[0 ..< Calendar.current.firstWeekday - 1])
        return sortedWeekDays
    }

}

struct CalendarView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar

    let interval: DateInterval
    let content: (Date) -> DateView


    init(interval: DateInterval, @ViewBuilder content: @escaping (Date) -> DateView) {
        self.interval = interval
        self.content = content
    }

    private var months: [Date] {
        calendar.generateDates(
            inside: interval,
            matching: DateComponents(day: 1, hour: 0, minute: 0, second: 0)
        )
    }

    var body: some View {

        ForEach(months, id: \.self) { month in
            VStack{
                MonthView(month: month, content: self.content)

            }

            }

    }
}

extension String {
    var subStringAfterLastComma : String {
        guard let subrange = self.range(of: ",\\s?", options: [.regularExpression, .backwards]) else { return self }
        return String(self[subrange.upperBound...])
    }
}



fileprivate extension DateFormatter {
    static var month: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }

    static var monthAndYear: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
}

fileprivate extension Calendar {
    func generateDates(
        inside interval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates: [Date] = []
        dates.append(interval.start)

        enumerateDates(
            startingAfter: interval.start,
            matching: components,
            matchingPolicy: .nextTime
        ) { date, _, stop in
            if let date = date {
                if date < interval.end {
                    dates.append(date)
                } else {
                    stop = true
                }
            }
        }

        return dates
    }
}

struct WeekView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar

    let week: Date
    let content: (Date) -> DateView

    init(week: Date, @ViewBuilder content: @escaping (Date) -> DateView) {
        self.week = week
        self.content = content
    }

    private var days: [Date] {
        guard
            let weekInterval = calendar.dateInterval(of: .weekOfYear, for: week)
            else { return [] }
        return calendar.generateDates(
            inside: weekInterval,
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        )
    }

    var body: some View {
        HStack {
            Grid(days, id: \.self) { date in
                HStack {
                    if self.calendar.isDate(self.week, equalTo: date, toGranularity: .month) {
                        self.content(date)
                    } else {
                        self.content(date).hidden()
                    }
                }
            }.gridStyle(
                ModularGridStyle(.vertical, columns: 7, rows: 6, spacing: 0)
            )
        }
    }
}


let gridstyle4sect = ModularGridStyle(columns: .min(10), rows: .fixed(20), spacing: 4)
let gridStyleCal =  ModularGridStyle(.vertical, columns: 7, rows: .fixed(hulk > 700 ? 0 : 20))

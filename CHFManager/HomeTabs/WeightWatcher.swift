//
//  NewsFeedView.swift
//  Golgi-Splash
//
//  Created by Marwan Zaarab on 2021-01-03.
//

import SwiftUI
import UserNotifications
import CoreData
import Grid

struct WeightWatcher: View{
    @Environment(\.calendar) var calendar
    @Environment(\.colorScheme) var cs: ColorScheme
    @Environment(\.managedObjectContext) var moc
    private var gridItemLayout = [GridItem(.flexible()),GridItem(.flexible())]
    @FetchRequest(fetchRequest : Weight.getWeightData()) var dayItems:FetchedResults<Weight>
    @State var months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"]
    @State var weightArray : [[Double]] = [[Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double]() ]
    @State var weights = [Double]()
    @State var day: Int = 0
    @State var indexes = [Int]()
    @State var dateMonthArray = [String?]()
    @State var isSheetShown = false
    @State var month = Date()
   
    @State var weight: Double = 0.0
    @State var showRedAlert = false
    @State var remove = false
 @State var showInfo = false
    @State var weightMonthKg: [Double] = []
    @State var liquidWeightData = [Double]()
    @State var toggle : Bool = false
   @State var selected = 0
    var body: some View {
        ZStack{
            LinearGradient.overall(for: cs).edgesIgnoringSafeArea(.all)
//            Color.backgroundColor(for: cs).edgesIgnoringSafeArea(.all)
           
            ScrollView{
                
        VStack{

            VStack(spacing:0){
            HStack{
                (Text("weight ").bold() + Text("tracker"))
                .padding(.trailing, 20)
                .opacity(0.7)
                .font(.system(size: 22, weight: .thin, design: .rounded))
                
                .padding()
                
                Spacer()
                
            }
           
            HStack{
                monthbuttons .padding(.leading, 25)
            Spacer()
                (Text(self.month.string(format: "MMMM").lowercased()).bold() + Text(" \(self.month.string(format: "Y"))").font(.system(size: 12, weight: .thin)))
                .padding(.trailing, 20)
                .opacity(0.7)
                .font(.system(size: 22, weight: .thin, design: .rounded))
                .padding(.trailing, 5)

            }
              
            }
          
                let days = self.getNumDays(month: self.month)
                Grid(1..<days+1, id: \.self) { day in
                    Button(action:{
                        DispatchQueue.main.async {
                            self.day = day
                                if checkWeightIndex(month: month, day: day) > 0  {
                                    self.isSheetShown = false
                                    self.showRedAlert = true
                                } else {
                                   
                                    self.isSheetShown.toggle()
                                    
                                }
                        }

                    })
                    {
                        ZStack{

                        Text("30")
                            .hidden()
                            .padding(7)

                            .overlay(
                                VStack(spacing: 12){
                               
                                Text("\(day)")
                                    .underline()
                                    .foregroundColor(cs == .light ? .lairDarkGray : .lairWhite)
                                   
                                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                                    .opacity(0.6)
        
                                    ZStack{
                                        let mass = self.checkWeightIndex(month: month, day: day)
                                        
                                        Text(mass > 0 ? "\(String(format: "%.1f",self.checkWeightIndex(month: month, day: day)))" : "")
                                            .fixedSize(horizontal: false, vertical: true)                                         .font(.system(size: 12, weight: .regular, design: .rounded))
                                            .foregroundColor(Color.textColor(for: cs))
                                            .opacity(0.8)
                                   
                                        Image(systemName: mass > 0 ? "" : "plus.circle.fill")
                                            .font(.system(size: 15, weight: cs == .dark ? .regular : .thin))
                                            .foregroundColor(Color("Color1").opacity(0.95))
                                       
                                    }

                                }
                            )
                    }
                    }.sheet(isPresented: $isSheetShown) {
                        WeightView(weight: $weight, index: $day, monthString: month.string(format: "MMM"))
                            .frame(height: UIScreen.main.bounds.height / 4)
                            .background(LinearGradient.overall(for: cs))
                            .cornerRadius(10.0)
                            .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.13), radius: 10.0)
                    } .frame(width: ultra, height: hulk / 4)
           
                  
                    
                   
                }.alert(isPresented: $showRedAlert) {
                    Alert(title: Text("Already Completed"), message: Text("You've already entered your weight for this day. Overwrite entry?"), primaryButton: .default(Text("Create New")) {
                        
                        self.deleteWeight(month: month, day: day)
                        self.isSheetShown.toggle()
                        
                    }, secondaryButton: .cancel() {
                        self.isSheetShown = false
                    })
                }
                .frame(height: 370)
               
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
                
//            .padding()
            .onAppear {
                DispatchQueue.main.async {
                    self.weightArray = [[], [], [], [], [], [], [], [], [], [] ,[] ,[]]
                    self.indexes = []
                    self.weights = []
                    self.dateMonthArray = []
                    self.weightMonthKg = []
                    self.fetchScores()
                    self.convertWeight()
                    self.liquidWeightData = weights
                }
            }
           
            Divider().padding()
            VStack(spacing:0){
                DryView(month: $month, selected: $selected, showInfo: $showInfo).frame(width: ultra, height: 60)
                Picker("", selection: $selected) {
                    Text("pounds (lbs)").tag(0)
                    Text("kilograms (kg)").tag(1)
                }.pickerStyle(SegmentedPickerStyle()).frame(width:ultra - 40, height: 30).padding(.top, 15).opacity(0.8)
              
//            HStack(spacing:20){
//                Spacer()
//                Button(action:{
//                    selected = 0
//                }){
//                    Text("lbs")
//                        .foregroundColor(selected == 0 ? Color.black.opacity(0.9) : Color.grayMe)
//                        .font(.system(size: 18, weight: .light, design:.rounded))
//
//                        .padding(12)
//
//                }
//                .buttonStyle(selected == 0 ?
//                                OtherModifiah(color: Color.neonBlue,r: 15, pressed: true ) :
//                                OtherModifiah(color: Color("ColorNeuro"),r: 15, pressed: false))
//                .opacity(selected == 0 ? 0.8 : 0.6)
//
//                Image(systemName: "arrow.left.arrow.right")
//                    .opacity(0.6)
//                Button(action:{
//                    selected = 1
//
//                }){
//                    Text("kg")
//                        .foregroundColor(selected == 1 ? Color.black.opacity(0.9) : Color.grayMe)
//                        .font(.system(size: 18, weight: .regular, design:.rounded))
//
//
//                        .padding(12)
//
//                }.buttonStyle(selected == 1 ?
//                                OtherModifiah(color: Color.neonBlue,r: 15, pressed: true ) :
//                                OtherModifiah(color: Color("ColorNeuro"),r: 15, pressed: false))
//                .opacity(selected == 1 ? 0.8 : 0.6)
//
//                Spacer()
//            }.frame(height: 70)
            }
        }.blur(radius: showInfo ? 15 : 0)
            }.gridStyle(
                ModularGridStyle(columns: 7, rows: self.getNumDays(month: self.month) > 28 ? 5 : 4) //spacing: 20)
            )
//            SlideOverCard{
           
              
            
             VStack(alignment:.leading){
               
                 Text("Your dry weight is your weight when you do not have extra fluid in your body. Ask your doctor or nurse what your dry weight is, then enter it on this page.\n\nCompare your daily weight to your dry weight. Your goal at home is to keep your weight within 4 pounds (higher or lower) of your dry weight. Your dry weight will change with time so be sure to ask your doctor or nurse what your dry weight is at every visit.").font(.system(size: 16, weight: .light, design: .rounded)).opacity(0.7)
                 .padding(.horizontal)
                 .frame(maxWidth: .infinity, alignment: .center)
                Button("Dismiss"){self.showInfo.toggle()}
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 5)
 //                .multilineTextAlignment(.center)
             }.padding(.vertical, 10)
             .frame(height: UIScreen.main.bounds.height / 4)
             .background(LinearGradient.overall(for: cs))
             .cornerRadius(10.0)
             .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.13), radius: 10.0)
             .offset(y: showInfo ? 0 : 1000)
             
           
                
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
       
    }
    func deleteWeight(month: Date, day: Int) {
        let mois = month.string(format: "MMM")
       
        for i in 0..<dayItems.count {
            if dayItems[i].weightIndex == day && dayItems[i].month == mois {
                moc.delete(dayItems[i])
            
            }
        }
        saveMoc()
    }
    func checkWeightIndex(month: Date, day: Int) -> Double {
        let mois = month.string(format: "MMM")
        var weight : Double = 0
    
        for i in 0..<indexes.count {
            if indexes[i] == day && dateMonthArray[i] == mois {
                if selected == 0 {
                weight = weights[i]
                } else {
                    weight = weightMonthKg[i]
                }
            
            }
        }
        return weight
    }
    var monthbuttons : some View {
      
            
            HStack(spacing: 15){
                Group{
                    Button(action: {
                        self.changeDateBy(-1)
                       
                    }) {
                        Image(systemName: "chevron.left.square")
                            .font(.system(size: 25, weight: .ultraLight))
                          
                                    .foregroundColor(Color.textColor(for:cs))
                                    .shadow(color: cs == .dark ? Color.white.opacity(0.3) : Color.black.opacity(0.3), radius: 2, x: 2, y: 2)
                    }
                    Button(action: {
                        self.month = Date()
                    }) {
                    Image(systemName: "dot.square")
                        .font(.system(size: 25, weight: .ultraLight))
                        .foregroundColor(Color.textColor(for:cs))
                        .shadow(color: cs == .dark ? Color.white.opacity(0.3) : Color.black.opacity(0.3), radius: 2, x: 2, y: 2)
                    }
                    Button(action: {
                        self.changeDateBy(1)
                    }) {
                        Image(systemName: "chevron.right.square")
                            .font(.system(size: 25, weight: .ultraLight))
                          
                                    .foregroundColor(Color.textColor(for:cs))
                                    .shadow(color: cs == .dark ? Color.white.opacity(0.3) : Color.black.opacity(0.3), radius: 2, x: 2, y: 2)
                    }
                }
                .foregroundColor(Color.darkBG)
                .frame(width: 25, height: 25)
                
            }
           
           
             
     
    }
    func convertWeight()  {
        for i in 0..<weights.count {
            let temp = weights[i]/2.2
            self.weightMonthKg.append(temp)
        }
    }
  
  
    func fetchScores() {
        let fetchRequest = NSFetchRequest<Weight>(entityName: "Weight")
        do{
            let result = try moc.fetch(fetchRequest)
            let weights = result.map{$0.weight}
            let dateMonthArray = result.map{$0.month}
            let weightIndexArray = result.map{$0.weightIndex}
            self.indexes = weightIndexArray
            self.weights = weights
            self.dateMonthArray = dateMonthArray
           print("weightIndexArray \(weightIndexArray)")
            print("indexes \(indexes)")
            
        } catch {
            print("Could not fetch. \(error)")
        }
    }
        
    func changeDateBy(_ months: Int) {
        if let date = Calendar.current.date(byAdding: .month, value: months, to: month) {
            self.month = date
        }
    }
    
    func getNumDays(month: Date) -> Int{
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: month)!
        let numDays = range.count
        print("numberOfDays: \(numDays)")
        return numDays
    }
    
 
    
    func saveMoc() {
        self.moc.performAndWait {
            if self.moc.hasChanges {
                do {
                    try moc.save()
                }
                 catch {
                    let error = error as NSError
                    fatalError("Unresolved Error: \(error)")
                }
            }
        }
    }
    

}

struct WeightWatcher_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
        WeightWatcher()
        }
            .environment(\.colorScheme, .dark)
//            .addPartialSheet()
            .navigationViewStyle(StackNavigationViewStyle())
//            .environmentObject(PartialSheetManager())
    }
}

extension Notification.Name {
    static let myNotification = Notification.Name("myNotification")
}
// Extension

extension View {
    func onReceive(_ name: Notification.Name,
                   center: NotificationCenter = .default,
                   object: AnyObject? = nil,
                   perform action: @escaping (Notification) -> Void) -> some View {
        self.onReceive(
            center.publisher(for: name, object: object), perform: action
        )
    }
}


struct DryView : View {
    @FetchRequest(entity: DryWeight.entity(), sortDescriptors: []) var dryItems: FetchedResults<DryWeight>
    @Environment(\.colorScheme) var cs: ColorScheme
    @Environment(\.managedObjectContext) var moc
    @State var showingAlertForSavedEntry = false
    @Binding var month: Date
    @Binding var selected: Int
    @State var dryWeight = ""
    @State var isEditing = false
    @Binding var showInfo : Bool
    @ObservedObject var viewModel = ViewModel()
    var body: some View {
        VStack{
            HStack{
                Text("Dry Weight:")
                let monthy = self.month.string(format: "MMM Y")
                if self.checkDryMonth(month: monthy) && !isEditing {
                    Text("\(self.returnDryWeight(month: monthy), specifier: "%.1f")") + Text(selected == 0 ? " lbs" : " kg")
                } else {
                    HStack{
                    TextField("Enter dry weight (\(self.month.string(format: "MMM")))", text: $dryWeight)
                        .keyboardType(.numberPad)
                        .padding(.trailing, 9).opacity(0.5)
                        Text(selected == 0 ? "lbs" : "kg")
                    }
                }
               
                if checkDryMonth(month: monthy) {
                    HStack{
                    Button(action: {
                        isEditing.toggle()
                       
                    }){
                        Image(systemName: isEditing ? "xmark.circle" : "pencil")
                            .foregroundColor(Color.textColor(for: cs))
                            .font(.system(size: 16))
                        
                    }.padding(.trailing, 5)
                    
                        Spacer(minLength: 0)
                           
                        Button(action: {
                            for i in 0..<dryItems.count {
                                if dryItems[i].monthYear == monthy {
                                    dryItems[i].dryWeight = self.dryWeight
                                }
                            }
                            self.saveMoc()
                            self.showingAlertForSavedEntry.toggle()
                            isEditing = false
                        })
                        {
                            Image(systemName: "square.and.arrow.down")
            //                        .foregroundColor(Color.textColor(for: cs))
                                .font(.system(size: 18))
                        }.disabled(!isEditing)
                        .opacity(isEditing ? 1 : 0.5)
                        .alert(isPresented: $showingAlertForSavedEntry, content: {
                            Alert(title: Text("Dry Weight"), message: Text("Your Dry weight for \(self.month.string(format: "MMM Y")) has been saved successfully."), dismissButton: .default(Text("Ok")))
                        })
                    }
                } else {
            Button(action: {
                let newDryWeight = DryWeight(context: self.moc)
                newDryWeight.monthYear = self.month.string(format: "MMM Y")
                newDryWeight.dryWeight = self.dryWeight
                self.saveMoc()
                self.showingAlertForSavedEntry.toggle()
            }){
                Image(systemName: "square.and.arrow.down")
//                        .foregroundColor(Color.textColor(for: cs))
                    .font(.system(size: 20))
            }.padding(.trailing, 5)
            .alert(isPresented: $showingAlertForSavedEntry, content: {
                Alert(title: Text("Dry Weight"), message: Text("Your Dry weight for \(self.month.string(format: "MMM Y")) has been saved successfully."), dismissButton: .default(Text("Ok")))
            })
                }
                
               
                
                    
                
                Button(action:{
                    self.showInfo.toggle()
                }){
                    Image(systemName: "questionmark.circle")
                        .foregroundColor(Color.textColor(for: cs)).opacity(0.6)
                        .font(.system(size: 20))
                }
                
            } .font(.system(size: ultra > 400 ? 16 : 15, weight: .light, design: .rounded))
            .padding(.horizontal, 25)
          
//           Spacer()
            Divider().padding()
//            Spacer(minLength: 30)
           
         
           
        }
    }
    func returnDryWeight(month: String) -> Double {
        var w: Double = 0
        for i in 0..<dryItems.count {
            if dryItems[i].monthYear == month {
                if selected == 0 {
                let doubleW = Double(dryItems[i].dryWeight)!

                w = doubleW
                } else {
                    let doubleW = Double(dryItems[i].dryWeight)!
                    let bw = doubleW / 2.2
                    w = bw
                }
            }
           
    }
        return w
    }
    func checkDryMonth(month: String) -> Bool  {
        var r = false
        for i in 0..<dryItems.count {
            if dryItems[i].monthYear == month {
                r = true
            }
        }
      return r
    }
    func saveMoc() {
        self.moc.performAndWait {
            if self.moc.hasChanges {
                do {
                    try moc.save()
                }
                 catch {
                    let error = error as NSError
                    fatalError("Unresolved Error: \(error)")
                }
            }
        }
    }
}





//
//   func notify() {
//     DispatchQueue.main.async {
//       let content = UNMutableNotificationContent()
//        content.title = "Feed the cat"
//        content.subtitle = "it looks hungry"
//        content.sound = UNNotificationSound.default
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 6, repeats: false)
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//        UNUserNotificationCenter.current().add(request)
//
//       let newsItem = NewsItem(context: self.moc)
//       newsItem.id = UUID().uuidString
//       newsItem.title = content.title
//       newsItem.subtitle = content.subtitle
//       newsItem.date = Date()
//       self.saveMoc()
//
//
//     }
//   }


//            List{
//                ForEach(newsItems, id: \.id) { new in
//                    HStack{
//                    VStack{
//                        Text(new.title)
//                            .font(.callout)
//                        Text(new.subtitle)
//                            .font(.caption)
//                    }
//                        Spacer()
//                        Text(new.date.string(format: "EEEE, MMM, d"))
//                            .font(.caption)
//                    }
//
//                }.onDelete(perform: deleteItems)
//
//
//            }.listStyle(InsetGroupedListStyle())
//
//            .navigationTitle("News Feed")
//            .navigationBarItems(leading: EditButton()
//
//                                , trailing:
//                                    Button(action:{
//
//                                        self.notify()
//                                    }){
//                                        Text("Notification")
//                                    }
//
//            )
    
let mockDates = [1, 26]
let mockWeight = [222, 223]
let cols = [ GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

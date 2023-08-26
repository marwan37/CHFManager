//
//  WaterBottle.swift
//  Golgi-Splash
//
//  Created by Marwan Zaarab on 2020-11-24.
//

import SwiftUI
import Combine
import FloatingButton
import CoreData

struct WaterContainer_Previews: PreviewProvider {
    
    static var previews: some View {

            WaterContainer()
//                .preferredColorScheme(.light)
        
    }
}
let colos = [GridItem(.adaptive(minimum: 120)),GridItem(.adaptive(minimum: 120))]
let rows = [GridItem(.fixed(20)),GridItem(.fixed(20)),GridItem(.fixed(20)),GridItem(.fixed(20))]
struct WaterContainer: View {
    init() {
       UITableView.appearance().separatorStyle = .none
       UITableViewCell.appearance().backgroundColor = .clear
       UITableView.appearance().backgroundColor = .clear
    }
    @Environment(\.colorScheme) var cs : ColorScheme
    @EnvironmentObject var dayData : DayData
    @State var recHeight:Double = 0
    @State var mainButtonUnit = AnyView(MainButton(imageName: "", colorHex: ""))
    @State var isOpen = false
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: CD_Liquids.entity(), sortDescriptors: []) var liquidItems: FetchedResults<CD_Liquids>
    @State var liquidsArray = [Double]()
    @State var dateArray = [String?]()
  
    @State var didDrink = false
    var colors: [Color] = [.white, .pulsatingColor]
//    var anime: [SplashShape.SplashAnimation] = [.topToBottom, .bottomToTop]
    @State var index: Int = 0
    @State var limit:Double = 64
    @State private var drank:Double = 0
    @State private var drankIndex:Int = 0
    @State private var indexes : [Int] = [0,0,0,0,0,0,0,0]
    @ObservedObject var settings = UserSettings()
    @State var showLimit = true
    @State var showTime = true
    @State private var currentDate = Date()
    @State var showExtraInfo = false
    @State var tempLimit = ""
    @State var dateStr = ""
@State var timeStart = Date()
    @AppStorage("drank", store: UserDefaults(suiteName: "group.H97YA8G6R5.com.golgi.CHFManager")) var drankData: Data = Data()
    @AppStorage("liquidLimit", store: UserDefaults(suiteName: "group.H97YA8G6R5.com.golgi.CHFManager")) var limitData: Data = Data()
    @State var activeUnit = "oz"
    @State var originalUnit = "oz"
    @State var change = false
    private var sizes = [2,4,6,8]
    @State var alertingSave = false
    @State var tapped = 3
    
    private var coloredSquares: [Color] = [.yellow, .blue, .green, .neonRed, .red]
    @State var timeRemaining = 24*60*60
    
    var fontsz : CGFloat {
        if ultra > 400 {
            return 16
        } else {
            return 14
        }
    }
    
    var largesz: CGFloat {
        if ultra > 400 {
            return 22
        } else {
            return 18
        }
    }
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
        
        ZStack{
            LinearGradient.overall(for: cs).edgesIgnoringSafeArea(.all)

            GeometryReader{ geo in
            ScrollView(.vertical){
                
                VStack{
                    HStack{
                        (Text("liquid ").bold() + Text("tracker"))
                        .padding(.trailing, 20)
                        .opacity(0.7)
                            .font(.system(size: 22, weight: cs == .light ? .light : .thin, design: .rounded))
                           
                            .shadow(color: Color.black.opacity(cs == .light ? 0.7 : 0.2), radius: 1, x: -1, y: 1)
                        .padding()
                        
                        Spacer()
                        
                    }
                    HStack{
               
                        HStack{
        
                    }
                        
                    }.foregroundColor(self.cs == .dark ? Color.lairWhite : Color.pulsatingColor)
                
                        HStack{
                            
                            LazyVGrid(columns: colos){
                                
                                
                                Bottles.padding()
                                
                                HStack(spacing: 0){
                                
                                Buttons.padding(.leading, 10)
                                  Spacer()
                                    LazyVGrid(columns: [GridItem(.fixed(50))], spacing: 10){
                                        VStack{
                                        ForEach(0..<sizes.count){ i in
                                            Button(action:{
                                                self.tapped = i
                                            })
                                            {
                                                Text("\(sizes[i])")
                                                    .font(.system(size: 14, weight: .regular, design:.rounded))
                                                    .frame(width: 30, height: 30)
                                                    .foregroundColor(self.tapped == i ? .white : .black)
                                                    .background(self.tapped == i ? Color.black : Color.white)
                                                    .cornerRadius(5)
                                                    .shadow(color: Color.black.opacity(self.tapped == i ? 0 : 0.6), radius: 2, x: -2, y: -2)
                                            }.padding(.vertical, 2)
                                        }
                                    }.padding(.top, 40)
                                        
                                    
                                        UnitButtons.padding(.leading, 20)
                                    }
                                    
                                }
                            }
                            
                        }
                   
                    VStack{
    
                        Section{
                            HStack{
                            Text("Liquid Intake Today")
                                .padding(.trailing, 20)
                                .opacity(0.8)
                                .font(.system(size: largesz, weight: .light, design: .rounded))
                                .shadow(color: Color.black.opacity(0.2), radius: 1, x: -1, y: 1)
                            Spacer()
                            Text("\(self.newUnit(val: drank)) \(self.activeUnit == "L" ? "L" : (self.activeUnit == "ml" ? "mL" : "oz"))")
                                .font(.system(size: fontsz+7, weight: .light, design: .rounded))
                                .foregroundColor(drank >= limit ? .red : (cs == .light ? Color.pulsatingColor.opacity(0.6) : Color.white.opacity(0.6)))
                            }
                           
                            .onAppear{
                                    self.drank = UserDefaults.standard.double(forKey: "Drank")
                                self.limit = UserDefaults.standard.double(forKey: "LiquidLimit")
                                    saveData(drank)
                                    
                                }
                            .onDisappear{
                                self.drank = UserDefaults.standard.double(forKey: "Drank")
                            self.limit = UserDefaults.standard.double(forKey: "LiquidLimit")
                                saveData(drank)
                            }
                            
                            .onChange(of: drank) { _ in
                                    let url = FileManager.appGroupContainerURL.appendingPathComponent(FileManager.liquidFileName)
                                    try? String(drank).write(to: url, atomically: false, encoding: .utf8)
                                }
                            .onChange(of: tempLimit) { _ in
                                let url = FileManager.appGroupContainerURL.appendingPathComponent(FileManager.liquidLimitFileName)
                                try? tempLimit.write(to: url, atomically: false, encoding: .utf8)
                            }
                            Divider().hidden()
                       
                            HStack{
                            Text("Balance from limit")
                                .padding(.trailing, 20)
                                .opacity(0.87)
                                .font(.system(size: largesz, weight: .light, design: .rounded))
                                .shadow(color: Color.black.opacity(0.2), radius: 1, x: -1, y: 1)
                            //Balance
                           Spacer()
                                Text("\(self.newUnit(val: limit-drank)) \(self.activeUnit == "L" ? "L" : (self.activeUnit == "ml" ? "mL" : "oz"))")
                                    .font(.system(size: fontsz+7, weight: .light, design: .rounded))
                                    .foregroundColor(drank >= limit ? .red : cs == .light ? Color.green.opacity(0.6) : Color.green.opacity(0.6))
                                
                            }
             .font(.system(size: fontsz, weight: .regular, design: .rounded))
  
                         
                            Divider().hidden()
                             HStack{
                                 Text("Next Cycle in")
                                    .padding(.trailing, 20)
                                    .opacity(0.8)
                                    .font(.system(size: largesz, weight: .light, design: .rounded))
                                    .shadow(color: Color.black.opacity(0.2), radius: 1, x: -1, y: 1)
                                     Spacer()
           
                                
                                Text("\(timeString(newTime: timeRemaining))")
                                    .font(.system(size: largesz - 2, weight: .light, design: .rounded))
                                    .frame(height: 20.0)
                                    .foregroundColor(cs == .light ? Color.pulsatingColor.opacity(0.6) : Color.white.opacity(0.6))
                                   
                                    .onReceive(timer){ _ in
                                        if self.timeRemaining > 0 {
                                            self.timeRemaining -= 1
                                        } else if self.timeRemaining < 1 {
                                            let dater = Date().string(format: "MMM d")
                                            if !dateArray.contains(dater) {
                                            let newLiquidData = CD_Liquids(context: self.moc)
                                            newLiquidData.intake = self.drank
                                            newLiquidData.date = Date()
                                            newLiquidData.limit = self.limit
                                            }
                                        } else{
                                            self.timer.upstream.connect().cancel()
                                         
                                        }
                                    }
                              
                             }
                            Divider().hidden()
                            cycleStart
                            Divider().hidden()
                            HStack{
                            Text("Save Intake for Today")
                                .padding(.trailing, 20)
                                .opacity(0.87)
                                .font(.system(size: largesz, weight: .light, design: .rounded))
                                .shadow(color: Color.black.opacity(0.2), radius: 1, x: -1, y: 1)
                            //Balance
                           Spacer()
                                Button(action:{
                                    let dater = Date().string(format: "MMM d")
                                    if !dateArray.contains(dater) {
                                    let newLiquid = CD_Liquids(context: self.moc)
                                    newLiquid.intake = self.drank
                                    newLiquid.limit = self.limit
                                    newLiquid.date = Date()
                                    self.save()
                                        self.alertingSave.toggle()
                                    } else {
                                        for i in 0..<dateArray.count {
                                            if dateArray[i] == dater {
                                                moc.delete(liquidItems[i])
                                            }
                                        }
                                        let newLiquid = CD_Liquids(context: self.moc)
                                        newLiquid.intake = self.drank
                                        newLiquid.limit = self.limit
                                        newLiquid.date = Date()
                                        self.save()
                                            self.alertingSave.toggle()
                                    }
                                })
                           {
                               Image(systemName: "square.and.arrow.down.on.square")
                                    .font(.system(size: fontsz+7, weight: .light, design: .rounded))
                                .foregroundColor(Color.blue.opacity(0.6))
                           }
                            }.alert(isPresented: $alertingSave, content: {
                                Alert(title: Text("Liquid Intake"), message: Text("Your water intake for \(Date().string(format: "EEEE, MMM d")) has been saved successfully."), dismissButton: .default(Text("Ok")))
                            })
                            
                           
                        }.font(.system(size: fontsz, weight: .regular, design: .rounded))
                       
                            
                      
      
                    }.frame(height: 230).padding(.top, 10)
                   
                    .padding()

                    
                    //MARK: 🚰💦🚰🛁🧊💧🌊🔫💦
                
            }.onAppear {
//                checkIndexes()
                self.dateStr = getDate()
                self.fetchLiquidData()
                if let savedDate = UserDefaults.standard.object(forKey:"TimeReset") as? Date {
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "nl_NL")
                formatter.setLocalizedDateFormatFromTemplate("dd-MM-yyyy HH:mm:ss")
                formatter.timeZone = TimeZone(abbreviation: "EST") // Eastern Standard Time
                formatter.timeStyle = .short
                    
                self.dateStr = formatter.string(from: savedDate)
                self.currentDate = savedDate
                    print("savedDate in UderDefaults = \(savedDate) -- currentDate = \(currentDate) -dateStr = \(dateStr)")
                    self.recHeight = UserDefaults.standard.double(forKey: "Drank")
            }
            }
            
        }
            .navigationTitle("")
        .navigationBarHidden(true)
    }.onReceive(timer){ _ in
        if self.timeRemaining > 0 {
           self.timeRemaining -= 1
        }else{
           self.timer.upstream.connect().cancel()
        }
  }
        }
    
}
    func fetchLiquidData() {
        let fetchRequest = NSFetchRequest<CD_Liquids>(entityName: "CD_Liquids")
        do{
            let result = try moc.fetch(fetchRequest)
            let dateArray = result.map{$0.date.string(format: "MMM d")}
            let liquidArray = result.map{$0.intake}
            self.dateArray = dateArray
            self.liquidsArray = liquidArray
            
            
        } catch {
            print("Could not fetch. \(error)")
        }
    }
    
   
    //Convert the time into 24hr (24:00:00) format
    func timeString(newTime: Int) -> String {
        var date = ""
        let calendar = Calendar.current
        
        let date1 = Date()
        let day1 = calendar.component(.day, from: date1)
        let hour1 = calendar.component(.hour, from: date1)
        let minute1 = calendar.component(.minute, from: date1)
        let second1 = calendar.component(.second, from: date1)
        let newDate1 = DateComponents(calendar: .current, day: day1, hour: hour1, minute: minute1, second: second1)
        
        if let date2 = UserDefaults.standard.object(forKey:"TimeReset") as? Date {
            let day2 = calendar.component(.day, from: date1.nextDay)
            let hour2 = calendar.component(.hour, from: date2)
            let minute2 = calendar.component(.minute, from: date2)
            let second2 = calendar.component(.second, from: date2)
            let newDate2 = DateComponents(calendar: .current, day: day2, hour: hour2, minute: minute2, second: second2)
            
        
        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = calendar.dateComponents(dayHourMinuteSecond, from: newDate1, to: newDate2)
            let seconds = "\(difference.second ?? 0)s"
            let minutes = "\(difference.minute ?? 0)m" + " " + seconds
            let hours = "\(difference.hour ?? 0)h" + " " + minutes
            
            if let hour = difference.hour, hour       > 0 { return hours }
            if let minute = difference.minute, minute > 0 { return minutes }
            if let second = difference.second, second > 0 { return seconds }

        
            
        date = String(format:"%02i:%02i:%02i", hours, minutes, seconds)
       
        }
        return date
    }
var UnitButtons: some View {
    
    let textButton1 =
        AnyView(Button(action:{
            self.activeUnit = "ml"
                            self.isOpen.toggle()
        }) {
            (Image(systemName: "square")
                .overlay(
                    Text("mL").font(.system(size: 18, weight: .regular, design: .rounded))))
                .foregroundColor(Color.textColor(for: cs))
                .font(.system(size: 35, weight: .light))  .opacity(self.activeUnit == "ml" ? 0.9 :  0.5)
        })
    let textButton2 = AnyView(Button(action:{
            self.activeUnit = "L"
                            self.isOpen.toggle()
        }) {
            (Image(systemName: "square")
                .overlay(
                    Text("L").font(.system(size: 18, weight: .regular, design: .rounded))))
                .foregroundColor(Color.textColor(for: cs))
                .font(.system(size: 35, weight: .light))
                .opacity(self.activeUnit == "L" ? 0.9 :  0.5)
        })
    let textButton3 =
        AnyView(Button(action:{
            self.activeUnit = "oz"
                            self.isOpen.toggle()
        }){
            (Image(systemName: "square")
                .overlay(
                    Text("oz").font(.system(size: 18, weight: .regular, design: .rounded))))
                .foregroundColor(Color.textColor(for: cs))
                .font(.system(size: 35, weight: .light))  .opacity(self.activeUnit == "oz" ? 0.9 :  0.5)
            
        })
       
    
    
            
    let menu3 = FloatingButton(mainButtonView: textButton3, buttons: [textButton1,textButton2], isOpen: $isOpen)
        .straight()
        .alignment(.bottom)
        .spacing(2)
        .initialOpacity(0)
    let menu2 = FloatingButton(mainButtonView: textButton2, buttons: [textButton1,textButton3], isOpen: $isOpen)
        .straight()
        .alignment(.bottom)
        .spacing(2)
        .initialOpacity(0)
    let menu1 = FloatingButton(mainButtonView: textButton1, buttons: [textButton3,textButton2], isOpen: $isOpen)
        .straight()
        .alignment(.bottom)
        .spacing(2)
        .initialOpacity(0)
    
    if self.activeUnit == "oz" {
        return menu3.padding(.top, 10)
            .padding(.trailing, 20)
    } else if self.activeUnit == "ml" {
        return menu1
            .padding(.top, 10)
            .padding(.trailing, 20)
    } else {
    return menu2
        .padding(.top, 10)
        .padding(.trailing, 20)
    }
        
    
}

//MARK: VARS BODY
    
    var cycleStart : some View {
      
            HStack{
                Text("Cycle start time")
                    .padding(.trailing, 20)
                    .font(.system(size: largesz, weight: .light, design: .rounded))
                   
                    .shadow(color: Color.black.opacity(0.2), radius: 1, x: -1, y: 1)
                     Spacer()
                Button(action:{
                    if self.showTime == true {
                        self.showTime = false
                    } else {
                        self.showTime = true
                        UserDefaults.standard.set(self.currentDate, forKey: "TimeReset")
                        print("LockDate = \(self.currentDate)")
                    }
                }){
                    Image(systemName: self.showTime ? "lock.fill" : "lock.open.fill")
                }.isHidden(self.showTime)
                        
        ZStack{
        DatePicker("", selection: $currentDate, displayedComponents: .hourAndMinute)
           
            .labelsHidden()
            .disabled(self.showTime)
            .isHidden(self.showTime)
    
            Text("\(currentDate.string(format: "h:mm a"))")
                .font(.system(size: fontsz+5, weight: .light, design: .rounded))
                .foregroundColor(cs == .light ? Color.pulsatingColor.opacity(0.6) : Color.white.opacity(0.6))
                .onTapGesture {
                    self.showTime.toggle()
                }
                .isHidden(!self.showTime)
            
           
        }
            
        }
 
        .foregroundColor(self.cs == .dark ? Color.lairWhite : Color.lairDarkGray)
    }
var ButtonInfo: some View {
    
    
    HStack(spacing:4){
        Text("Tap the + sign each time you drink 8oz")
    }
    
    .font(.system(size: 14, weight: .light, design: .rounded))
    .foregroundColor(.pulsatingColor)
}
var Bottles: some View {
    VStack(spacing: 5){
        
//        RoundedRectangle(cornerRadius: 3)
//            .frame(width:25, height: 20)
//            .foregroundColor(didDrink ? .goldenYellow : drank < limit ? Color.neonGreen.opacity(0.6) : .red).animation(.easeInOut(duration: 0.5))
//            .shadow(color: .black, radius: 1, x: 0.0, y: 0.0)
//            .animation(.none)
       let spaces = [15, 18, 22, 25]
        let floater = CGFloat(sizes[tapped])
        ZStack{
//            FILLER RECTANGLE ***********
            RoundedRectangle(cornerRadius:15)
                .frame(width: 92, height: 240)
                .foregroundColor(.clear)
                //                        .hidden()
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(drank > 0 ? 0 : 0.2), radius: 10, x: 0, y: 4)
                .overlay(
                    
                    VStack(spacing: CGFloat(spaces[tapped])){
                        let lineAmount = 16 - sizes[tapped]
//                        Text("lines = \(16 - sizes[tapped])").font(.caption2)
                        ForEach(0..<lineAmount, id:\.self) { i in
                            HStack{
                                Rectangle()
                                    .frame(width: 25, height: 1)
                                    .foregroundColor(.grayMe)
                                    .opacity(Double(i*sizes[tapped]) == limit ? 0 : 0.2)
                                    .shadow(color: Color.black.opacity(0.3), radius: 2, x: 3, y: 4)
                            }.offset(x:33, y: -floater+5)
                        }
                    }
                ).zIndex(5)
            VStack(spacing: 5){
                
                RoundedRectangle(cornerRadius: 3)
                    .frame(width: 25, height: 15)
                    .foregroundColor(didDrink ? .goldenYellow : drank < limit ? Color.neonGreen.opacity(0.6) : .red).animation(.easeInOut(duration: 0.5))
                               .shadow(color: .black, radius: 1, x: 0.0, y: 0.0)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: -2.0, y: 5.0)
                
                ZStack(alignment:.bottomTrailing){
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width: 92, height: 256)
                        .foregroundColor(cs == .dark ? Color.white.opacity(0.8) : .white)
                        .shadow(color: Color.black.opacity(0.5), radius: 2, x: 0.0, y: 0.0)
                    
                  
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(cs == .dark ? Color.neonBlue : Color.blue.opacity(0.5))
                        .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
                        .cornerRadius(drank < limit ? 5 : 2, corners: [.topLeft, .topRight])
                        .frame(width: 92, height: CGFloat((drank < limit) && limit > 0 ? (recHeight * 256/limit) : 256))
                        .animation(.easeInOut(duration: 0.2))
         
                    

                
                }
               
            }
        }

    }.padding()
}
var Buttons : some View {
    //Buttons
    VStack(spacing: 20){
        Button(action:{
           
            if self.drank < limit {
                self.drank += Double(sizes[tapped])
                self.dayData.liquids += Double(sizes[tapped])
                
                if self.drank + Double(sizes[tapped]) <= limit {
                self.recHeight = drank + Double(self.sizes[tapped]/2)
                } else {
                    self.drank = limit
                }
            } else {
                self.recHeight = 256
               
//                self.drankIndex = 7
            }
           
//            self.indexes[drankIndex] = 1
//            self.drankIndex += 1
            UserDefaults.standard.set(self.drank, forKey: "Drank")
            let waterShared = Int(self.drank)
            UserDefaults(suiteName: "group.H97YA8G6R5.com.golgi.CHFManager")!.set("\(waterShared)", forKey: "drank")
            self.saveData(drank)
        
        }){
            VStack {
            Image(systemName: "plus")
                .foregroundColor(.black)
                .frame(width: 80, height: 50)
                .font(.system(size: 25, weight: .thin))
                
               
            }
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                  .stroke(LinearGradient.lairDiagonalDarkBorder, lineWidth: 1)
            ) .background(Color.white)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 5, y: 5)
            .shadow(color: .lairShadowGray, radius: 2, x: 3, y: 3)
           
            }
        Button(action:{
            if self.drank > 0 {
                self.drank -= Double(sizes[tapped])
                self.dayData.liquids -= Double(sizes[tapped])
//                self.drankIndex -= 1
//                self.indexes[drankIndex] = 0
                if drank - Double(self.sizes[tapped]/2) >= 0 {
                self.recHeight = drank - Double(self.sizes[tapped]/2)
                } else {
                    self.recHeight = 0
                }
              
            } else {
//                self.drankIndex = 0
//                self.indexes[drankIndex] = 0
              
                self.dayData.liquids = 0
                self.drank = 0
            }
          
         
            UserDefaults.standard.set(self.drank, forKey: "Drank")
            let waterShared = Int(self.drank)
            UserDefaults(suiteName: "group.H97YA8G6R5.com.golgi.CHFManager")!.set("\(waterShared)", forKey: "drank")
            self.saveData(drank)
        }){
            VStack {
            Image(systemName: "minus")
                .foregroundColor(.black)
                .frame(width: 80, height: 50)
                .font(.system(size: 25, weight: .thin))
                
               
            }
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                  .stroke(LinearGradient.lairDiagonalDarkBorder, lineWidth: 1)
            ) .background(Color.white)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 5, y: 5)
            .shadow(color: .lairShadowGray, radius: 2, x: 3, y: 3)
           
        }
       
                
        
        
    }.onChange(of: drank) { _ in
        let url = FileManager.appGroupContainerURL.appendingPathComponent(FileManager.liquidFileName)
        try? String(drank).write(to: url, atomically: false, encoding: .utf8)
    }
    
}


func newUnit(val: Double) -> String {
    var returned = ""
    if self.activeUnit == "oz" {
        let ozzyDrink = val
        returned = String(format: "%.0f", ozzyDrink)
    } else if self.activeUnit == "ml" {
        let miliDrink = val * 30
        returned = String(format: "%.0f", miliDrink)
    } else if self.activeUnit == "L" {
        let literDrink = val * 0.0295735
        returned = String(format: "%.2f", literDrink)
    }
    return returned
}
func getDate() -> String {
    if let savedDate = UserDefaults.standard.object(forKey:"TimeReset") as? Date {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        self.dateStr = formatter.string(from: savedDate)
        self.currentDate = savedDate
        
    }
    
    return self.dateStr
}
    func save() {
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
  
//func checkIndexes() {
//
//    self.drankIndex = Int(UserDefaults.standard.double(forKey: "Drank") / 8)
//    for i in 0..<drankIndex {
//        indexes[i] = 1
//    }
//}

func saveData(_ drank: Double) {
    guard let drankData = try? JSONEncoder().encode(drank) else { return }
    self.drankData = drankData
    print("saveData \(drank)")
}
    //Convert the time into 24hr (24:00:00) format
    func timeString(time: Int) -> String {
        let hours   = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }

}

struct Waterline: View{
    @State var num : Double
    @State var limit: Double
    var body : some View {
        HStack{
            Rectangle().frame(width: 30, height: 4).foregroundColor(.grayMe).opacity(num == limit ? 0 : 0.3)
            ZStack{
                Text("32oz").font(.system(size: 10, weight: .semibold, design: .rounded)).hidden()
                Text("\(num, specifier: "%.0f")oz").font(.system(size: 10, weight: .semibold, design: .rounded)).opacity(0.7)
                    .offset(y:3).foregroundColor(.lairGray)
            }
        }.offset(x:45, y: 0)
    }
    
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
let columns2 = [
    GridItem(.flexible()),
    GridItem(.fixed(140))
]
let columns3 = [
    GridItem(.fixed(400)),
    GridItem(.fixed(200))
]

struct TimerView: View {
    //MARK: - PROPERTIES
    @State var timeRemaining = 24*60*60
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Environment(\.colorScheme) var cs
    //MARK: - BODY
    var body: some View {
        
        Text("\(timeString(newTime: timeRemaining))")
            .font(.system(size: 20, weight: .light, design: .rounded))
            .frame(height: 20.0)
//            .frame(minWidth: 0, maxWidth: .infinity)
            .foregroundColor(cs == .light ? Color.pulsatingColor.opacity(0.6) : Color.white.opacity(0.6))
           
            .onReceive(timer){ _ in
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                }else{
                    self.timer.upstream.connect().cancel()
                }
            }
    }
    
    //Convert the time into 24hr (24:00:00) format
    func timeString(newTime: Int) -> String {
        var date = ""
        let calendar = Calendar.current
        
        let date1 = Date()
        let day1 = calendar.component(.day, from: date1)
        let hour1 = calendar.component(.hour, from: date1)
        let minute1 = calendar.component(.minute, from: date1)
        let second1 = calendar.component(.second, from: date1)
        let newDate1 = DateComponents(calendar: .current, day: day1, hour: hour1, minute: minute1, second: second1)
        
        if let date2 = UserDefaults.standard.object(forKey:"TimeReset") as? Date {
            let day2 = calendar.component(.day, from: date1.nextDay)
            let hour2 = calendar.component(.hour, from: date2)
            let minute2 = calendar.component(.minute, from: date2)
            let second2 = calendar.component(.second, from: date2)
            let newDate2 = DateComponents(calendar: .current, day: day2, hour: hour2, minute: minute2, second: second2)
            
        
        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = calendar.dateComponents(dayHourMinuteSecond, from: newDate1, to: newDate2)
            let seconds = "\(difference.second ?? 0)s"
            let minutes = "\(difference.minute ?? 0)m" + " " + seconds
            let hours = "\(difference.hour ?? 0)h" + " " + minutes
            
            if let hour = difference.hour, hour       > 0 { return hours }
            if let minute = difference.minute, minute > 0 { return minutes }
            if let second = difference.second, second > 0 { return seconds }

            
        date = String(format:"%02i:%02i:%02i", hours, minutes, seconds)
       
        }
        return date
    }
    
        
}
















//struct Watercolors:View {
//    var colors: [Color] = [.white, .pulsatingColor]
//    var anime: [SplashShape.SplashAnimation] = [.topToBottom, .bottomToTop]
//    @State var height: CGFloat
//    @State var indexes = [0,0,0,0,0,0,0,0]
//    @Binding var index: Int
//    @State var radi:CGFloat
//    var body: some View {
//        Animations(
//            animationType: self.anime[index],
//            color: self.colors[index])
//            .frame(width: 92, height: height, alignment: .center)
//            .cornerRadius(radi, corners: height > 32 ? [.topLeft, .topRight] : [.allCorners])
//            .cornerRadius(height > 32 ? 4 : 0, corners: [.bottomLeft, .bottomRight])
//        //            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 4)
//        //            .offset(y: 120)
//    }
//}







//            VStack{
//                let lineAmount = limit / Double(sizes[tapped])
//                let intLineAmount = Int(lineAmount)
//                ForEach(0..<intLineAmount, id:\.self) { i in
//                    HStack{
//                        Rectangle()
//                            .frame(width: 25, height: 2)
//                            .foregroundColor(.grayMe)
//                            .opacity(Double(i*sizes[tapped]) == limit ? 0 : 0.3)
//                        ZStack{
//                            Text("32oz")
//                                .font(.system(size: 10, weight: .semibold, design: .rounded)).hidden()
//                            Text("\(limit - 8*Double(i), specifier: "%.0f")oz").font(.system(size: 10, weight: .semibold, design: .rounded)).opacity(0.7)
//                                .offset(y:3).foregroundColor(.lairGray)
//                        }
//                    }.offset(x:30, y: 10)
//                }
//            }

//            Text("\(limit)")
        
        
       
//        HStack{
//        ForEach(0..<indexes.count){ i  in
//        Text("\(indexes[i])")
//        }
//        }
//                    VStack(spacing:0){
//
//                        let h: CGFloat = 32
//                        Watercolors(height: 33, index: $indexes[7], radi: 97)
//                        Watercolors(height: h, index: $indexes[6], radi: 5)
//                        Watercolors(height: h, index: $indexes[5], radi: 5)
//                        Watercolors(height: h, index: $indexes[4], radi: 5)
//                        Watercolors(height: h, index: $indexes[3], radi: 5)
//                        Watercolors(height: h, index: $indexes[2], radi: 5)
//                        Watercolors(height: h, index: $indexes[1], radi: 5)
//                        Watercolors(height: h, index: $indexes[0], radi: 5)
//                    }

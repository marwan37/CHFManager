//
//  LiquidPractice.swift
//  Golgi-Splash
//
//  Created by Marwan Zaarab on 2021-01-17.
//

import SwiftUI
import CoreData
import Shapes

struct LiquidSettings : View {
   
    let calendar = Calendar.current
    let now = Date()
    var sevenDaysAgo : Date {
        return calendar.date(byAdding: .day, value: -7, to: now)!
    }
    @State var showAddView = false
    var startDate : Date {
      return calendar.startOfDay(for: sevenDaysAgo)
    }
    @FetchRequest(
        entity: CD_Liquids.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \CD_Liquids.date, ascending: true),
        ],
        predicate: NSPredicate(format:"(date >= %@) AND (date < %@)", Calendar.current.date(byAdding: .day, value: -7, to: Date())! as CVarArg, Date() as CVarArg)
    ) var last7days: FetchedResults<CD_Liquids>
    @State var liquidsArray = [Double]()
    @State private var currentDate = Date()
    @State var showTime = true
    @Environment(\.managedObjectContext) var moc
    @Environment(\.colorScheme) var cs : ColorScheme
    @State var showLimit = true
    @State var tempLimit = ""
    var totalWidth = UIScreen.main.bounds.width - 60
    @State var limit: Double = 64
    @State var activeUnit = "oz"
    @State var dateArray = [Date?]()
    @ObservedObject var settings = UserSettings()
    @AppStorage("drank", store: UserDefaults(suiteName: "group.H97YA8G6R5.com.golgi.CHFManager")) var drankData: Data = Data()
    @AppStorage("liquidLimit", store: UserDefaults(suiteName: "group.H97YA8G6R5.com.golgi.CHFManager")) var limitData: Data = Data()
    @State var originalUnit = "oz"
    @State var average = 0
    @State var units = ["oz", "ml", "L"]
    @State var unit = 0
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
            return 16
        }
    }
    var body : some View {
        ZStack{
            LinearGradient.overall(for: cs).edgesIgnoringSafeArea(.all)
        VStack{
          
                    HStack{
//                    Image(systemName: "deskclock.fill")
//                        .foregroundColor(cs == .dark ? Color.sand : .gray)
                        Text("Cycle start time")
                            .opacity(0.8)
                            .font(.system(size: largesz, weight: .light, design: .rounded))
                            .shadow(color: Color.black.opacity(0.2), radius: 1, x: -1, y: 1)
            HStack{
             
                Spacer()
                ZStack{
                    DatePicker("", selection: $currentDate, displayedComponents: .hourAndMinute)
                        
                        .labelsHidden()
                        .disabled(self.showTime)
                        .isHidden(self.showTime)
                    
                    Text("\(currentDate.string(format: "h:mm a"))")
                        .font(.system(size: largesz - 2, weight: .light, design: .rounded))
                        .foregroundColor(showTime ? .gray : /*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        .onTapGesture {
                            self.showTime.toggle()
                        }
                        .isHidden(!self.showTime)
                    
                    
                }
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
                        .font(.system(size: largesz - 4, weight: .regular, design: .rounded))
                        .foregroundColor(cs == .dark ? Color.sand : .gray)
                        
                }
                
            }
                
            }
            .foregroundColor(self.cs == .dark ? Color.lairWhite : Color.black)
                
  // DAILY LIMIT
            VStack{
                    HStack{
//
                        Text("Daily Limit")
                            .opacity(0.8)
                        .font(.system(size: largesz, weight: .light, design: .rounded))
                        .shadow(color: Color.black.opacity(0.2), radius: 1, x: -1, y: 1)
                          
                        Spacer()
                        (Text("\(limit, specifier: activeUnit == "L" ? "%.2f" : "%.0f")") + Text(self.activeUnit))
                            .font(.system(size: largesz, weight: .light, design: .rounded))
                            .foregroundColor(showLimit ? (cs == .dark ? Color.sand : .gray) : (cs == . dark ? .neonBlue : .pulsatingColor))
                        
                        Button(action:{
                            self.showLimit.toggle()
                            self.tempLimit = "\(limit)"
                            UserDefaults.standard.set(limit, forKey: "LiquidLimit")
                            let limitShared = Int(self.limit)
                            UserDefaults(suiteName: "group.H97YA8G6R5.com.golgi.CHFManager")!.set("\(limitShared)", forKey: "liquidLimit")
                            
                        }){
                            Image(systemName: showLimit ? "lock.fill" : "lock.open.fill")
                                .font(.system(size: 18, weight: cs == .dark ? .regular : .light, design: .rounded))
                                .foregroundColor(showLimit ? (cs == .dark ? Color.sand : .gray) : (cs == . dark ? .blue : .pulsatingColor))
                        }.onChange(of: tempLimit) { _ in
                            let url = FileManager.appGroupContainerURL.appendingPathComponent(FileManager.liquidLimitFileName)
                            try? tempLimit.write(to: url, atomically: false, encoding: .utf8)
                        }
                        
                    } .padding(.leading, 5).padding(.top, 30)
                LSlider($limit, range: 0...100, isDisabled: showLimit)
                    .linearSliderStyle(SliderStyleLiquids())
                    
                    .frame(width: UIScreen.main.bounds.width - 70, height: 40)
                    .shadow(color: Color.black.opacity(0.5), radius: 3, x: 3, y:3)
                    .padding(.vertical, 30)
            }
            
       
            
            HStack{

                Text("Average Intake last 7 days")
                    .opacity(0.8)
                .font(.system(size: largesz, weight: .light, design: .rounded))
                .shadow(color: Color.black.opacity(0.2), radius: 1, x: -1, y: 1)
     
                Spacer()
                Text("\(self.average) oz")
                    .font(.system(size: largesz, weight: .light, design: .rounded))
                    .foregroundColor(cs == .dark ? Color.sand : .gray)
            }.padding(.top, 20)
            
          
            HStack{
                Button(action:{
                    self.showAddView.toggle()
                })
                {
                    HStack {
                Text("Add Custom Entry")
                    .opacity(0.8)
                    .foregroundColor(Color.textColor(for: cs))
                    .font(.system(size: largesz, weight: .light, design: .rounded))
                    .shadow(color: Color.black.opacity(0.2), radius: 1, x: -1, y: 1)
                        Spacer()
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: largesz + 5)
                    .foregroundColor(.blue)
//                Spacer()
                    }
                }.sheet(isPresented: $showAddView) {
                    CustomLiquidEntry()
//                        .environment(\.managedObjectContext, self.moc)
                }
            }.padding(.top, 45)
            
            Divider()
                .padding(.top, 40)
            NavigationLink(destination:  MoreInformation().navigationTitle("").navigationBarHidden(true)) {
                HStack(alignment:.lastTextBaseline,spacing:10){
                    Text("Fluid Tracking : Tips & Rec.")
                    .foregroundColor(Color.textColor(for: cs))

                    .font(.system(size: largesz, weight: .light, design: .rounded))
                    .shadow(color: Color.black.opacity(0.2), radius: 1, x: -1, y: 1)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color.textColor(for: cs))

                }.opacity(0.7)
            }.padding(.vertical, 15)
            .padding(.horizontal, 5)
            
            Divider()
//                .padding()
            
           
            
                Spacer(minLength: 0)
            
        }.padding(.horizontal)
        .padding(.top, 40)
       
        }
//
//        .onAppear{
//
//            self.fetchLast7Days()
//            self.average = self.getAverage()
//            self.limit = UserDefaults.standard.double(forKey: "LiquidLimit")
//        }
        
    }

   
    func getValueForUDReversed(val:Double) -> Double {
        if self.activeUnit == "ml" {
            return val * 29.5735
           
        } else if activeUnit == "L" {
            return val * 0.0295735
         
        } else {
            return val
            
        }
    }
    
    func getAverage() -> Int {
        var avg: Double = 0
        print("last7days count \(last7days.count)")
        var total: Double = 0
        
        for i in 0..<last7days.count {
            total += last7days[i].intake
        }
        if total > 0 {
       avg = total / Double(last7days.count)
        }
        return Int(avg)
    }
    
    func fetchLast7Days() {

        let fetchRequest = NSFetchRequest<CD_Liquids>(entityName: "CD_Liquids")
        do{
            let result = try moc.fetch(fetchRequest)
            let dateArray = result.map{$0.date}
            let liquidArray = result.map{$0.intake}
            self.dateArray = dateArray
            self.liquidsArray = liquidArray
           
            
        } catch {
            print("Could not fetch. \(error)")
        }
    }
    
//    func getResult() {
//        func getResult(){
//            let second = self.width1 / self.totalWidth
//            let average = Int(second * 10)
//            self.sliderValue = String(average)
//        }
//    }
    
    func getValue(val: CGFloat) -> Double {
        if self.activeUnit == "ml" {
            return Double(val * 80 * 29.5735)
           
        } else if activeUnit == "L" {
            return Double(val * 80 * 0.0295735)
         
        } else {
            return Double(val * 80)
            
        }
    }
    func getValueForUD(val: Double) -> Double {
        if self.activeUnit == "ml" {
            return val / 29.5735
           
        } else if activeUnit == "L" {
            return val / 0.0295735
         
        } else {
            return val
            
        }
    }
}

struct LiquidPractice_Previews: PreviewProvider {
    static var previews: some View {
        LiquidSettings().preferredColorScheme(.light)
    }
}


struct LiquidPractice: View {
    @Environment(\.colorScheme) var cs
    @State var months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"]
    @Binding var pushed: Bool
     var gridItemLayout = [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()), GridItem(.flexible())]
     var symbols = ["info", "linear", "table", "bar"]
     var colors: [Color] = [.yellow, .white, .green, .lightEnd]
    @Environment(\.managedObjectContext) var moc
    @State var shows = [0,1,2]
    @State var tapped = false
    var body: some View {
        
        TabView {
            
            WaterContainer().navigationTitle("").navigationBarHidden(true)
                .tabItem {
                    Image(systemName: "drop.fill")
                }

            FluidCharts(show: $shows[1]).navigationTitle("").navigationBarHidden(true)
                .tabItem{
                    Image(systemName: "tablecells.fill")
                }
            
         
            LiquidGraphView()
                .environment(\.managedObjectContext, self.moc)
                .navigationTitle("").navigationBarHidden(true)
                .tabItem {
                    Image(systemName: "waveform.path.ecg.rectangle.fill")

                }
            LiquidSettings()
                .navigationTitle("").navigationBarHidden(true)
                 .tabItem{
                     Image(systemName: "drop.triangle.fill")
                 }
             
//
//            LiquidLineChart().navigationTitle("").navigationBarHidden(true)
//            .tabItem{
//                Image(systemName: "point.topleft.down.curvedto.point.bottomright.up")
//            }
            
        }.foregroundColor(Color.textColor(for: cs))
    }
}


struct SliderStyleLiquids : LSliderStyle {
    func makeThumb(configuration:  LSliderConfiguration) -> some View {
              Circle()
                  .fill(configuration.isActive ? Color.yellow : Color.blue)
                  .frame(width: 30, height: 30)
               
        
    }
    
          func makeTrack(configuration:  LSliderConfiguration) -> some View {
              let style: StrokeStyle = .init(lineWidth: 10, lineCap: .round, lineJoin: .round, miterLimit: 0, dash: [], dashPhase: 0)
              return AdaptiveLine(angle: configuration.angle)
                  .stroke(Color.gray, style: style)
                  .overlay(AdaptiveLine(angle: configuration.angle).trim(from: 0, to: CGFloat(configuration.pctFill)).stroke(Color.blue, style: style))
          }
    

        
}
//    var SliderView : some View {
//
//            VStack{
//
//                ZStack(alignment: .leading) {
//
//                    Rectangle()
//                        .fill(Color.lairGray.opacity(0.2))
//                        .frame(height: 6)
//
//                    Rectangle()
//                        .fill(!showLimit ? (cs == .dark ? Color("ColorNeuro") : Color.blue) : Color.lairGray)
//                        .frame(width: self.width1 - self.width, height: 6)
//                        .offset(x: self.width)
//
//                    HStack(spacing: 0){
//
//                        Circle()
//                            .fill(!showLimit ? (cs == .dark ? Color("ColorNeuro") : Color.blue) : Color.lairGray)
//                            .frame(width: 15, height: 15)
//                            .offset(x: self.width1)
//                            .gesture (
//                                DragGesture()
//                                    .onChanged({ (value) in
//                                        if value.location.x <= self.totalWidth && value.location.x >= self.width {
//                                            self.width1 = value.location.x
//                                        }
//                                    })
//                                    .onEnded({ _ in
//                                        let widthVal = self.getValue(val: width1 / totalWidth)
//                                        self.limit = widthVal
//                                        let newVal = self.getValueForUD(val: widthVal)
//                                        UserDefaults.standard.set(newVal, forKey: "LiquidLimit")
//                                    })
//
//                            ).disabled(showLimit)
//                    }
//                }
//                .padding(.top, 25)
//            }.onAppear {
//                if self.width1 < 5 {
//                    self.width1 = CGFloat(64*4.544)
//                }
//            }
//            .padding(.horizontal, 5)
//
//
//    }

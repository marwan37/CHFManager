//
//  SymptomsView.swift
//  Golgi-Splash
//
//  Created by Marwan Zaarab on 2021-01-12.
//

import SwiftUI
import CoreData
import FloatingButton

struct SymptomsView: View {

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var pushed: Bool
    @Environment(\.managedObjectContext) var moc
    @Environment(\.colorScheme) private var colorScheme
    @FetchRequest(entity: MasterData.entity(), sortDescriptors: []) var dayItems: FetchedResults<MasterData>
    @State var months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"]
    @State var fullMonths = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var dateFormat = "EEEE, MMM d"
    @State var dateFrequency: [Double] = [0,0,0,0,0,0,0,0,0,0,0,0]
    @State var swellingFreqByMonth = [Double]()
    @State var fatigueFreqByMonth = [Double]()
    @State var dyspneaFreqByMonth = [Double]()
    @State var combinedFreqByMonth = [Double]()
    @State var swellingMonthly : [[Double]] = [ [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double]() ]
    @State var fatigueMonthly : [[Double]] = [ [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double]() ]
    @State var dyspneaMonthly : [[Double]] = [ [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double]() ]
    @State var combinedMonthly : [[Double]] = [ [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double]() ]
// symptoms DateMonthly
    @State var swellingDateMonthly : [[String]] = [ [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String]() ]
    @State var dyspneaDateMonthly : [[String]] = [ [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String]() ]
    @State var fatigueDateMonthly : [[String]] = [ [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String]() ]
    @State var combinedDateMonthly : [[String]] = [ [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String]() ]
    @State var swellar = [Int]()
    @State var dyspar = [Int]()
    @State var fatigar = [Int]()
    @State var combinar = [Int]()
// Direct CoreData Fetched Arrays
    @State var monthChecker = [Int]()
    @State var dateArray = [String?]()
    @State var fatigueMonth: [Double] = []
    @State var swellingMonth: [Double] = []
    @State var dyspneaMonth: [Double] = []
    @State var monthArray = [String?]()
// Computed properties for Line Charts
         @State var combinedMonth: [Double] = []
         @State var rxDouble: [Double] = []
         @State var fatigue: [String] = []
         @State var dyspnea: [String] = []
         @State var swelling: [String] = []
    @State var leadingTag: String = "symptoms"
    @State var trailingTag: String = "curved"
    @State var leadImg: String = "cross.fill"
    @State var trailImg = "scribble"
    @State var showSx = "swell"
    @State var title = "Occurences"
    @State var swellPie = [Pie]().sorted(by: { $0.percent > $1.percent })
    @State var dysPie = [Pie]().sorted(by: { $0.percent > $1.percent })
    @State var combinedPie = [Pie]().sorted(by: { $0.percent > $1.percent })
    @State var fatPie = [Pie]().sorted(by: { $0.percent > $1.percent })
    @State var pieData = [Pie]()
    @State var titresPie = ["Swelling", "Dyspnea", "Fatigue", "Reported Symptoms Distribution (Combined)"]
    @State var titres = ["Swelling", "Dyspnea", "Fatigue", "Combined"]
    static let chartImageNames = ["scribble","char.bar.fill","chart.pie.fill"]
    static let iconImageNames = ["cross.fill","scalemass.fill","drop.fill","pills.fill"]
    @State var leadButtons = [AnyView]()
    @State var leadButton = AnyView(MainButton(imageName: "cross.fill", colorHex: "222831"))
    @State var trailButton : AnyView =  AnyView(MainButton(imageName: "chart.bar.fill", colorHex: "222831"))
    @State var trailButtons = [AnyView]()
    @State var tapie = 0
    @State var symptomData = [Double]()
    @State var dateMonthlyData = [[String]]()
    @State var monthlyData = [[Double]]()
    @State var pieSxTotal : Double = 0
    @State var swellTotal: Double = 0
    @State var dyspTotal: Double = 0
    @State var fatTotal: Double = 0
    @State var sympTotal: Double = 0
    @State var swellPercent : Double = 0
    @State var fatPercent : Double = 0
    @State var dyspPercent : Double = 0
    @State var combPercent: Double = 0
    @State var showSxS = ["swell", "dysp", "fat", "combine"]
    @State var occurences : [Double] = [0,0,0,0]
    @State var moIndex : Int = 0
    @State var selected = ""
    @State var month = Date()
    
    @Namespace var animation
    var body: some View {
        ZStack{
            LinearGradient.overall(for: colorScheme).edgesIgnoringSafeArea(.all)
        VStack{
//            Picker("", selection: $selected){
//                ForEach(0..<titres.count){
//                    Text(self.titres[$0])
//                }
//            }.pickerStyle(SegmentedPickerStyle())
          
            if selected == "" {
                VStack(spacing : 20){
                    Text("Select Symptom").font(.system(size: 25, weight: .regular, design: .rounded))
                    TBNoImage2(selected: $selected, title: "Swelling", size : 45)
                      TBNoImage2(selected: $selected, title: "Dyspnea", size : 45)
                      TBNoImage2(selected: $selected, title: "Fatigue", size : 45)
                      TBNoImage2(selected: $selected, title: "Combined", size : 45)
                }.padding(.top, 35)
            }
            HStack{
              TBNoImage(selected: $selected, title: "Swelling", animation: animation, size : 25)
                TBNoImage(selected: $selected, title: "Dyspnea", animation: animation, size : 25)
                TBNoImage(selected: $selected, title: "Fatigue", animation: animation, size : 25)
                TBNoImage(selected: $selected, title: "Combined", animation: animation, size : 25)
            }.isHidden(self.selected == "")
            ZStack{
//                Color.backgroundColor(for: colorScheme)

//                   TabView{

                LineChartFiller(title: "Swelling", data: swellingFreqByMonth, sM: swellingMonth, sMly: swellingMonthly, occurences: occurences[0], pie: $swellPie, dateArray: $dateArray, month: $month, symptomDate: $swellingDateMonthly, selected: $moIndex, moIndex: $moIndex)
                        .isHidden(self.selected != "Swelling")
                    
                LineChartFiller(title:"Dyspnea", data: dyspneaFreqByMonth, sM: dyspneaMonth, sMly: dyspneaMonthly, occurences: occurences[1], pie: $dysPie, dateArray: $dateArray, month: $month, symptomDate: $dyspneaDateMonthly, selected: $moIndex, moIndex: $moIndex)
                            .isHidden(self.selected != "Dyspnea")
                    
                LineChartFiller(title: "Fatigue", data: fatigueFreqByMonth,  sM: fatigueMonth, sMly: fatigueMonthly, occurences: occurences[2], pie: $fatPie, dateArray: $dateArray, month: $month, symptomDate: $fatigueDateMonthly, selected: $moIndex, moIndex: $moIndex)
                        .isHidden(self.selected !=  "Fatigue")
                
                LineChartFiller(title: "Combined", data: combinedFreqByMonth,  sM: combinedMonth, sMly: combinedMonthly, occurences: occurences[3], pie: $combinedPie, dateArray: $dateArray, month: $month, symptomDate: $combinedDateMonthly, selected: $moIndex, moIndex: $moIndex)
                        .isHidden(self.selected != "Combined")
                       
//                    } .tabViewStyle(PageTabViewStyle())
                 
            }.isHidden(selected == "")
                   .offset(y: -10)
            .padding()
                      
            }
        .onAppear {

                self.onAppearDo()

            }
        }
        
        
       
        
       
    }

    func onAppearDo() {
        DispatchQueue.main.async {
            
            //dates
            self.monthArray = []
            self.monthChecker = [0,0,0,0,0,0,0,0,0,0,0,0]
            self.dateFrequency = [0,0,0,0,0,0,0,0,0,0,0,0]
            //meds
           
             self.rxDouble = []
             //symptoms
            self.swellTotal = 0
            self.dyspTotal = 0
            self.fatTotal = 0
            self.swellPercent = 0
            self.dyspPercent = 0
            self.fatPercent = 0
            self.fatigue = []
            self.swelling = []
            self.dyspnea = []
            self.dyspneaMonth = []
            self.swellingMonth = []
            self.fatigueMonth = []
         
            self.swellingFreqByMonth = []
            self.fatigueFreqByMonth = []
            self.dyspneaFreqByMonth = []
            self.combinedFreqByMonth = []
            self.swellingMonthly = [[], [], [], [], [], [], [], [], [], [] ,[] ,[]]
            self.dyspneaMonthly = [[], [], [], [], [], [], [], [], [], [] ,[] ,[]]
            self.fatigueMonthly = [[], [], [], [], [], [], [], [], [], [] ,[] ,[]]
            self.combinedMonthly = [[], [], [], [], [], [], [], [], [], [] ,[] ,[]]
            self.swellingDateMonthly = [[], [], [], [], [], [], [], [], [], [] ,[] ,[]]
            self.dyspneaDateMonthly = [[], [], [], [], [], [], [], [], [], [] ,[] ,[]]
            self.fatigueDateMonthly = [[], [], [], [], [], [], [], [], [], [] ,[] ,[]]
            self.combinedDateMonthly = [[], [], [], [], [], [], [], [], [], [] ,[] ,[]]
            //water weight
         
            //pies
            self.swellPie = []
            self.fatPie = []
            self.dysPie = []
            //functions
            self.fetchSymptomData()
            self.fetchMonths()
            self.fetchSymptoms()
            self.fetchDicts()

            self.fetchMonthlyData()
            self.checkIfMonthIsPresent()
            self.fetchPieInfo()
            self.pieMaker()
            //tags
            self.getCurrentMonthIndex()
            self.getOccurences(0, moIndex, swellingFreqByMonth)
            self.getOccurences(1, moIndex, dyspneaFreqByMonth)
            self.getOccurences(2, moIndex, fatigueFreqByMonth)
            self.getOccurences(3, moIndex, combinedFreqByMonth)
            self.pieData = swellPie
      
        }
    }

    func getOccurences(_ type: Int, _ index: Int, _ data: [Double])  {
        
        self.occurences[type] = data[index]
         
            
    }
    func getCurrentMonthIndex() {
        let now = Date()
        let masterDateString = now.string(format: "EEEE, MMM d")
        let masterMonth = masterDateString.subStringAfterLastComma.components(separatedBy: CharacterSet.decimalDigits).joined()
        let petit = monthToInt(month: masterMonth)
        self.moIndex = petit
        
       
        
    }
        func monthToInt(month: String) -> Int {
            switch month {
            case "Jan" : return 0
            case "Feb" : return 1
            case "Mar" : return 2
            case "Apr" : return 3
            case "May" : return 4
            case "Jun" : return 5
            case "Jul" : return 6
            case "Aug" : return 7
            case "Sep" : return 8
            case "Oct" : return 9
            case "Nov" : return 10
            case "Dec" : return 11
            default: return 0
            }
        }
    func fetchDicts() {
        
        for num in self.months.indices {
            let fatCount = Double(fatigue.frequency(of: months[num]))
            let swellCount = Double(swelling.frequency(of: months[num]))
            let dyspCount = Double(dyspnea.frequency(of: months[num]))
            let total = fatCount + swellCount + dyspCount
            fatigueFreqByMonth.append(fatCount)
            swellingFreqByMonth.append(swellCount)
            dyspneaFreqByMonth.append(dyspCount)
            combinedFreqByMonth.append(total)
          
        }
    }
    func checkIfMonthIsPresent() {
        
        for i in 0..<monthArray.count{
            for num in self.monthChecker.indices{
                if self.monthArray[i]!.contains(months[num]) {
                    self.monthChecker[num] = 1
                }
            }
            
        }
    }

    func fetchMonthlyData() {
        
       
        for i in 0..<monthArray.count {
            
            for num in self.months.indices {
                if self.monthArray[i]!.contains(months[num]) {
                        
                    self.swellingMonthly[num].append(swellingMonth[i])
                        self.swellingDateMonthly[num].append(dateArray[i]!)
                       
                    self.fatigueMonthly[num].append(fatigueMonth[i])
                        self.fatigueDateMonthly[num].append(dateArray[i]!)
                       
                    self.dyspneaMonthly[num].append(dyspneaMonth[i])
                        self.dyspneaDateMonthly[num].append(dateArray[i]!)
                   
                    let temp = swellingMonth[i] + fatigueMonth[i] + dyspneaMonth[i]
                    self.combinedMonthly[num].append(temp)
                    self.combinedDateMonthly[num].append(dateArray[i]!)
                    
                  
            
                   
                }
               
              
            }
        }
        
    }
    func fetchPieInfo() {
        //symptoms
        var n: Double = 0
        var k: Double = 0
        var j: Double = 0
        for i in 0..<swellingMonthly.count {
            let m = swellingMonthly[i].reduce(0, +)
            
            n += m
           
        }
        
        for i in 0..<fatigueMonthly.count {
            let m = fatigueMonthly[i].reduce(0, +)
            k += m
           
        }
        
        for i in 0..<dyspneaMonthly.count {
            let m = dyspneaMonthly[i].reduce(0, +)
            j += m
          
        }
      
        
       
        
        let total = n + k + j
        self.sympTotal = total
        self.swellTotal = n
        self.fatTotal = k
        self.dyspTotal = j
        self.swellPercent = Double((n / total) * 100)
        self.fatPercent = Double ((k / total) * 100)
        self.dyspPercent = Double((j / total) * 100)
      
    }
    //MARK: SYMPTOMS
    func fetchSymptoms() {
        if self.combinedMonth.isEmpty == false {
            
            for i in 0..<self.monthArray.count{
                for month in self.months {
                    if self.monthArray[i]!.contains(month) && self.fatigueMonth[i] == 1 {
                        self.fatigue.append(month)
                    }
                    
                    if self.monthArray[i]!.contains(month) && self.dyspneaMonth[i] == 1 {
                        self.dyspnea.append(month)
                    }
                    
                    if self.monthArray[i]!.contains(month) && self.swellingMonth[i] == 1 {
                        self.swelling.append(month)
                        
                    }
                }
            }
        }
    }
   //MARK:DATE and MONTH
    func fetchMonths() {
        if self.dateArray.isEmpty == false {
            for i in 0..<self.dateArray.count {
                if dateArray[i]?.isEmpty == false {
                    let dateString = dateArray[i]!.subStringAfterLastComma
                    let dateMonth = dateString.components(separatedBy: CharacterSet.decimalDigits).joined().uppercased()
                    
                    self.monthArray.append(dateMonth)
                }
            }
        }
        
        if self.monthArray.isEmpty == false {
            for i in 0..<self.monthArray.count{
                for num in months.indices {
                    if self.monthArray[i]!.contains(months[num]) {
                        self.dateFrequency[num] += 1
                    }
                    
                }
                
            }
        }
        
        
    }
    func fetchSymptomData() {
        let fetchRequest = NSFetchRequest<MasterData>(entityName: "MasterData")
        do{
            let result = try moc.fetch(fetchRequest)
            let dateArray = result.map{$0.date?.string(format: self.dateFormat)}
            let fatigueArray = result.map{Double($0.fatigue)}
            let swellingArray = result.map{Double($0.swelling)}
            let dyspneaArray = result.map{Double($0.dyspnea)}
         
            
            self.dateArray = dateArray
            self.fatigueMonth = fatigueArray
            self.dyspneaMonth = dyspneaArray
            self.swellingMonth = swellingArray
          
            for i in 0..<dateArray.count {
                let temp = swellingMonth[i] + fatigueMonth[i] + dyspneaMonth[i]
                self.combinedMonth.append(temp)
            }

        } catch {
            print("Could not fetch. \(error)")
        }
        
        
    }
    func pieMaker() {
        let colors: [Color] = [Color("ColorPieKavsoft") , .red, .blue, .sand, .yellow, .green, .purple, .orange, .bubbleGum, .metallicGold, .navy, .neonRed]
        
        for i in 0..<swellingMonthly.count {
            let reduct = Double(swellingMonthly[i].reduce(0, +))
            let temp = reduct/(swellTotal + 0.01) * 100
            let pie =  Pie(id: i, percent: CGFloat(temp), name: months[i], color: colors[i])
            self.swellPie.append(pie)
        }
        
        for i in 0..<dyspneaMonthly.count {
            let reduct = Double(dyspneaMonthly[i].reduce(0, +))
            let temp = reduct/(dyspTotal + 0.01) * 100
            let pie =  Pie(id: i, percent: CGFloat(temp), name: months[i], color: colors[i])
            self.dysPie.append(pie)
            
        }
        
        for i in 0..<fatigueMonthly.count {
            let reduct = Double(fatigueMonthly[i].reduce(0, +))
            let temp = reduct/(fatTotal + 0.01) * 100
            let pie =  Pie(id: i, percent: CGFloat(temp), name: months[i], color: colors[i])
            self.fatPie.append(pie)
            
        }
        
        for i in 0..<combinedMonthly.count{
            let reduct = Double(combinedMonthly[i].reduce(0, +))
            let temp = reduct/(sympTotal + 0.01) * 100
            let pie =  Pie(id: i, percent: CGFloat(temp), name: months[i], color: colors[i])
            self.combinedPie.append(pie)
        }
//        let piedata = [
//            Pie(id: 0, percent: CGFloat(swellPercent), name: "Swelling", color: Color.sand),
//            Pie(id: 1, percent: CGFloat(dyspPercent), name: "Dyspnea", color: .red),
//            Pie(id: 2, percent: CGFloat(fatPercent), name: "Fatigue", color: .blue),
//            Pie(id: 3, percent: 0, name: "", color: .clear),
//            Pie(id: 4, percent: 0, name: "", color: .clear),
//            Pie(id: 5, percent:0, name: "", color: .clear),
//            Pie(id: 6, percent: 0, name: "", color: .clear),
//            Pie(id: 7, percent:0, name: "", color: .clear),
//            Pie(id: 8, percent: 0, name: "", color: .clear),
//            Pie(id: 9, percent: 0, name: "", color: .clear)
//        ]
//        self.combinedPie = piedata

    }
    
}

struct SymptomsView_Previews: PreviewProvider {
    static var previews: some View {
        SymptomsView(pushed : .constant(true)).preferredColorScheme(.light)
    }
}

struct TBNoImage : View {
    @Binding var selected : String
    var title : String
    var animation : Namespace.ID
    @State var size : CGFloat
    @Environment(\.colorScheme) var cs
    var body: some View{
       
        Button(action: {
            
            withAnimation(.spring()){
                
                selected = title
              
            }
            
        }) {
            
            ZStack{
                
                // Capsule And Sliding Effect...
                
                Capsule()
                    .fill(Color.clear)
                    .frame(height: size)
                    .padding(.horizontal)
                
                if selected == title{
                    
                    Capsule()
                        .fill(Color.white)
                        .opacity(0.8)
                        .frame(height: size)
                    // Mathced Geometry Effect...
                        .matchedGeometryEffect(id: "Tab", in: animation)
                }
                
                Text(title)
                    .font(.system(size: size / 2))
                    .foregroundColor(selected == "" ? Color.textColor(for: cs).opacity(0.6) : (selected == title ? .navy : Color.textColor(for: cs).opacity(0.6) ))
                    .fontWeight(selected == "" ? .regular : (selected == title ? .semibold : .light))
                    .opacity(selected == title ? 0.9 : 0.7)
            }
        }.frame(width: size > 30 ? ultra / 2 : ultra / 4 - 10, height : size)
        .buttonStyle(ChartModifier(gradient: LinearGradient.overall(for: cs), r: 20))
        
    }
}

struct TBNoImage2 : View {
    @Binding var selected : String
    var title : String
    @State var size : CGFloat
    @Environment(\.colorScheme) var cs
    var body: some View{
       
        Button(action: {
            
            withAnimation(.spring()){
                
                selected = title
              
            }
            
        }) {
            
            ZStack{
                
                // Capsule And Sliding Effect...
                
                Capsule()
                    .fill(Color.clear)
                    .frame(height: size)
                    .padding(.horizontal)
                
                if selected == title{
                    
                    Capsule()
                        .fill(Color.white)
                        .opacity(0.8)
                        .frame(height: size)
                    // Mathced Geometry Effect...
                }
                
                Text(title)
                    .font(.system(size: size / 2))
                    .foregroundColor(selected == "" ? Color.textColor(for: cs).opacity(0.6) : (selected == title ? .navy : Color.textColor(for: cs).opacity(0.6) ))
                    .fontWeight(selected == "" ? .regular : (selected == title ? .semibold : .light))
                    .opacity(selected == title ? 0.9 : 0.7)
            }
        }.frame(width: size > 30 ? ultra / 2 : ultra / 4 - 10, height : size)
        
    }
}

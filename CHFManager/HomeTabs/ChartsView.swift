//
//  ChartsView.swift
//  Golgi-Splash
//
//  Created by Marwan Zaarab on 2020-12-07.
//

import SwiftUI
import CoreData
import FloatingButton
//import iLineChart

struct ChartsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var pushed : Bool
    @Environment(\.managedObjectContext) var moc
    @Environment(\.colorScheme) private var colorScheme
    @FetchRequest(entity: MasterData.entity(), sortDescriptors: []) var dayItems: FetchedResults<MasterData>
    @State var months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"]
    @State var monthsSmall = ["J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D"]

    @State var fullMonths = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var dateFormat = "EEEE, MMM d"
    
    //symptoms Monthly
    @State var swellingFreqByMonth = [Double]()
    @State var fatigueFreqByMonth = [Double]()
    @State var dyspneaFreqByMonth = [Double]()
    @State var combinedFreqByMonth = [Double]()
    @State var swellingMonthly : [[Double]] = [ [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double]() ]
    @State var fatigueMonthly : [[Double]] = [ [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double]() ]
    @State var dyspneaMonthly : [[Double]] = [ [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double]() ]
    @State var combinedMonthly : [[Double]] = [ [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double]() ]
    //symptoms DateMonthly
    @State var swellingDateMonthly : [[String]] = [ [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String]() ]
    @State var dyspneaDateMonthly : [[String]] = [ [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String]() ]
    @State var fatigueDateMonthly : [[String]] = [ [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String]() ]
    @State var combinedDateMonthly : [[String]] = [ [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String]() ]
    
    @State var combinedPercentageMonthly = [CGFloat]()
    //water weight
    @State var waterDateMonthly : [[String]] = [ [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String]() ]
    @State var waterMonthly : [[Double]] = [ [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double]() ]
    @State var liquidsArray = [Double]()
    @State var liquidDates = [Date]()
    @State var liquids: [Double] = [0,0,0,0,0,0,0,0,0,0,0,0]
    @State var weightMonth : [Double] = []
    @State var weightMonthKg: [Double] = []
@State var selected = 1
    //meds
    @State var medsCompliance = [Double]()
    @State var medsDateMonthly : [[String]] = [ [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String]() ]
    @State var medsMonthly : [[Double]] = [ [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double]() ]
    @State var medsPercentageMonthly = [CGFloat]()
    @State var totalMedsTaken: Double = 0
    @State var totalMedsToBeTaken : Double = 0
    @State var totalMedsTakenArray = [Double]()
    
    // Direct CoreData Fetched Arrays
    @State var monthChecker = [Int]()
    @State var dateArray = [String?]()
    @State var fatigueMonth: [Double] = []
    @State var swellingMonth: [Double] = []
    @State var dyspneaMonth: [Double] = []
    @State var monthArray = [String?]()
    @State var combinedMeds: [Double] = []
    
   // Computed properties for Line Charts
    @State var combinedMonth: [Double] = []
    @State var rxDouble: [Double] = []
    @State var fatigue: [String] = []
    @State var dyspnea: [String] = []
    @State var swelling: [String] = []
    
    @State var dateFrequency: [Double] = [0,0,0,0,0,0,0,0,0,0,0,0]
    @State var isTapped = 1
    @State var isDxTapped = 5
  

    @State var liquidWeightData = [Double]()
  
    @State var monthWidth = UIScreen.main.bounds.width / 3 - 25
    @State var monthHeight = UIScreen.main.bounds.height / 4 - 130
    @State var circlesOffset: CGFloat = -50
  
    @State var graphVisible = 1
    let rows = [
        GridItem(.fixed(20)),
        GridItem(.fixed(20))
    ]
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.fixed(30))
    ]
    @State var image: String = "scribble"
    @State var leadingTag: String = "symptoms"
    @State var trailingTag: String = "curved"
    @State var extraTag: String = "pill"
    @State var showSx = "swell"
    @State var title = "Occurences"
    @State var subtitle = "weight in pounds (lbs)"
    
    @State var swellPie = [Pie]()
    @State var dysPie = [Pie]()
    @State var combinedPie = [Pie]()
    @State var fatPie = [Pie]()
    @State var pieData = [Pie]()
    @State var titresPie = ["Swelling", "Dyspnea", "Fatigue", "Combined"]
    @State var tapie = 0
    
    @State var swellTotal: Double = 0
    @State var dyspTotal: Double = 0
    @State var fatTotal: Double = 0
    @State var sympTotal: Double = 0
    @State var swellPercent : Double = 0
    @State var fatPercent : Double = 0
    @State var dyspPercent : Double = 0
    @State var combPercent: Double = 0
    @State var leadButtons = [AnyView]()
    @State var leadButton = AnyView(MainButton(imageName: "cross.fill", colorHex: "222831"))
    @State var trailButton : AnyView =  AnyView(MainButton(imageName: "chart.bar.fill", colorHex: "222831"))
    @State var trailButtons = [AnyView]()
    @State var symptomData = [Double]()
    @State var dateMonthlyData = [[String]]()
    @State var monthlyData = [[Double]]()
    @State var pieSxTotal : Double = 0
    @State var leadImg: String = "cross.fill"
    @State var trailImg = "scribble"
    @State var tap = 0
    @State var titres = ["Swelling", "Dyspnea", "Fatigue", ultra > 400 ? "Combined" : "Merged", "Medication Compliance",]
    static let chartImageNames = ["scribble","char.bar.fill","chart.pie.fill"]
    static let iconImageNames = ["cross.fill","scalemass.fill","drop.fill","pills.fill"]
    @State var showSxS = ["swell", "dysp", "fat", "combine"]
    @State var isOpen = false
    @State var isOpen2 = false
  @State var selected1 = 0
    var body: some View {
        //        NavigationView {
        ZStack{
            let showSymps = ["swell", "dysp", "fat", "combine"]
            let showData = [swellingFreqByMonth, dyspneaFreqByMonth, fatigueFreqByMonth, combinedFreqByMonth]
            let showDateMonthly = [swellingDateMonthly, dyspneaDateMonthly, fatigueDateMonthly, combinedDateMonthly]
            let showMonthly = [swellingMonthly, dyspneaMonthly, fatigueMonthly, combinedMonthly]
            let rightButton = AnyView(
                Button(action: {
                    tap += 1
                    self.showSx = showSymps[tap]
                    self.symptomData = showData[tap]
                    self.monthlyData = showMonthly[tap]
                    self.dateMonthlyData = showDateMonthly[tap]
                    self.title = self.titres[tap]
            }) {
                    IconAndTextButton(imageName: "arrow.right", buttonText: tap < 3 ? self.titres[tap+1] : self.titres[3])
                        .fixedSize(horizontal: false, vertical: true)

            }.disabled(self.title == self.titres[3]))
//                .buttonStyle(ChartModifier(gradient: LinearGradient.overall(for: colorScheme), r: 10  ))
                .isHidden(self.leadingTag != "symptoms" || self.title == self.titres[3])
            let leftButton = AnyView(
                Button(action: {
                    tap -= 1
                    self.showSx = showSymps[tap]
                    self.symptomData = showData[tap]
                    self.monthlyData = showMonthly[tap]
                    self.dateMonthlyData = showDateMonthly[tap]
                    self.title = self.titres[tap]
                }) {
                    IconAndTextButton(imageName: "arrow.left", buttonText: tap > 0 ? self.titres[tap-1] : self.titres[0])
                        .fixedSize(horizontal: false, vertical: true)

                      
                }.disabled(self.title == self.titres[0]))
                .isHidden(self.leadingTag != "symptoms" || self.title == self.titres[0])
//                .buttonStyle(ChartModifier(gradient: LinearGradient.overall(for: colorScheme), r: 10  ))

            
            ZStack{
//                Color.backgroundColor(for: colorScheme).edgesIgnoringSafeArea(.all)
                LinearGradient.overall(for: colorScheme).edgesIgnoringSafeArea(.all)
                
                ScrollView{
                    
                    ZStack{
    //MARK: ************************** SYMPTOMS CHARTS **************************
                ZStack{
                    GeometryReader{ geo in
                        VStack{
                           
                        
                        ZStack{
                        //MARK: Swelling Line Graph
                        SwellingGraph(title: self.title, data: symptomData, curved: self.trailingTag == "curved" ? true : false)
                            .isHidden(self.leadingTag != "symptoms")
                            
                        AceGraph(title: "Medication Compliance", data: medsCompliance,
                                 curved: self.trailingTag == "curved" ? true : false)
                            .isHidden(self.leadingTag != "meds")
                        
                      
                   
                      
                        WeightGraph(title: self.title, subtitle: self.subtitle, data: liquidWeightData, curved: self.trailingTag == "curved" ? true : false)
                            .isHidden(self.leadingTag != "weight")
//                            .offset(y: -15)
                           
                            
                            LiquidGraph(title: "Liquids", subtitle: "Intake in ounces (oz)", data: liquidsArray, curved: true)
                          .isHidden(self.leadingTag != "liquide")
                          .offset(y: -15)
                            
                        
                        .padding(.top, 20)
                           
                        } .isHidden(self.trailingTag == "bar" || self.trailingTag == "pie")
                            .onAppear{
                            self.symptomData = swellingFreqByMonth
                            self.monthlyData = swellingMonthly
                            self.dateMonthlyData = swellingDateMonthly
                            
                        }
                    }
                    }
                }
                                        
//       📊 📊 📊 📊 📊📊 📊 📊 📊📊 📊 📊 📊 📊
                    ZStack{
                           VStack(spacing:5){
                            (Text("\(self.title.lowercased())").bold() + Text(" daily data"))
                                         .font(.system(size: 18, weight: .thin, design: .rounded))
                                         .foregroundColor(Color(hex: "4b5d67"))
                                .padding(.top, 20)
                            SymptomBarChart(
                                title: self.title,
                                monthChecker: self.$monthChecker,
                                symptomDateMonthly: self.$dateMonthlyData,
                                symptomMonth: self.$symptomData,
                                symptomMonthly: self.$monthlyData)
                            .isHidden(self.leadingTag != "symptoms")
                            .offset(y: self.showSx == "combine" ? 20 : 0)
                           }
                        
                        GeometryReader{ ge in
                            MedsBarChart(
                                monthChecker: self.$monthChecker,
                                medsDateMonthly: self.$medsDateMonthly,
                                combinedMeds: self.$medsCompliance,
                                medsMonthly: self.$medsMonthly)
                            .isHidden(self.leadingTag != "meds")
                                .frame(width: ge.size.width, height: ge.size.height, alignment: .center)
                        }
                        
                        WeightCharts()
                            .offset(y: 40)
                            .isHidden(self.leadingTag != "weight")
                        
                        FluidCharts(show: $selected).navigationTitle("").navigationBarHidden(true)
                            .isHidden(self.leadingTag != "liquide")
                   
                    }
                    .isHidden(self.trailingTag != "bar")
                    .isHidden(self.trailingTag == "pie")
                    .padding(.top, 35)
                                   
                        
                        
                      
       //🧩🧩🧩🧩🧩🧩🧩🧩🧩🧩🧩🧩🧩🧩🧩🧩🧩🧩🧩🧩🧩🧩🧩🧩🧩🧩🧩
                        ZStack{
                            GeometryReader { geo in
                       // 💊💊💊💊💊💊
                             CombinedRxSxBarChart(monthChecker: self.$monthChecker, medsPercentageMonthly: self.$medsPercentageMonthly, combinedPercentageMonthly: self.$combinedPercentageMonthly)
                                .isHidden(self.leadingTag != "meds" || self.trailingTag != "pie")
                                .offset(y:-30)
                           // 🤕🩹🤕🩹🤕🩹
                            allPies
                                .isHidden(self.trailingTag != "pie" || self.leadingTag != "symptoms")
                                .padding(.top, 25)
                                    }
                            }

                        .onAppear {
                          
                            self.onAppearDo()
                           
                        }
                        

                        
    //MARK: 🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵
   
            VStack{
 
                        VStack{
                            Spacer(minLength: hulk > 700 ? (hulk > 800 ? 505 : hulk / 2 + 40)  : hulk / 2 + 30)
                            GeometryReader { geo in
                            HStack{
                                Spacer()
                                ForEach(ultra > 400 ? months : monthsSmall, id: \.self) { month in
                                
                                    Text(month)
                                        .font(.system(size: ultra > 400 ? 12 : 11, weight: .light, design: .rounded)).foregroundColor(.grayMe)
                                        .fixedSize(horizontal: false, vertical: true)
                                    Spacer()
                                        
                                }
                            }
                        }
                            HStack{
                                leftButton
                                Spacer()
                                rightButton
                            }.zIndex(100).isHidden(self.trailingTag == "pie")
                            .padding(.top, 25)
                            .padding(.horizontal, 10)
                        }.isHidden(self.trailingTag == "bar" || self.trailingTag == "pie")
                      
                            Spacer(minLength: 330)
                            ZStack{
                                HStack{
                                    Spacer()
                                    Button(action:{
                                        self.liquidWeightData = weightMonthKg
                                        self.subtitle = "Weight in kilograms (kg)"
                                    }){
                                    LinearGradient.diagonalLairColor(for: colorScheme).mask(
                                       Text("Kilograms (kg)")
                                        .opacity(self.liquidWeightData == weightMonthKg ? 1 : 0.5)
                                        )
                                }
                                    Spacer()
                                    Button(action:{
                                        self.liquidWeightData = weightMonth
                                        self.subtitle = "Weight in pounds (lbs)"
                                    }){
                                        LinearGradient.diagonalLairColor(for: colorScheme).mask(
                                       Text("Pounds (lbs)")
                                        .opacity(self.liquidWeightData == weightMonth ? 1 : 0.5)
                                        )
                                }
                                    Spacer()
                                }.font(.system(size: 14, weight: .light, design: .monospaced))
                                .shadow(color: Color.textColor(for: self.colorScheme).opacity(0.5), radius: 3, x: 2, y: 2)
                                
                                .isHidden(self.leadingTag != "weight" || self.trailingTag == "bar" || self.trailingTag == "pie")
                         
                            }.offset(y: -350)
                        }
                        
                    }
                    
                }
//                .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
                
            }
           
            Spacer()
         // 🎱⚽️🏀⚾️🥎🏉🎾🏐🏸
            GeometryReader { g in
            HStack{

                HStack(spacing: 10){

                    ChartButtons(leadImg: $leadImg, trailImg: $trailImg, leadButton: $leadButton, trailButton: $trailButton, leadingTag: $leadingTag, trailingTag: $trailingTag, showSx: $showSx, title: $title, symptomData: $symptomData)
                    Spacer()
                }.padding(.leading, 10)



            }.frame(width:g.size.width, height: g.size.height * 2 - 140)
            }
            
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .onAppear {
            self.showSx = "swell"
            self.leadingTag = "symptoms"
            self.symptomData = swellingFreqByMonth
            self.title = "Swelling"
            self.liquidWeightData = weightMonth
        }
        
        
        
    }
   
    var allPies : some View {
        VStack{
            HStack{
                Button(action:{
                        if tapie > 0 {
                            tapie -= 1
                            self.showSx = showSxS[tapie]
                        } else {
                            tapie = 3
                            self.showSx = showSxS[tapie]
                        }
                }) {
                    Image(systemName: "arrow.left")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(8)
                }.buttonStyle(OtherModifier2())
                Spacer()
                Text("\(titresPie[tapie].lowercased())").bold()
                             .font(.system(size: 22, weight: .thin, design: .rounded))
                             .foregroundColor(Color(hex: "4b5d67"))
                   
                Spacer()
                Button(action:{
                        if tapie < 3 {
                            tapie += 1
                            self.showSx = showSxS[tapie]
                        } else {
                            tapie = 0
                            self.showSx = showSxS[tapie]
                        }
                }) {
                    Image(systemName: "arrow.right")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(8)
                }.buttonStyle(OtherModifier2())
            } .padding(.top, 40)
            .padding(.horizontal, 40)
        ZStack{
            PieChartKav(piedata: self.swellPie.sorted(by: { $0.percent > $1.percent }), selected: $selected)
                .isHidden(self.showSx != "swell")
            PieChartKav(piedata: self.dysPie.sorted(by: { $0.percent > $1.percent }), selected: $selected)
                .isHidden(self.showSx != "dysp")
            PieChartKav(piedata: self.fatPie.sorted(by: { $0.percent > $1.percent }), selected: $selected)
                .isHidden(self.showSx != "fat")
            PieChartKav(piedata: [
                Pie(id: 0, percent: CGFloat(swellPercent), name: "Swelling", color: Color.sand),
                Pie(id: 1, percent: CGFloat(dyspPercent), name: "Dyspnea", color: .red),
                Pie(id: 2, percent: CGFloat(fatPercent), name: "Fatigue", color: .blue),
                Pie(id: 3, percent: 0, name: "", color: .clear),
                Pie(id: 4, percent: 0, name: "", color: .clear),
                Pie(id: 5, percent:0, name: "", color: .clear),
                Pie(id: 6, percent: 0, name: "", color: .clear),
                Pie(id: 7, percent:0, name: "", color: .clear),
                Pie(id: 8, percent: 0, name: "", color: .clear),
                Pie(id: 9, percent: 0, name: "", color: .clear)
            ], selected: $selected)
            .isHidden(self.showSx != "combine")
            
        }
        }
    }

/*    🔴🟢🔴🟢 🔴🟢🔴🟢 🔴🟢🔴🟢 🔴🟢🔴🟢 🔴🟢🔴🟢 🔴🟢🔴🟢 🔴🟢🔴🟢 🔴🟢🔴🟢 */
//MARK: ************************** FUNCTIONS **************************************************** FUNCTIONS ********************************************************* FUNCTIONS *****************************************
    
 
    
    
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
                    
                   
            
                    //meds
                    self.medsMonthly[num].append(combinedMeds[i])
                    self.medsDateMonthly[num].append(dateArray[i]!)
                }
               
              
            }
        }
        
        for i in 0..<liquidDates.count  {
            for num in self.months.indices {
                let dater = liquidDates[i].string(format: "MMM")
                let waterDater = liquidDates[i].string(format: "EEEE, MMM d")
                if dater == months[num] {
                    self.waterMonthly[num].append(liquidsArray[i])
                    self.waterDateMonthly[num].append(waterDater)
                }
            }
        }
        
        
        
    }

    //MARK: FETCH Pie INFO Pie PUEEEEEEEEEE pew Pewwwwww Pew pew
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
        
        for i in 0..<combinedMonthly.count {
            let temp = combinedMonthly[i].reduce(0, +)
           
            let floater = CGFloat((temp/(sympTotal)) * 100)
          
            self.combinedPercentageMonthly.append(floater)
        }
       
    }
    
    func fetchMedsCompliance() {
        if dayItems.count > 0 {
        for i in 0..<dayItems.count {
            let temp = dayItems[i].rxComp
            let percent = (temp / 4) * 100
           self.medsCompliance.append(percent)
         
         
        }
            print("medsComplianceListView: \(medsCompliance)")
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
            
            if dateFrequency[num] != 0 {
                let rxFrequency = combinedMeds.reduce(0, +)
                let rxPercentage = rxFrequency/(dateFrequency[num] * 4)
                self.rxDouble.append(rxPercentage * 100)
            }
        }
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
    func fetchLiquidCompliance() {
        if self.liquidsArray.isEmpty == false {
            for i in 0..<self.liquidsArray.count{
                for num in months.indices {
                    let dater = liquidDates[i].string(format: "MMM")
                    if dater == months[num] {
                        self.liquids[num] += self.liquidsArray[i]
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
    //MARK: MEDS Compliance
    func fetchMedsPercentage() {
        var totalD: Double = 0
        var totalN: Double = 0
        for i in 0..<medsMonthly.count {
         
            if medsMonthly[i].count > 0 {
                let n = medsMonthly[i].reduce(0, +)
                if medsDateMonthly[i].count > 0 {
                let d = Double(medsDateMonthly[i].count * 4)
                
              
                let percent = Double((n/d)) * 100
                let floater = CGFloat(percent)
               
                self.medsPercentageMonthly.append(floater)
                self.medsCompliance.append(percent)
                self.totalMedsTakenArray.append(n)
              
                totalD += d
                totalN += n
                }
            } else {
                self.medsPercentageMonthly.append(0.0)
                self.medsCompliance.append(0.0)
                self.totalMedsTakenArray.append(0.0)
            }
        }
        self.totalMedsToBeTaken = Double(totalD)
       
        self.totalMedsTaken = totalN
        
    }
    
    func fetchMedsPercentageIntoFloaters() {
        for i in 0..<totalMedsTakenArray.count {
            self.totalMedsTakenArray[i] =  Double(self.totalMedsTakenArray[i] / self.totalMedsToBeTaken) * 100
        }
     
    }
    
    func convertWeight()  {
        for i in 0..<weightMonth.count {
            let temp = weightMonth[i]/2.2
            self.weightMonthKg.append(temp)
        }
    }
    
    func fetchWeightData() {
        let fetchRequest = NSFetchRequest<Weight>(entityName: "Weight")
        do{
            let result = try moc.fetch(fetchRequest)
            let weightArray = result.map{$0.weight}
            self.weightMonth = weightArray
        } catch {
            print("Could not fetch \(error)")
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
            let rxArray = result.map{$0.rxComp}
            self.dateArray = dateArray
            self.fatigueMonth = fatigueArray
            self.dyspneaMonth = dyspneaArray
            self.swellingMonth = swellingArray
            self.combinedMeds = rxArray
          
            for i in 0..<dateArray.count {
                let temp = swellingMonth[i] + fatigueMonth[i] + dyspneaMonth[i]
                self.combinedMonth.append(temp)
            }

        } catch {
            print("Could not fetch. \(error)")
        }
        
        let fetchRequest2 = NSFetchRequest<CD_Liquids>(entityName: "CD_Liquids")
        do {
            let result = try moc.fetch(fetchRequest2)

            let liquidArray = result.map{$0.intake}
            let liquidDates = result.map{$0.date}
            self.liquidDates = liquidDates
            self.liquidsArray = liquidArray
            
        } catch {
            print("Could not fetch. \(error)")
        }
        
        
    }
    func getEmoji() -> String {
        var image: String = "line.diagonal"
        
        let value: Double = Double((totalMedsTaken) / totalMedsToBeTaken) * 100
        
                if value > 70 {
                    image = "happy"
                } else {
                    image = "sad-face"
                }
       
       
        return image
    }
    
   // 🥧🥧🍰🍰🥧🍰
    func pieMaker() {
        let colors: [Color] = [Color("ColorNeuro"), .red, .blue, .sand, .yellow, .green, .purple, .orange, .bubbleGum, .metallicGold, .navy, .neonRed]
        
        for i in 0..<swellingMonthly.count {
            let reduct = Double(swellingMonthly[i].reduce(0, +))
            let temp = reduct/(swellTotal + 0.01) * 100
            let pie =  Pie(id: i, percent: CGFloat(temp), name: fullMonths[i], color: colors[i])
            self.swellPie.append(pie)
        }
        
        for i in 0..<dyspneaMonthly.count {
            let reduct = Double(dyspneaMonthly[i].reduce(0, +))
            let temp = reduct/(dyspTotal + 0.01) * 100
            let pie =  Pie(id: i, percent: CGFloat(temp), name: fullMonths[i], color: colors[i])
            self.dysPie.append(pie)
            
        }
        
        for i in 0..<fatigueMonthly.count {
            let reduct = Double(fatigueMonthly[i].reduce(0, +))
            let temp = reduct/(fatTotal + 0.01) * 100
            let pie =  Pie(id: i, percent: CGFloat(temp), name: fullMonths[i], color: colors[i])
            self.fatPie.append(pie)
            
        }
 

    }
   
    func onAppearDo() {
        DispatchQueue.main.async {
            //dates
         
            self.monthArray = []
            self.monthChecker = [0,0,0,0,0,0,0,0,0,0,0,0]
            self.dateFrequency = [0,0,0,0,0,0,0,0,0,0,0,0]
           
            //meds
             self.totalMedsToBeTaken = 0
             self.totalMedsTaken = 0
             self.totalMedsTakenArray = []
             self.medsMonthly = [[], [], [], [], [], [], [], [], [], [] ,[] ,[]]
             self.medsDateMonthly = [[], [], [], [], [], [], [], [], [], [] ,[] ,[]]
             self.medsPercentageMonthly = []
            self.medsCompliance = []
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
            self.combinedMeds = []
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
            self.waterMonthly = [[], [], [], [], [], [], [], [], [], [] ,[] ,[]]
            self.waterDateMonthly = [[], [], [], [], [], [], [], [], [], [] ,[] ,[]]
            self.liquids = [0,0,0,0,0,0,0,0,0,0,0,0]
            self.liquidDates = []
            self.liquidsArray = []
            self.weightMonth = []
            self.weightMonthKg = []
            //pies
            self.swellPie = []
            self.fatPie = []
            self.dysPie = []
            //functions
            self.fetchWeightData()
            self.convertWeight()
            self.fetchSymptomData()
            self.fetchMonths()
            self.fetchSymptoms()
            self.fetchDicts()

            self.fetchMonthlyData()
            self.checkIfMonthIsPresent()
//            self.fetchMedsCompliance()
            self.fetchMedsPercentage()
            self.fetchMedsPercentageIntoFloaters()
            self.fetchPieInfo()
            self.pieMaker()
            self.fetchLiquidCompliance()
            //tags
            self.showSx = "swell"
            self.leadingTag = "symptoms"
            self.symptomData = swellingFreqByMonth
            self.title = "Swelling"
            self.liquidWeightData = weightMonth
        }
    }
    
    
}



struct ChartsView_Previews: PreviewProvider {
    static var previews: some View {
        ChartsView(pushed: .constant(true))
    }
}




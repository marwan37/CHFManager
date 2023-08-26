//
//  PillModel.swift
//  Golgi-Splash
//
//  Created by Marwan Zaarab on 2021-01-13.
//

import SwiftUI
import Combine
import CoreData
import PartialSheet
import Grid

struct PillsView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var cs
    @Binding var pushed: Bool
        @Environment(\.managedObjectContext) var moc
        @FetchRequest(entity: MasterData.entity(), sortDescriptors: []) var dayItems: FetchedResults<MasterData>
        @FetchRequest(fetchRequest : RxData.getRx()) var rxData:FetchedResults<RxData>
    @EnvironmentObject var data : DayData
    var gridItemLayout = [GridItem(.flexible()),GridItem(.flexible())]
    var colors: [Color] = [.yellow, .white, .green, .lightEnd]
    @State var showAddView = false
    @State var months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"]
    @State var dateFrequency: [Double] = [0,0,0,0,0,0,0,0,0,0,0,0]
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
    @State var monthArray = [String?]()
    @State var combinedMeds: [Double] = []
    @State var numb = [0,1,2,3]
    @State var offset : CGFloat = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack{
            if cs == .dark {
                LinearGradient.init(gradient: Gradient(colors: [Color.trackColor, Color.lilly]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            } else {
                LinearGradient.init(gradient: Gradient(colors: [Color.grayMe, Color.lairWhite]), startPoint: .bottom, endPoint: .top).edgesIgnoringSafeArea(.all)
            }
            
            
            ScrollView(.vertical){
                VStack{
                    HStack{
                        
                        (Text("my ") + Text("medications").bold())
                        .opacity(0.7)
                        .font(.system(size: 22, weight: .thin, design: .rounded))
                            .padding(.vertical, 15)
                        
                        Spacer()
                        Button(action:{
                            self.showAddView.toggle()
                        }){
                            Image("plus")
                                .resizable().aspectRatio(contentMode: .fit)
                                .frame(width: 24, height: 24)
                        }.sheet(isPresented: $showAddView) {
                            AddRxView()
                        }
                    } .padding(.horizontal, 10)
                    GeometryReader{ geo in
                        
//                        let r = rxData.count
                       
                        Grid(rxData, id:\.self.id) { rx in
                            PillModel(rx: rx)
                                .environmentObject(PartialSheetManager())

//                                .padding()
//                        Grid(0..<self.numb.count, id:\.self) { _ in
//
//                            PillModelTesting()
//                            PillModelTesting()
//
//
//
                        }
                        .gridStyle(
                            ModularGridStyle(.vertical, columns: 2, rows: .fixed(hulk > 700 ? 200 : 150))
                        )
//
                            
                       
                    }
                    .navigationTitle("")
                    .navigationBarHidden(true)
                    
                    Spacer()
                   
                }
//                .sheet(isPresented: $remove) {
//                    VStack{
//
//                        Spacer()
//
//                        CustomActionSheet()
//                        .offset(y: self.offset)
//                        .gesture(DragGesture()
//
//                            .onChanged({ (value) in
//
//                                if value.translation.height > 0{
//
//                                    self.offset = value.location.y
//
//                                }
//                            })
//                            .onEnded({ (value) in
//
//                                if self.offset > 100{
//
//                                    self.offset = UIScreen.main.bounds.height
//                                }
//                                else{
//
//                                    self.offset = 0
//                                }
//                            })
//                        )
//
//                    }.background((self.offset <= 100 ? Color(UIColor.label).opacity(0.3) : Color.clear).edgesIgnoringSafeArea(.all)
//                        .onTapGesture {
//
//                        self.offset = 0
//
//                    })
//
//                    .edgesIgnoringSafeArea(.bottom)
//                }
                
                
            }
            
          
        }.animation(.default)
        
    }
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
}


struct PillsView_Previews: PreviewProvider {
    static var previews: some View {
        PillsView(pushed:.constant(true)).preferredColorScheme(.light)
            .environmentObject(DayData())
    }
}





    
    //                    GeometryReader { geo in
    //                        LazyVGrid(columns:gridItemLayout){
    //                        NavigationLink(destination:
    //                                        MedsBarChart(
    //                                            monthChecker: self.$monthChecker,
    //                                            medsDateMonthly: self.$medsDateMonthly,
    //                                            combinedMeds: self.$medsCompliance,
    //                                            medsMonthly: self.$medsMonthly)
    //                                        .navigationTitle("")
    //                                        .navigationBarHidden(true)
    //                        )
    //                        {
    //                            HStack{
    //                            Image(cs == .dark ? "excelWhite" : "excel")
    //                                .resizable()
    //                                .aspectRatio(contentMode: .fit)
    //                                .frame(width: 50, height: 50)
    //                                .background(cs == .dark ? Color.darkBG : Color.white)
    //                                .cornerRadius(10)
    //                                .shadow(color: cs == .dark ? Color.white.opacity(0.3) : Color.black.opacity(0.3), radius: 2, x: -2, y: -3)
    //
    //                            Text("Table View")
    //                                .foregroundColor(.white)
    //                                .font(.system(size: 15, weight: .light, design: .monospaced))
    //                            }.frame(width: geo.size.width, height: geo.size.height + UIScreen.main.bounds.height )
    //                        }
    //
    //                            NavigationLink(destination:
    //                                            VStack{
    //                                                AceGraph(title: "Medication Compliance", data: combinedMeds,
    //                                                         curved:true)
    //
    //
    //                                                Spacer(minLength: 535)
    //                                                GeometryReader { geo in
    //                                                    HStack{
    //                                                        Spacer()
    //                                                        ForEach(months, id: \.self) { month in
    //
    //                                                            Text(month).font(.caption).foregroundColor(.grayMe)
    //
    //                                                            Spacer()
    //
    //                                                        }
    //                                                    }
    //                                                }
    //                                            }
    //                                            .navigationTitle("")
    //                                            .navigationBarHidden(true)
    //                            )
    //                            {
    //                                HStack{
    //                                    Image(systemName: "point.topleft.down.curvedto.point.bottomright.up")
    //                                        .rotationEffect(.init(degrees: 90))
    //                                        .font(.system(size: 30))
    //                                        .frame(width: 50, height: 50)
    //                                        .background(cs == .dark ? Color.darkBG : Color.white)
    //                                        .cornerRadius(10)
    //                                        .shadow(color: cs == .dark ? Color.white.opacity(0.3) : Color.black.opacity(0.3), radius: 2, x: -2, y: -3)
    //
    //                                    Text("Graph View")
    //                                        .foregroundColor(Color.white)
    //                                        .font(.system(size: 15, weight: .light, design: .monospaced))
    //                                }
    //                            }
    //                        }
    //                        .navigationTitle("")
    //                        .navigationBarHidden(true)
//            .onAppear{
//                    DispatchQueue.main.async {
//
//                    self.monthArray = []
//                    self.monthChecker = [0,0,0,0,0,0,0,0,0,0,0,0]
//                    self.dateFrequency = [0,0,0,0,0,0,0,0,0,0,0,0]
//                    //meds
//                     self.totalMedsToBeTaken = 0
//                     self.totalMedsTaken = 0
//                     self.totalMedsTakenArray = []
//                     self.medsMonthly = [[], [], [], [], [], [], [], [], [], [] ,[] ,[]]
//                     self.medsDateMonthly = [[], [], [], [], [], [], [], [], [], [] ,[] ,[]]
//                     self.medsPercentageMonthly = []
//                    self.medsCompliance = []
//                    self.fetchSymptomData()
//                    self.fetchMonths()
//                    self.fetchMonthlyData()
//                    self.checkIfMonthIsPresent()
//         self.fetchMedsPercentage()
//                    self.fetchMedsPercentageIntoFloaters()
//                    }
//                }
    
    
//    func checkIfMonthIsPresent() {
//
//        for i in 0..<monthArray.count{
//            for num in self.monthChecker.indices{
//                if self.monthArray[i]!.contains(months[num]) {
//                    self.monthChecker[num] = 1
//                }
//            }
//
//        }
//    }
//    func fetchMedsPercentage() {
//        var totalD: Double = 0
//        var totalN: Double = 0
//        print("combinedMeds \(combinedMeds)")
//        for i in 0..<combinedMeds.count {
//
//            if medsMonthly[i] != [] {
//                let n = medsMonthly[i].reduce(0, +)
//                if medsDateMonthly[i].count > 0 {
//                let d = Double(medsDateMonthly[i].count * 4)
//
//
//                let percent = Double((n/d)) * 100
//                let floater = CGFloat(percent)
//
//                self.medsPercentageMonthly.append(floater)
//                self.medsCompliance.append(percent)
//                self.totalMedsTakenArray.append(n)
//
//                totalD += d
//                totalN += n
//                }
//            } else {
//                self.medsPercentageMonthly.append(0.0)
//                self.medsCompliance.append(0.0)
//                self.totalMedsTakenArray.append(0.0)
//            }
//        }
//        self.totalMedsToBeTaken = Double(totalD)
//
//        self.totalMedsTaken = totalN
//
//    }
//
//    func fetchMedsPercentageIntoFloaters() {
//        for i in 0..<totalMedsTakenArray.count {
//            self.totalMedsTakenArray[i] =  Double(self.totalMedsTakenArray[i] / self.totalMedsToBeTaken) * 100
//        }
//
//    }
//
//    func fetchMonthlyData() {
//
//
//        for i in 0..<monthArray.count {
//
//            for num in self.months.indices {
//                if self.monthArray[i]!.contains(months[num]) {
//
//
//
//
//                    //meds
//                    self.medsMonthly[num].append(combinedMeds[i])
//                    self.medsDateMonthly[num].append(dateArray[i]!)
//
//                }
//
//
//            }
//        }
//        print("medsMonthly \(medsMonthly)")
//        print("medsDateMonthly \(medsDateMonthly)")
//    }
   
//    func fetchMedsCompliance() {
//        if dayItems.count > 0 {
//        for i in 0..<dayItems.count {
//            let temp = dayItems[i].rxComp
//            let percent = (temp / self.data.rxQty) * 100
//           self.medsCompliance.append(percent)
//
//
//        }
//            print("medsComplianceListView: \(medsCompliance)")
//        }
//    }
//    func fetchSymptomData() {
//        let fetchRequest = NSFetchRequest<MasterData>(entityName: "MasterData")
//        do{
//            let result = try moc.fetch(fetchRequest)
//            let dateArray = result.map{$0.date?.string(format: "EEEE, MMM d")}
//
//            let rxArray = result.map{$0.rxComp}
//            self.dateArray = dateArray
//            self.combinedMeds = rxArray
//    print("rxArray \(rxArray)")
//
//        } catch {
//            print("Could not fetch. \(error)")
//        }
//
//
//    }
//    func saveMoc() {
//        do {
//            try moc.save()
//        } catch {
//            let error = error as NSError
//            fatalError("Unresolved Error: \(error)")
//        }
//    }
    
   


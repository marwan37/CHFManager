//
//  FluidCharts.swift
//  Golgi-Splash
//
//  Created by Marwan Zaarab on 2021-01-10.
//

import SwiftUI
import CoreData

struct FluidCharts: View {
    @Environment(\.colorScheme) var cs : ColorScheme
    @Environment(\.managedObjectContext) var moc
    @State var months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"]
    @State var fullMonths = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var dateFormat = "EEEE, MMM d"
    @State var waterMonthly : [[Double]] = [ [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double]() ]
    @State var dateArray = [String?]()
    @State var waterDateMonthly : [[String]] = [ [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String]() ]
    @State var liquidsArray = [Double]()
    @State var monthArray = [String?]()
    @State var liquids: [Double] = [0,0,0,0,0,0,0,0,0,0,0,0]
    @State var liquidsml: [Double] = [0,0,0,0,0,0,0,0,0,0,0,0]
    @State var liquidsL: [Double] = [0,0,0,0,0,0,0,0,0,0,0,0]
    @State var monthChecker = [Int]()
    @State var selected = 1
    @State var units = ["oz", "ml", "L"]
    @State var unit = 0
    var colors = [Color("fb"),Color("Color1")]
    let columns = [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()) ]
    @Binding var show: Int
    var body: some View {
        ZStack{
            LinearGradient.overall(for: cs).edgesIgnoringSafeArea(.all)
        VStack{
            HStack{
                Button("Table View"){
                    self.show = 1
                }
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                .opacity(self.show == 1 ? 1 : 0.6)
                  Spacer()
                
                Button("Bar Chart"){
                    self.show = 0
                }.font(.system(size: 16, weight: .regular, design: .rounded))
                .opacity(self.show == 0 ? 1 : 0.6)
               
            }.padding(.horizontal)
            HStack{
            Spacer()
            Picker("", selection: $unit) {
                ForEach(0..<units.count){
                    Text(units[$0])
                }
           
            }.pickerStyle(SegmentedPickerStyle())
                Spacer()
        }
            
            ScrollView(.vertical) {
                ZStack{
//                    if cs == .dark {
//                        LinearGradient(gradient: Gradient(colors: [Color.navy, Color.neonBlue]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
//                    }
                
               
                pratiquee(waterDateMonthly: $waterDateMonthly, monthChecker: $monthChecker, waterMonthly: $waterMonthly, unit:$unit)
                    .offset(x: self.show != 0 ? 1000 : 0)
                
                VStack{
                   
                    ForEach(monthChecker.indices, id: \.self) { monthIndex in
                      
                            if monthChecker[monthIndex] > 0 {
                                let datesForMonth = waterDateMonthly[monthIndex]
                            
                           
                            ScrollView(.horizontal, showsIndicators: false){
                              
                                    HStack{
                                        ForEach(waterMonthly[monthIndex].indices, id: \.self) { indexOfValue in
              
                                                
                                            HStack{
                                                VStack{
                                                    ZStack{
                                                    Text("Jan 30").hidden()
                                                    Text(datesForMonth[indexOfValue].subStringAfterLastComma )
                                                    }
                                                    let value = Int(waterMonthly[monthIndex][indexOfValue])
                                                    Text(newUnit(val: value))
                                                    
                                                        
                                                    } .font(.system(size: 12, weight: .light, design: .rounded))
                                                    

                                                }
           
                                        }
                                    }
     
                                
                            }.frame(width:UIScreen.main.bounds.width-20)
                            
                            Divider()
                            
                        }
                        
                }
                    Spacer()
                }
                .padding(.vertical)
                .isHidden(self.show != 1)
            }
                
            }.onAppear{
            self.onAppearDo()
            }

        }.padding(.top, 20)
//        .background(cs == .dark ? LinearGradient(gradient: Gradient(colors: [Color.navy, Color.neonBlue]), startPoint: .top, endPoint: .bottom) : LinearGradient(gradient: Gradient(colors: [Color("ColorNeuro"), Color.lairWhite]), startPoint: .top, endPoint: .bottom)  ).edgesIgnoringSafeArea(.all)
        }
    }
 
    
    var LiquidBars: some View {
        VStack{
           
            LazyHGrid(rows: Array(repeating: GridItem(.flexible(),spacing: 25), count: checkCount() + 1)){
                
                
                ForEach(monthChecker.indices, id: \.self) { monthIndex in
                   
                    if monthChecker[monthIndex] > 0 {
                        let datesForMonth = waterDateMonthly[monthIndex]
                        
                        HStack(alignment: .lastTextBaseline, spacing: 5){
                            ForEach(waterMonthly[monthIndex].indices, id: \.self) { indexOfValue in
                                VStack{
                                    VStack{
                                        
                                        Spacer(minLength: 0)
                                        Text("64")
                                            .font(.system(size: 12, weight: .light, design: .rounded))
                                            .padding(.bottom,5)
                                            .hidden()
                                        if selected == monthIndex{
                                            let value = Int(waterMonthly[monthIndex][indexOfValue])
                                            Text(newUnit(val: value))
                                                .font(.system(size: 12, weight: .light, design: .rounded))
                                                .padding(.bottom,5)
                                        }
                                        RoundedShape()
                                            .fill(LinearGradient(gradient: .init(colors: selected == monthIndex ? self.colors : self.cs == .dark ? [Color.white.opacity(0.06)] : [Color.black.opacity(0.06)]), startPoint: .top, endPoint: .bottom))
                                            // max height = 200
                                            
                                          
                                            .frame(minWidth: 10, maxWidth: 50, idealHeight: CGFloat(waterMonthly[monthIndex][indexOfValue]), maxHeight: CGFloat(waterMonthly[monthIndex][indexOfValue]))
                                    }
                                    
                                    .onTapGesture {
                                        
                                        withAnimation(.easeOut){
                                            
                                            selected = monthIndex
                                        }
                                    }
                                    
                                    Text(datesForMonth[indexOfValue].subStringAfterLastComma )
                                        .font(.system(size: 10, weight: .light, design: .rounded))
                                        .fixedSize(horizontal: true, vertical: false)
                                        .foregroundColor(self.cs == .dark ? .sand : .black)
                                    Divider()
                                }.padding(.vertical)
                                .frame(minHeight: 500, maxHeight: .infinity, alignment: .center)
                               
                            }
                        }
                    }
                
                }
            }
            
        }.offset(y: -100)
    }
    func newUnit(val: Int) -> String {
        var returned = ""
        if self.unit == 0{
            returned = "\(val)"
        } else if self.unit == 1 {
            let doubleDrank = Double(val)
            let doubledDrink = doubleDrank * 30
            returned = String(format: "%.0f", doubledDrink)
        } else if self.unit == 2 {
            let doubleDrank = Double(val)
            let doubledDrink = doubleDrank * 0.0295735
            returned = String(format: "%.2f", doubledDrink)
        }
        return returned
    }
    func checkCount() -> Int{
        var count = 0
        for i in monthChecker.indices {
            if monthChecker[i] > 0 {
                count += 1
            }
        }
        return count
    }
    func onAppearDo() {
        self.monthArray = []
        self.monthChecker = [0,0,0,0,0,0,0,0,0,0,0,0]
        //water weight
        self.waterMonthly = [[], [], [], [], [], [], [], [], [], [] ,[] ,[]]
        self.waterDateMonthly = [[], [], [], [], [], [], [], [], [], [] ,[] ,[]]
        self.liquids = [0,0,0,0,0,0,0,0,0,0,0,0]
        self.liquidsml = []
        self.liquidsL = []
        self.fetchLiquidData()
        self.fetchMonths()
        self.fetchLiquidCompliance()
        self.fetchMonthlyData()
        self.checkIfMonthIsPresent()
       
    }
    func fetchLiquidData() {
        let fetchRequest = NSFetchRequest<CD_Liquids>(entityName: "CD_Liquids")
        do{
            let result = try moc.fetch(fetchRequest)
            let dateArray = result.map{$0.date.string(format: "MMM d")}
            let liquidArray = result.map{$0.intake}
            self.dateArray = dateArray
            self.liquidsArray = liquidArray
            
            for i in 0..<liquidArray.count {
                liquidsml.append(liquidArray[i] * 29.5735)
                liquidsL.append(liquidArray[i] * 0.0295735)
            }
            
        } catch {
            print("Could not fetch. \(error)")
        }
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
    }
    //MARK: FUNCTIONS
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
                    self.waterMonthly[num].append(liquidsArray[i])
                    self.waterDateMonthly[num].append(dateArray[i]!)
                }
            }
        }
    }
    func fetchLiquidCompliance() {
        if self.liquidsArray.isEmpty == false {
            for i in 0..<self.liquidsArray.count{
                for num in months.indices {
                    if self.monthArray[i]!.contains(months[num]) {
                        self.liquids[num] += self.liquidsArray[i]
                    }
                    
                }
                
            }
            
        }
    }
}

struct FluidCharts_Previews: PreviewProvider {
    static var previews: some View {
        FluidCharts(show: .constant(1))
    }
}

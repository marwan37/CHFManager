//
//  WeightCharts.swift
//  Golgi-Splash
//
//  Created by Marwan Zaarab on 2021-01-18.
//

import SwiftUI
import CoreData
struct WeightCharts: View {
    @Environment(\.calendar) var calendar
    @Environment(\.colorScheme) var cs: ColorScheme
    @Environment(\.managedObjectContext) var moc
    var gridItemLayout = [GridItem(.flexible()),GridItem(.flexible())]
    @FetchRequest(fetchRequest : Weight.getWeightData()) var dayItems:FetchedResults<Weight>
    @State var months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"]
    @State var weightArray : [[Double]] = [[Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double]() ]
    @State var dateArray = [String?]()
    @State var weights = [Double]()
    @State var weightMonthKg: [Double] = []
    @State var indexes = [Int]()
    @State var dateMonthArray = [String?]()
    @State var month = Date()
    @State var weight: Double = 0.0
    @State var liquidWeightData = [Double]()
    @State var toggle = false
    @State var subtitle = "Weight in pounds (lbs)"
    @State var selected = 0
    var body: some View {
        
        VStack{
           
            Picker("", selection: $selected) {
                Text("pounds (lbs)").tag(0)
                Text("kilograms (kg)").tag(1)
            }.pickerStyle(SegmentedPickerStyle())
            
            ScrollView(.horizontal, showsIndicators: false){
                
                HStack{
                    ForEach(weights.indices, id: \.self) { i in
                        
                        
                        HStack{
                            VStack{
                                ZStack{
                                    Text("Jan 30").hidden()
                                    Text("\(dateMonthArray[i]!) \(indexes[i])" )
                                }
                                let value = Int(weights[i])
                                let valueKg = Int(weights[i]/2.2)
                                Text("\(selected == 0 ? value : valueKg)")
                                
                                
                            } .font(.system(size: 12, weight: .light, design: .monospaced))
                            .foregroundColor(Color.textColor(for: cs))
                            
                        }
                        
                    }
                }
                
                
            }.frame(width:UIScreen.main.bounds.width-20)
            
            Divider()
            
            
            
            
            Spacer()
        }.onAppear {
            
            //water weight
            
            self.weightMonthKg = []
            self.fetchWeightData()
            self.convertWeight()
            
            self.liquidWeightData = weights
        }
        .padding(.vertical)
        
    }
    func convertWeight()  {
        for i in 0..<weights.count {
            let temp = weights[i]/2.2
            self.weightMonthKg.append(temp)
        }
    }
    
    
    
    
    
    func fetchWeightData() {
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


struct WeightGraphView : View {
    @Environment(\.calendar) var calendar
    @Environment(\.colorScheme) var cs: ColorScheme
    @Environment(\.managedObjectContext) var moc
    var gridItemLayout = [GridItem(.flexible()),GridItem(.flexible())]
    @FetchRequest(fetchRequest : Weight.getWeightData()) var dayItems:FetchedResults<Weight>
    @State var months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"]
    @State var weightArray : [[Double]] = [[Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double]() ]
    @State var dateArray = [String?]()
    @State var weights = [Double]()
    @State var weightMonthKg: [Double] = []
    @State var indexes = [Int]()
    @State var dateMonthArray = [String?]()
    @State var month = Date()
    @State var weight: Double = 0.0
    @State var liquidWeightData = [Double]()
    @State var toggle = false
    @State var subtitle = "Weight in pounds (lbs)"
    var body: some View {
        
            GeometryReader { geo in
                VStack{
                iLineChart(
                    data: liquidWeightData.count > 0 ? liquidWeightData : [0,0,0,0],
                    title: "weight",
                    subtitle: subtitle.lowercased(),
                    style: .secondary,
                    lineGradient: self.cs == .dark ?
                        .init(start: Color("ColorNeuro"), end: .lairWhite) :
                        .init(start: Color("ColorNeuro"), end: Color.trackColor),
                    chartBackgroundGradient: self.cs == .dark ?
                        .init(start: Color("ColorNeuro").opacity(0.2), end: Color.lairWhite.opacity(0.2)) :
                        .init(start: Color("ColorNeuro").opacity(0.2), end: Color.trackColor.opacity(0.2)),
                    canvasBackgroundColor: .clear,
                    titleColor: Color.textColor(for: self.cs).opacity(0.7),
                    numberColor: Color.textColor(for: self.cs).opacity(0.7),
                    curvedLines: true,
                    cursorColor: .neonBlue,
                    displayChartStats: true,
                    maxHeight: geo.size.height / 1.5,
                    titleFont: Font.system(size: ultra > 400 ? 25 : 20, weight: .bold, design: .rounded),
                    subtitleFont: Font.system(size: ultra > 400 ? 22 : 18, weight: .thin, design: .rounded),
                    floatingPointNumberFormat: "%.1f")
                    
//                    .frame(width: geo.size.width, height: geo.size.height / 2)
                
                
                    VStack(spacing:0){
                HStack{
                    Spacer()
                    ForEach(months, id: \.self) { month in
                        
                        Text(ultra > 400 ? month : month.lowercased())
                            .font(.system(size: ultra > 400 ? 14 : 11, weight: .light, design: .rounded))
                            .foregroundColor(.grayMe)
                            .fixedSize(horizontal: true, vertical: false)
                        
                        Spacer()
                        
                    }
                    
                }
                
                HStack{
                    Spacer()
                    Button(action:{
                        self.liquidWeightData = weightMonthKg
                        self.subtitle = "Weight in kilograms (kg)"
                    }){
                        LinearGradient.diagonalLairColor(for: cs).mask(
                            Text("Kilograms (kg)")
                                .opacity(self.liquidWeightData == weightMonthKg ? 1 : 0.5)
                        )
                    }
                    Spacer()
                    Button(action:{
                        self.liquidWeightData = weights
                        self.subtitle = "Weight in pounds (lbs)"
                    }){
                        LinearGradient.diagonalLairColor(for: cs).mask(
                            Text("Pounds (lbs)")
                                .opacity(self.liquidWeightData == weights ? 1 : 0.5)
                        )
                    }
                    Spacer()
                }.font(.system(size: ultra > 400 ? 14 : 12, weight: .light, design: .monospaced))
                .shadow(color: Color.textColor(for: self.cs).opacity(0.5), radius: 3, x: 2, y: 2)
                .frame(height: 62)
                    }.frame(height: geo.size.height - geo.size.height / 1.5)
                    .offset(y: -hulk/9)
            }
        }
            .onAppear {

            //water weight
            self.weightArray = []
            self.weightMonthKg = []
            self.fetchWeightData()
            self.convertWeight()


            self.liquidWeightData = weights
        }
    }
    func convertWeight()  {
        for i in 0..<weights.count {
            let temp = weights[i]/2.2
            self.weightMonthKg.append(temp)
        }
    }
    
    
    
    
    
    func fetchWeightData() {
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
}
struct WeightCharts_Previews: PreviewProvider {
    static var previews: some View {
        WeightGraphView()
    }
}

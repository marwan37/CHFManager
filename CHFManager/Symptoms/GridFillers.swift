//
//  GridFillers.swift

let columns4flex = [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()) ]
let hulk = UIScreen.main.bounds.height
import SwiftUI

struct LineChartFiller: View {
    @Environment(\.colorScheme) var cs : ColorScheme
    @State var title: String
    @State var data: [Double]
    @State var sM: [Double]
    @State var sMly: [[Double]]
    @State var occurences : Double
    @Binding var pie : [Pie]
    @Binding var dateArray: [String?]
    @Binding var month: Date
    @Binding var symptomDate: [[String]]
    @Binding var selected: Int
    @Binding var moIndex : Int
    @State var showJelly = false
    
    @State var months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"]
    @State var fullMonths = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var dateFormat = "EEEE, MMM d"
    @State var offset : CGFloat = UIScreen.main.bounds.width
    var width = UIScreen.main.bounds.width
    let spacing: CGFloat = 10
    var infoView: AnyView {
        var infov = AnyView(Sweller())
        if title == "Swelling" {
            infov = AnyView(Sweller())
        } else if title == "Dyspnea" {
            infov = AnyView(Breather())
        } else if title == "Fatigue" {
            infov = AnyView(Fatiguer())
        }
        return infov
    }
    
    @State var curved = true
    @State var colors : [Color] = [Color("ColorPieKavsoft") , .red, .blue, .sand, .yellow, .green, .purple, .orange, .bubbleGum, .metallicGold, .navy, .neonRed]
    var body: some View {
        //        ZStack{
        //            Color.backgroundColor(for: cs).edgesIgnoringSafeArea(.all)
        
        VStack{
        VStack(alignment:.leading){
            
          
            GeometryReader{ gp in
        
                
                //CHARTS
                TabView(selection: $selected) {
                    
                    ForEach(sMly.indices) { idx in
                        
                        if symptomDate[idx].count > 0 {
                            ZStack{
                                Rectangle().frame(width: gp.size.width, height: 370).hidden()
                                
                                let total = Int(sMly[idx].reduce(0, +))
                               
                                iLineChart(data: sMly[idx],
                                           title: fullMonths[idx].lowercased(),
                                           subtitle: "occurences: \(sMly[idx].count > 0 ? total : 0)",
                                           style: .primary,
                                           lineGradient: GradientColor.init(start: colors[selected], end: .lairWhite),
                                           chartBackgroundGradient: GradientColor.init(start: colors[selected], end: Color.lairWhite.opacity(0.2)),
                                           canvasBackgroundColor: Color.clear,
                                           titleColor: cs == .dark ? colors[selected] : colors[selected],
                                           numberColor: colors[selected],
                                           curvedLines: true,
                                           cursorColor: colors[selected],
                                           displayChartStats: true,
                                           maxWidth: self.width,
                                           maxHeight: hulk > 700 ? (hulk > 800 ? 400 : 340) : 250,
                                           titleFont: Font.system(size: ultra / 15, weight: .bold, design: .rounded),
                                           subtitleFont: Font.system(size: ultra / 20, weight: .thin, design: .rounded)
                                )
                                .frame(width: gp.size.width, height: gp.size.height)
                               
                                
                                
                                HStack{
                                    
                                    let nonth = Calendar.current.date(byAdding: .month, value: idx, to: month)
                                    let days = self.getNumDays(month: nonth ?? Date())
                                    let arr = [5,10,15,20,25]
                                    Text("1")
                                    Spacer()
                                    ForEach(arr, id:\.self) { day in
                                        Text("\(day)")
                                        
                                        
                                        Spacer()
                                    }
                                    Text("\(days)")
                                    
                                    
                                }.font(.caption2).foregroundColor(.grayMe)
                                .offset(y: hulk > 700 ? hulk / 10 - 10 : hulk / 12)
                            }.tag(idx)
                        }
                        else {
                            
                            Rectangle().frame(width: gp.size.width, height: gp.size.height/4).hidden()
                                .overlay(
                                    VStack{
                                        Text("\(fullMonths[idx])")
                                            .font(.system(size: 27, weight: .light, design: .rounded))
                                            .padding(.horizontal, 25)
                                        Text("No Data Available")
                                            .font(.system(size: 18, weight: .light, design: .rounded))
                                            .padding(.horizontal, 25)
                                        
                                    }
                                )
                                .offset(y: hulk > 700 ? -hulk / 8 : -hulk / 5)
                                .tag(idx)
                            
                        }
                        
                        
                        
                    }
                    
                }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

            //PIECHART
                PieChartKavsoft(piedata: pie, selected: $selected)
                    .offset(y: hulk > 700 ? (hulk / 12) + 2  : (hulk / 6) + 15)
                   
           
                
            }
            
        }
      
               Text("Swipe left/right, or tap on pie chart areas to navigate months.")
                   .font(.system(size: ultra > 400 ? 14 : 12, weight:.light, design:.rounded))
                   .foregroundColor(Color.textColor(for: cs).opacity(0.4))
                   .padding(.horizontal, 20)
                   .offset(y: 19)
        }
   
    }
    
    var swellGraph : some View {
        VStack{
            //MARK: Swelling Line Graph
            SwellingGraph(
                title: self.title,
                data: data,
                curved: true)  .offset(y: 40)
            
            Spacer(minLength: hulk/2 + 40)
            GeometryReader { geo in
                HStack{
                    Spacer()
                    ForEach(months, id: \.self) { month in
                        Text(month).font(.caption).foregroundColor(.grayMe)
                        Spacer()
                    }
                }
            }
            Spacer(minLength: 330)
        }
    }
    func getNumDays(month: Date) -> Int{
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: month)!
        let numDays = range.count
        print("numberOfDays: \(numDays)")
        return numDays
    }
    
}



struct GridFillers: View {
    @Environment(\.colorScheme) var cs
    @Binding var title: String
    @Binding var months: [String]
    @Binding var sMly: [[Double]]
    @Binding var dateArray: [String?]
    @Binding var month: Date
    @Binding var sM : [Double]
    var body: some View {
        VStack{
            Text(self.title)
                .font(.system(size: 25, weight: .regular, design: .monospaced))
                .foregroundColor(Color.textColor(for: cs))
                .padding()
            ScrollView{
                ForEach(months.indices) { i in
                    
                    Text("\(months[i]) \(self.month.string(format: "Y"))")
                    ZStack{
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(),spacing: 5), count: 7))  {
                            let nonth = Calendar.current.date(byAdding: .month, value: i, to: month)
                            let days = self.getNumDays(month: nonth ?? Date())
                            
                            ForEach(1..<days, id: \.self) { day in
                                
                                ZStack{
                                    Text("30")
                                        .hidden()
                                        .padding(3)
                                        .padding(.horizontal, 10)
                                        .background(checkDay(month: nonth!, day: day))
                                        .clipShape(Rectangle())
                                        .cornerRadius(4)
                                        .padding(4)
                                        .overlay(
                                            VStack(spacing: 3){
                                                Text("\(day)")
                                                    .foregroundColor(cs == .light ? .lairDarkGray : .mediumgray)
                                                    .font(.system(size: 15, weight: .light, design: .monospaced))
                                                
                                            }
                                        )
                                }
                                
                            }
                            
                        } .isHidden(sMly[i].count < 1)
                        Text("No data for \(months[i])")
                            .font(.system(size: 14, weight: .light, design: .monospaced))
                            .isHidden(sMly[i].count > 0)
                        
                    }
                }
            }
        }
    }
    
    
    
    func checkDay(month: Date, day: Int) -> Color {
        var r = Color.pulsatingColor
        let checkedMonth = month.string(format: "MMM") // "Jan"
        let checkedDay = day // 3
        let comb = "\(checkedMonth) \(checkedDay)"
        print("mymonth comb = \(comb)")
        for i in 0..<dateArray.count {
            let myMonth = dateArray[i]?.subStringAfterLastComma
            print("MyMonth = \(String(describing: myMonth))")
            //                .components(separatedBy: .decimalDigits).joined() // "Jan"
            //            let myDay = Int(myMonth!.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
            if myMonth == comb && sM[i] == 1 {
                r = Color.red
                
            } else if myMonth == comb && sM[i] == 0 {
                r = Color.blue
            } else {
                r = Color.pulsatingColor.opacity(0.2)
            }
            
            
        }
        return r
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
    func titleColor(title: String) -> Color {
        switch title {
        case "Swelling" : return (self.cs == .dark ? Color.sand : Color.darkOrange)
        case "Fatigue" : return Color.blue
        case "Dyspnea" : return Color.red
        case "Combined" : return (self.cs == .dark ? Color.white : Color.black.opacity(0.8))
        default : return Color.sand
        }
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
}


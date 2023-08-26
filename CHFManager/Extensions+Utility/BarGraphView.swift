//
//  BarGraphView.swift
//  Golgi-Splash
//
//  Created by Marwan Zaarab on 2020-12-18.
//

import SwiftUI
struct RoundedShape : Shape {
    
    func path(in rect: CGRect) -> Path {
        
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize(width: 5, height: 5))
        
        return Path(path.cgPath)
    }
}
struct CombinedRxSxBarChart: View {
    var colors = [Color("Color1"),Color("Color")]
    var colors2 = [Color("energy"),Color("dyspnea")]
    @Environment(\.colorScheme) var colorScheme : ColorScheme
    @Binding var monthChecker:[Int]
    @Binding var medsPercentageMonthly: [CGFloat]
    @Binding var combinedPercentageMonthly: [CGFloat]
    @State var selected = 0
    @State var fullMonths = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var body: some View {
        ZStack{
            Color.backgroundColor(for: self.colorScheme).edgesIgnoringSafeArea(.all)
            VStack{
                HStack{
                    (Text("medication ").bold() + Text("compliance / ") + Text("symptom ").bold() + Text("occurences"))
                    .padding(.trailing, 20)
                    .opacity(0.7)
                    .font(.system(size: 18, weight: .thin, design: .rounded))
                    
                    .padding()
                    
                    Spacer()
                    
                }.foregroundColor(self.colorScheme == .dark ? .sand : Color.black.opacity(0.8))
                .padding(.bottom, 20)
                    
                
                LazyHGrid(rows: Array(repeating: GridItem(.flexible(),spacing: 55), count: self.checkCount() + 1 )){
                    
                    ForEach(medsPercentageMonthly.indices, id: \.self) { indexOfValue in
                        
                        if monthChecker[indexOfValue] > 0 && combinedPercentageMonthly.isEmpty == false && medsPercentageMonthly.isEmpty == false {
                            
                            VStack(alignment: .leading){
                                HStack{
                                    VStack{
                                        HStack{
                                            Rectangle()
                                                .fill(LinearGradient(gradient: .init(colors: selected == indexOfValue ? self.barColor(val: Double(medsPercentageMonthly[indexOfValue])) : self.colorScheme == .dark ? [Color.white.opacity(0.06)] : [Color.black.opacity(0.06)]), startPoint: .top, endPoint: .bottom))
                                                .opacity(0.8)
                                                .frame(width: medsPercentageMonthly[indexOfValue] * 2, height: 20)
                                            Text("\(Int(medsPercentageMonthly[indexOfValue]))%")
                                                .font(.system(size: 10, weight: .light, design: .rounded))
                                                .foregroundColor(self.colorScheme == .dark ? Color("Color1") : Color.lairDarkGray)
                                                .padding(.bottom,5)
                                                .isHidden(selected != indexOfValue)
                                            Spacer(minLength: 100)
                                            
                                        }
                                        
                                        HStack{
                                            Rectangle()
                                                .fill(LinearGradient(gradient: .init(colors: selected == indexOfValue ? self.colors2 : self.colorScheme == .dark ? [Color.white.opacity(0.06)] : [Color.black.opacity(0.06)]), startPoint: .top, endPoint: .bottom)).opacity(0.8)
                                                
                                                .frame(width: combinedPercentageMonthly[indexOfValue] < 0 ? 0 : combinedPercentageMonthly[indexOfValue]  * 2, height:  combinedPercentageMonthly[indexOfValue] < 0 ? 0 : 20)
                                            Text ("\(combinedPercentageMonthly[indexOfValue].isNaN ? 0 : combinedPercentageMonthly[indexOfValue], specifier: "%.1f")")
                                                .font(.system(size: 10, weight: .light, design: .rounded))
                                                .foregroundColor(self.colorScheme == .dark ? Color("energy") : Color.lairDarkGray)
                                                .padding(.bottom,5)
                                                .isHidden(selected != indexOfValue)
                                            
                                            Spacer(minLength: 100)
                                        }
                                    }
                                    
                                    
                                    Text(fullMonths[indexOfValue])
                                        .font(.system(size: 12, weight: .light, design: .rounded))
                                       
                                        .foregroundColor(self.colorScheme == .dark ? .sand : .black)
                                    
                                }.onTapGesture {
                                    
                                    withAnimation(.easeOut){
                                        
                                        selected = indexOfValue
                                    }
                                    
                                }
                            }
                            
                        }
                    }
                }
                
                VStack{
                    HStack{
                        (Text("medication ").bold() + Text("compliance"))
                        .padding(.trailing, 20)
                        .opacity(0.7)
                        .font(.system(size: 18, weight: .thin, design: .rounded))
                        
                        .padding()
                        
                        Spacer()
                        
                    }.foregroundColor(self.colorScheme == .dark ? .sand : Color.black.opacity(0.8))
                    .padding(.bottom, 20)
                    LazyHGrid(rows: Array(repeating: GridItem(.flexible(),spacing: 25), count:checkCount() + 1 )){
                        ForEach(medsPercentageMonthly.indices, id: \.self) { indexOfValue in
                            if monthChecker[indexOfValue] > 0 {
                                VStack(alignment: .leading){
                                    HStack{
                                        
                                        Rectangle()
                                            .fill(LinearGradient(gradient: .init(colors: selected == indexOfValue ? self.barColor(val: Double(medsPercentageMonthly[indexOfValue])) : self.colorScheme == .dark ? [Color.white.opacity(0.06)] : [Color.black.opacity(0.06)]), startPoint: .top, endPoint: .bottom))
                                            .opacity(0.6)
                                            .frame(width: medsPercentageMonthly[indexOfValue] * 2, height: 20)
                                        //                                                .offset(x:20)
                                        
                                        
                                        Text("\(Int(medsPercentageMonthly[indexOfValue]))%")
                                            .font(.system(size: 12, weight: .light, design: .rounded))
                                            .foregroundColor(self.textColor(val: Double(medsPercentageMonthly[indexOfValue])))
                                            .padding(.bottom,5)
                                            .isHidden(selected != indexOfValue)
                                        Spacer(minLength: 100)
                                        
                                        Text(fullMonths[indexOfValue])
                                            .font(.system(size: 12, weight: .light, design: .rounded))
                                            .foregroundColor(self.colorScheme == .dark ? .sand : .black)
                                        //                                                .frame(width: 100)
                                        
                                        
                                    }
                                    .onTapGesture {
                                        
                                        withAnimation(.easeOut){
                                            
                                            selected = indexOfValue
                                        }
                                    }
                                    
                                    
                                }
                                
                            }
                        }
                        
                    }
                }
                
            }
            
        }
    }
    func checkCount() -> Int {
        var count = 0
        for i in monthChecker.indices {
            if monthChecker[i] > 0 {
                count += 1
            }
        }
        return count
    }
    func barColor(val: Double) -> [Color] {
        switch val {
        //        case 75 : return self.colors
        case 100 : return [Color("cycle"), Color("fb")]
        //        case 50 : return [Color("energy"), Color("dyspnea")]
        //        case 25 : return [Color("dyspnea"), Color("heart")]
        default : return self.colors
        }
    }
    func textColor(val: Double) -> Color {
        switch val {
        //        case 0 : return (self.colorScheme == .dark ? Color.neonRed : Color.red)
        //        case 25 : return Color.neonRed
        //        case 50 : return Color.neonOrange
        //        case 75 : return (Color("Color1"))
        case 100: return Color.neonGreen
        default : return Color("Color1")
        }
    }
    
    func getColor(value: Double) -> Color {
        var color:Color = Color.green
        if value == 4{
            color = .green
        } else if value == 3 {
            color = .orange
        } else {
            color = .red
        }
        return color
    }
}
struct MedsPercentChart: View {
    var colors = [Color("Color1"),Color("Color")]
    @Environment(\.colorScheme) var colorScheme : ColorScheme
    @Binding var monthChecker:[Int]
    @Binding var medsPercentageMonthly: [CGFloat]
    @State var selected = 0
    
    @State var fullMonths = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var body: some View {
        ZStack{
            Color.backgroundColor(for: self.colorScheme).edgesIgnoringSafeArea(.all)
            VStack{
                Text("Medication Compliance")
                    .font(.system(size: 15, weight: .thin, design:.monospaced))
                    .foregroundColor(self.colorScheme == .dark ? .sand : Color.black.opacity(0.8))
                
                LazyHGrid(rows: Array(repeating: GridItem(.flexible(),spacing: 25), count:checkCount() + 1 )){
                    ForEach(medsPercentageMonthly.indices, id: \.self) { indexOfValue in
                        if monthChecker[indexOfValue] > 0 {
                            VStack(alignment: .leading){
                                HStack{
                                    
                                    Rectangle()
                                        .fill(LinearGradient(gradient: .init(colors: selected == indexOfValue ? self.barColor(val: Double(medsPercentageMonthly[indexOfValue])) : self.colorScheme == .dark ? [Color.white.opacity(0.06)] : [Color.black.opacity(0.06)]), startPoint: .top, endPoint: .bottom))
                                        
                                        .frame(width: medsPercentageMonthly[indexOfValue] * 2, height: 20)
                                    //                                                .offset(x:20)
                                    
                                    
                                    Text("\(Int(medsPercentageMonthly[indexOfValue]))%")
                                        .font(.system(size: 12, weight: .light, design: .monospaced))
                                        .foregroundColor(self.textColor(val: Double(medsPercentageMonthly[indexOfValue])))
                                        .padding(.bottom,5)
                                        .isHidden(selected != indexOfValue)
                                    Spacer(minLength: 100)
                                    
                                    Text(fullMonths[indexOfValue])
                                        .font(.system(size: 12, weight: .light, design: .monospaced))
                                        .foregroundColor(self.colorScheme == .dark ? .sand : .black)
                                    //                                                .frame(width: 100)
                                    
                                    
                                }
                                .onTapGesture {
                                    
                                    withAnimation(.easeOut){
                                        
                                        selected = indexOfValue
                                    }
                                }
                                
                                
                            }
                            
                        }
                    }
                    
                }
            }
            
        }
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
    func barColor(val: Double) -> [Color] {
        switch val {
        //        case 75 : return self.colors
        case 100 : return [Color("cycle"), Color("fb")]
        //        case 50 : return [Color("energy"), Color("dyspnea")]
        //        case 25 : return [Color("dyspnea"), Color("heart")]
        default : return self.colors
        }
    }
    func textColor(val: Double) -> Color {
        switch val {
        //        case 0 : return (self.colorScheme == .dark ? Color.neonRed : Color.red)
        //        case 25 : return Color.neonRed
        //        case 50 : return Color.neonOrange
        //        case 75 : return (Color("Color1"))
        case 100: return Color.neonGreen
        default : return Color("Color1")
        }
    }
    
    func getColor(value: Double) -> Color {
        var color:Color = Color.green
        if value == 4{
            color = .green
        } else if value == 3 {
            color = .orange
        } else {
            color = .red
        }
        return color
    }
}

struct MedsBarChart: View {
    var colors = [Color("fb"),Color("Color")]
    @Environment(\.colorScheme) var colorScheme : ColorScheme
    @Binding var monthChecker:[Int]
    @Binding var medsDateMonthly: [[String]]
    @Binding var combinedMeds: [Double]
    @Binding var medsMonthly: [[Double]]
    @State var selected = 0
    @State var fullMonths = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var body: some View {
        
        ScrollView(.vertical){
               
            VStack(spacing:0){
                    
                    ForEach(monthChecker.indices, id: \.self) { m in
                        //
                        ScrollView(.horizontal, showsIndicators:false){
                        if monthChecker[m] > 0 {
                            
                            let datesForMonth = medsDateMonthly[m]
                            
                            HStack(alignment: .lastTextBaseline, spacing: 5){
                                ForEach(medsMonthly[m].indices, id: \.self) { i in
                                    //                                    if medsDateMonthly[monthIndex].count > 0 {
                                    VStack{ 
                                        VStack{
                                            Spacer(minLength: 0)
                                            let valie = Double(medsMonthly[m][i] / 4) * 100
                                            if selected == m {
                                                
                                                Text("\(String(format: "%.0f", (Double(medsMonthly[m][i] / 4) * 100)))%")
                                                    .font(.system(size: 11, weight: .light, design: .monospaced))
                                                    .fixedSize(horizontal: true, vertical: false)
                                                    .foregroundColor(self.textColor(val: valie))
                                                    .padding(.bottom,5)
                                            }
                                           
                                            RoundedShape()
                                        .fill(selected == m ? barColor(val: valie) : Color("ColorNeuro").opacity(0.98))
                                                // max height = 200
                                                
                                                .frame(height: CGFloat(valie) / 2)
                                        }.onTapGesture {
                                            
                                            withAnimation(.easeOut){
                                                
                                                selected = m
                                            }
                                        }
                                        
                                        Text(datesForMonth[i].subStringAfterLastComma)
                                            .font(.system(size: 10, weight: .light, design: .monospaced))
                                            .fixedSize(horizontal: true, vertical: false)
                                            .foregroundColor(self.colorScheme == .dark ? .sand : .black)
                                        Divider()
                                    }.padding(.vertical, 25)
                                    .frame(minHeight: 70, maxHeight: 100, alignment: .center)
//                                    .offset(y: -50)
                                    //                                    }
                                }
                            }

                        }
                    }
                    
                }
            }
            
        }.padding(.horizontal, 50)
        .padding(.top, 60)
    }
    func barColor(val: Double) -> Color {
        switch val {
        case 100 : return Color("cycle")
        //        case 1 : return [Color("energy"), Color("heart")]
        //        case 2 : return [Color("energy"), Color("dyspnea")]
        //        case 3 : return [Color("dyspnea"), Color("heart")]
        default : return Color("Color1")
        }
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
    
    func textColor(val: Double) -> Color {
        switch val {
        //        case 0 : return (self.colorScheme == .dark ? Color.neonRed : Color.red)
        //        case 25 : return Color.neonRed
        //        case 50 : return Color.neonOrange
        //        case 75 : return (Color("Color1"))
        case 100: return (self.colorScheme == .dark ? Color.neonGreen : Color.darkGreen)
        default : return Color("Color1")
        }
    }
    func getEmoji(value: Double) -> String {
        var image: String = "line.diagonal"
        for i in 0..<combinedMeds.count {
            if medsMonthly[i].count != 0 {
                if value > 70 {
                    image = "happy"
                } else {
                    image = "sad-face"
                }
            }
        }
        return image
    }
    
    func getColor(value: Double) -> Color {
        var color:Color = Color.green
        if value == 4{
            color = .green
        } else if value == 3 {
            color = .orange
        } else {
            color = .red
        }
        return color
    }
}

struct LiquidsBarChart: View {
    @Environment(\.colorScheme) var colorScheme : ColorScheme
    var colors = [Color("fb"),Color("Color1")]
    @Binding var monthChecker:[Int]
    @Binding var waterDateMonthly: [[String]]
    @Binding var waterMonthly: [[Double]]
    @State var selected = 0
    @State var fullMonths = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var body: some View {
        ZStack{
            Color.backgroundColor(for: self.colorScheme).edgesIgnoringSafeArea(.all)
            
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
                                            
                                            if selected == monthIndex{
                                                Text(String(format: "%.0f", waterMonthly[monthIndex][indexOfValue]))
                                                    .font(.system(size: 12, weight: .light, design: .rounded))
                                                    .padding(.bottom,5)
                                            }
                                            RoundedShape()
                                                .fill(LinearGradient(gradient: .init(colors: selected == monthIndex ? self.colors : self.colorScheme == .dark ? [Color.white.opacity(0.06)] : [Color.black.opacity(0.06)]), startPoint: .top, endPoint: .bottom))
                                                // max height = 200
                                                
                                                .frame(height: CGFloat(waterMonthly[monthIndex][indexOfValue]))
                                        }
                                        .frame(height: 220)
                                        .onTapGesture {
                                            
                                            withAnimation(.easeOut){
                                                
                                                selected = monthIndex
                                            }
                                        }
                                        
                                        let m = datesForMonth[indexOfValue].subStringAfterLastComma
                                        let mon = m.components(separatedBy: .decimalDigits).joined()
                                        
                                        let nom = m.components(separatedBy:  CharacterSet.decimalDigits.inverted).joined()
                                        let nomero = Int(nom)
                                        
                                        (Text(mon).fontWeight(.thin) + Text("\(nomero!)").bold())
                                            .font(.system(size: 10, weight: .light, design: .rounded))
                                            .fixedSize(horizontal: true, vertical: false)
                                            .foregroundColor(self.colorScheme == .dark ? .sand : .black)
                                        Divider()
                                    }
                                    .offset(y: -50)
                                }
                            }
                        }
                        
                    }
                    
                }
            }.padding(.top, 50)
            
        }
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
}

struct SymptomBarChart: View {
    var colors = [Color("fb"),Color("Color1")]
    @Environment(\.colorScheme) var colorScheme : ColorScheme
    @State var title: String
    @Binding var monthChecker:[Int]
    @Binding var symptomDateMonthly: [[String]]
    @Binding var symptomMonth: [Double]
    @Binding var symptomMonthly: [[Double]]
    @State var selected = 0
    @State var fullMonths = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var body: some View {
        
        GeometryReader { geo in
            LazyHGrid(rows: Array(repeating: GridItem(.flexible(),spacing: 100), count: checkCount() + 1)){
                ForEach(monthChecker.indices, id: \.self) { monthIndex in
                    //
                    if monthChecker[monthIndex] > 0 && symptomMonthly[monthIndex].count > 0 {
                        
                        let datesForMonth = symptomDateMonthly[monthIndex]
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15){
                                ForEach(symptomMonthly[monthIndex].indices, id: \.self) { indexOfValue in
                                    VStack{
                                        VStack{
                                            Spacer(minLength: 0)
                                            
                                            if selected == monthIndex{
                                                
                                                Image(systemName: String(format: "%.0f", (symptomMonthly[monthIndex][indexOfValue])) == "0" ? "minus.circle.fill" : "plus.circle.fill")
                                                    .font(.system(size: 12, weight: .regular, design: .monospaced))
                                                    .foregroundColor(textColor(val: symptomMonthly[monthIndex][indexOfValue]))
                                                    .padding(.bottom,5)
                                            }
                                            
                                            RoundedShape()
                                                .fill(LinearGradient(gradient: .init(colors: selected == monthIndex ? self.barColor(val: symptomMonthly[monthIndex][indexOfValue]) : self.colorScheme == .dark ? [Color.white.opacity(0.06)] : [Color.black.opacity(0.06)]), startPoint: .top, endPoint: .bottom))
                                                // max height = 200
                                                
                                                .frame(height: CGFloat(symptomMonthly[monthIndex][indexOfValue] * 25 + 25))
                                        }
                                        .frame(height: 150)
                                        .onTapGesture {
                                            
                                            withAnimation(.easeOut){
                                                
                                                selected = monthIndex
                                            }
                                        }
                                        
                                        Text(datesForMonth[indexOfValue].subStringAfterLastComma)
                                            .font(.system(size: 10, weight: .light, design: .monospaced))
                                            .fixedSize(horizontal: true, vertical: false)
                                            .foregroundColor(self.colorScheme == .dark ? .sand : .black)
                                        Divider()
                                    }
                                }
                            }
                        }.frame(width:geo.size.width - 20)
                        .padding(.horizontal)
                    }
                }
            }
        }.padding(.top, 40)
        .padding(.horizontal)
        
        
        
        
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
    func barColor(val: Double) -> [Color] {
        switch val {
        case 0 : return self.colors
        case 1 : return [Color.neonRed, Color.red]
        //        case 2 : return [Color("energy"), Color("dyspnea")]
        //        case 3 : return [Color("dyspnea"), Color("heart")]
        default : return self.colors
        }
    }
    func textColor(val: Double) -> Color {
        switch val {
        case 0 : return Color("Color1")
        case 1 : return Color.neonRed
        //        case 2 : return Color.orange
        //        case 3 : return (self.colorScheme == .dark ? Color.neonRed : Color.red)
        default : return Color("Color1")
        }
    }
    
    func titleColor(title: String) -> Color {
        switch title {
        case "Swelling" : return (self.colorScheme == .dark ? Color.sand : Color.darkOrange)
        case "Fatigue" : return Color.blue
        case "Dyspnea" : return Color.red
        case "Combined" : return (self.colorScheme == .dark ? Color.white : Color.black.opacity(0.8))
        default : return Color.sand
        }
    }
}





struct SwellingGraph : View {
    var title: String
    var data: [Double]
    var curved: Bool
    @Environment(\.colorScheme) var colorScheme : ColorScheme
    var body: some View {
        
        
        iLineChart(
            data: data,
            title: title.lowercased(),
            subtitle: "occurences",
            style: .secondary,
            lineGradient: self.colorScheme == .dark ?
                .init(start: Color("ColorNeuro"), end: .lairWhite) :
                .init(start: Color("ColorNeuro"), end: Color.trackColor),
            chartBackgroundGradient: self.colorScheme == .dark ?
                .init(start: Color("ColorNeuro").opacity(0.2), end: Color.lairWhite.opacity(0.2)) :
                .init(start: Color("ColorNeuro").opacity(0.2), end: Color.trackColor.opacity(0.2)),
            canvasBackgroundColor: .clear,
            titleColor: colorScheme == .dark ? Color.sand.opacity(0.7) : Color.black.opacity(0.7),
            subtitleColor: colorScheme == .dark ? Color.sand.opacity(0.7) : Color.black.opacity(0.7),
            numberColor: Color.textColor(for: self.colorScheme).opacity(0.7),
            curvedLines: curved,
            cursorColor: .neonBlue,
            displayChartStats: true,
            maxHeight: hulk / 1.8,
            titleFont: Font.system(size: ultra / 15, weight: .bold, design: .rounded),
            subtitleFont: Font.system(size: ultra / 18, weight: .thin, design: .rounded),
            floatingPointNumberFormat: "%.1f")
        
        
    }
}

struct NakedFatigueGraph : View {
    
    var data: [Double]
    var curved: Bool
    @Environment(\.colorScheme) var colorScheme : ColorScheme
    var body: some View {
        
        iLineChart(
            data: data,
            title: "Combined",
            subtitle: "Occurences",
            style: .tertiary,
            lineGradient: .blu,
            chartBackgroundGradient: .init(start: .clear, end: .clear),
            canvasBackgroundColor: .clear,
            numberColor: .blue,
            curvedLines: curved,
            cursorColor: .blue,
            displayChartStats: true,
            maxHeight: 500,
            floatingPointNumberFormat: "%.1f")
        
        
    }
}

struct NakedDyspneaGraph : View {
    
    var data: [Double]
    var curved: Bool
    @Environment(\.colorScheme) var colorScheme : ColorScheme
    var body: some View {
        
        
        iLineChart(
            data: data,
            title: "\n\n",
            subtitle: "",
            style: .dyspnea2,
            lineGradient: .init(start: .red, end: .red),
            chartBackgroundGradient: .init(start: .clear, end: .clear),
            canvasBackgroundColor: .clear,
            numberColor: .red, curvedLines: curved, cursorColor: .red,
            displayChartStats: true,
            maxHeight: 500,
            floatingPointNumberFormat: "%.1f")
        
        
    }
}

struct NakedSwellingGraph : View {
    
    var data: [Double]
    var curved: Bool
    @Environment(\.colorScheme) var colorScheme : ColorScheme
    var body: some View {
        
        iLineChart(
            data: data,
            title: "\n",
            subtitle: "",
            style: .dark,
            lineGradient: .init(start: .sand, end: .sand),
            chartBackgroundGradient: .init(start: .clear, end: .clear),
            canvasBackgroundColor: .clear,
            numberColor: .sand,  curvedLines: curved, cursorColor: .sand, displayChartStats: true,
            maxHeight: 500,
            floatingPointNumberFormat: "%.1f")
        
        
    }
}

struct AceGraph : View {
    var title: String
    var data: [Double]
    var curved: Bool
    @Environment(\.colorScheme) var colorScheme : ColorScheme
    var body: some View {
        
        iLineChart(
            data: data,
            title: title.lowercased(),
            subtitle: "compliance",
            style: .tertiary,
            lineGradient: self.colorScheme == .dark ?
                .init(start: Color.waterColor, end: .lairWhite) :
                .init(start: Color.pulsatingColor, end: Color.lairWhite),
            chartBackgroundGradient: self.colorScheme == .dark ?
                .init(start: Color.waterColor.opacity(0.2), end: Color.lairWhite.opacity(0.2)) :
                .init(start: Color.waterColor.opacity(0.2), end: Color.lairDarkGray.opacity(0.2)),
            canvasBackgroundColor: .clear,
            //                chartBackgroundGradient: .blu,
            titleColor: Color.textColor(for: self.colorScheme).opacity(0.7),
            numberColor: Color.textColor(for: self.colorScheme).opacity(0.7),
            displayChartStats: true,
            maxHeight: hulk / 1.8,
            titleFont: Font.system(size: ultra / 15, weight: .bold, design: .rounded),
            subtitleFont: Font.system(size: ultra / 18, weight: .thin, design: .rounded),
            floatingPointNumberFormat: "%.1f")
        
        
    }
}



struct LiquidGraph : View {
    var title : String
    var subtitle: String
    var data: [Double]
    var curved: Bool
    @Environment(\.colorScheme) var colorScheme : ColorScheme
    var body: some View {
        iLineChart(
            data: data,
            title: title.lowercased(),
            subtitle: subtitle.lowercased(),
            style: .secondary,
            lineGradient: self.colorScheme == .dark ?
                .init(start: Color("fb"), end: .lairWhite) :
                .init(start: Color("fb"), end: Color.trackColor),
            chartBackgroundGradient: self.colorScheme == .dark ?
                .init(start: Color("fb").opacity(0.2), end: Color.lairWhite.opacity(0.2)) :
                .init(start: Color("fb").opacity(0.2), end: Color.trackColor.opacity(0.2)),
            canvasBackgroundColor: .clear,
            titleColor: Color.textColor(for: self.colorScheme).opacity(0.7),
            numberColor: Color.textColor(for: self.colorScheme).opacity(0.7),
            curvedLines: curved,
            cursorColor: .neonBlue,
            displayChartStats: true,
            maxHeight: hulk / 1.8,
            titleFont: Font.system(size: ultra / 15, weight: .bold, design: .rounded),
            subtitleFont: Font.system(size: ultra / 18, weight: .thin, design: .rounded),
            floatingPointNumberFormat: "%.1f")
        
    }
        
        
    }
    
    struct WeightGraph : View {
        var title : String
        var subtitle: String
        var data: [Double]
        var curved: Bool
        @Environment(\.colorScheme) var colorScheme : ColorScheme
        var body: some View {
            iLineChart(
                data: data.count > 0 ? data : [0,0,0,0],
                title: "weight",
                subtitle: subtitle.lowercased(),
                style: .secondary,
                lineGradient: self.colorScheme == .dark ?
                    .init(start: Color("ColorNeuro"), end: .lairWhite) :
                    .init(start: Color("ColorNeuro"), end: Color.trackColor),
                chartBackgroundGradient: self.colorScheme == .dark ?
                    .init(start: Color("ColorNeuro").opacity(0.2), end: Color.lairWhite.opacity(0.2)) :
                    .init(start: Color("ColorNeuro").opacity(0.2), end: Color.trackColor.opacity(0.2)),
                canvasBackgroundColor: .clear,
                titleColor: Color.textColor(for: self.colorScheme).opacity(0.7),
                numberColor: Color.textColor(for: self.colorScheme).opacity(0.7),
                curvedLines: curved,
                cursorColor: .neonBlue,
                displayChartStats: true,
                maxHeight: hulk / 1.8,
                titleFont: Font.system(size: ultra / 15, weight: .bold, design: .rounded),
                subtitleFont: Font.system(size: ultra / 18, weight: .thin, design: .rounded),
                floatingPointNumberFormat: "%.1f")
 
        }
        
}

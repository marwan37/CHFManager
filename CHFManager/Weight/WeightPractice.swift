//
//  WeightPractice.swift
//  Golgi-Splash
//
//  Created by Marwan Zaarab on 2021-01-18.
//

import SwiftUI
import PartialSheet
struct WeightPractice: View {
    @Environment(\.colorScheme) var cs: ColorScheme
    @Environment(\.managedObjectContext) var moc

    @State var dateMonthArray = [String?]()
    @State var weights = [Double]()
    @State var day: Int = 0
    @State var indexes = [Int]()
    @State var weightMonthKg: [Double] = []
    @State var liquidWeightData = [Double]()
    @State var months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"]
    @State var selected = 0
    @State var selected1 = 1
    @Binding var pushed: Bool
    var body: some View {
        TabView {
            
            WeightWatcher()

                .environment(\.managedObjectContext, self.moc)
                .navigationTitle("")
                .navigationBarHidden(true)
                .tabItem{
                    Image(systemName: "scalemass.fill")
                }
            
            WeightCharts()
                .environment(\.managedObjectContext, self.moc)
                .navigationTitle("")
                .navigationBarHidden(true)
                .tabItem{
                    Image(systemName: "tablecells")
                }
            
            WeightGraphView()
                .environment(\.managedObjectContext, self.moc)
                .navigationTitle("")
                .navigationBarHidden(true)
                .tabItem{
                    Image(systemName: "point.topleft.down.curvedto.point.bottomright.up")
                        .rotationEffect(.init(degrees: 150))
                }
            
            EmptyView()
                .tabItem{
                    Image(systemName: "info")
                }
            
        }
    }
    
    var liquidGraph : some View {
        VStack{
            LiquidGraph(title: "Weight",
                        subtitle: liquidWeightData == weights ? "Weight in pounds (lbs)" : "Weight in kilograms (kg)",
                        data: liquidWeightData,
                        curved: true)
            
            Spacer(minLength: 335)
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
            ZStack{
                HStack{
                    Spacer()
                    Button(action:{
                        self.liquidWeightData = weightMonthKg
                        
                    }){
                    LinearGradient.diagonalLairColor(for: cs).mask(
                       Text("Kilograms (kg)")
                        .opacity(self.liquidWeightData == weightMonthKg ? 1 : 0.5)
                        )
                }
                    Spacer()
                    Button(action:{
                        self.liquidWeightData = weights
                    }){
                        LinearGradient.diagonalLairColor(for: cs).mask(
                       Text("Pounds (lbs)")
                        .opacity(self.liquidWeightData == weights ? 1 : 0.5)
                        )
                }
                    Spacer()
                }.font(.system(size: 14, weight: .light, design: .monospaced))
                .shadow(color: Color.textColor(for: self.cs).opacity(0.5), radius: 3, x: 2, y: 2)
         
            }.offset(y: -300)
        }
    }
}

//struct WeightPractice_Previews: PreviewProvider {
//    static var previews: some View {
//        WeightPractice()
//    }
//}
//NavigationLink(destination:
//                WeightTable(month: $dateMonthArray, weightIndex: $indexes, weight: $weights)
//)
//{
//    HStack{
//        Image(systemName: "table")
//            .renderingMode(.template)
//        .font(.system(size: 30))
//        .frame(width: 50, height: 50)
//        .background(cs == .dark ? Color.lairShadowDark : Color.white)
//        .cornerRadius(10)
//        .shadow(color: cs == .dark ? Color.white.opacity(0.3) : Color.black.opacity(0.3), radius: 2, x: -2, y: -3)
//
//       Text("Table View\nWeight Tracking Workbook")
//        .font(.system(size: 16, weight:.regular, design:.rounded))
//            .padding(.leading, 20)
//        .foregroundColor(Color.textColor(for:cs))
//        .font(.system(size: 14, weight: .light, design: .rounded))
//        Spacer()
//        Image("right-chevron-3")
//            .resizable()
//            .aspectRatio(contentMode:.fit)
//            .frame(width: 20)
//    }.padding(.horizontal, 20)
//}

//NavigationLink(destination:
//                VStack{
//                    LiquidGraph(title: "Weight",
//                                subtitle: liquidWeightData == weights ? "Weight in pounds (lbs)" : "Weight in kilograms (kg)",
//                                data: liquidWeightData,
//                                curved: true)
//
//                    Spacer(minLength: 535)
//                    GeometryReader { geo in
//                        HStack{
//                            Spacer()
//                            ForEach(months, id: \.self) { month in
//
//                                Text(month).font(.caption).foregroundColor(.grayMe)
//
//                                Spacer()
//
//                            }
//                        }
//                    }
//
//
//                    Spacer(minLength: 330)
//                    ZStack{
//                        HStack{
//                            Spacer()
//                            Button(action:{
//                                self.liquidWeightData = weightMonthKg
//
//                            }){
//                            LinearGradient.diagonalLairColor(for: cs).mask(
//                               Text("Kilograms (kg)")
//                                .opacity(self.liquidWeightData == weightMonthKg ? 1 : 0.5)
//                                )
//                        }
//                            Spacer()
//                            Button(action:{
//                                self.liquidWeightData = weights
//                            }){
//                                LinearGradient.diagonalLairColor(for: cs).mask(
//                               Text("Pounds (lbs)")
//                                .opacity(self.liquidWeightData == weights ? 1 : 0.5)
//                                )
//                        }
//                            Spacer()
//                        }.font(.system(size: 14, weight: .light, design: .monospaced))
//                        .shadow(color: Color.textColor(for: self.cs).opacity(0.5), radius: 3, x: 2, y: 2)
//
//                    }.offset(y: -300)
//                }
//)
//VStack(alignment:.leading,spacing: 15){

//
//{
//    HStack{
//    Image(systemName: "point.topleft.down.curvedto.point.bottomright.up")
//        .renderingMode(.template)
//        .rotationEffect(.init(degrees: 90))
//        .font(.system(size: 30))
//        .frame(width: 50, height: 50)
//        .background(cs == .dark ? Color.darkBG : Color.white)
//        .cornerRadius(10)
//        .shadow(color: cs == .dark ? Color.white.opacity(0.3) : Color.black.opacity(0.3), radius: 2, x: -2, y: -3)
//
//       Text("LineChartView\nTrack Changes Over Time")
//            .font(.system(size: 16, weight:.regular, design:.rounded))
//            .padding(.leading, 20)
//        .foregroundColor(Color.textColor(for:cs))
//        .font(.system(size: 14, weight: .light, design: .rounded))
//        Spacer()
//        Image("right-chevron-3")
//            .resizable()
//            .aspectRatio(contentMode:.fit)
//            .frame(width: 20)
//}.padding(.horizontal, 20)
//}
//    Divider().padding()
//}.isHidden(!showinfo)

//
//  LiquidGraphView.swift
//
//
//  Created by Marwan Zaarab on 2021-02-03.
//

import SwiftUI
import CoreData

struct LiquidGraphView: View {
    @Environment(\.managedObjectContext) var moc
    @State var months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"]
    @State var monthsSmall = ["J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D"]

    @Environment(\.colorScheme) var colorScheme : ColorScheme
    @State var liquidsArray = [Double]()
    var body: some View {
        GeometryReader { geo in
            ZStack{
                LinearGradient.overall(for: colorScheme).edgesIgnoringSafeArea(.all)
            VStack{
                iLineChart(
                    data: liquidsArray,
                    title: "Liquids",
                    subtitle: "intake in ounces (oz)",
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
                    curvedLines: true,
                    cursorColor: .neonBlue,
                    displayChartStats: true,
                    maxHeight: geo.size.height / 1.4,
                    titleFont: Font.system(size: ultra / 15, weight: .bold, design: .rounded),
                    subtitleFont: Font.system(size: ultra / 18, weight: .thin, design: .rounded),
                    floatingPointNumberFormat: "%.1f")
                HStack{
                    Spacer()
                    ForEach(ultra > 400 ? months : monthsSmall, id: \.self) { month in
                        
                        Text(month)
                            .font(.system(size: 12, weight: .light, design: .rounded)).foregroundColor(.grayMe)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Spacer()
                        
                    }
                    
                }.frame(height: geo.size.height / 2)
            }.padding(.bottom, 20)
            
            .onAppear {
                self.liquidsArray = []
                self.fetchCoreData()
            }
            }
        }
    }
    
    func fetchCoreData() {
        let fetchRequest2 = NSFetchRequest<CD_Liquids>(entityName: "CD_Liquids")
        do {
            let result = try moc.fetch(fetchRequest2)

            let liquidArray = result.map{$0.intake}

            self.liquidsArray = liquidArray
            
        }catch {
            print("Could not fetch. \(error)")
        }
    }
}

struct LiquidGraphView_Previews: PreviewProvider {
    static var previews: some View {
        LiquidGraphView()
    }
}



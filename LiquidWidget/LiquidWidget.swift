//
//  LiquidWidget.swift
//  LiquidWidget
//
//  Created by Marwan Zaarab on 2021-01-07.
//

import WidgetKit
import SwiftUI
import CoreData
import SharedObjects

struct SimpleEntry: TimelineEntry {
    let date : Date
    let drank: Int
}

struct Provider: TimelineProvider {
    @AppStorage("drank", store: UserDefaults(suiteName: "group.H97YA8G6R5.com.golgi.CHFManager")) var drankData: Data = Data()
    @AppStorage("liquidLimit", store: UserDefaults(suiteName: "group.H97YA8G6R5.com.golgi.CHFManager")) var liquidLimitData: Data = Data()
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), drank: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        guard let drank = try? JSONDecoder().decode(Int.self, from: drankData) else { return }
        let entry = SimpleEntry(date: Date(), drank: drank)
        completion(entry)
    }
   
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        var entries: [SimpleEntry] = []
        guard let drank = try? JSONDecoder().decode(Int.self, from: drankData) else { return }
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for minuteOffset in 0 ..< 60 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, drank: drank)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct LiquidWidgetEntryView : View {
    @Environment(\.colorScheme) var cs
    @State var unit = "fl. oz."
    var entry: Provider.Entry
    let testStr = UserDefaults(suiteName: "group.H97YA8G6R5.com.golgi.CHFManager")!.string(forKey: "waterShared")
    var body: some View {
        return  ZStack{
            LinearGradient.minimalist(for: cs).edgesIgnoringSafeArea(.all)
            VStack{
                VStack{
                    
                    Text("Fluid Tracker")
   
                   
                }.font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(Color.pulsatingColor)
//                .shadow(color:Color.white.opacity(0.6), radius: 1, x: -2, y:2)
                HStack{
                    Spacer()
                    VStack(alignment:.leading, spacing:5){
                        HStack{
                            Text("intake:")
                        Text("\(drankAmountFromUserDefaults * 8)")
                        }.font(.system(size: 14, weight: .bold, design: .rounded)).foregroundColor(.cap)
                       
                        Text(unit).font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundColor(.lairGray)
                        HStack{
                           Text("limit:")
                        Text("\(limitAmountFromFileManager)")
                          
                        } .font(.system(size: 14, weight: .bold, design: .rounded)).foregroundColor(.pulsatingColor)
                    }
                    
             
                    Spacer()
                    VStack(spacing: 5){
                        
                        RoundedRectangle(cornerRadius: 3)
                            .frame(width: 15, height: 10)
                            .foregroundColor(.yellow)
                      
                        ZStack(alignment:.bottomTrailing){
                            RoundedRectangle(cornerRadius: 7)
                                .frame(width: 35, height: 80)
                                .foregroundColor(.white)
                                .shadow(color: Color.black.opacity(0.5), radius: 2, x: 0.0, y: 0.0)
                            
                            let recHeight = (2 - drankAmountFromFileManager) * 10
                            Rectangle()
                                .cornerRadius(7, corners: [.bottomLeft, .bottomRight])
                                .cornerRadius(drankAmountFromFileManager < 7 ? 5 : 2, corners: [.topLeft, .topRight])
                                .frame(width: 35, height: CGFloat(recHeight))
                                .foregroundColor(Color.blue.opacity(0.5))
                            

                            
                        }
                       
                    }
                    Spacer()
                }
                HStack{
                    
                Text(entry.date, style: .time)
                    .font(.system(size: 10, weight:.light, design:.monospaced))
                    .foregroundColor(.textColor(for: cs))
                }.padding(.top, 4)
            }
        }
    }
    var drankAmountFromUserDefaults: Int {
        UserDefaults.appGroup.integer(forKey: UserDefaults.Keys.drank.rawValue)
    }
    
    var limitFromUserDefaults: Int {
        UserDefaults.appGroup.integer(forKey: UserDefaults.Keys.liquidLimit.rawValue)
    }
    
    var drankAmountFromFileManager: Int {
        let url = FileManager.appGroupContainerURL.appendingPathComponent(FileManager.liquidFileName)
        guard let text = try? String(contentsOf: url, encoding: .utf8) else { return 0 }
        return Int(text) ?? 0
    }
    var limitAmountFromFileManager: Int {
        let url = FileManager.appGroupContainerURL.appendingPathComponent(FileManager.liquidLimitFileName)
        guard let text = try? String(contentsOf: url, encoding: .utf8) else { return 0 }
        return Int(text) ?? 0
    }
}

@main
struct LiquidWidget: Widget {
    let kind: String = "LiquidWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            LiquidWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct LiquidWidget_Previews: PreviewProvider {
    static var previews: some View {
        LiquidWidgetEntryView(entry: SimpleEntry(date: Date(), drank: 32))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}


extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}


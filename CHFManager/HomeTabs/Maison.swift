//import SwiftUI
//import PartialSheet
//
//struct Maison: View {
//    @Environment(\.managedObjectContext) var moc
//    @State var tap = 0
//    @FetchRequest(entity: NewsItem.entity(), sortDescriptors: []) var newsItems: FetchedResults<NewsItem>
//    @State private var badgeCount: Int = 1
//    private var badgePosition: CGFloat = 5
//    private var tabsCount: CGFloat = 5
//    var body : some View {
//        
//        GeometryReader { geometry in
//            ZStack(alignment: .bottomLeading) {
//                
//                TabView {
//                    MasterCalendarView()
//                        .environmentObject(DayData())
//                        .environmentObject(NYHAQuestions())
//                        .environment(\.managedObjectContext, self.moc)
//                        .tabItem {
//                            Image(systemName: "house")
//                        }
//                    PillsView().environment(\.managedObjectContext, self.moc)
//                        .navigationBarHidden(true)
//                        .navigationTitle("")
//                        .tabItem {
//                            Image(systemName: "pills.fill")
//                        }
//                    
//                    SymptomsView().environment(\.managedObjectContext, self.moc).navigationTitle("")
//                        .navigationBarHidden(true)
//                        .tabItem {
//                            Image(systemName: "cross.fill")
//                        }
//                   
//                    WeightWatcher()
//                        .tabItem{
//                            Image(systemName: "scalemass")
//                        }
//                    
//                    WaterContainer()
//                        .tabItem{
//                            Image(systemName: "drop")
//                        }
//                 
//                    }
//                
//                // Badge View
//                ZStack {
//                  Circle()
//                    .foregroundColor(.red)
//
//                    Text("\(newsItems.count)")
//                    .foregroundColor(.white)
//                    .font(Font.system(size: 12))
//                }
//                .frame(width: 15, height: 15)
//                .offset(x: ( ( 2 * self.badgePosition) - 0.95 ) * ( geometry.size.width / ( 2 * self.tabsCount ) ) + 2, y: -25)
//                .opacity(newsItems.count == 0 ? 0 : 1.0)
//                
//            }
//        }.navigationTitle("")
//        .navigationBarHidden(true)
//        
//        
//    }
//}

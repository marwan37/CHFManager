let gridstyle1 = ModularGridStyle(.vertical, columns: .min(100), rows: .fixed(100))
let gridstyle2 =  ModularGridStyle(columns: 2, rows: 4, spacing: 16)
let gridstyle3 =  ModularGridStyle(columns: .min(80), rows: .fixed(80), spacing: 4)


import SwiftUI
import PartialSheet
import Grid
struct BarMod : ViewModifier {
    @State var yeah : Bool
    func body(content: Content) -> some View {
        content
            .padding(20)
            .background(yeah ? Color("ColorNeuro") : Color.lairWhite)
            .cornerRadius(15)
            .overlay(
                
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.black.opacity(0.05), lineWidth: yeah ? 4 : 1)
                    .shadow(color: Color.black.opacity(yeah ? 0.2 : 0), radius: 3, x: 5, y: 5)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(color: Color.black.opacity(yeah ? 0.2 : 0), radius: 3, x: -5, y: -5)
                    
        )
    }
}

var tabs = ["Home","My Medications","Symptoms","Weight","Liquids", "Questionnaires", "Daily Log", "Settings"]
let columns = [GridItem(.flexible()), GridItem(.flexible())]
struct previewhome : View {
    @State var pushed = [false, false]
    @State var edges = UIApplication.shared.windows.first?.safeAreaInsets
    @Environment(\.colorScheme) var cs

@State var toggle = false
    var body: some View {
        NavigationView {
            
        GeometryReader { g in
            ZStack{
                LinearGradient.lairGradientReverse(for: cs)
                    .ignoresSafeArea()
            VStack(spacing:0){
            Grid(0..<tabs.count,id: \.self){tab in
                    CTabButton(title: tabs[tab])
            }
            .gridStyle(
                ModularGridStyle(columns: 2, rows: 4, spacing: 0)
            )
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            
            .navigationViewStyle(
                StackNavigationViewStyle()
            )
            
            }
        }
            }
    }
    func ret(_ selectedTab: String) -> Int {
        switch selectedTab {
        case "Home": return 0
        case "My Medications" : return 1
        case "Symptoms" : return 2
        case "Weight" : return 3
        case "Liquids" : return 4
        case "Questionnaires" : return 5
        case "Daily Log" : return 6
        case "Settings" : return 7
        default:  return 0
        }
    }
}
 
       
struct BHome_Previews: PreviewProvider {
    static var previews: some View {
        Group{
       previewhome()
        .preferredColorScheme(.dark)
        }
    }
}
var squires = [0,3,4,7]

let uwd = UIScreen.main.bounds.width
let uhd = UIScreen.main.bounds.height
struct CTabButton : View {
    @Environment(\.colorScheme) var cs
    var title : String
    var opac : Double {
        if cs == .dark {
            return 0.8
        } else {
            return 0.6
        }
    }
  
    let full = UIScreen.main.bounds.width
    var body: some View{
        
        
        ZStack{
            if cs == .dark {
                Rectangle()
                    .foregroundColor(squires.contains(returnIndex(selectedTab: title)) ? Color.trackColor.opacity(0.98) :
                                        Color.trackColor.opacity(0.9)
                    )

                    .frame(width: uwd / 2 ) .edgesIgnoringSafeArea(.all)
            } else {
                Rectangle()
                    .foregroundColor(squires.contains(returnIndex(selectedTab: title)) ? Color("ColorNeuro").opacity(0.98) :
                                        Color("ColorNeuro").opacity(0.3)
                    )

                    .frame(width: uwd / 2 ) .edgesIgnoringSafeArea(.all)
            }
           
            
            VStack(spacing: 0){
                VStack(alignment:.center,spacing:20){

                    Image(cs == .light ? "menub\(returnIndex(selectedTab: title))" : "menubc\(returnIndex(selectedTab: title))" )
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 55, height: 55)
                            .shadow(color: cs == .light ? Color.black.opacity(0.5) : Color.white.opacity(0.5), radius: 2, x: -2, y: 2)
                            .opacity(0.8)
                        if title == "Home" {
                            
                            (Text("daily") + Text("|Completion").fontWeight(.regular))

                        } else if title == "Weight" {
                            (Text("weight") + Text("|Tracker").fontWeight(.regular))
                        } else if title == "Questionnaires" {
                            (Text("weekly") + Text("|Questionnaires").fontWeight(.regular))
                        } else if title == "Symptoms" {
                            (Text("symptom") + Text("|Tracker").fontWeight(.regular))

                        }else if title == "Liquids" {
                            (Text("liquid") + Text("|Tracker").fontWeight(.regular))

                        } else if title == "Daily Log" {
                            (Text("analytics") + Text("|Charts").fontWeight(.regular))

                        }else if title == "Weight" {
                            (Text("weight") + Text("|Tracker").fontWeight(.regular))
                        } else if title == "Settings" {
                            (Text("account") + Text("|Settings").fontWeight(.regular))
                        } else if title == "My Medications" {
                            (Text("medication") + Text("|Manager").fontWeight(.regular))
                        } else {
                            Text(title.lowercased()).foregroundColor(Color.textColor(for: cs)).opacity(opac)

                        }
                    } .font(.system(size: 12, weight: .heavy, design: .rounded))
                .foregroundColor(Color.textColor(for: cs)).opacity(opac)
            }

        }
    }
    func returnIndex(selectedTab: String) -> Int {
        switch selectedTab {
        case "Home": return 0
        case "My Medications" : return 1
        case "Symptoms" : return 2
        case "Weight" : return 3
        case "Liquids" : return 4
        case "Questionnaires" : return 5
        case "Daily Log" : return 6
        case "Settings" : return 7
        default:  return 0
        }
    }
}

struct BHome : View {
    @Environment(\.colorScheme) var cs
    @State var links: [Any] = [MasterCalendarView.self, PillsView.self, SymptomsView.self, WeightWatcher.self, WaterContainer.self,NYHAView.self, ChartsView.self, Home.self]
    @Environment(\.managedObjectContext) var moc
    @State var selectedTab = "Home"
    @State var selectedLink = 0
    @State var pushed = [false, false, false, false, false, false, false, false]
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    @State var numbers = [0,1,2,3,4,5,6,7]
    @State var tabs = ["Home","My Medications","Symptoms","Weight","Liquids", "Questionnaires", "Daily Log", "Settings"]
    @State var toggle = false
    
    var body: some View{
        GeometryReader { g in
            VStack(spacing:0){
           
                HomeBackButton(pushed: $pushed, toggle: $toggle)
                Divider()
            NavigationView{
            Grid(0..<tabs.count,id: \.self){tab in
             
                NavigationLink(destination:
                                ZStack{
                                    LinearGradient.overall(for:cs).edgesIgnoringSafeArea(.all)
                                buildView(types: links, index: tab, toggle: toggle)
                               
                                }
                               , isActive:$pushed[tab])
                {
                   
                  
                    CTabButton(title: tabs[tab])
                        .buttonStyle(BorderlessButtonStyle())
                }
                
            }.gridStyle(
                ModularGridStyle(columns: 2, rows: 4, spacing: 0)
            )
            .navigationTitle("")
            .navigationBarHidden(true)
            }
            }
        }
        .background(toggle || cs == .dark ? Color.lilly : Color("ColorNeuro")).edgesIgnoringSafeArea(.all)
        .environment(\.colorScheme, toggle ? .dark : .light)
    }
    var toggleButton : some View {
        Button(action: {
            self.toggle.toggle()
            
        }){
    Image(toggle ? "bulb2" : "bulb")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 45, height: 45)
        .shadow(color: cs == .dark ? Color.white.opacity(0.3) : Color.black.opacity(0.3), radius: 2, x: -2, y: -2)
        }
    }

    func buildView(types: [Any], index: Int, toggle: Bool) -> AnyView {
       
        switch types[index].self {
        case is MasterCalendarView.Type: return
            AnyView(MasterCalendarTabView(pushed: $pushed[index]) 
                                                            .environmentObject(DayData())
                                                            .environment(\.managedObjectContext, self.moc)
                                                            .navigationTitle("")
                                                            .navigationBarHidden(true)
        )
        case is PillsView.Type: return AnyView(
            PillsView(pushed: $pushed[index])
                .environment(\.managedObjectContext, self.moc)
                .navigationTitle("")
                .navigationBarHidden(true)
        )
        case is SymptomsView.Type: return AnyView(
            
            SymptomsView(pushed: $pushed[index]).environment(\.managedObjectContext, self.moc) 
                                                    .navigationTitle("")
                                                    .navigationBarHidden(true)
                                                    )
        case is WeightWatcher.Type: return AnyView( WeightPractice(pushed: $pushed[index])
                                                        .environment(\.managedObjectContext, self.moc)
                                                        .navigationTitle("")
                                                        .navigationBarHidden(true) )
        case is WaterContainer.Type: return AnyView( LiquidPractice(pushed: $pushed[index])
                                                        .environment(\.managedObjectContext, self.moc)
                                                        .navigationTitle("")
                                                        .navigationBarHidden(true) )
        case is NYHAView.Type: return AnyView(  NYHAView().environment(\.managedObjectContext, self.moc) .navigationTitle("")
                                                    .navigationBarHidden(true))
        case is ChartsView.Type : return AnyView ( ChartsView(pushed: $pushed[index]).environment(\.managedObjectContext, self.moc)
                                                    .navigationTitle("")
                                                    .navigationBarHidden(true))
        case is Home.Type : return AnyView ( Home()
                                                .environmentObject(PartialSheetManager())
                                                .navigationTitle("")
                                                .navigationBarHidden(true))
        default: return AnyView(EmptyView())
           }
       }
}




struct HomeBackButton : View {
    @Binding var pushed:[Bool]
    @Environment(\.colorScheme) var cs
    @Binding var toggle : Bool
    @State var bgColor = Color.clear
    @State var edges = UIApplication.shared.windows.first?.safeAreaInsets
    @State var linearColor = LinearGradient.diagonalLairColorLight
    var body: some View {
       
            HStack{
                Button(action:{
                    
                    for i in 0..<pushed.count {
                        if pushed[i] == true {
                            self.pushed[i] = false
                           
                        }
                    }
                       
                    
                    
                })
                {
                    Image("homey2")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 16, height: 16)
                        .padding(6)
                       
                        .shadow(color: cs == .dark ? Color.white.opacity(0.3) : Color.black.opacity(0.3), radius: 2, x: -2, y: -2)
                }.buttonStyle(OtherModifier()) .padding(.leading, 20).opacity(0.8)
                Spacer()
                HStack(spacing:0){
                    Image(cs == .dark || toggle == true ? "swiss-franc copy" : "swiss-franc")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30)
               

                Text("Manager").font(.system(size: 18, weight:.light, design:.rounded))
                }.opacity(0.5)
                Spacer()
                Button(action: {
                    self.toggle.toggle()
                    
                }){
                    Image(systemName: !toggle ? "sun.max.fill" : "moon.fill")
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 16, height: 16)
                            .padding(6)
                        .opacity(cs == .dark ? 0.6 : 1)
                       
                }.buttonStyle(OtherModifier())
                    .padding(.trailing, 20)
            }
         
            
            .padding(.bottom, 15)
            .padding(.top, edges!.top)
            .ignoresSafeArea(.all, edges: .all)
            .background(self.generateBgColor())
    }
    func generateBgColor() ->LinearGradient {
        var linearColor = LinearGradient.init(gradient: .init(colors: [cs == .light ? Color("ColorNeuro") : Color.trackColor, cs == .light ? Color("ColorNeuro") : Color.trackColor]), startPoint: .bottom, endPoint: .top)

    if self.pushed[1] == true {
            if cs == .dark {
                linearColor = LinearGradient.init(gradient: Gradient(colors: [Color.trackColor, Color.trackColor]), startPoint: .topLeading, endPoint: .bottomTrailing)
            } else {
                linearColor = LinearGradient.init(gradient: Gradient(colors: [Color.lairWhite, Color.lairWhite]), startPoint: .bottom, endPoint: .top)
            }
        }
        

        return linearColor
    }
}

extension LinearGradient {
    
    static let lightMenu = LinearGradient(gradient: .init(colors: [Color("Squire"), Color("Squire").opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing)
    static let darkMenu = LinearGradient(gradient: .init(colors: [Color.darkBG, Color.darkBG.opacity(0.85)]), startPoint: .topLeading, endPoint: .bottomTrailing)
    static func linearDarkBG(for colorScheme: ColorScheme) -> LinearGradient {
        if colorScheme == .dark {
            return diagonalLairColorDark
        } else {
            return diagonalLairColorLight
        }
    }
    
}


struct BCustomShape: Shape {
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.bottomLeft,.bottomRight], cornerRadii: CGSize(width: 10, height: 10))
        
        return Path(path.cgPath)
    }
}

struct BackButton: View {
    let label: String
    let closure: () -> ()

    var body: some View {
        Button(action: { self.closure() }) {
            HStack {
                Image(systemName: "chevron.left")
                Text(label)
            }
        }
    }
}

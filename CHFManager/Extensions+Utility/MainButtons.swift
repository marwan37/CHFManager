//
//  MainButtons.swift
//  Pods
//
//  Created by Marwan Zaarab on 2021-01-03.
//

import SwiftUI
import FloatingButton

struct ScreenCircle: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
@State var leadingTag = ""
    var body: some View {
        let mainButton1 = AnyView(MainButton(imageName: "chart.bar.fill", colorHex: "f7b731"))
        let mainButton2 = AnyView(MainButton(imageName: "cross.case.fill", colorHex: "eb3b5a"))

        
        
        
        let buttonsImage = (0..<MockDatas.iconImageNames.count).map { i in
            AnyView(IconButton(imageName: MockDatas.iconImageNames[i], color: MockDatas.colors[i]))
        }
        let buttonsChart = (0..<MockDatas.chartImageNames.count).map { i in
            AnyView(IconButton(imageName: MockDatas.chartImageNames[i], color: MockDatas.colors[i]))
        }

        let menu1 = FloatingButton(mainButtonView: mainButton2, buttons: buttonsImage.dropLast())
            .circle()
            .startAngle(3/2 * .pi)
            .endAngle(66 * .pi)
            .radius(70)
        let menu2 = FloatingButton(mainButtonView: mainButton1, buttons: buttonsChart)
            .circle()
            .delays(delayDelta: 0.1)

        return VStack() {
            Spacer(minLength: 200)
            FloatingButton(mainButtonView: mainButton2, buttons: buttonsImage.dropLast())
                .circle()
                .startAngle(3/2 * .pi)
                .endAngle(85 * .pi)
                .radius(70)
            Spacer().layoutPriority(10)
            Spacer().layoutPriority(10)
            HStack() {
                menu1.padding(20)
                Spacer().layoutPriority(10)
                menu2.padding(20)
                Spacer().layoutPriority(10)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading:
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .padding(.init(top: 0, leading: 10, bottom: 0, trailing: 0))
                }
        )
    }
}

struct ScreenStraight: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        let mainButton1 = AnyView(MainButton(imageName: "thermometer", colorHex: "f7b731"))
        let mainButton2 = AnyView(MainButton(imageName: "cloud.fill", colorHex: "eb3b5a"))

        let buttonsImage = (0..<MockDatas.iconImageNames.count).map { i in
            AnyView(IconButton(imageName: MockDatas.iconImageNames[i], color: MockDatas.colors[i]))
        }

        let menu1 = FloatingButton(mainButtonView: mainButton1, buttons: buttonsImage)
            .straight()
            .direction(.right)
            .delays(delayDelta: 0.1)
        
        let menu2 = FloatingButton(mainButtonView: mainButton2, buttons: buttonsImage)
            .straight()
            .direction(.top)
            .delays(delayDelta: 0.1)

        return VStack() {
            Spacer().layoutPriority(10)
            HStack() {
                menu1.padding(20)
                Spacer().layoutPriority(10)
                menu2.padding(20)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading:
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .padding(.init(top: 0, leading: 10, bottom: 0, trailing: 0))
                },
            trailing:
                NavigationLink(destination: ScreenCircle()) {
                    Image(systemName: "arrow.right.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding(.init(top: 0, leading: 0, bottom: 0, trailing: 10))
                }
                .isDetailLink(false)
        )
    }
}
struct ScreenIconsAndText: View {

    @State var isOpen = false

    var body: some View {
        let textButtons = (0..<MockDatas.iconAndTextTitles.count).reversed().map { i in
            AnyView( IconAndTextButton(imageName: MockDatas.iconAndTextImageNames[0], buttonText: MockDatas.iconAndTextTitles[0])
                        .onTapGesture {
                            isOpen.toggle()
                        })
        }
        let textButtons2 = (0..<MockDatas.iconAndTextTitles.count).reversed().map { i in
            AnyView( IconAndTextButton(imageName: MockDatas.iconAndTextImageNames[1], buttonText: MockDatas.iconAndTextTitles[1])
                        .onTapGesture {
                            isOpen.toggle()
                        })
        }

        let mainButton1 = AnyView(MainButton(imageName: "star.fill", colorHex: "f7b731", width: 60))
        let mainButton2 = AnyView(MainButton(imageName: "heart.fill", colorHex: "eb3b5a", width: 60))

        let menu1 = FloatingButton(mainButtonView: mainButton1, buttons: textButtons, isOpen: $isOpen)
            .straight()
            .direction(.top)
            .alignment(.left)
            .spacing(10)
            .initialOffset(x: -1000)
            .animation(.spring())

        let menu2 = FloatingButton(mainButtonView: mainButton2, buttons: textButtons2)
            .straight()
            .direction(.top)
            .alignment(.right)
            .spacing(10)
            .initialOpacity(0)

        return NavigationView {
            VStack() {
                HStack() {
                    menu1.padding(20)
                    Spacer().layoutPriority(10)
                    menu2.padding(20)
                }
            }
            .navigationBarItems(
                trailing:
                    NavigationLink(destination: ScreenStraight()) {
                        Image(systemName: "arrow.right.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .padding(.init(top: 0, leading: 0, bottom: 0, trailing: 10))
                    }
                    .isDetailLink(false)
            )
        }
    }
}


struct MainButton: View {
    @Environment(\.colorScheme) var cs : ColorScheme
    var imageName: String
    var colorHex: String

    var width: CGFloat = 50

    var body: some View {
       
        ZStack {
            if cs == .dark {
            Color(hex: colorHex)
                .frame(width: width, height: width)
                .cornerRadius(width/2)
                .shadow(color: Color(hex: colorHex).opacity(0.3), radius: 15, x: 0, y: 15)
            Image(systemName: imageName).foregroundColor(.white)
            } else {
                Color.white
                    .frame(width: width, height: width)
                    .cornerRadius(width/2)
//                    .shadow(color: Color.black.opacity(1), radius:1, x: 0, y: 0)
                Image(systemName: imageName).foregroundColor(.black)
            }
        }
    }
}

struct IconButton: View {
    @Environment(\.colorScheme) var cs : ColorScheme
    var imageName: String
    var color: Color

    let imageWidth: CGFloat = 20
    let buttonWidth: CGFloat = 30

    var body: some View {
        ZStack {
            if cs == .dark {
            Color.grayMe

            Image(systemName: imageName)
                .frame(width: self.imageWidth, height: self.imageWidth)
                .foregroundColor(.white)
            } else  {
                Color.white
                Image(systemName: imageName)
                    .frame(width: self.imageWidth, height: self.imageWidth)
                    .foregroundColor(.black) .shadow(color: Color.black.opacity(1), radius:25, x: 0, y: 0)
            }
        }
        .frame(width: self.buttonWidth, height: self.buttonWidth)
        .cornerRadius(self.buttonWidth / 2)
    }
}

struct IconAndTextButton2: View {
    @Environment(\.colorScheme) var cs : ColorScheme
   
    var buttonText: String

    let imageWidth: CGFloat = 12

    var body: some View {
        ZStack {
           
            if cs == .light {
            Color.white

            HStack {
               
                Text(buttonText)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundColor(Color(hex: "4b5d67"))
            
            }
            
            } else {
                Color.black

                HStack {
                    Text(buttonText)
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundColor(Color(hex: "ebecf1"))
                }
                
            }
        }
        .frame(width: 40, height: 25)
        .cornerRadius(8)
//        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 1)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(hex: "F4F4F4"), lineWidth: 1)
        )
        
        
    }
}

struct IconAndTextButton: View {
    @Environment(\.colorScheme) var cs : ColorScheme
    var imageName: String
    var buttonText: String

    let imageWidth: CGFloat = 12

    var body: some View {
        ZStack {
            LinearGradient.overall(for: cs)
            HStack {
                Image(systemName: self.imageName)
                    .resizable()
                    .aspectRatio(1, contentMode: .fill)
                    .foregroundColor(Color(hex: "4b5d67"))
                    .frame(width: self.imageWidth, height: self.imageWidth)
                    .clipped()
                Spacer()
                Text(buttonText)
                    .font(.system(size: ultra > 400 ? 12 : 10, weight: .semibold, design: .rounded))
                    .foregroundColor(Color(hex: "4b5d67"))
                    .fixedSize(horizontal: false, vertical: true)

                Spacer()
            }.padding(.leading, 15).padding(.trailing, 15)
            
            
        }
        .frame(width: UIScreen.main.bounds.width / 3, height: hulk > 700 ? 35 : 30)
        .cornerRadius(8)
//        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 1)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(cs == .light ? Color(hex: "F4F4F4") : Color.trackColor, lineWidth: 1)
        )
        
        
    }
}

struct MockDatas { 

    static let colors = [
        "e84393",
        "0984e3",
        "6c5ce7",
        "00b894"
    ].map { Color(hex: $0) }

    static let iconImageNames = [
        "bandage.fill",
        "scalemass.fill",
        "drop.fill",
        "pills.fill"
    ]
    static let chartImageNames = [
        "chart.pie",
        "chart.bar.doc.horizontal",
        "line.diagonal",
        "scribble"
    ]

    static let iconAndTextImageNames = [
        "arrow.left",
        "arrow.right",
        "plus.circle.fill",
        "minus.circle.fill",
        "pencil.circle.fill"
    ]

    static let iconAndTextTitles = [
        "Swelling",
        "Fatigue",
        "Combined",
        "Rename"
    ]
}


struct ScreenCircle_Previews: PreviewProvider {
    static var previews: some View {
       ScreenCircle()
    }
}
struct ChartButtons: View {
    @State var isOpen = false
    @State var isOpen2 = false
    @Binding var leadImg : String
    @Binding var trailImg: String
    @Binding var leadButton: AnyView
    @Binding var trailButton: AnyView
    @Binding var leadingTag: String
    @Binding var trailingTag: String
    @Binding var showSx : String
    @Binding var title : String
    @Binding var symptomData: [Double]
   
    @State var showSxS = ["swell", "", "liquide", "weight"]
    @State var titles = ["Swelling", "Medication Compliance", "Liquids", "Weight"]
    @State var tags = ["symptoms", "meds", "liquide", "weight"]
    @State var trails = ["curved", "bar", "pie"]
    @State var icons = ["cross.fill","pills.fill", "drop.fill", "scalemass.fill"]
   @State var charts = [
     "scribble",
    "chart.bar.fill",
    "chart.pie.fill"
    ]
    @State var charts2 = [
      "scribble",
     "chart.bar.fill",
     ]
    @State var trails2 = ["curved", "bar"]
    var opac : Double {
        if self.isOpen {
            return 0.9
        } else {
            return 0.3
        }
    }
    var opac2: Double {
        if self.isOpen2 {
            return 0.9
        } else {
            return 0.3
        }
    }
    var opac3 : Double {
        if self.isOpen {
            return 0.85
        } else {
            return 0
        }
    }
    var opac4: Double {
        if self.isOpen2 {
            return 0.85
        } else {
            return 0
        }
    }
    var body: some View {
        let main = AnyView(
            Button(action:{
                    self.isOpen.toggle()
                
            }) {
            MainButton(imageName: leadImg, colorHex: "f7b731")
                
            }.buttonStyle(OtherModifier())
            .opacity(opac)
        )
        let butts = self.iconButtons()
        let mains =
            AnyView(
                Button(action:{
                        self.isOpen2.toggle()
                }) {
                    MainButton(imageName: trailImg, colorHex: "f7b731")
                    
                }.buttonStyle(OtherModifier())
                .opacity(opac2)
            )
        let trailers = self.graphButtons()
        let trailers2 = self.graphButtons2()
        let taggers = ["liquide", "weight"]
        let menu1 = FloatingButton(mainButtonView: main, buttons: butts, isOpen: $isOpen)
//            .straight()
//            .direction(.right)
//            .spacing(10)
//            .initialOpacity(0)
            .circle()
            .startAngle(3/2 * .pi)
            .endAngle(2 * .pi)
            .radius(70)
        
        let menu3 = FloatingButton(mainButtonView: mains, buttons : trailers2, isOpen: $isOpen2)
            .straight()
            .direction(.top)
            .spacing(10)
            .initialOpacity(0)
            
        
        let menu2 = FloatingButton(mainButtonView: mains, buttons: trailers, isOpen: $isOpen2)
            .straight()
            .direction(.top)
            .spacing(10)
            .initialOpacity(0)
            
        
        VStack{
            HStack() {
                menu1.padding(20)
//                    .opacity(self.isOpen ? 0.9 : 0.8)
                Spacer().layoutPriority(10)
                if leadingTag == "liquide" || leadingTag == "weight" {
                    menu3.padding(20)
                } else {
                menu2.padding(20)
                }
//                    .opacity(self.isOpen2 ? 0.9 : 0.8)
            }
        }
    }
    func iconButtons() -> [AnyView] {
        var views = [AnyView]()
        for i in 0..<icons.count {
            if self.leadImg != icons[i] {
            let view = AnyView( Button(action:{
                self.leadButton = AnyView(MainButton(imageName: icons[i], colorHex: "222831"))
                self.leadingTag = tags[i]
                self.leadImg = icons[i]
                self.showSx = showSxS[i]
                self.title = titles[i]
                self.isOpen.toggle()
            })
            {
                IconButton(imageName: icons[i], color: Color(hex:"778ca3")).opacity(opac3)
            })
            views.append(view)
            }
        }
        return views
    }
  
    func graphButtons() -> [AnyView] {
       
        var views = [AnyView]()
        for i in 0..<charts.count {
            if self.trailImg != charts[i] {
            let view = AnyView( Button(action:{
                self.trailButton = AnyView(MainButton(imageName: charts[i], colorHex: "222831"))
                self.trailingTag = trails[i]
                self.trailImg = charts[i]
                self.isOpen2.toggle()
            })
            {
                IconButton(imageName: charts[i], color: Color(hex:"778ca3")).opacity(opac4)
            })
            views.append(view)
            }
        }
        return views
    }
    
    func graphButtons2() -> [AnyView] {
       
        var views = [AnyView]()
        for i in 0..<charts2.count {
            if self.trailImg != charts2[i] {
            let view = AnyView( Button(action:{
                self.trailButton = AnyView(MainButton(imageName: charts2[i], colorHex: "222831"))
                self.trailingTag = trails2[i]
                self.trailImg = charts2[i]
                self.isOpen2.toggle()
            })
            {
                IconButton(imageName: charts2[i], color: Color(hex:"778ca3")).opacity(opac4)
            })
            views.append(view)
            }
        }
        return views
    }
    
}

var HomeWeekTitle : some View {
    VStack{
LazyVGrid(columns: Array(repeating: GridItem(.flexible(),spacing: 5), count: 4)){
        Text("Date")
        Text("Score")
    HStack(spacing:0){
        Text("Reminder")
//        Image(systemName: "heart.fill").foregroundColor(.lightRed)
    }
        Text("Status")
    } .font(.system(size: 14, weight: .light, design: .rounded))
    .frame(width:UIScreen.main.bounds.width * (3/4) + 40)
    .offset(y: 30)
    RoundedRectangle(cornerRadius: 15)
        .foregroundColor(Color.grayMe)
        .frame(width:UIScreen.main.bounds.width * (3/4) + 20, height: 5)
        .offset(y: 30)
    }
}

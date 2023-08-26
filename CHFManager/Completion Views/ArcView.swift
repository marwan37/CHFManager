//
//  ArcView.swift
//  Golgi-Splash
//
//  Created by Marwan Zaarab on 2020-11-26.
//

import SwiftUI

//MARK: ARCVIEW
struct ArcView: View {
    @State private var percent: CGFloat = 0
    @EnvironmentObject var data: DayData
    var body: some View {
        VStack {
//            Button(action: {self.data.percentage += 1/2}) {Text("tap")}
            Spacer()
            Color.clear.overlay(Indicator(pct: CGFloat(self.data.percentage)))
                .animation(.easeInOut(duration: 0.2))

        }
    }
}

struct Indicator: View {
    var pct: CGFloat
    @Environment(\.colorScheme) var cs : ColorScheme
    var body: some View {
        return Circle()
            .fill(LinearGradient(gradient: Gradient(colors: [Color.lairWhite, Color.lairWhite]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .frame(width: 100, height: 100)
            .modifier(PercentageIndicator(pct: self.pct))
            .foregroundColor((pct.isNaN || pct.isInfinite) ? .clear : Int(pct.rounded()) == 1 ? .clear : cs == .dark ? .black : .white)
            .overlay(Circle().stroke(style: StrokeStyle(lineWidth: 5)).foregroundColor(.gray).opacity(0.1))
    }
}

struct PercentageIndicator: AnimatableModifier {
    @State var heart = false
    @Environment(\.colorScheme) var cs : ColorScheme
    var pct: CGFloat = 0
    var animatableData: CGFloat {
        get { pct }
        set { pct = newValue }
    }

    func body(content: Content) -> some View {
        content
            .overlay(ArcShape(pct: pct).foregroundColor( cs == .dark ? .neonRed : .neonRed ))
            .overlay(Image(systemName: "heart.fill")
                        .foregroundColor( cs == .dark ? .trackColor : .red )
                        .font(.system(size: 35))
                        .isHidden(Int(pct) == 1)
                        )
                                   
                .overlay(Image(systemName: "star.circle.fill")
                            .foregroundColor( cs == .dark ? .lightGreen : .red )
                    .font(.system(size: Int(pct) == 1 ? 100 : 35))
//                    .rotationEffect(Int(pct) == 1 ? .degrees(360) : .degrees(0))
                    .animation(
                        Animation.easeInOut(duration: 1)
                            .repeatCount(1, autoreverses: true)
                    )
                    .isHidden(Int(pct) < 1)
                       )
                                               
//            .overlay(LabelView(pct: pct))
            
    }
//
//    Image(systemName: "heart.fill").isHidden(Int(pct) == 1)
//            .font(.system(size: 35))
//                   .padding(.init(top: 5, leading: 5, bottom: 10, trailing: 5))
//                   .foregroundColor(Color.red)
//            .scaleEffect(self.heart ? 1.05: 0.95, anchor: .center)
//            .opacity(self.heart ? 1.0: 0.75)
//            .animation(Animation.easeInOut.repeatForever())
//                   .onAppear{
//                       self.heart.toggle()
//               }

    struct ArcShape: Shape {
        let pct: CGFloat

        func path(in rect: CGRect) -> Path {

            var p = Path()

            p.addArc(center: CGPoint(x: rect.width / 2.0, y:rect.height / 2.0),
                     // add +5.0 to radius if you want the progress indicator to be on top of the circle
                     radius: rect.height / 2.0 ,
                     startAngle: .degrees(0),
                     endAngle: .degrees(360.0 * Double(pct)), clockwise: false)

//            return p.strokedPath(.init(lineWidth: 10, dash: [6, 3], dashPhase: 10))
            return p.strokedPath(.init(lineWidth: 7))
        }
    }

    //MARK: HEART + LABEL OVERLAY
    struct LabelView: View {
        let pct: CGFloat
        
        var body: some View {
            ZStack{
//                Text(Int(pct) == 1 ? "" : "\(Int(pct * 100))%")
//                .font(.title3)
//                .fontWeight(.bold)
//                .foregroundColor(.pulsatingColor)
                Image(systemName: Int(pct) == 1 ? "star.circle.fill" : "").animation(.easeOut(duration: 2))
                    .font(.system(size: 75))
                    .foregroundColor(.red)
//                Image(systemName: Int(pct) == 1 ? "sparkles" : "")
//                    .font(.caption)
//                    .foregroundColor(.white)
//                    .animation(.none)
//                    .offset(x: -10, y: -5)
//                    
            
            }
        }
    }
}


//struct ArcView_Previews: PreviewProvider {
//    static var previews: some View {
//        ArcView().environmentObject(DayData())
//    }
//}

















//
//
//
//MARK: LINEAR ARC VIEW
//struct LabelView: View {
//        let waterpct: CGFloat
//    @StateObject var data = DayData()
//        var body: some View {
//            ZStack{
//                Text(self.data.liquids == 64 ? "" : "\(Int(self.data.liquids)) %")
//                .font(.callout)
//                .fontWeight(.bold)
//                .foregroundColor(.white)
//                .contrast(3.0)
//                .shadow(color: .black, radius: 5, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
//                Image(systemName: Int(waterpct) == 1 ? "star.circle.fill" : "").animation(.spring())
//                    .font(.system(size: 35))
//                .foregroundColor(.red)
//            }
//        }
//    }



//struct LinearArcView: View {
//    @State private var percent: CGFloat = 0
//    @StateObject var data = DayData()
//    var body: some View {
//        VStack {
//            Spacer()
//            Color.clear.overlay(
//                WaterIndicator(waterpct: CGFloat(self.data.liquids * (100/64))).environmentObject(DayData())
//
//                WaterIndicator(waterpct: percent)
//
//
//            ).overlay(LabelView(waterpct: CGFloat(self.data.liquids)))
//                .animation(.easeInOut(duration: 0.2))
//
//        }
//    }
//}
//
//struct WaterIndicator: View {
//    var waterpct: CGFloat
//
//    var body: some View {
//        return RoundedRectangle(cornerRadius: 10)
//            .fill(LinearGradient(gradient: Gradient(colors: [Color.outlineColor, Color.trackColor]), startPoint: .topLeading, endPoint: .bottomTrailing))
//            .frame(width: UIScreen.main.bounds.width * CGFloat((1 - waterpct / 64)) , height: 10, alignment: .leading)
//    }
//}
//
//
//
//
//

extension View {
    
    // Hide or show the view based on a boolean value.
    //
    // Example for visibility:
    // ```
    // Text("Label")
    //     .isHidden(true)
    // ```
    //
    // Example for complete removal:
    // ```
    // Text("Label")
    //     .isHidden(true, remove: true)
    // ```
    //
    // - Parameters:
    //   - hidden: Set to `false` to show the view. Set to `true` to hide the view.
    //   - remove: Boolean value indicating whether or not to remove the view.
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}









//            Spacer()
//            HStack(spacing: 10) {
//                Button(action: {
//
//                    withAnimation(.easeInOut(duration: 1.0))
//                        { self.percent = 0 }
//
//                }) { Text("0%").font(.headline) }
//
//                Button(action: {
//
//                    withAnimation(.easeInOut(duration: 1.0))
//                        { self.percent = 0.27 }
//
//                }) { Text("27%").font(.headline) }
//
//                Button(action: {
//
//                    withAnimation(.easeInOut(duration: 1.0))
//                        { self.percent = 1 }
//
//                }) { Text("100%").font(.headline) }
//
//
//            }


//            Spacer()
//            HStack(spacing: 10) {
//                Button(action: {
//
//                    withAnimation(.easeInOut(duration: 1.0))
//                        { self.percent = 0 }
//
//                }) { Text("0%").font(.headline) }
//
//                Button(action: {
//
//                    withAnimation(.easeInOut(duration: 1.0))
//                        { self.percent = 0.27 }
//
//                }) { Text("27%").font(.headline) }
//
//                Button(action: {
//
//                    withAnimation(.easeInOut(duration: 1.0))
//                        { self.percent = 1 }
//
//                }) { Text("100%").font(.headline) }
//
//
//            }

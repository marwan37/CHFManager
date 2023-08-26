//
//  LiquidTaskView.swift
//  Golgi-Splash
//
//  Created by Deeb Zaarab on 2020-11-26.
//

import SwiftUI
import Combine
struct LiquidTaskView: View {
    @EnvironmentObject var data: DayData
    @Environment(\.colorScheme) var cs : ColorScheme
    let columns2 = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    @State var limit: Double = 64
    @State var progress: String = ""
    @State var goal: Double  = 0
    @State var isComplete: Bool = false
    
    @State var isSheetShown = false
    let cols = [GridItem(.fixed(UIScreen.main.bounds.width - 100)), GridItem(.fixed(100))]
    var body: some View {
        //MARK: LIQUIDS TASK VIEW
        ScrollView(.vertical){
        VStack(alignment: .leading){
            
         
            WaterContainer(limit: Int(self.limit))

            Divider()
                        
         
            }.offset(x: 10.0, y: 0)
            
        }
        
      
        
    }
    
    


func limitY(_ upper: Int) {
    if data.value.count > upper {
        data.value = String(data.value.prefix(upper))
    }
}
}


struct LiquidTaskView_Previews: PreviewProvider {
    static var previews: some View {
        LiquidTaskView()
            .environmentObject(DayData())
         
    }
}




//struct InformationCard : View {
//    @State var infoButtonTapped = false
//    var body: some View {
//        VStack{
//            Button(action:{
//                self.infoButtonTapped.toggle()
//            }){
//                Image(systemName: infoButtonTapped ? "chevron.right.circle" : "")
//                    .font(.system(size: 15))
//                    
//                    .foregroundColor(.blue).opacity(0.5)
//            }
//            
//            HStack{
//                Text("1 ")
//                    .fontWeight(.thin)
//                    .font(.title3)
//                    .foregroundColor(.grayText).offset(y: 5)
//                
//                WaterBottleInfo()
//                
//                Image(systemName: "equal.circle")
//                    .foregroundColor(.grayText)
//                    .font(.system(size: 25, weight: .thin)).offset(y: 5)
//                
//                Text("8 fluid ounces")
//                    .font(.title3)
//                    .fontWeight(.thin)
//                    .foregroundColor(.grayText).offset(y: 5)
//                
//                Text("≈ 236 mL")
//                    .font(.title3)
//                    .fontWeight(.thin)
//                    .foregroundColor(.grayText).offset(y: 5)
//            }
//            
//        }
//        //                    .isHidden(infoButtonTapped ? false : true)
//        //                    .rotation3DEffect(.degrees(180), axis: (x: 0.0, y: -1.0, z: 0.0))
//    }
//}

//struct WaterBottle_Previews: PreviewProvider {
//
//    static var previews: some View {
//        VStack{
//            WaterContainer()
////                .environment(\.colorScheme, .light)
//            //            WaterBottle(waterIndex: 0).environmentObject(DayData())
//            //            WaterBottleInfo().environmentObject(DayData())
//        }
//    }
//}
//struct WaterBottle: View {
//    @EnvironmentObject var data: DayData
//    @Environment(\.colorScheme) var cs : ColorScheme
//    //Animation properties
//    var colors: [Color] = [.white, .pulsatingColor, .grayMe, .trackColor]
//    @State var index: Int = 0
//    @State var stateId: [Int] = [0,0,0,0,0,0,0,0]
//    @State var didDrink = false
//    var anime: [SplashShape.SplashAnimation] = [.topToBottom, .bottomToTop]
//    @State var waterIndex: Int
//    var body: some View {
//        VStack(spacing: 2){
//
//            RoundedRectangle(cornerRadius: 3)
//                .frame(width:15, height: 10)
//                .foregroundColor(didDrink ? .goldenYellow : cs == .dark ? Color.sand.opacity(0.6) : .white).animation(.easeInOut(duration: 0.5))
//                .shadow(color: .black, radius: 1, x: 0.0, y: 0.0)
//                .animation(.none)
//
//            Button(action: {
//                self.didDrink.toggle()
//                if self.didDrink{
//                    self.stateId[waterIndex] = 1
//                    self.data.waterIndex[waterIndex] = 1
//
//                    self.data.liquids += 8
//                    self.data.percentage += 0.05
//                } else {
//                    self.stateId[waterIndex] = 0
//                    self.data.waterIndex[waterIndex] = 0
//                    self.data.liquids -= 8
//
//                    self.data.percentage -= 0.05
//                }
//            })
//            {
//                ZStack{
//                    Animations(
//                        animationType: self.anime[ self.stateId[waterIndex]],
//                        color: self.cs == .dark ? self.colors[self.stateId[waterIndex]+2] : self.colors[self.stateId[waterIndex]])
//                        .frame(width: 35, height: 50, alignment: .center)
//                        .cornerRadius(6)
//                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 4)
//
//                }
//
//
//            }.buttonStyle(BorderlessButtonStyle())
//
//        }
//    }
//}


//struct WaterBottleInfo: View {
//
//    var body: some View {
//
//        VStack(spacing: 2){
//
//            RoundedRectangle(cornerRadius: 3)
//                .frame(width:15, height: 10)
//                .foregroundColor(.red)
//                .shadow(color: .black, radius: 1, x: 0.0, y: 0.0)
//            ZStack{
//                RoundedRectangle(cornerRadius: 6)
//                    .frame(width: 35, height: 50, alignment: .center)
//                    .foregroundColor(.blue)
//
//                Text("8oz").font(.caption2).foregroundColor(.white).shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: 2)
//            }
//
//        }
//    }
//}
//


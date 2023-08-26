////
////  MedsTaskView.swift
////  Golgi-Splash
////
////  Created by Deeb Zaarab on 2020-11-25.
////
//
//import SwiftUI
//
//
//struct SymptomsTaskView: View {
//    @EnvironmentObject var data: DayData
//    @State var swellingPresented = false
//    @State var fatiguePresented = false
//    @State var dyspneaPresented = false
//    @Environment(\.colorScheme) var cs : ColorScheme
//    @State var colorIndex = "lht"
//    let rows = [
//        GridItem(.flexible()),
//        GridItem(.flexible()),
//        GridItem(.flexible())
//    ]
//    let recWidth = UIScreen.main.bounds.width - 60
//    let titleOffset: CGFloat = 37
//    let chevyOffset: CGFloat = -45
//
//    @State var opacity = 0.0
//    var textColor: Color {
//        return colorIndex == "light" ? Color.black : Color.gray
//    }
//    var body: some View {
//            //MARK: Swelling question
//           
//                VStack(alignment: .leading, spacing: 10){
//                        HStack{
//                            Image(systemName: "staroflife.circle" )
//                                .font(.system(size: 20, weight: .semibold))
//                                .shadow(color: sxProgress() ? .pulsatingColor : .clear, radius: 5, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
//                                .opacity(0.6)
//                            Text("Symptom Tracker").font(.callout).fontWeight(.bold)
//                                   
//                            }.foregroundColor(self.cs == .dark ? Color.trackColor : Color.pulsatingColor)
//                        .padding(.bottom, 10)
//                   
//                        Button(action: {self.swellingPresented = true})
//                        {
//                      
//                            ZStack{
//                                RoundedRectangle(cornerRadius: 10.0)
//                                    .fill(LinearGradient(gradient: Gradient(colors: [Color.pulsatingColor, Color.trackColor]), startPoint: .topLeading, endPoint: .bottomTrailing))
//                                    .opacity(0.5)
//                                    .frame(width: recWidth, height: 50)
////                                  .foregroundColor( cs == .dark ? Color.tealMe : .white)
//                                    .shadow(color: .black, radius: 1).opacity(0.5)
//                                HStack{
//                                Text("Swelling").font(.callout)
//                                    .font(.system(size: 16, weight: .regular, design: .rounded))
//                                    .foregroundColor(cs == .dark ? Color.sand.opacity(0.8) : .pulsatingColor)
//                                    .offset(x: titleOffset)
//                                    Spacer()
//                                    Text(self.data.swelling)
//                                        .foregroundColor(.pulsatingColor)
//                                        .fontWeight(self.data.swelling != ">" ? .semibold : .regular)
//                                        .offset(x: chevyOffset)
//                                }
//                                    }
//                            .sheet(isPresented: $swellingPresented, content: {
//                                SwellingView(isPresented: self.$swellingPresented)
//                            })
//                        }
//                    
//                //MARK: Dyspnea question
//                    Button(action: {self.dyspneaPresented = true})
//                        {
//                      
//                            ZStack{
//                                RoundedRectangle(cornerRadius: 10.0)
//                                    .fill(LinearGradient(gradient: Gradient(colors: [Color.pulsatingColor, Color.trackColor]), startPoint: .topLeading, endPoint: .bottomTrailing))
//                                    .opacity(0.5)
//                                    .frame(width: recWidth, height: 50)
////                                   .foregroundColor( cs == .dark ? Color.tealMe : .white)
//                                    .shadow(color: .black, radius: 1).opacity(0.5)
//                                HStack{
//                                Text("Shortness of Breath")
//                                    .font(.system(size: 16, weight: .regular, design: .rounded))
//                                    .foregroundColor(cs == .dark ? Color.sand.opacity(0.8) : .pulsatingColor)
//                                    .offset(x: titleOffset)
//                                    Spacer()
//                                    Text(self.data.dyspnea)
//                                        .foregroundColor(.pulsatingColor)
//                                        .fontWeight(self.data.dyspnea != ">" ? .semibold : .regular)
//                                        .offset(x: chevyOffset)
//                                }
//                                    }
//                    }
//                            .sheet(isPresented: $dyspneaPresented, content: {
//                                DyspneaView(isPresented: self.$dyspneaPresented)
//                            })
//                      
//                    
//                //MARK: Fatigue question
//                    Button(action: {self.fatiguePresented = true})
//                        {
//                      
//                            ZStack{
//                                RoundedRectangle(cornerRadius: 10.0)
//                                    .fill(LinearGradient(gradient: Gradient(colors: [Color.pulsatingColor, Color.trackColor]), startPoint: .topLeading, endPoint: .bottomTrailing))
//                                    .opacity(0.5)
//                                    .frame(width: recWidth, height: 50)
////                                   .foregroundColor( cs == .dark ? Color.tealMe : .white)
//                                    .shadow(color: .black, radius: 1).opacity(0.5)
//                                HStack{
//                                Text("Fatigue").font(.system(size: 16, weight: .regular, design: .rounded))
//                                    .foregroundColor(cs == .dark ? Color.sand.opacity(0.8) : .pulsatingColor).offset(x: titleOffset)
//                                    Spacer()
//                                    Text(self.data.fatigue)
//                                        .foregroundColor(.pulsatingColor)
//                                        .fontWeight(self.data.fatigue != ">" ? .semibold : .regular)
//                                        .offset(x: chevyOffset)
//                                }
//                                    }
//                    }
//                    .sheet(isPresented: $fatiguePresented, content: {
//                        FatigueView(isPresented: self.$fatiguePresented)
//                    })
//              
//                      
//                    
//                    
//            }
//        
//        
//    }
//    
//        func sxProgress() -> Bool {
//            var result = false
//            if self.data.swelling != ">" && self.data.dyspnea != ">" && self.data.fatigue != ">" {
//                result = true
//            }
//            return result
//        }
//        
//    
//
//}
//
//struct SymptomsTaskView_Previews: PreviewProvider {
//    static var previews: some View {
//        SymptomsTaskView().environmentObject(DayData())
//    }
//}

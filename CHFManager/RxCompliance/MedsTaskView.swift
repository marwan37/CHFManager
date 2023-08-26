//
//  MedsTaskView.swift
//  Golgi-Splash
//
//  Created by Marwan Zaarab on 2020-11-25.
//

import SwiftUI

struct MedsTaskView: View {
    @Environment(\.colorScheme) var cs : ColorScheme
    @EnvironmentObject var data: DayData
    @State var colorIndex = "lht"
    let columns2 = [
        GridItem(.fixed(UIScreen.main.bounds.midX - 25)),
        GridItem(.fixed(UIScreen.main.bounds.midX - 25))
    ]
    var colors: [Color] = [.clear, Color.trackColor]
    //MARK: RxCompletion Booleans
    var textColor: Color {
        return colorIndex == "light" ? Color.grayText : Color.white
    }
    @State var isComplete : [Bool] = [false, false, false, false, false, false, false, false]
    @State var medColor : Color = Color.lairWhite
    @State var gen : String
    @State var type : String
    @State var qty: Int
    var body: some View {
        VStack(alignment: .leading){
           
            VStack{
//                HStack(spacing: 40){
                    HStack{

                ZStack{
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.lairWhite)
                    .opacity(0.8)
                    .frame(width: ultra > 400 ? ultra / 2 - 40 : ultra / 1.6, height: 85)
//                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 5, x: 0.0, y: 0.0).opacity(0.3)
                    VStack{
                        HStack(spacing:0){
                            Text(gen.lowercased())
                                .font(.system(size: 14, weight: .regular, design: .rounded))
                                .foregroundColor(self.cs == .dark ? medColor.opacity(0.8) : .grayText)
                              
                            Text(" | \(type.lowercased())")
                                .font(.system(size: 11, weight: .light, design: .rounded))
                                .foregroundColor(self.cs == .dark ? medColor.opacity(0.7) : .grayText)
                          Spacer()
                               
                       }.padding(.leading, 15)
//                        Spacer()
                        HStack{
                        ForEach(0..<qty, id:\.self) { m in
                            
                            
                            if m < 6 {
                        Button(action:{
                            let dqty = Double(qty)
                            self.isComplete[m].toggle()
                            if self.isComplete[m] {
                                self.data.howMany += 1/dqty
                                self.data.percentage += data.rxQty / Double(m + 1)
                                      } else {
                                        self.data.percentage -= data.rxQty / Double(m + 1)
                                            if self.data.howMany > 0 {
                                                self.data.howMany -= 1/dqty
                                            }
                                        }
                        }){
                            ZStack{
                                Image(systemName: self.isComplete[m] ? "circle.fill" : "circle")
                                    .font(.system(size: qty > 1 ? ( qty < 3 ? 35 : 25) : 40, weight: .ultraLight))
                              
                                Image(systemName: self.isComplete[m] ? "checkmark" : "")
                                    .font(.system(size: qty > 1 ? ( qty < 3 ? 18 : ( qty > 4 ? 10 : 15)) : 21, weight: .regular))
                                .foregroundColor(.white)
                            }
//                            .offset(x: -2)
                        }
                        }
                        }
                        }
                    }.frame(width: ultra > 400 ? ultra / 2 - 20 : ultra / 1.6, height: 85)

                }
                    
                }
         
            }

        }.foregroundColor(self.cs == .dark ? Color.trackColor : Color.grayText)
        .onAppear {
            var arrayBool : [Bool] = []
            for i in 0..<qty {
                if i < 6 {
                arrayBool.append(false)
                self.isComplete = arrayBool
                }
            }
        }
    }
 

}

struct MedsTaskView_Previews: PreviewProvider {
    
    static var previews: some View {
        MedsTaskView(gen:"Lisinopril", type:"ACE inhibitor", qty: 5).environmentObject(DayData())
//            .preferredColorScheme(.dark)
//            .previewLayout(.sizeThatFits)
    }
}

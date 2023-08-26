//
//  LinearProgressView.swift
//  Golgi-Splash
//
//  Created by Marwan Zaarab on 2020-11-25.
//
import SwiftUI

struct ProgressBar: View {
   var value: Float
   
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 45)
                    .frame(width: geometry.size.width , height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color(UIColor.systemTeal))
                LinearGradient.lairHorizontalLight
                  .frame(height: 14)
                  .mask(Capsule())
                  .opacity(0.7)
                ZStack{
                    
                    LinearGradient.init(Color.cap)
                    .frame(width: min(CGFloat(value / 100)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(.cap)
                        .mask(
                          Capsule()
                            .padding(.horizontal, 2)
                      )
                    .animation(.linear).cornerRadius(45.0)
                    Image(systemName: value == 100 ? "checkmark" : "")
                        .foregroundColor(.white)
                }
            }
        }
    }
}
struct  LinearProgressView: View {
    @State var progressValue: Float
  
    var body: some View {
        VStack {
            HStack {
              Text("Progress")
                .foregroundColor(.lairDarkGray)
                .bold()
              Spacer()
                
                Text("\(Int(progressValue))%")
                .foregroundColor(.lairDarkGray)
                .bold()
            }
            
            ProgressBar(value: Float(progressValue)).frame(height: 20)

        }.padding()
    }
 
}

//struct LinearProgressView_Previews : PreviewProvider {
//    static var previews: some View {
//        LinearProgressView(progressValue: 25)
//    }
//}

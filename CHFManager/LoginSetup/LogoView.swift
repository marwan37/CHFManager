//
//  SwiftUIView23.swift
//  Golgi-Splash
//
//  Created by Marwan Zaarab on 2021-01-26.
//

import SwiftUI

struct SwiftUIView23: View {
    let size: CGFloat = 37
    let size2:CGFloat = 25
let w: CGFloat = 80
let d: CGFloat = 80
  
    var body: some View {
        
        ZStack{
            LinearGradient.init(Color("ColorNeuro")).edgesIgnoringSafeArea(.all)
        VStack {
            LinearGradient(gradient: .init(colors: [.red, .red]), startPoint: .topLeading, endPoint: .bottomTrailing)            .mask(Image("drawheart").resizable().scaledToFit())
            .frame(width: 150, height: 150)
            .padding(40)
            .font(.system(size: 150, weight: .thin))
            .shadow(color: .white, radius: 2, x: -3, y: -3)
            .shadow(color: .lairShadowGray, radius: 2, x: 3, y: 3)
                
          
//            HStack(spacing: 0){
//                Text("CHF").font(.system(size: 25, weight:.bold, design:.rounded))
//        Text("manager").font(.system(size:  25, weight:.thin, design:.rounded))
//            }
//            .padding(.trailing, ultra > 400 ? 55 : 29)
//            .padding(.leading)
//            .padding(.bottom)
//            .opacity(0.5)
        }
        .frame(width: 230)
//        .overlay(
//          RoundedRectangle(cornerRadius: 15)
//            .stroke(LinearGradient.init(Color.white), lineWidth: 2)
//        )
//          .background(Color.lairBackgroundGray)
          .cornerRadius(15)
//          .shadow(color: Color(white: 1.0).opacity(0.9), radius: 3, x: -2, y: -2)
//          .shadow(color: Color.lairShadowGray.opacity(0.5), radius: 14, x: 14, y: 14)
        .overlay(LinearGradient.init(Color.white).mask(Image("art5")
                    .resizable().scaledToFit())
//                    .shadow(color: Color.red.opacity(0.5), radius: 3, x: 2, y: 2)
                    .offset(x:10, y: 5).opacity(1)
                        
        .frame(width:w, height: w))
        
        .overlay(LinearGradient.init(Color.white).mask(Image("vein1")
                    .resizable().scaledToFit())
                    .rotation3DEffect(
                        .init(degrees: 180),
                        axis: (x: 1.0, y: -0.1, z: 0.0))
                    .opacity(0.0)
                    .offset(x:-5, y: -5)
//                    .shadow(color:  Color.blue.opacity(1), radius: 2, x: -2, y: -2)
        .frame(width: d, height: d)
        
        )
        }
    }
}

struct SwiftUIView23_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView23()
            
    }
}

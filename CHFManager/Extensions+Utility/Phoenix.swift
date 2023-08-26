//
//  Phoenix.swift
//  Golgi-Splash
//
//  Created by Deeb Zaarab on 2021-01-02.
//

import SwiftUI

struct Phoenix: View {
    @State var rise = false
    @State var image = "arrowheart"
    
    var body: some View {
      VStack {
        LinearGradient.lairHorizontalDark
            .mask(Image(systemName: "heart").resizable().scaledToFit())
          .frame(width: 150, height: 150)
          .padding(40)
          .font(.system(size: 150, weight: .thin))
//          .shadow(color: .white, radius: 2, x: -3, y: -3)
          .shadow(color: .lairShadowGray, radius: 2, x: 3, y: 3)
        
//        HStack {
//          Text("CHF Manager")
//            .foregroundColor(.lairDarkGray)
//            .bold()
//            .padding(.leading)
//            .padding(.bottom)
//          Spacer()
//        }
      }
//      .frame(width: 230)
//      .overlay(
//        RoundedRectangle(cornerRadius: 15)
//          .stroke(LinearGradient.lairDiagonalDarkBorder, lineWidth: 2)
//      )
//        .background(Color.lairBackgroundGray)
//        .cornerRadius(15)
//        .shadow(color: Color(white: 1.0).opacity(0.9), radius: 18, x: -18, y: -18)
//        .shadow(color: Color.lairShadowGray.opacity(0.5), radius: 14, x: 14, y: 14)
    }
  }

struct Phoenix_Previews: PreviewProvider {
    static var previews: some View {
        Phoenix()
    }
}
// HEART
//
//ZStack{
//    LinearGradient(gradient: .init(colors: [.red, .lairWhite]), startPoint: .topLeading, endPoint: .bottomTrailing)
//        .mask(Image(systemName: "heart.fill")
//                .font(.system(size: 125))
//                .padding(.init(top: 5, leading: 5, bottom: 10, trailing: 5))
//                .scaleEffect(self.heart ? 1.05: 1.03, anchor: .center)
//                .opacity(self.heart ? 1.0: 0.97))
//        .onAppear() {
//            DispatchQueue.main.async {
//                withAnimation(Animation.easeInOut(duration:1).repeatForever(autoreverses: false)) {
//                self.heart.toggle()
//                }
//            }
//        }
//}.frame(width: 130, height: 130)
//

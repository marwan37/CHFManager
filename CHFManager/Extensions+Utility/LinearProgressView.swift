//
//  LinearProgressView.swift
//  Golgi-Splash
//
//  Created by Deeb Zaarab on 2020-11-25.
//
import SwiftUI

struct ProgressBar: View {
   var value: Float
    @StateObject var data = DayData()
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 45).frame(width: geometry.size.width , height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color(UIColor.systemTeal))
                
                ZStack{
                Rectangle().frame(width: min(CGFloat(self.data.liquids / 64)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(.blue)
                    .animation(.linear).cornerRadius(45.0)
                    Image(systemName: self.data.liquids == 64 ? "checkmark" : "")
                        .foregroundColor(.white)
                }
            }
        }
    }
}
struct  LinearProgressView: View {
    @State var progressValue: Float = 0.0
    @StateObject var data = DayData()
    var body: some View {
        VStack {
            ProgressBar(value: Float(self.data.liquids)).frame(height: 20)
          
//            HStack{
//            Button(action: {
//                self.startProgressBar()
//            }) {
//                Text("Start Progress")
//            }.padding()
//            
//            Button(action: {
//                self.resetProgressBar()
//            }) {
//                Text("Reset")
//            }
//            }
//            
//            Spacer()
        }.padding()
    }
    
    func startProgressBar() {
        for _ in 0...80 {
            self.data.liquids += 5
        }
    }
    
    func resetProgressBar() {
        self.data.liquids = 0.0
    }
}

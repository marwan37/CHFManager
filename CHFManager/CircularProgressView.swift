//
//  CircularProgressView.swift
//  Golgi-Splash
//
//  Created by Deeb Zaarab on 2020-11-24.
//

import SwiftUI
var width: CGFloat = 100
var height: CGFloat = 100

struct CircularProgressView: View {
    @EnvironmentObject var symptoms: Symptoms
    @State private var pulsate = false
    
    var countTo: Double = 100.0

    var colors: [Color] = [Color.pulsatingColor]
    var trackColors: [Color] = [Color.trackColor]
    var outlineColors: [Color] = [Color.outlineColor]
    var body: some View {
        ZStack {
//            Color.backgroundColor
//                .edgesIgnoringSafeArea(.all)
            VStack{
//                Spacer()
                ZStack{
                    //PULSATE
                    ZStack {
                        Circle()
                            .fill(Color.pulsatingColor)
                            .frame(width: width - 5, height: height - 5)
                            .scaleEffect(pulsate ? 1.3 : 1.1)
                            .animation(Animation.easeInOut(duration: 1.1).repeatForever(autoreverses: true))
                            .onAppear {
                                self.pulsate.toggle()
                            }
                        
                    }
                    //TRACK
                    ZStack {
                        Circle()
                            .fill(Color.clear)
                            .frame(width: width, height: height)
                            .overlay(Circle()
                                        .stroke(style: StrokeStyle(lineWidth: 5))
                                        .fill(AngularGradient(gradient: .init(colors: trackColors), center: .center))
                            )
                    }
                    //LABEL
                    ZStack {
                        Text("\(Int(self.symptoms.percentage))%")
                            .font(.system(size: 35))
                            .fontWeight(.regular).colorInvert()
                    }
                    //OUTLINE
                    ZStack{
                        Circle()
                            .fill(Color.clear)
                                    .frame(width: width, height: height)
                                    .overlay(
                        Circle().trim(from:0, to: progress())
                                            .stroke(
                        style: StrokeStyle(
                        lineWidth: 5,
                        lineCap: .round,
                        lineJoin:.round
                                                )
                                        )
                                            .foregroundColor(
                                                (completed() ? Color.green : Color.outlineColor)
                                        ).animation(
                                            .easeInOut(duration: 0.7)
                                        )
                                )

                    }
                    
                }
            }
        }
    }
    
    func completed() -> Bool {
    return progress() == 1
        }
    func progress() -> CGFloat {
        return (CGFloat(self.symptoms.percentage) / CGFloat(countTo))
        }
}


//MARK: PREVIEWS
struct CircularProgressView_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
        CircularProgressView().environmentObject(Symptoms())
 
        }
    }
}


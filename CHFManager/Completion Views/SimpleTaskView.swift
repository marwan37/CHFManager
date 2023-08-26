//
//  SimpleTaskView.swift
//  Golgi-Splash
//
//  Created by Deeb Zaarab on 2020-11-29.
//

import SwiftUI

struct SimpleTaskView: View {
    @EnvironmentObject var data: DayData
    @State var title: String
    @State var detail: String
    @State var isComplete: Bool
        
    var body: some View {
        
        VStack{
            HStack{
            ZStack{
            RoundedRectangle(cornerRadius: 10)
                .frame(width: UIScreen.main.bounds.width / 2 - 50, height: 70)
                .foregroundColor(.white)
                .shadow(color: .black, radius: 5, x: 0.0, y: 0.0).opacity(0.3)
                HStack{
                    VStack(alignment: .leading){
                        Text(title)
                            .fontWeight(.regular)
                            .foregroundColor(.pulsatingColor)
                            .offset(x: 5)
                        Text(detail)
                            .font(.caption)
                            .fontWeight(.light)
                            .foregroundColor(.pulsatingColor)
                            .offset(x: 5)
                    }
                    Spacer()
                    Button(action:{
                        self.isComplete.toggle()
                        if isComplete {
                            self.data.howMany += 1
                            self.data.percentage += 0.1
                                  } else {
                                      self.data.percentage -= 0.1
                                        if self.data.howMany > 0 {
                                            self.data.howMany -= 1
                                        }
                                    }
                    }){
                        ZStack{
                        Image(systemName: isComplete ? "circle.fill" : "circle")
                            .font(.system(size: 45, weight: .ultraLight))
                            .foregroundColor(.pulsatingColor)
                        Image(systemName: isComplete ? "checkmark" : "")
                            .font(.system(size: 25, weight: .regular))
                            .foregroundColor(.white)
                        }.offset(x: -2)
                    }
                }.frame(width: UIScreen.main.bounds.width / 2 - 50, height: 70)
            }
                ZStack{
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: UIScreen.main.bounds.width / 2 - 50, height: 70)
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 5, x: 0.0, y: 0.0).opacity(0.3)
                    HStack{
                        VStack(alignment: .leading){
                            Text(title)
                                .fontWeight(.regular)
                                .foregroundColor(.pulsatingColor)
                                .offset(x: 5)
                            Text(detail)
                                .font(.caption)
                                .fontWeight(.light)
                                .foregroundColor(.pulsatingColor)
                                .offset(x: 5)
                        }
                        Spacer()
                        Button(action:{
                            self.isComplete.toggle()
                            if isComplete {
                                self.data.howMany += 1
                                self.data.percentage += 0.1
                                      } else {
                                          self.data.percentage -= 0.1
                                            if self.data.howMany > 0 {
                                                self.data.howMany -= 1
                                            }
                                        }
                        }){
                            ZStack{
                            Image(systemName: isComplete ? "circle.fill" : "circle")
                                .font(.system(size: 45, weight: .ultraLight))
                                .foregroundColor(.pulsatingColor)
                            Image(systemName: isComplete ? "checkmark" : "")
                                .font(.system(size: 25, weight: .regular))
                                .foregroundColor(.white)
                            }.offset(x: -2)
                        }
                    }.frame(width: UIScreen.main.bounds.width / 2 - 50, height: 70)
                }
            }
            HStack{
            ZStack{
            RoundedRectangle(cornerRadius: 10)
                .frame(width: UIScreen.main.bounds.width / 2 - 50, height: 70)
                .foregroundColor(.white)
                .shadow(color: .black, radius: 5, x: 0.0, y: 0.0).opacity(0.3)
                HStack{
                    VStack(alignment: .leading){
                        Text(title)
                            .fontWeight(.regular)
                            .foregroundColor(.pulsatingColor)
                            .offset(x: 5)
                        Text(detail)
                            .font(.caption)
                            .fontWeight(.light)
                            .foregroundColor(.pulsatingColor)
                            .offset(x: 5)
                    }
                    Spacer()
                    Button(action:{
                        self.isComplete.toggle()
                        if isComplete {
                            self.data.howMany += 1
                            self.data.percentage += 0.1
                                  } else {
                                      self.data.percentage -= 0.1
                                        if self.data.howMany > 0 {
                                            self.data.howMany -= 1
                                        }
                                    }
                    }){
                        ZStack{
                        Image(systemName: isComplete ? "circle.fill" : "circle")
                            .font(.system(size: 45, weight: .ultraLight))
                            .foregroundColor(.pulsatingColor)
                        Image(systemName: isComplete ? "checkmark" : "")
                            .font(.system(size: 25, weight: .regular))
                            .foregroundColor(.white)
                        }.offset(x: -2)
                    }
                }.frame(width: UIScreen.main.bounds.width / 2 - 50, height: 70)
            }
                ZStack{
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: UIScreen.main.bounds.width / 2 - 50, height: 70)
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 5, x: 0.0, y: 0.0).opacity(0.3)
                    HStack{
                        VStack(alignment: .leading){
                            Text(title)
                                .fontWeight(.regular)
                                .foregroundColor(.pulsatingColor)
                                .offset(x: 5)
                            Text(detail)
                                .font(.caption)
                                .fontWeight(.light)
                                .foregroundColor(.pulsatingColor)
                                .offset(x: 5)
                        }
                        Spacer()
                        Button(action:{
                            self.isComplete.toggle()
                            if isComplete {
                                self.data.howMany += 1
                                self.data.percentage += 0.1
                                      } else {
                                          self.data.percentage -= 0.1
                                            if self.data.howMany > 0 {
                                                self.data.howMany -= 1
                                            }
                                        }
                        }){
                            ZStack{
                            Image(systemName: isComplete ? "circle.fill" : "circle")
                                .font(.system(size: 45, weight: .ultraLight))
                                .foregroundColor(.pulsatingColor)
                            Image(systemName: isComplete ? "checkmark" : "")
                                .font(.system(size: 25, weight: .regular))
                                .foregroundColor(.white)
                            }.offset(x: -2)
                        }
                    }.frame(width: UIScreen.main.bounds.width / 2 - 50, height: 70)
                }
            }
        }
    }
}

struct SimpleTaskView_Previews: PreviewProvider {
    static var previews: some View {
        SimpleTaskView(title: "Lisinopril", detail: "Ace Inhibitor", isComplete: false).environmentObject(DayData())
    }
}

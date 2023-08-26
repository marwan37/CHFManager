//
//  AnswerView.swift
//  Golgi-Splash
//
//  Created by Marwan Zaarab on 2020-12-14.
//

import SwiftUI
import Shapes


struct AnswerView: View {
    @EnvironmentObject var presentationManager : PresentationManager
    let columns = [
        GridItem(.fixed(150)),
        GridItem(.fixed(150))
    ]
    let count = 1...10
    @Environment(\.colorScheme) var cs: ColorScheme
    @EnvironmentObject var data : NYHAQuestions
    @Binding var answerSelected: String
    @Binding var sliderAnswerSelected: Double
    @State var score: Int = 0
    @Binding var answered: Int
    @State var activeHidden = [1, 5, 8, 14, 17]
   @State var buttonsTapped = [false, false, false, false, false, false]
    @State var choices = ["Never", "Rarely","Sometimes","Frequently"]
    @State var mycolor : Color = Color("ColorNeuro").opacity(0.8)
    @State var val: Double = 0
    var totalWidth = UIScreen.main.bounds.width - 60
    @State var sliderAnswer = ""
    var body: some View {
        
//    VStack{
        ZStack{
            
            VStack {
                VStack{
                    
                    Text("Value")
                        .font(.title)
                        .fontWeight(.bold)
                    
                  
                    Text("\(Int(sliderAnswerSelected))")
                        .fontWeight(.bold)
                        .padding(.top)
                    
                    LSlider($sliderAnswerSelected, range: 0...10)
                        .linearSliderStyle(MySliderStyle())
                        .frame(width: UIScreen.main.bounds.width - 80)
                        .shadow(color: Color.black.opacity(0.5), radius: 3, x: 3, y:3)
                       
                    
                }
                .padding()
                
            }.isHidden(self.presentationManager.activeScreen != 19)

//MARK: NEVER/RARELY/SOMETIMES/FREQUENTLY
        VStack(spacing: 10){

            
            ForEach(choices.indices) { choice in
                
                Button(action:{
                    self.data.isSubmitted = false
                    self.answerSelected = choices[choice]
                    self.buttonsTapped[choice].toggle()
                    for i in 0..<buttonsTapped.count {
                        if i != choice {
                            self.buttonsTapped[i] = false
                        }
                    }
                })
                {
                    ZStack{
//                        RoundedRectangle(cornerRadius: 10)
//                            .fill(buttonsTapped[choice] ? (self.data.isSubmitted ? .cap : mycolor) : Color.clear)
//                            .frame(width: ultra - 100, height: 60)
//
                        
                        HStack{
                            Image(systemName: (buttonsTapped[choice]) ? "circle.fill" : "circle")
                                .foregroundColor(buttonsTapped[choice] && data.isSubmitted ? .blue : Color.textColor(for: cs))
                                .opacity(0.5)
                                .padding(.leading, 15)
                            Text(choices[choice])
                                
                                .fontWeight(buttonsTapped[choice] ? Font.Weight.semibold : .light)
                                .padding(.leading, 15)
                                .foregroundColor(buttonsTapped[choice] && data.isSubmitted ? .blue : Color.textColor(for: cs))
//                                .offset(x: 15)
                               
                            Spacer()
                         
                        }
                  
                        .frame(width: ultra - 80, height: 60)
                        .padding(.horizontal,20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(buttonsTapped[choice] && self.data.isSubmitted ? .cap : Color.clear, lineWidth: 1)
                                
                                .frame(width: ultra - 80)
                    )
                    }.frame(width: ultra - 80, height: 60)

                }.padding(.horizontal)
//                .buttonStyle(OtherModifie5(color: self.data.isSubmitted && buttonsTapped[choice] ? .cap : mycolor, r: 10))
               
                
            }
            
     


        }.isHidden(!checkHidden() || self.presentationManager.activeScreen == 19)
        .padding(.horizontal)
//MARK: NO/YES answers
            VStack(spacing:10){
//                RoundedRectangle(cornerRadius: 10)
//                    .frame(width: UIScreen.main.bounds.width, height: 0.4).foregroundColor(.grayMe).opacity(0.5)
//                .shadow(color: Color.gray.opacity(0.5), radius: 2, x: 0.0, y: 0.0)
            Button(action:{
                self.answerSelected = "No"
                self.data.isSubmitted = false
                self.buttonsTapped[4].toggle()
                
                for i in 0..<buttonsTapped.count {
                    if i != 4 {
                        self.buttonsTapped[i] = false
                    }
                }
            })
            {
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .fill(buttonsTapped[4] ? (self.data.isSubmitted ? Color.cap : mycolor) : Color.clear)
                        .frame(width: ultra - 100, height: 60)
                       
                    HStack{
                        Image(systemName: buttonsTapped[4] ? "circle.fill" : "circle")
                            .foregroundColor(buttonsTapped[4] && data.isSubmitted ? .white : .grayText)
                            
                            .opacity(0.5)
                            .padding(.leading, 15)
                        Text("No")
                            .fontWeight(buttonsTapped[4] ? Font.Weight.semibold : .light)
                            .padding(.leading, 15)
                            .foregroundColor(buttonsTapped[4] && data.isSubmitted ? .white : .grayText)
                        
                        Spacer()
                       
                    }
                    .frame(width: ultra - 100, height: 60)
                    .padding(.horizontal,20)
                        
                }.frame(width: ultra - 100, height: 60)
               
                
            }.padding(.horizontal)
            .buttonStyle(OtherModifie5(color: data.isSubmitted && buttonsTapped[4] ? .cap : mycolor, r: 9))
                
                
//            Rectangle().frame(width: UIScreen.main.bounds.width, height: 0.4).foregroundColor(.grayMe).opacity(0.5)
//                .shadow(color: Color.gray.opacity(0.5), radius: 2, x: 0.0, y: 0.0)
                    
            Button(action:{
                self.data.isSubmitted = false
                self.answerSelected = "Yes"
                self.buttonsTapped[5].toggle()
                for i in 0..<buttonsTapped.count {
                    if i != 5 {
                        self.buttonsTapped[i] = false
                    }
                }
                
            })
            {
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .fill(buttonsTapped[5] ? (self.data.isSubmitted ? Color.cap : mycolor) : Color.clear)
                        .frame(width: ultra - 100, height: 60)
                        
                      
                    HStack{
                        Image(systemName: buttonsTapped[5] ? "circle.fill" : "circle")
                            .foregroundColor(buttonsTapped[5] && data.isSubmitted ? .white : .grayText)
                            .padding(.leading, 15)
                            .opacity(0.5)
                        Text("Yes")
                            .fontWeight(buttonsTapped[5] ? Font.Weight.semibold : .light)
                            .padding(.leading, 15)
                            .foregroundColor(buttonsTapped[5] && data.isSubmitted ? .white : .grayText)
                        Spacer()
                       
                    } .frame(width: ultra - 100, height: 60)
                    .padding(.horizontal,20)
                        
                }.frame(width: ultra - 100, height: 60)
              
                
            }.padding(.horizontal)
            .buttonStyle(OtherModifie5(color: data.isSubmitted && buttonsTapped[5] ? .cap : mycolor, r : 10))
            
        }
        .isHidden(checkHidden() || self.presentationManager.activeScreen == 19)
        
        }.font(.system(size: 20, weight: .semibold, design: .rounded))
          
            
           
   
//        }
    }
    
    func sliderToStringAnswer(_ value: Int) -> String {
        self.answerSelected = String(value)
        return answerSelected
            
    }
    
//    func getValue(val: CGFloat) -> String {
//        return String(format: "%.0f", val * 10)
//    }
//
//    func getResult(){
//        let first = self.width / self.totalWidth
//        let second = self.width1 / self.totalWidth
//       let average = Int((first + second) / 2 * 10)
//        self.answerSelected = String(average)
//    }
    
    func checkHidden() -> Bool {
        var result = true
        if self.activeHidden.contains(presentationManager.activeScreen) {
            result = false
        } else {
            result = true
        }
        return result
    }
    
   
 
}

struct AnswerView_Previews: PreviewProvider {
    static var previews: some View {
        AnswerView(answerSelected: .constant("No"), sliderAnswerSelected: .constant(5), answered: .constant(5)).environmentObject(NYHAQuestions()).environmentObject(PresentationManager())
    }
}
struct MySliderStyle : LSliderStyle {
    func makeThumb(configuration:  LSliderConfiguration) -> some View {
              Circle()
                  .fill(configuration.isActive ? Color.yellow : Color.blue)
                  .frame(width: 40, height: 40)
               
        
    }
    
          func makeTrack(configuration:  LSliderConfiguration) -> some View {
              let style: StrokeStyle = .init(lineWidth: 10, lineCap: .round, lineJoin: .round, miterLimit: 0, dash: [], dashPhase: 0)
              return AdaptiveLine(angle: configuration.angle)
                  .stroke(Color.gray, style: style)
                  .overlay(AdaptiveLine(angle: configuration.angle).trim(from: 0, to: CGFloat(configuration.pctFill)).stroke(Color.blue, style: style))
          }
    

        
}


//
//  QuestionView.swift
//  Quiz
//
//  Created by Balaji on 28/11/20.
//

import SwiftUI
//import Firebase
import CoreData

struct QuestionView: View {
    @EnvironmentObject var presentationManager : PresentationManager
    @Environment(\.colorScheme) var cs
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var present
    @State var answered: Int = 0
    @State var activeNever = [0, 4, 7, 13, 16]
    @State var yesNoSkippers = [1, 5, 8, 14, 17]
    @EnvironmentObject var data : NYHAQuestions
    @State var answerSelected: String = ""
    @Binding var scoreIndex: Int
    @Binding var monthString: String
    let rows = [
        GridItem(.fixed(ultra/3)),
        GridItem(.fixed(300)),
        GridItem(.adaptive(minimum: 70, maximum: 100)),
        GridItem(.adaptive(minimum: 70, maximum: 100))
    ]
    @State var sliderAnswerSelected: Double = 0
    var body: some View {
        ZStack{
            Color.backgroundColor(for: cs).edgesIgnoringSafeArea(.all)
            if data.questions.isEmpty{
                
                ProgressView()
            }
            else{
                
                if answered == data.questions.count{
                    
                    VStack(spacing: 25){
                        
                        Image("goodjob3")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 250, height: 250)
                        
                        Text("Well Done!")
                            .font(.title)
                            .fontWeight(.heavy)
                            .foregroundColor(.black)
                        
                        
                        Button(action: {
                            // closing sheet....
                            let scoreData = Score(context: self.moc)
                            scoreData.scoreIndex = self.scoreIndex
                            scoreData.score = self.data.scores.reduce(0, +)
                            scoreData.month = self.monthString
                         
                            self.saveMoc()
                            
                            
                            present.wrappedValue.dismiss()
                            answered = 0
                            
                        }, label: {
                            Text("Go to Home")
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 150)
                                .background(Color.blue)
                                .cornerRadius(15)
                        })
                    }
                }
                else{
//
//                    VStack(alignment: .leading, spacing: 22){
//                        Button(action:{
//                            print("indexNYHA questionView \(self.scoreIndex)")
//                            answered = data.questions.count - 1
//                            presentationManager.activeScreen = 19
//                            let scoreData = Score(context: self.moc)
//
//                            scoreData.scoreIndex = self.scoreIndex
//                            scoreData.score = 27
//
//                            scoreData.month = self.monthString
//
//                            self.saveMoc()
//                            present.wrappedValue.dismiss()
//                            answered = 19
//                        }){
//                            Text("Complete")
//                        }
                        LazyHGrid(rows: rows) {
                            ForEach(data.questions.indices) { index in
                        
                                
            // QUESTION
                                if presentationManager.activeScreen == index {
                                    Text(data.questions[presentationManager.activeScreen])
                                        .font(.system(size: 22, weight: .regular, design:.rounded))
                                        .foregroundColor(Color.textColor(for: cs))
                                        .frame(width: UIScreen.main.bounds.width - 80)
                                        .padding(.bottom, 15).padding(.top, 50)
                                        
                                        .fixedSize(horizontal: true, vertical: true)
//                                        .shadow(color: Color.black.opacity(0.2), radius: 3, x: -2, y: 2)
                                        .onAppear {
                                            print("presentationManagerActiveScreen: \(presentationManager.activeScreen)")
                                            print("index, presentation : \(index)")
                                        }
                                        .padding(.top, 45)
                                        
//                                    Divider()
            // ANSWER
                                    AnswerView(answerSelected: $answerSelected, sliderAnswerSelected: $sliderAnswerSelected, answered: $answered)
//                                        .frame(width: UIScreen.main.bounds.width, height: 300)
                                        .padding(.top, 95)
                                    
                                   
                  
        // PROGRESS VIEW
                                  
                                    
        // SUBMIT BUTTON & NEXT
                                    HStack(spacing: 15){
                                        Spacer()
                                        Button(action: {
                                           checkAns()
                                            
                                        }) {
                                            Text("submit")
                                                .foregroundColor(.white)
                                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                                .padding(10)
                                                .frame(width: 120, height: 50)
                                        }.buttonStyle(OtherModifie5(color: .cap, r: 25))
                                        // disabling...
                                        .disabled(data.isSubmitted ? true : false)
//                                        .disabled(sliderAnswerSelected == 0 && self.presentationManager.activeScreen != 19)
                                        .opacity(answerSelected == "" && presentationManager.activeScreen != 19 ? 0.7 : 1)
                                        .opacity(data.isSubmitted ? 0.7 : 1)
                                        
                                        Spacer()
                                        Button(action: {
                                            withAnimation(.linear(duration: 0.1)){
                                             
                                                data.completed.toggle()
                                                answered += 1
                                                data.isSubmitted = false
                                                if self.activeNever.contains(index) && self.answerSelected == "Never" {
                                                    self.presentationManager.activeScreen += 1
        
                                                } else if self.activeNever.contains(index) && self.answerSelected != "Never"  {
                                                    self.presentationManager.activeScreen += 2
                                                    self.answered += 1
                                                } else if index == 1 {
                                                    self.presentationManager.activeScreen += 3
                                                    self.answered += 2
                                                } else if index == 5 {
                                                    self.presentationManager.activeScreen += 2
                                                    self.answered += 1
                                                } else if index == 8 {
                                                    self.presentationManager.activeScreen += 4
                                                    self.answered += 3
                                                } else if index == 14 {
                                                    self.presentationManager.activeScreen += 2
                                                    self.answered += 1
                                                } else if index == 17 {
                                                    self.presentationManager.activeScreen += 2
                                                    self.answered += 1
                                                }
                                                
                                                else {
                                                    self.presentationManager.activeScreen += 1
                                                }
                                               
                                                answerSelected = ""
                                            }
                                        }, label: {
                                            Text("next")
                                                .foregroundColor(.white)
                                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                                .padding(10)
                                                .frame(width: 120, height: 50)
                                        }).buttonStyle(OtherModifie5(color: data.isSubmitted ? .green : .cap, r: 24))
                                        .disabled(!data.isSubmitted ? true : false)
                                        .opacity(!data.isSubmitted ? 0.7 : 1)
                                       
                                        Spacer()
                                    } .padding(.top, 95)
//                                    .padding(.horizontal)
//                                    .padding(.bottom)
                                    
                                    
                                    HStack {
                                        Spacer()
                                        ProgressViewCustom
                                        Spacer()
                                    } .padding(.top, 95)
                                }
                                    
                                
                            }
                            
                        }
                        
                        
//                    }
                
//                .padding()
//                    .background(Color.white)
//                    .cornerRadius(25)
//                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
//                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
                
                }
                }
        }
    }
    var ProgressViewCustom : some View {
        GeometryReader { geometry in
            let percent = (answered/data.questions.count)
              VStack {
                HStack {
                  Text("Progress")
                    .foregroundColor(.lairDarkGray)
                    .bold()
                  Spacer()
                    
//                    Text("\(Int(percent*100))%")
//                    .foregroundColor(.lairDarkGray)
//                    .bold()
                }
                ZStack(alignment: .leading) {
                  ZStack {
                    Capsule()
                      .frame(height: 14)
                      .foregroundColor(Color(white: 0.8))
                    LinearGradient.lairHorizontalLight
                      .frame(height: 14)
                      .mask(Capsule())
                      .opacity(0.7)
                  }
                  
                  ZStack {
                    LinearGradient.lairHorizontalLight
                        .frame(
                          width: progress(),
                          height: 10)
                      .mask(
                        Capsule()
                          .padding(.horizontal, 2)
                    )
                    LinearGradient.init(gradient: Gradient(colors: [Color.cap, Color.green]), startPoint: .leading, endPoint: .trailing)
                        .frame(
                          width: progress(),
                          height: 10)
                      .mask(
                        Capsule()
                          .padding(.horizontal, 2)
                    )
                      .opacity(0.7)
                  }
                  .shadow(color: Color.black.opacity(0.5), radius: 2, x: 0, y: 1)
                }
                .clipShape(Capsule())
              }
              .padding(.horizontal)
        }.frame(width: UIScreen.main.bounds.width - 50, height: 50)
    }
    
    
    func checkAns(){
        let initialQs = [0,4,7,12,13,16]
        
        if initialQs.contains(presentationManager.activeScreen) {
            self.data.scores[presentationManager.activeScreen] = 1
        }
        else {
            if self.answerSelected == "Never" {
                self.data.scores[presentationManager.activeScreen] = 1
            } else if self.answerSelected == "Rarely" {
                self.data.scores[presentationManager.activeScreen] = 2
            } else if self.answerSelected == "Sometimes" {
                self.data.scores[presentationManager.activeScreen] = 3
            } else if self.answerSelected == "Frequently" {
                self.data.scores[presentationManager.activeScreen] = 4
            } else if self.answerSelected == "Yes" {
                self.data.scores[presentationManager.activeScreen] = 4
            } else if self.answerSelected == "No" {
                self.data.scores[presentationManager.activeScreen] = 0
            }
            
            if self.presentationManager.activeScreen == 19 {
                
                self.data.scores[presentationManager.activeScreen] = Int(self.sliderAnswerSelected)
                
            }
        }
        data.isSubmitted.toggle()
        print("score array \(data.scores)")
        print("total score: \(data.scores.reduce(0, +))")
        print("answer Selected \(answerSelected)")
        
    }
    
    func saveMoc() {
        do {
            try moc.save()
        } catch {
            let error = error as NSError
            print("Unresolved Error: \(error)")
        }
    }
    
    func progress()->CGFloat{
        
        let fraction = CGFloat(answered) / CGFloat(data.questions.count)
        
        let width = UIScreen.main.bounds.width - 30
        
        return fraction * width
    }
    
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView(scoreIndex: .constant(23), monthString: .constant("Dec"))
            .environmentObject(NYHAQuestions())
            .environmentObject(PresentationManager())
    }
}


class PresentationManager : ObservableObject {
    @Published var activeScreen = 0;
}
//MARK: PROGRESS BAR
//                                    Text("Progress").foregroundColor(.gray).font(.caption).offset(x:20, y: 25)
//                                    ZStack(alignment: Alignment(horizontal: .leading, vertical: .center), content: {
//
//                                        Capsule()
//                                            .fill(Color.gray.opacity(0.5))
//                                            .frame(height: 6)
//
//                                        Capsule()
//                                            .fill(Color.green)
//                                            .frame(width: progress(), height: 6)
//                                    })
//                                    .padding()

//
//  NYHAView.swift
//  Golgi-Splash
//
//  Created by Marwan Zaarab on 2020-12-26.
//

import SwiftUI
import CoreData

enum Sheets: Identifiable {
    var id : Int {
        self.hashValue
    }
    case a, b, c, d
}


struct NYHAView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.colorScheme) var cs : ColorScheme
    @State var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    @State var fullMonths = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var dateFormat = "EEEE, MMM d"
    @State var scoreIndex = 0
    @State var indexes = [Int]()
    @State var indexArray : [[Int]] = [[Int](), [Int](), [Int](), [Int](), [Int](), [Int](), [Int](), [Int](), [Int](), [Int](), [Int](), [Int]() ]
    @State var monthArray : [[String]] = [[String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String]() ]
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Score.entity(), sortDescriptors: []) var dayItems: FetchedResults<Score>
    @Environment(\.calendar) var calendar
    @State var monthDate = Date()
    @State var monthDateString = Date().string(format: "MMM")
    @State var monthString : String = ""
    @State var scoreArray : [[Int]] = [[Int](), [Int](), [Int](), [Int](), [Int](), [Int](), [Int](), [Int](), [Int](), [Int](), [Int](), [Int]() ]
    @State var scores = [Int]()
    
    @State var dateMonthArray = [String?]()
    @State private var activeSheet : Sheets?
    @State var sheets: [Sheets?] = [.a,.b,.c,.d]
    @State private var heart = [false, false, false, false]
    @State var showingMore = false
    
    var body: some View {
        ZStack{
          
            LinearGradient.overall(for: cs).ignoresSafeArea()
        VStack{
            
               HStack{
   
                HStack{
                    (Text("weekly ").bold() + Text("questionnaires"))
                    .padding(.leading, 10)
                    .opacity(0.7)
                    .font(.system(size: 22, weight: .light, design: .rounded))
                    
                    .padding()
                    
                    Spacer()
                    HStack(spacing: 10){
                        Group{
                            Button(action: {
                                self.changeDateBy(-1)
                                self.monthString = monthDate.string(format: "MMM")

                            }) {
                                Image(systemName: "chevron.left.square")
                                    .font(.system(size: 30, weight: .light))
                                  
                                            .foregroundColor(Color.textColor(for:cs))
                                    .shadow(color: cs == .dark ? Color.white.opacity(0.3) : Color.black.opacity(0.3), radius: 2, x: 2, y: 2)
                            }.opacity(0.6)
                            Button(action: {
                                self.monthDate = Date()
                                self.monthDateString = Date().string(format:"MMM")
                            }) {
                            Image(systemName: "dot.square")
                                .font(.system(size: 30, weight: .light))
                                .foregroundColor(Color.textColor(for:cs))
                                .shadow(color: cs == .dark ? Color.white.opacity(0.3) : Color.black.opacity(0.3), radius: 2, x: 2, y: 2)
                               
                            } .opacity(0.6)
                            Button(action: {
                                self.changeDateBy(1)
                                self.monthString = monthDate.string(format: "MMM")

                            }) {
                                Image(systemName: "chevron.right.square")
                                    .font(.system(size: 30, weight: .light))
                                            .foregroundColor(Color.textColor(for:cs))
                                            .shadow(color: cs == .dark ? Color.white.opacity(0.3) : Color.black.opacity(0.3), radius: 2, x: 2, y: 2)
                                   
                            } .opacity(0.6)
                        }
                        .foregroundColor(Color.darkBG)
                        .frame(width: 25, height: 25)
                        
                    }.padding(.trailing, 25)
                   
                }
                
               }.offset(y: 20)
            
            HomeWeekTitle
         
            ScrollView(.vertical, showsIndicators: false) {
//            ForEach(months.indices) { month in
//                if self.monthDateString == months[month] {
                ForEach(0..<4, id: \.self) { index in
                    let num = (index+1) * 7 - 2

                        HStack{
                            let mo = monthDate.string(format: "MMM")
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible(),spacing: 5), count: 4)){
                                    
                                    VStack(alignment:.leading){
                                        Text("\(mo.uppercased()) \(num)")
                                            .font(.system(size: 14, weight: .light, design: .rounded))
                                          
                                        Text("WEEK \(index+1)")
                                            .font(.system(size: 12.0, weight: .light, design: .rounded))
           
                                    }
                                    
                                    //MARK: COLUMN 2 -> SCORES FETCH
                                    VStack(alignment:.leading){
                                        Text(self.checkScoreIndex(month: mo, index: index))
                                            .font(.system(size: 14, weight: self.checkIfBegin(month: mo, index: index) ? .regular : .regular, design: .rounded))
                                            
                                            .frame(height: 50)
                                    }
                                    
                                    //MARK: COLUMN3 Linear Gradient / Heart
                                    if self.checkNyha(month: mo, val: index) {
                                        LinearGradient(gradient:
                                                        .init(colors: [.red, .lairWhite]),
                                                       startPoint: .topLeading,
                                                       endPoint: .bottomTrailing)
                                            .mask(
                                                Image(systemName: "heart.fill")
                                                    .font(.system(size: 25))
                                                    .padding(.init(top: 5, leading: 5, bottom: 10, trailing: 5))
                                                    .scaleEffect(self.heart[index] ? 1.05 : 0.95, anchor: .center)
                                                    .opacity(self.heart[index] ? 1.0: 0.75))
                                            .onAppear() {
                                                DispatchQueue.main.async {
                                                    withAnimation(Animation.easeInOut(duration:1).repeatForever(autoreverses: false)) {
                                                        self.heart[index].toggle()
                                                    }
                                                }
                                            }

                                    }
                                    else {
                                        LinearGradient.diagonalLairColor(for: self.cs)
                                            .mask(
                                                Image(systemName: "heart.fill")
                                                    .font(.system(size: 25))
                                                    .padding(.init(top: 5, leading: 5, bottom: 10, trailing: 5))
                                                    .opacity(0.75)
                                                
                                            )
                                    }
                                    //
                                    Button(action:{
                                        self.activeSheet = self.sheets[index]
                                        self.scoreIndex = index
                                        self.monthString = mo
                                    })
                                    {
                                        if !self.checkIfBegin(month: mo, index: index) {
                                        Text("Begin")
                                            .font(.system(size: 14, weight: .light, design: .rounded))
                                            .foregroundColor(.blue)
                                        }
                                        else {
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 14, weight: .light, design: .rounded))
                                                .foregroundColor(Color.textColor(for:cs))
                                        }
                                            
                                    }
                                    .disabled(checkIfBegin(month: mo, index: index))
                                    .sheet(item: self.$activeSheet) { item in
                                        switch item{
                                        case .a: QuestionView(scoreIndex: $scoreIndex, monthString: $monthString).environmentObject(NYHAQuestions()).environmentObject(PresentationManager())
                                        case .b: QuestionView(scoreIndex: $scoreIndex, monthString: $monthString).environmentObject(NYHAQuestions()).environmentObject(PresentationManager())
                                        case .c: QuestionView(scoreIndex: $scoreIndex, monthString: $monthString).environmentObject(NYHAQuestions()).environmentObject(PresentationManager())
                                        case .d: QuestionView(scoreIndex: $scoreIndex, monthString: $monthString).environmentObject(NYHAQuestions()).environmentObject(PresentationManager())
                                        }

                                    }
                                    
                                }
                            }

                        
                       
                        }.foregroundColor(self.cs == .dark ? Color.white.opacity(0.8) : Color.black.opacity(0.8))
                        
                        .frame(width:UIScreen.main.bounds.width * (3/4) + 40)
                    RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(.lairBackgroundColor(for: cs))
                    .frame(width:UIScreen.main.bounds.width * (3/4) + 20, height: 5)
                        .padding()
                    
                   
                    
                    NyhaClass(month: $monthDateString)
//                    }
//            }
//            .padding(.top, 5)
                
                
            }
            .padding(.top, 25)
            .navigationBarTitle("")
            .navigationBarHidden(true)
            
           
            
        }
 

        .onAppear {
            DispatchQueue.main.async {
                self.scoreArray = [[], [], [], [], [], [], [], [], [], [] ,[] ,[]]
                self.indexArray =  [[], [], [], [], [], [], [], [], [], [] ,[] ,[]]
                self.monthArray =  [[], [], [], [], [], [], [], [], [], [] ,[] ,[]]
                self.indexes = []
                self.scores = []
                self.dateMonthArray = []
                self.fetchScores()
                self.checkScoreMonth()
                print("MZ scoreArray \(self.scoreArray)")
                print("MZ indexArray \(self.indexArray)")
                print("MZ indexes \(self.indexes)")
                print("MZ monthArray \(self.monthArray)")
            }
        }
        
        
        }
//        .background(LinearGradient.overall(for: cs)).ignoresSafeArea()
    }
    
    func changeDateBy(_ months: Int) {
        if let date = Calendar.current.date(byAdding: .month, value: months, to: monthDate) {
            
            self.monthDate = date
            self.monthDateString = date.string(format:"MMM")

        }
    }
    
    func checkIfBegin(month: String, index: Int) -> Bool {
        var r = false
        let monthin = Calendar.current.dateComponents([.month], from: self.monthDate).month!
        let monthInt = monthin - 1

        if self.dateMonthArray.isEmpty == false {
            if self.scoreArray[monthInt].isEmpty == false {
                for i in 0..<self.indexArray[monthInt].count{
                    if indexArray[monthInt][i] == index && monthArray[monthInt][i] == month {
                        r = true
                    }
                }
            }
            
        }
      
        return r
    }
    
    func checkScoreIndex(month: String, index: Int) -> String {
        var score : Int = 0
        var intScore: Int = 0
        var scoreStr: String = "N/A"
        let monthin = Calendar.current.dateComponents([.month], from: self.monthDate).month!
        let monthInt = monthin - 1
        print("monthInt = \(monthInt)")
        if self.dateMonthArray.isEmpty == false {
            if self.scoreArray[monthInt].isEmpty == false {
                for i in 0..<self.indexArray[monthInt].count{
                    if indexArray[monthInt][i] == index && monthArray[monthInt][i] == month {
                        score = scoreArray[monthInt][i]
                        intScore = Int(score)
                        scoreStr = String(intScore)
                    }
                }
            }
            
        }
       
        
        return scoreStr
    }
    func checkNyha(month: String, val: Int) -> Bool {
        var result = false
        let array = [5, 12, 19, 26]
        let currentDateString = Date().string(format: "MMM d")
        
        let dateString = "\(month) \(array[val])"
        if dateString == currentDateString {
            result = true
        }
        return result
    }
    

    func checkScoreMonth() {

        if self.dateMonthArray.isEmpty == false {

            for i in 0..<self.dateMonthArray.count {
                for m in 0..<self.months.count {
                if self.dateMonthArray[i]!.contains(months[m]) {
                    self.scoreArray[m].append(scores[i])
                    self.monthArray[m].append(dateMonthArray[i]!)
                    self.indexArray[m].append(indexes[i])
                }

                }

            }


        }
        
    }
    func fetchScores() {
        let fetchRequest = NSFetchRequest<Score>(entityName: "Score")
        do{
            let result = try moc.fetch(fetchRequest)
            let scores = result.map{$0.score}
            let dateMonthArray = result.map{$0.month}
            let indexArray = result.map{$0.scoreIndex}

            self.indexes = indexArray
            self.scores = scores
            self.dateMonthArray = dateMonthArray


        } catch {
            print("Could not fetch. \(error)")
        }
    }
}

struct NYHAView_Previews: PreviewProvider {
    static var previews: some View {
        NYHAView().environmentObject(NYHAQuestions())
    }
}

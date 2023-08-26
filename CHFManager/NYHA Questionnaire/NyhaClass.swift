//
//  NyhaClass.swift
//  Golgi-Splash
//
//  Created by Marwan Zaarab on 2021-01-28.
//

import SwiftUI
import Grid
import CoreData

struct NyhaClass: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.colorScheme) var cs
//    @FetchRequest(entity: Score.entity(), sortDescriptors: []) var dayItems: FetchedResults<Score>
    @State var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    @State var fullMonths = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var dateFormat = "EEEE, MMM d"
    @State var scoreArray : [[Int]] = [[Int](), [Int](), [Int](), [Int](), [Int](), [Int](), [Int](), [Int](), [Int](), [Int](), [Int](), [Int]() ]
    @State var scores = [Int]()
    @Binding var month : String
    @State var dateMonthArray = [String?]()
    @State var indexArray : [[Int]] = [[Int](), [Int](), [Int](), [Int](), [Int](), [Int](), [Int](), [Int](), [Int](), [Int](), [Int](), [Int]() ]
    @State var monthArray : [[String]] = [[String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String]() ]
    @State var scoreIndex = 0
    @State var indexes = [Int]()
    @State var showingMore = false
    var infos = [
  "Cardiac disease, but no symptoms, and no limitation in ordinary physical activity.", "Mild symptoms and slight limitation during ordinary activity.", "Significant limitation in activity due to symptoms. Comfortable only at rest.", "Severe limitations. Symptoms even while at rest."
 ]
    var body: some View {
        VStack(spacing: 15){
//            Grid(0..<months.count, id: \.self) { month in
                HStack{
            Text("Average Score")
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .opacity(0.6)
            Spacer()
                Text("\(self.scoreAverage(month: self.month))")
                .font(.system(size: 15, weight: .light, design: .rounded))
                .opacity(0.6)
                    .frame(width: 22, height: 22, alignment: .center)
//                    .padding(.trailing, 20)
                    
                }                .frame(width: ultra * (3/4), height: 20)

                HStack{
           ( Text("Estimated NYHA Class") + Text("*").baselineOffset(2) )
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .opacity(0.6)
                Spacer()
                
                    let theScore = self.scoreAverage(month: self.month)

                    let nyhatemp = self.nyhaEstimate(month: self.month)
                    Image(systemName: theScore > 0 ? "\(nyhatemp).circle.fill" : "")
                .font(.system(size: 20, weight: .light, design: .rounded))
                    .foregroundColor(.red)
                .opacity(0.86)
                        .overlay(Image(theScore > 0 ? "" : (cs == .dark ? "not-available-white" : "not-available-circle")).resizable().aspectRatio(contentMode: .fit)
                                    .frame(width: 22, height: 22, alignment: .center).padding(.trailing, 20)
                                    .opacity(0.7)
                                    )

                }                .frame(width: ultra * (3/4), height: 20)

//        }
            HStack(alignment: .firstTextBaseline, spacing: 0){
//            Text("*")
                Button(action:{
                    self.showingMore.toggle()
                })
                {
                    Text(showingMore ? "Close" : "More info")
                }
            }.padding()
            .font(.system(size: 14, weight: .light, design: .rounded))
            .opacity(0.6)
            VStack{
            Text("The New York Heart Association (NYHA) Class displayed is an estimate based on the questionnaire made by Kubo et al., and should not be taken as being 100% accurate.")
                .fixedSize(horizontal: false, vertical: true)
                .font(.system(size: 12, weight: .light, design: .rounded))
                .opacity(0.6)
            ZStack{
                RoundedRectangle(cornerRadius: 7)
                    .stroke(lineWidth: 1.0)
                    .frame(height: 240)
                VStack{
            HStack{
          Text("Heart Failure Classifications")
            .font(.system(size: 16, weight: .semibold, design: .rounded))
            .opacity(0.6)
            
            Spacer()
            }
            Grid(1...4, id:\.self) {i in
                HStack(alignment: .center){
                    Image(systemName: "\(i).circle.fill")
                     .font(.system(size: 20, weight: .light, design: .rounded))
                         .foregroundColor(.red)
                     .opacity(0.86)
//                        Spacer()
                        Text(infos[i-1])
                            .font(.system(size: 12, weight: .regular, design: .rounded))
                            .opacity(0.6)
                        Spacer()
                    }
                }
            .frame(height: 200)
            .gridStyle(ModularGridStyle(.vertical, columns: 1, rows: 4))
                }.padding(.leading, 8)
            }
            }.isHidden(!showingMore)
      
        }  .frame(width: ultra * (3/4))
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
          
            }
        }
    }

 

func nyhaEstimate(month: String) -> Int {
    let average = scoreAverage(month: month)
    var nyhaclass = 1
    if average < 19 {
        nyhaclass = 1
        
    } else if average < 27 && average >= 19 {
        nyhaclass = 2
        
    } else if average >= 27 && average < 36 {
        nyhaclass = 3
        
    } else {
        nyhaclass = 4
        
    }
    return nyhaclass
}



func scoreAverage(month: String) -> Int {
    var intScore: Int = 0
    let monthNumber = monthToInt(month: month)
    if monthArray[monthNumber].isEmpty == false {
        let scoreA = scoreArray[monthNumber].reduce(0, +) 
        let countA = scoreArray[monthNumber].count
        let scoreAverage = scoreA / countA
        intScore = Int(scoreAverage)
    }
    return intScore
}
func monthToInt(month: String) -> Int {
    switch month {
    case "Jan" : return 0
    case "Feb" : return 1
    case "Mar" : return 2
    case "Apr" : return 3
    case "May" : return 4
    case "Jun" : return 5
    case "Jul" : return 6
    case "Aug" : return 7
    case "Sep" : return 8
    case "Oct" : return 9
    case "Nov" : return 10
    case "Dec" : return 11
    default: return 0
    }
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

struct NyhaClass_Previews: PreviewProvider {
    static var previews: some View {
        NyhaClass(month: .constant("Jan"))
    }
}

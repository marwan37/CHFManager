//
//  WeightView.swift
//  Golgi-Splash
//
//  Created by Marwan Zaarab on 2020-12-26.
//

import SwiftUI
import Combine
import CoreData

struct WeightView: View {
    @ObservedObject var viewModel = ViewModel()

    @State private var entry: String = ""
    @Environment(\.presentationMode) var present
    @Environment(\.managedObjectContext) var moc
    @Binding var weight: Double
    @State var selected = 0
    
    @Binding var index: Int
    @State var monthString: String
    @Environment(\.colorScheme) var cs : ColorScheme
    
    var body: some View {
        ZStack{
            LinearGradient.overall(for: self.cs).edgesIgnoringSafeArea(.all)
            VStack{
//                Text("\(self.monthString) \(self.index)")
                HStack{
                    Spacer()
                    TextField("Enter weight", text: $viewModel.text)
                        .font(.system(size: 16, weight: .light, design:.rounded))
                        .keyboardType(.numberPad)
                        .frame(width: 140)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color(UIColor.systemGray2), lineWidth: 1)
                    )
                        .padding(.leading, 10)
                        .foregroundColor(Color.grayText)
                    
                    Text("lbs")
                        .font(.system(size: 18, weight: .light, design:.rounded))
                        .hidden()
                        .overlay(
                    Text(selected == 1 ? "kg" : "lbs")
                        .font(.system(size: 18, weight: .light, design:.rounded))
                        .foregroundColor(Color.textColor(for: cs))
                            )
                    Spacer()
                    
                            Button(action:{
                                if let floatValue = Float(viewModel.text) {
                                    print("Float value = \(floatValue)")
                                    
                                    if selected == 0 {
                                        self.weight = Double(floatValue)
                                    } else {
                                        self.weight = Double(floatValue) * 2.205
                                }
                                }
                               
                                let weightData = Weight(context: self.moc)
                                weightData.weightIndex = self.index
                                weightData.weight = self.weight
                                weightData.month = self.monthString
                                self.saveMoc()
                                present.wrappedValue.dismiss()
                                
                            }) {
                                Text("submit")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                                    .padding(10)
                                    .frame(width: 80, height: 45)
                                    
                            }.buttonStyle(OtherModifie5(color: viewModel.text != "" ? .blue : .gray, r: 10))
                            .padding()
                }.padding()
                HStack(spacing:20){
                    Spacer()
                    Button(action:{
                        selected = 0
                    }){
                        Text("lbs")
                            .foregroundColor(selected == 0 ? Color.black.opacity(0.9) : Color.grayMe)
                            .font(.system(size: 18, weight: .light, design:.rounded))

                            .padding()
                           
                    }
                    .buttonStyle(selected == 0 ?
                                    OtherModifiah(color: Color.neonBlue,r: 15, pressed: true ) :
                                    OtherModifiah(color: Color("ColorNeuro"),r: 15, pressed: false))
                    .opacity(selected == 0 ? 1 : 0.8)
                  
                    Image(systemName: "arrow.left.arrow.right")
                    Button(action:{
                        selected = 1
                           
                    }){
                        Text("kg")
                            .foregroundColor(selected == 1 ? Color.black.opacity(0.9) : Color.grayMe)
                            .font(.system(size: 18, weight: .regular, design:.rounded))


                            .padding()
                        
                    }.buttonStyle(selected == 1 ?
                                    OtherModifiah(color: Color.neonBlue,r: 15, pressed: true ) :
                                    OtherModifiah(color: Color("ColorNeuro"),r: 15, pressed: false))
                    .opacity(selected == 1 ? 1 : 0.8)

                    Spacer()
                }
//                    .padding()
                
            
//            Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
        }.frame(width: ultra, height: hulk / 3)
        }.frame(width: ultra, height: hulk / 3)
//          .frame(minHeight: 350, maxHeight: 400)
    }
    func saveMoc() {
        do {
            try moc.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved Error: \(error)")
        }
    }
}

struct WeightView_Previews: PreviewProvider {
    static var previews: some View {
        WeightView(weight: .constant(555), index: .constant(1), monthString: "Dec")

    }
}
class ViewModel: ObservableObject {
    @Published var text = ""
    @Published var text2 = ""
    @Published var text3 = ""
    private var subCancellable: AnyCancellable!
    private var validCharSet = CharacterSet(charactersIn: "1234567890.")

    init() {
        subCancellable = $text.sink { val in
            //check if the new string contains any invalid characters
            if val.rangeOfCharacter(from: self.validCharSet.inverted) != nil {
                //clean the string (do this on the main thread to avoid overlapping with the current ContentView update cycle)
                DispatchQueue.main.async {
                    self.text = String(self.text.unicodeScalars.filter {
                        self.validCharSet.contains($0)
                    })
                }
            }
        }
        subCancellable = $text2.sink { val in
            //check if the new string contains any invalid characters
            if val.rangeOfCharacter(from: self.validCharSet.inverted) != nil {
                //clean the string (do this on the main thread to avoid overlapping with the current ContentView update cycle)
                DispatchQueue.main.async {
                    self.text2 = String(self.text2.unicodeScalars.filter {
                        self.validCharSet.contains($0)
                    })
                }
            }
        }
        subCancellable = $text3.sink { val in
            //check if the new string contains any invalid characters
            if val.rangeOfCharacter(from: self.validCharSet.inverted) != nil {
                //clean the string (do this on the main thread to avoid overlapping with the current ContentView update cycle)
                DispatchQueue.main.async {
                    self.text3 = String(self.text3.unicodeScalars.filter {
                        self.validCharSet.contains($0)
                    })
                }
            }
        }
    }

    deinit {
        subCancellable.cancel()
    }
}


struct WeightTracker: View {
    @Environment(\.colorScheme) var colorScheme : ColorScheme
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Weight.entity(), sortDescriptors: []) var dayItems: FetchedResults<Weight>
   
    @State var index: Int
    @Binding var month: Date
    
    @State var weightArray : [[Double]] = [[Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double](), [Double]() ]
    @State var weights = [Double]()
    
    @State var dateMonthArray = [String?]()
    @State var monthArray : [[String]] = [[String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String](), [String]() ]
    
    @State var monthString : String = ""
    
    @State var indexes = [Int]()
    @State var weightIndexArray : [[Int]] = [[Int](), [Int](), [Int](), [Int](), [Int](), [Int](), [Int](), [Int](), [Int](), [Int](), [Int](), [Int]() ]
    
    @State var show = false
   @State var enteredWeight = false
 let columns = [
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible())
 ]
    var body: some View {
        LazyVGrid(columns: columns){
            Text("")
            Text("")
            Text("")
        LazyHGrid(rows: Array(repeating: GridItem(.flexible(),spacing: 60), count: 4)){
            ForEach(0..<4, id:\.self) { index in
                
            Button(action:{
                self.index = index
                self.monthString = self.month.string(format: "MMM")
                show.toggle()
            }) {
                Text(self.checkWeightIndex(month: self.monthString, index: index))
                    .font(.system(size: 12, weight: .light, design: .rounded))
                    .foregroundColor(self.checkEntry(month: self.monthString, index: index) ? Color.textColor(for: self.colorScheme) : .blue)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        }.onAppear {
            DispatchQueue.main.async {
                self.weightArray = [[], [], [], [], [], [], [], [], [], [] ,[] ,[]]
                self.weightIndexArray =  [[], [], [], [], [], [], [], [], [], [] ,[] ,[]]
                self.monthArray =  [[], [], [], [], [], [], [], [], [], [] ,[] ,[]]
                self.indexes = []
                self.weights = []
                self.dateMonthArray = []
                self.monthString = self.month.string(format: "MMM")
                self.fetchScores()
                self.checkWeightMonth(month: self.monthString)
            }
        }
        }
        .frame(width:UIScreen.main.bounds.width * (3/4) + 40)
        .offset(y: 60)
        .background(Color.backgroundColor(for: self.colorScheme).opacity(0.05).ignoresSafeArea())
//        .sheet(isPresented: $show){
//            WeightView(weight: self.weight, index: self.index, monthString: monthString)
//        }
    }
    func checkWeightIndex(month: String, index: Int) -> String {
        var weight : Double = 0
        var intWeight: Int = 0
        var weightStr: String = "Enter\nWeight\n"
        
        if self.dateMonthArray.isEmpty == false {
            let monthInt = monthToInt(month: month)
            if self.weightArray[monthInt].isEmpty == false {
                for i in 0..<self.weightIndexArray[monthInt].count{
                    if weightIndexArray[monthInt][i] == index && monthArray[monthInt][i] == self.month.string(format: "MMM") {
                        weight = weightArray[monthInt][i]
                        intWeight = Int(weight)
                        weightStr = "\(intWeight) lbs"
                    }
                }
            }
            
        }
       
        return weightStr
    }
    func checkEntry(month: String, index: Int) -> Bool {
        var r = false
        if checkWeightIndex(month: month , index: index) != "Enter\nWeight\n" {
            r = true
        } else {
            r = false
        }
        return r
    }
    
    func checkWeightMonth(month: String) {
        
        if self.dateMonthArray.isEmpty == false {
            let monthInt = monthToInt(month: month)
            
            for i in 0..<self.dateMonthArray.count {
                if self.dateMonthArray[i]!.contains(month) {
                    self.weightArray[monthInt].append(weights[i])
                    self.monthArray[monthInt].append(dateMonthArray[i]!)
                    self.weightIndexArray[monthInt].append(indexes[i])
                }
                
              
              
            }
     
               
        }
        print("weightArray : \(weightArray)")
        print("weightIndex : \(weightIndexArray)")
        
    }
    func fetchScores() {
        let fetchRequest = NSFetchRequest<Weight>(entityName: "Weight")
        do{
            let result = try moc.fetch(fetchRequest)
            let weights = result.map{$0.weight}
            let dateMonthArray = result.map{$0.month}
            let weightIndexArray = result.map{$0.weightIndex}
            self.indexes = weightIndexArray
            self.weights = weights
            self.dateMonthArray = dateMonthArray
           
            
        } catch {
            print("Could not fetch. \(error)")
        }
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
}

//struct WeightTracker_Previews: PreviewProvider {
//    static var previews: some View {
//        WeightTracker(index: 1, month: .constant(Date()))
//
//    }
//}




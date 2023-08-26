//
//  WeightView.swift
//  Golgi-Splash
//
//  Created by Deeb Zaarab on 2020-12-26.
//

import SwiftUI
import Combine
import CoreData

struct WeightCalView: View {
    @Environment(\.colorScheme) var cs : ColorScheme

    @FetchRequest(fetchRequest : Weight.getWeightData()) var dayItems:FetchedResults<Weight>

    @State private var entry: String = ""
    @Environment(\.presentationMode) var present
    @Environment(\.managedObjectContext) var moc
    @State var weight: Double
    @State var selected = 0
    @ObservedObject var wmd = WeightModel()
    @State var index: Int
    @State var monthString: String
    @State var showingAlertForSavedEntry = false
    var body: some View {
 
        let weight = self.checkWeightIndex(month: monthString, day: index)
        
        if weight > 0 {
            HStack{
            (Text("Weight:").fontWeight(.semibold) + Text(" \(weight, specifier: "%.1f") lbs"))
                .font(.system(size: 14, weight: .regular, design: .rounded))
                Spacer()
            }
        } else {
                HStack{
                    TextField("Enter weight...", text: $wmd.weight)
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .onReceive(Just($wmd.weight)) { _ in limitD(5) }
                        .keyboardType(.decimalPad)
                        .frame(width: 120)
                        .foregroundColor(Color.grayText)
//                        .modifier(TFModifier())
                 
               
                    
                    submitButton
                    
//                    unitButtons.opacity(0.85)
                  Spacer()

                }

        }
    }
    func checkWeightIndex(month: String, day: Int) -> Double {
        var weight : Double = 0
    
        for i in 0..<dayItems.count {
            if dayItems[i].weightIndex == day && dayItems[i].month == month {
                weight = dayItems[i].weight
            
            }
        }
        return weight
    }
    var submitButton : some View {
        Button(action:{
            DispatchQueue.main.async {
            if let floatValue = Float(wmd.weight) {
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
                self.showingAlertForSavedEntry.toggle()            }
        }) {
           
                Text("Save")
                    .font(.system(size: 14, weight: .semibold, design:.rounded))
                    .foregroundColor(.blue)
//                    .padding(5)
//                    .frame(width: 50, height: 10)
                   
//                    .background(
//                        RoundedRectangle(cornerRadius: 5)
//                            .stroke(Color.pulsatingColor, lineWidth: 1)
//                            .frame(width: 55, height: 30)
//                    )

                       
                    .padding(5)
            
        }.alert(isPresented: $showingAlertForSavedEntry, content: {
            Alert(title: Text("Weight"), message: Text("Your weight for \(self.monthString) \(self.index) has been saved successfully."), dismissButton: .default(Text("Ok")))
        })
        
        .opacity(wmd.weight == "" ? 0.7 : 1)

    }
    
    var unitButtons : some View {
        HStack{
        Button(action:{
            withAnimation(.easeInOut(duration: 0.1)){
                selected = 0
            }
        }){
            Text("lbs")
                .foregroundColor( Color.white)
                .font(.system(size: 16, weight: .light, design:.rounded))

                .padding(7)

        }

        .buttonStyle(selected == 0 ?
                        OtherModifiah(color: Color.pulsatingColor,r: 15, pressed: true ) :
                        OtherModifiah(color: Color.gray,r: 15, pressed: false))
        .opacity(selected == 0 ? 1 : 0.8)
        Image(systemName: "arrow.left.arrow.right")
            .font(.system(size: 12, weight:.light))
        Button(action:{
            withAnimation(.easeInOut(duration: 0.1)){
            selected = 1
            }
        }){
            Text("kg")
                .foregroundColor(Color.white)
                .font(.system(size: 16, weight: .regular, design:.rounded))


                .padding(7)
            
        }.buttonStyle(selected == 1 ?
                        OtherModifiah(color: Color.pulsatingColor,r: 15, pressed: true ) :
                        OtherModifiah(color: Color.gray,r: 15, pressed: false))
        .opacity(selected == 1 ? 1 : 0.8)
        }
    }
    func saveMoc() {
        do {
            try moc.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved Error: \(error)")
        }
    }
    
    func limitD(_ upper: Int) {
        if wmd.weight.count > upper {
            wmd.weight = String(wmd.weight.prefix(upper))
        }
    }
    
}

struct WeightCalView_Previews: PreviewProvider {
    static var previews: some View {
        WeightCalView(weight: 222, index: 1, monthString: "Dec")
//        DryWeightView(month: .constant(Date()))
    }
}

class WeightModel : ObservableObject {
    
    @Published var weight = "" {
        didSet {
            let filtered = weight.filter { $0.isNumber || $0.isPunctuation }
            
            if weight != filtered {
                weight = filtered
            }
        }
    }
}


struct DryWeightView : View  {
    @Environment(\.colorScheme) var cs : ColorScheme
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: DryWeight.entity(), sortDescriptors: []) var dryItems: FetchedResults<DryWeight>
    @State var dryWeight = ""
    @State var month : Date
    @State var showingAlertForSavedEntry = false
    @State var showinfo = false
    @State var isEditing = false
    var body: some View {
            HStack(alignment: .lastTextBaseline){
            Text("Dry Weight:")
                .font(.system(size: 14, weight: .semibold, design: .rounded))
            let monthy = self.month.string(format: "MMM Y")
            if self.checkDryMonth(month: monthy) && !isEditing {
                Text(self.returnDryWeight(month: monthy)) + Text("lbs")
                    .font(.system(size: 14, weight: .regular, design: .rounded))

            } else {
                TextField("Enter dry weight (\(self.month.string(format: "MMM Y")))", text: $dryWeight)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .padding(.trailing, 9).opacity(0.5)
                    .frame(width: ultra / 2 - 90)
            }
            Spacer(minLength: 0)
               
                if checkDryMonth(month: monthy) {
                    HStack{
                    Button(action: {
                        isEditing.toggle()
                       
                    }){
                        Image(systemName: isEditing ? "square.and.pencil" : "pencil")
                            .foregroundColor(Color.textColor(for: cs))
                            .font(.system(size: 18))
                        
                    }.padding(.trailing, 5)
                    
                        Button(action: {
                            for i in 0..<dryItems.count {
                                if dryItems[i].monthYear == monthy {
                                    dryItems[i].dryWeight = self.dryWeight
                                }
                            }
                            self.saveMoc()
                            self.showingAlertForSavedEntry.toggle()
                        })
                        {
                            Image(systemName: "square.and.arrow.down")
            //                        .foregroundColor(Color.textColor(for: cs))
                                .font(.system(size: 18))
                        }.disabled(!isEditing)
                        .opacity(isEditing ? 1 : 0.5)
                    }
                } else {
            Button(action: {
                let newDryWeight = DryWeight(context: self.moc)
                newDryWeight.monthYear = self.month.string(format: "MMM Y")
                newDryWeight.dryWeight = self.dryWeight
                self.saveMoc()
                self.showingAlertForSavedEntry.toggle()
            }){
                Image(systemName: "square.and.arrow.down")
//                        .foregroundColor(Color.textColor(for: cs))
                    .font(.system(size: 16))
            }.padding(.trailing, 5)
                }
           
            
                
            
            Button(action:{
                self.showinfo.toggle()
            }){
                Image(systemName: "questionmark.circle")
                    .foregroundColor(Color.textColor(for: cs)).opacity(0.6)
                    .font(.system(size: 18))
            }.sheet(isPresented: $showinfo) {
                VStack(alignment:.leading){
                    Text("Your dry weight is your weight when you do not have extra fluid in your body. Ask your doctor or nurse what your dry weight is. Compare your daily weight to your dry weight. Your goal at home is to keep your weight within 4 pounds (higher or lower) of your dry weight. Your dry weight will change with time so be sure to ask your doctor or nurse what your dry weight is at every visit.").font(.system(size: 14, weight: .light, design: .rounded)).opacity(0.7)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .center)

        //                .multilineTextAlignment(.center)
                }.padding(.top, 10)
            }
                
                
            Spacer()
        } .font(.system(size: 16, weight: .light, design: .rounded))
        .alert(isPresented: $showingAlertForSavedEntry, content: {
            Alert(title: Text("Dry Weight"), message: Text("Your Dry weight for \(self.month.string(format: "MMM Y")) has been saved successfully."), dismissButton: .default(Text("Ok")))
        })

    }
    func returnDryWeight(month: String) -> String {
        var w = ""
        for i in 0..<dryItems.count {
            if dryItems[i].monthYear == month {
                w = dryItems[i].dryWeight
            }
           
    }
        return w
    }
    func checkDryMonth(month: String) -> Bool  {
        var r = false
        for i in 0..<dryItems.count {
            if dryItems[i].monthYear == month {
                r = true
            }
        }
      return r
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

//struct WeightTracker_Previews: PreviewProvider {
//    static var previews: some View {
//        WeightTracker(index: 1, month: .constant(Date()))
//
//    }
//}




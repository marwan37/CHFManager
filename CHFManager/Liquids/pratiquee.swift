//
//  pratiquee.swift
//  Golgi-Splash
//
//  Created by Marwan Zaarab on 2021-01-19.
//

import SwiftUI
import CoreData
import FloatingButton

struct pratiquee: View {
    @Environment(\.colorScheme) var cs : ColorScheme
    @State var months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"]
    @State var fullMonths = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var dateFormat = "EEEE, MMM d"
    @Binding var waterDateMonthly : [[String]]
    @Binding var monthChecker : [Int]
    @Binding var waterMonthly : [[Double]]
    @State var selected = 1
    @State var units = ["oz", "ml", "L"]
    @Binding var unit : Int
    var body: some View {

        ZStack{
            LinearGradient.overall(for: cs).edgesIgnoringSafeArea(.all)
        ScrollView(.vertical){
               
            VStack(spacing:0){
                    
                    
                    ForEach(monthChecker.indices, id: \.self) { m in
                        ScrollView(.horizontal, showsIndicators:false){
                            
                            if monthChecker[m] > 0 {
                            HStack(alignment: .lastTextBaseline, spacing: 5){
                                ForEach(waterMonthly[m].indices, id: \.self) { i in
                                    VStack{
                                        VStack{
                                            
                                            Spacer(minLength: 0)
                                            Text("64")
                                                .font(.system(size: 12, weight: .light, design: .rounded))
                                                .padding(.bottom,5)
                                                .hidden()
                                          
                                            if selected == m {
                                            let value = Int(waterMonthly[m][i])
                                                Text(newUnit(val: value))
                                                .font(.system(size: 11, weight: .light, design: .rounded))
                                                .padding(.bottom,5)
                                            }
                                            RoundedShape()
                                                .fill(Color.blue)
                                                // max height = 200
                                                
                                              
                                                .frame(height: CGFloat(waterMonthly[m][i]))
                                        }  .onTapGesture {
                                            
                                            withAnimation(.easeOut){
                                                
                                                selected = m
                                            }
                                        }
                                    
                                        
                                        Text(waterDateMonthly[m][i])
                                            .font(.system(size: 10, weight: .light, design: .rounded))
                                            .fixedSize(horizontal: true, vertical: false)
//                                            .foregroundColor(self.cs == .dark ? Color.offWhite.opacity(0.75) : .black)
                                        Divider()
                                    }.padding(.vertical)
                                    .frame(minHeight: 70, maxHeight: 100, alignment: .center)
                                   
                                }
                            }
                            }
                            
                        }
                    
                    }
                }
                
        }.padding(.horizontal, 20)

        }
    }
   
    func newUnit(val: Int) -> String {
        var returned = ""
        if self.unit == 0{
            returned = "\(val)"
        } else if self.unit == 1 {
            let doubleDrank = Double(val)
            let doubledDrink = doubleDrank * 30
            returned = String(format: "%.0f", doubledDrink)
        } else if self.unit == 2 {
            let doubleDrank = Double(val)
            let doubledDrink = doubleDrank * 0.0295735
            returned = String(format: "%.2f", doubledDrink)
        }
        return returned
    }
   
}

//struct pratiquee_Previews: PreviewProvider {
//    static var previews: some View {
//        pratiquee()
//    }
//}


struct CustomLiquidEntry : View {
    @Environment(\.presentationMode) var present

    @Environment(\.colorScheme) var cs
    @State var drank: Double = 0
    @Environment(\.managedObjectContext) var moc
    @State private var datePicked = Date()
    @State var dateArray = [String]()
    @State var liquidsArray = [Double]()
    @FetchRequest(entity: CD_Liquids.entity(), sortDescriptors: []) var liquidItems: FetchedResults<CD_Liquids>
    @State var alertingSave = false
    @State var units = ["oz", "ml", "L"]
    @State var activeUnit = "oz"
    @State var isOpen = false
    var fontsz : CGFloat {
        if ultra > 400 {
            return 16
        } else {
            return 14
        }
    }
    
    var largesz: CGFloat {
        if ultra > 400 {
            return 22
        } else {
            return 16
        }
    }
    var body: some View {
        
        VStack(spacing : 15){
     
            
            DatePicker("Choose Date", selection: $datePicked, displayedComponents: [.date])
                .datePickerStyle(GraphicalDatePickerStyle())
            
            HStack{
                Text("Fluid Intake:").fontWeight(.semibold)
                Text("\(newTextUnit(val: drank)) \(self.activeUnit)")
//                .keyboardType(.decimalPad)
//                .modifier(TFModifier())
                Spacer()
                UnitButtons
               
            
            }.foregroundColor(Color.textColor(for: cs))
            .padding(.horizontal, 20)
            LSlider($drank, range: 0...100)
                .linearSliderStyle(SliderStyleLiquids())
                .frame(width: ultra - 80, height: 40)
                .shadow(color: Color.black.opacity(0.5), radius: 3, x: 3, y:3)
                .padding(.vertical, 15)
            
           
           
            Button(action:{
                DispatchQueue.main.async {
                    if drank != 0 {
                        let newValue = newUnit(val: drank)
                        let dater = Date().string(format: "MMM d")
                        if !dateArray.contains(dater) {
                            let new = CD_Liquids(context: self.moc)
                            new.date = datePicked
                            new.intake = newValue
                            new.limit = 64
                            self.save()
                            self.alertingSave.toggle()
                        } else {
                            for i in 0..<dateArray.count {
                                if dateArray[i] == dater {
                                    moc.delete(liquidItems[i])
                                }
                            }
                            let new = CD_Liquids(context: self.moc)
                            new.date = datePicked
                            new.intake = newValue
                            new.limit = 64
                            self.save()
                            self.alertingSave.toggle()
                        }
                    }
                   
                }
            }) {
                Text("Submit")
                    .foregroundColor(.blue)
                    .font(.system(size: largesz, weight: .light, design: .rounded))
                    .padding(15)
            }.buttonStyle(OtherModifie5(color: Color.goldenYellow, r: 25))
            .padding(.top, 25)
            
            Spacer(minLength: 0)
        }.opacity(0.8)
        .font(.system(size: largesz, weight: .light, design: .rounded))
        .shadow(color: Color.black.opacity(0.2), radius: 1, x: -1, y: 1)
        .padding(.top, 15)
        .onAppear {
            self.liquidsArray = []
            self.dateArray = []
            self.fetchLiquidData()
        }
        
        .navigationTitle("")
        .navigationBarHidden(true)
        .alert(isPresented: $alertingSave, content: {
            Alert(title: Text("Liquid Intake"), message: Text("Your water intake for \(datePicked.string(format: "MMM d")) has been saved successfully."), dismissButton: .default(Text("Ok")) {
                self.present.wrappedValue.dismiss()
            })
        })
        
        
    }
    func newTextUnit(val: Double) -> String {
        var returned = ""
        if self.activeUnit == "oz"{
            returned = "\(Int(val))"
        } else if self.activeUnit == "ml"{
            let doubledDrink = val * 30
            returned = String(format: "%.0f", doubledDrink)
        } else if self.activeUnit == "L" {
            let doubledDrink = val * 0.0295735
            returned = String(format: "%.2f", doubledDrink)
        }
        return returned
    }
    func newUnit(val: Double) -> Double {
        var returned: Double = 0.0
        if self.activeUnit == "oz"{
            returned = val
        } else if self.activeUnit == "ml"{
           returned = val / 30
        } else if self.activeUnit == "L" {
            
            returned = val / 0.0295735
        }
        return returned
    }
    private func endEditing() {
          UIApplication.shared.endEditing()
      }
    
    var UnitButtons: some View {
        
        let textButton1 =
            AnyView(Button(action:{
                self.activeUnit = "ml"
            }) {
                (Image(systemName: "square")
                    .overlay(
                        Text("mL").font(.system(size: 18, weight: .regular, design: .rounded))))
                    .foregroundColor(Color.textColor(for: cs))
                    .font(.system(size: 35, weight: .light))  .opacity(self.activeUnit == "ml" ? 0.9 :  0.5)
            }).opacity(self.activeUnit == "ml" ? 1 : 0.5)
        let textButton2 = AnyView(Button(action:{
                self.activeUnit = "L"
            }) {
                (Image(systemName: "square")
                    .overlay(
                        Text("L").font(.system(size: 18, weight: .regular, design: .rounded))))
                    .foregroundColor(Color.textColor(for: cs))
                    .font(.system(size: 35, weight: .light))
                    .opacity(self.activeUnit == "L" ? 0.9 :  0.5)
        }).opacity(self.activeUnit == "L" ? 1 : 0.5)
        let textButton3 =
            AnyView(Button(action:{
                self.activeUnit = "oz"
            }){
                (Image(systemName: "square")
                    .overlay(
                        Text("oz").font(.system(size: 18, weight: .regular, design: .rounded))))
                    .foregroundColor(Color.textColor(for: cs))
                    .font(.system(size: 35, weight: .light))  .opacity(self.activeUnit == "oz" ? 0.9 :  0.5)
                
            }).opacity(self.activeUnit == "oz" ? 1 : 0.5)
           
        
        
      
        
        return HStack(spacing: 5){
            textButton3
            textButton1
            textButton2
           
        }

       
            
        
    }
    func save() {
        self.moc.performAndWait {
            if self.moc.hasChanges {
                do {
                    try moc.save()
                }
                catch {
                    let error = error as NSError
                    fatalError("Unresolved Error: \(error)")
                }
            }
        }
    }
    
    func fetchLiquidData() {
        let fetchRequest = NSFetchRequest<CD_Liquids>(entityName: "CD_Liquids")
        do{
            let result = try moc.fetch(fetchRequest)
            let dateArray = result.map{$0.date.string(format: "MMM d")}
            let liquidArray = result.map{$0.intake}
            self.dateArray = dateArray
            self.liquidsArray = liquidArray
            
            
        } catch {
            print("Could not fetch. \(error)")
        }
    }
}








struct Background<Content: View>: View {
    private var content: Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }

    var body: some View {
        Color.white
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .overlay(content)
    }
}
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

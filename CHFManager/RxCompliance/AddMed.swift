//
//  AddMed.swift
//  Golgi-Splash
//
//  Created by Marwan Zaarab on 2021-01-13.
//

import SwiftUI
import Combine
import CoreData
struct AddMed: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    
    @Binding var gen: String
    @Binding var brand: String
    @Binding var type: String
    @ObservedObject var data = SearchMeds()
    @State var selection = 0
    @State var qty = 0
    var frequencies = ["q24h","q12h", "q8h", "q6h", "prn", "qhs"]
    var body: some View {
        VStack{
        VStack(alignment:.leading, spacing: 20){
           
            VStack{
            LazyVGrid(columns: cols) {
            Text("GENERIC NAME")
            Text("BRAND NAME")
            Text("CLASS")
            }.font(.system(size: 12, weight: .regular, design: .rounded))
            
            LazyVGrid(columns: cols) {
                Text(self.gen)
                Text(self.brand)
                Text(self.type)
            }.font(.system(size: 14, weight: .regular, design: .rounded))
                Divider()
            }
           
           
            HStack{
            Section(header:Text("Dose")){
                TextField("Enter Dosage", text: $data.dose)
                    
                    .onReceive(Just($data.dose)) { _ in limitD(4) }
                    .keyboardType(.decimalPad)
            }
            
                Section(header:Text("Quantity: \(qty)").font(.system(size: 14, weight: .regular, design: .rounded))){
                Stepper("") {
                    self.qty += 1
                } onDecrement: {
                    if self.qty > 0 {
                    self.qty -= 1
                    } else {
                        self.qty = 0
                    }
                }

            }
            }.padding(.vertical)
            .padding(.horizontal, 20)
            Text("Daily Frequency").padding(.leading, 20)
                Picker("", selection: $selection) {
                    ForEach(0..<frequencies.count) { i in
                        Text("\(frequencies[i])")
                    }
                }.pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
             
         

     }.font(.system(size: 14, weight: .regular, design: .rounded))

            Text("\(data.dose) mg, \(qty)x \(self.explain(frequencies[selection]))")
            .font(.system(size: 16, weight: .light, design: .rounded))
            .padding(.vertical)
        Button(action:{
            let newRx = RxData(context: self.moc)
            newRx.id = UUID().uuidString
            newRx.gen = self.gen
            newRx.brand = self.brand
            newRx.type = self.type
            newRx.dose = data.dose
            newRx.qty = self.qty * realQty(selection)
            newRx.freq = frequencies[selection]
            
            saveMoc()
            self.presentationMode.wrappedValue.dismiss()
            
        }){
            Text("Save entry").font(.system(size: 16, weight: .regular, design: .rounded))
                .foregroundColor(.white)
                .background(RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.blue, lineWidth: 1.5)
                                .frame(width: 120, height: 40, alignment: .center))
                .padding(10)
        } .padding(.vertical)
        .buttonStyle(OtherModifie5(color: .blue, r: 10))
        
        
           
        }
    }
    func realQty(_ sel: Int) -> Int {
        switch sel{
        case 0 : return 1
        case 1: return 2
        case 2: return 3
        case 3: return 4
        case 4: return 0
        case 5: return 1
        default: return 1
        }
    }
    
    func explain(_ freq: String) -> String {
    var stringy = ""
        if selection < 4 {
    let masterNum = Int(freq.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
        stringy = "every \(masterNum!) hours"
        } else if selection == 4 {
            stringy = "as needed"
        } else if selection == 5 {
            stringy = "before bed"
        }
        return stringy
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
        if data.dose.count > upper {
            data.dose = String(data.dose.prefix(upper))
            }
        }
}
struct AddMed_Previews: PreviewProvider {
    static var previews: some View {
        AddMed(gen: .constant("generic"), brand: .constant("brand"), type: .constant("type"))
    }
}

struct AddOtherMed: View {
@Environment(\.presentationMode) var presentationMode
@Environment(\.managedObjectContext) var moc

@State var gen: String = ""

@ObservedObject var data = SearchMeds()
@State var selection = 0
@State var qty = 0
var frequencies = ["q24h","q12h", "q8h", "q6h", "prn", "qhs"]
var body: some View {
    VStack{
    VStack(alignment:.leading, spacing: 20){
       
        
            HStack{
        Text("Medication Name")
      TextField("Enter Medication Name", text: $gen)
            }.padding(.leading, 20)
        .font(.system(size: 14, weight: .regular, design: .rounded))
        
       
            Divider()
        
       
       
        HStack{
        Section(header:Text("Dose")){
            TextField("Enter Dosage", text: $data.dose)
                
                .onReceive(Just($data.dose)) { _ in limitD(4) }
                .keyboardType(.decimalPad)
        }
        
            Section(header:Text("Quantity: \(qty)").font(.system(size: 14, weight: .regular, design: .rounded))){
            Stepper("") {
                self.qty += 1
            } onDecrement: {
                if self.qty > 0 {
                self.qty -= 1
                } else {
                    self.qty = 0
                }
            }

        }
        }.padding(.vertical)
        .padding(.horizontal, 20)
        Text("Daily Frequency").padding(.leading, 20)
            Picker("", selection: $selection) {
                ForEach(0..<frequencies.count) { i in
                    Text("\(frequencies[i])")
                }
            }.pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
         
     

 }.font(.system(size: 14, weight: .regular, design: .rounded))

        Text("\(data.dose) mg \(qty) \(self.explain(frequencies[selection]))")
        .font(.system(size: 16, weight: .light, design: .rounded))
        .padding(.vertical)
    Button(action:{
        let newRx = RxData(context: self.moc)
        newRx.id = UUID().uuidString
        newRx.gen = self.gen
        newRx.dose = data.dose
        newRx.qty = self.qty
        newRx.freq = frequencies[selection]
        
        saveMoc()
        self.presentationMode.wrappedValue.dismiss()
        
    }){
        Text("Save entry").font(.system(size: 16, weight: .regular, design: .rounded))
            .foregroundColor(.white)
            .background(RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.blue, lineWidth: 1.5)
                            .frame(width: 120, height: 40, alignment: .center))
            .padding(10)
    } .padding(.vertical)
    .buttonStyle(OtherModifie5(color: .blue, r: 10))
    
    
       
    }
}
func explain(_ freq: String) -> String {
var stringy = ""
    if selection < 4 {
let masterNum = Int(freq.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
    stringy = "every \(masterNum!) hours"
    } else if selection == 4 {
        stringy = "as needed"
    } else if selection == 5 {
        stringy = "before bed"
    }
    return stringy
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
    if data.dose.count > upper {
        data.dose = String(data.dose.prefix(upper))
        }
    }
}

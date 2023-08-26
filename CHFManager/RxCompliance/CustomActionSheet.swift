//
//  CustomActionSheet.swift
//  CHFManager
//
//  Created by Macbook on 03/04/2021.
//

import SwiftUI
import Combine
import CoreData

struct CustomActionSheet : View {
    @Environment(\.managedObjectContext) var moc

    @State var selection = 0
    var frequencies = ["q24h","q12h", "q8h", "q6h", "prn", "qhs", "qod"]
    
    @ObservedObject var rx = RxData()
    let characterLimit = 4

    @State var newField = ""
    
    var body : some View{
        
        VStack(spacing: 15){
           //Dose
            TextField("Dose", text: $rx.dose)
                .keyboardType(.numberPad)
                .onReceive(Just(rx.dose)) { _ in limitD(characterLimit) }
            
            //Quantity
            Stepper(onIncrement: {
                rx.qty += 1
            }, onDecrement: {
                if rx.qty != 0{
                    rx.qty -= 1
                }
            }) {
                Text("Quantity: \(rx.qty)")
            }
        
            //Frequency
            Picker("", selection: $selection) {
                    ForEach(0..<frequencies.count) { i in
                        Text("\(frequencies[i])")
                    }
                }.pickerStyle(SegmentedPickerStyle())

            
            Button(action: {
                
                moc.delete(rx)
            }) {
                
               Text("Remove medication from list")
                    
            }
            
           
            
        }.padding(.bottom, (UIApplication.shared.windows.last?.safeAreaInsets.bottom)! + 10)
        .padding(.horizontal)
        .padding(.top,20)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(25)
        
    }
    
    func limitD(_ upper: Int) {
        if rx.dose.count > upper {
            rx.dose = String(rx.dose.prefix(upper))
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
}


struct CustomActionSheet_Previews: PreviewProvider {
    static var previews: some View {
        CustomActionSheet()
    }
}

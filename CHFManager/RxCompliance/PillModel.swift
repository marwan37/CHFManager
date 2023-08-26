//
//  PillModel.swift
//  Golgi-Splash
//
//  Created by Marwan Zaarab on 2021-01-17.
//

import SwiftUI
import CoreData
import Combine
import PartialSheet


struct PillModel: View {
    @Environment(\.colorScheme) var cs
    @Environment(\.managedObjectContext) var moc
    var gridItemLayout = [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())]
    var colors: [Color] = [.yellow, .white, .green, .lightEnd, .pulsatingColor]
    @EnvironmentObject var sheetManager: PartialSheetManager
    @State var isSheetShown = false
    @State var isSheetShown2 = false
    @State var isSheetShown3 = false
    let characterLimit = 4
    @State var remove = false
    @State var selection = 0
    var frequencies = ["q24h","q12h", "q8h", "q6h", "prn", "qhs", "qod"]
    @State var newField = ""
    @State var rx: RxData
    let uwd = UIScreen.main.bounds.width
    let uhd = UIScreen.main.bounds.height
    var body: some View {
 
        ZStack{
        Rectangle()
            .cornerRadius(10)
            .frame(width: hulk > 700 ? uwd / 2 - 35 : uwd / 2 - 20, height: hulk > 700 ? ( hulk > 800 ? uhd / 5 : uhd/4.2) : uhd / 4)
            .foregroundColor(cs == .light ? Color.lairWhite : Color.darkBG)
                        .shadow(color: cs == .dark ? Color.darkBG.opacity(0.6) : Color.black.opacity(0.3), radius: 2, x: -2, y: 3)
            .overlay(
                VStack{
                    VStack{
                        HStack{
                            
                            Text("\(rx.gen)")
                                .font(.system(size: hulk > 700 ? 16 : 14, weight: .regular, design: .rounded ))
                            
                            Spacer()
                            Button(action: {
                                self.remove.toggle()
                                
                            }) {
                                
                                Image(systemName: "square.and.pencil")
                                    
                                    
                                    .frame(width: 20, height: 20)
                                
                            }.buttonStyle(BorderlessButtonStyle())
                        }
                        HStack{
                            Text(rx.brand == "" ? "" :  "(\(rx.brand))")
                            .font(.system(size: hulk > 700 ? 11 : 10, weight: .light, design: .rounded ))
                        Spacer()
                        }
//                        HStack{
//                            Spacer()
//                            Text("\(rx.type)").font(.system(size: 11, weight: .light, design: .rounded ))
//
//                        }
                    }.padding(.horizontal, 10).padding(.top, 15)
                    
                    VStack(spacing: hulk > 700 ? 10 : 5){
                        HStack{
                            Text("Dose:").fontWeight(.regular)
                            Spacer()
                            Button(action: {
                                self.isSheetShown = true
                                
                            }) {
                                
                                Image(systemName: self.remove ? "pencil.circle" : "")
                                    
                                    .frame(width: 20, height: 20)
                                
                            }
                            .sheet(isPresented: $isSheetShown) {
                                HStack(spacing: 15){

                                    TextField("Dose", text: $newField)
                                        .keyboardType(.numberPad)
                                        .onReceive(Just($newField)) { _ in limitD(characterLimit) }
                                    Button(action: {
                                        //code here to update moc data
                                        if newField != "" {
                                            rx.dose = newField
                                        } else  {
                                            rx.dose = rx.dose
                                        }
                                        self.isSheetShown.toggle()
                                    }) {
                                        Text("Submit").font(.system(size: 14, weight: .light, design: .rounded))
                                    }
                                }
                                .padding()
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            
                            Text("\(rx.dose) mg")
                        }
                        
                        
                        HStack{
                            Text("Quantity:").fontWeight(.regular)
                            Spacer()
                            Button(action: {
                                self.isSheetShown2 = true
                            }) {
                                
                                Image(systemName: self.remove ? "pencil.circle" : "")
                                    
                                    
                                    .frame(width: 20, height: 20)
                                
                            }
                            .sheet(isPresented: $isSheetShown2) {
                                HStack(spacing: 15){
                                    
                                    TextField("Quantity", text: $newField)
                                        .keyboardType(.numberPad)
                                        .onReceive(Just($newField)) { _ in limitD(characterLimit) }
                                    Button(action: {
                                        //code here to update moc data
                                        rx.qty = Int(newField) ?? rx.qty
                                        self.isSheetShown2.toggle()
                                    }) {
                                        Text("Submit").font(.system(size: 14, weight: .light, design: .rounded))
                                    }
                                }
                                .padding()

                            }
                            .buttonStyle(BorderlessButtonStyle())
                            
                            
                            Text(rx.qty > 0 ? "\(rx.qty)" : "prn")
                        }
                        
                        
                        HStack{
                            Image(systemName: "clock")
                            Spacer()
                            Button(action: {
                                self.isSheetShown3 = true
                                
                            }) {
                                
                                Image(systemName: self.remove ? "pencil.circle" : "")
                                      
                                    .frame(width: 20, height: 20)
                                
                            }
                            .sheet(isPresented: $isSheetShown3) {

                                VStack(spacing: 15){

                                    Picker("", selection: $selection) {
                                        ForEach(0..<frequencies.count) { i in
                                            Text("\(frequencies[i])")
                                        }
                                    }.pickerStyle(SegmentedPickerStyle())
                                    Text("\(explain(frequencies[selection]))")
                                        .fixedSize(horizontal: false, vertical: true)
                                    Button(action: {
                                        //code here to update moc data
                                        rx.freq = frequencies[selection]


                                        self.isSheetShown3.toggle()
                                    }) {
                                        Text("Submit").font(.system(size: 14, weight: .regular, design: .rounded))
                                            .foregroundColor(.white)
                                            .padding(10)
                                    }.buttonStyle(OtherModifiah(color: Color.neonBlue, r: 15, pressed: false))
                                }
                                .padding()

                            }
                            .buttonStyle(BorderlessButtonStyle())
                            
                            Text("\(explain(rx.freq))")
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }.foregroundColor(Color.textColor(for: cs))
                    .padding(.top, hulk > 700 ? 10 : 0)
                    .padding(.horizontal, 15)
                    
                    HStack{
                        Spacer()
                        ZStack{
                        Image(systemName: "pills.fill")
                            
                            .font(.system(size: hulk > 700 ? 12 : 10))
                            .frame(width: 30, height: 30)
                            .cornerRadius(10)
                            .shadow(color: cs == .dark ? Color.sand.opacity(0.2) : Color.black.opacity(0.2), radius: 2, x: 1, y: 1)
                            .offset(x: self.remove ? -25 : 0)
                        Button(action: {
                            
                            moc.delete(rx)
                        }) {
                            
                            Image(systemName: self.remove ? "minus.circle.fill" : "")
                                .resizable()
                                .foregroundColor(.red)
                                .frame(width: 15, height: 15)
                                
                        }
                        }
                    }.offset(y: hulk > 700 ? 0 : -5)
                }.font(.system(size: hulk > 700 ? 14 : 12, weight: .light, design: .rounded ))
                .foregroundColor(Color.textColor(for: cs)) .opacity(0.7)
            )
                
        } .padding(.horizontal)
        .addPartialSheet(style: PartialSheetStyle(
                            background: .solid(Color.navy),
                            accentColor: .orange,
                            enableCover:true ,
                            coverColor: Color.black.opacity(0.6),
                            blurEffectStyle: .dark,
                            cornerRadius: 15,
                            minTopDistance: hulk / 2))
          
    }
    func explain(_ f: String) -> String {
    var stringy = ""
       
        if f == "q24h" {
        stringy = "daily"
        } else if f == "q12h" {
            stringy = "twice a day"
        } else if f == "q8h" {
            stringy = "every 8 hours"
        } else if f == "q6h" {
            stringy = "every 6 hours"
        }else if f == "prn" {
            stringy = "as needed"
        } else if f == "qhs" {
            stringy = "before bed"
        } else if f == "qod" {
            stringy = "every other day"
        }
        return stringy
        
        
    }
    
    func limitD(_ upper: Int) {
        if newField.count > upper {
            newField = String(newField.prefix(upper))
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

//
//struct PillModel_Previews: PreviewProvider {
//    static var previews: some View {
//        PillModel()
//    }
//}

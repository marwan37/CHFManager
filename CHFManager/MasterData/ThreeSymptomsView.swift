//
//  ThreeSymptomsView.swift
//  Golgi-Splash
//
//  Created by Marwan Zaarab on 2021-01-07.
//

import SwiftUI


struct ThreeSymptomsView: View {
    @Environment(\.colorScheme) var cs
    @State var offs:CGFloat = 34
    @State var offs2:CGFloat = 34
    @State var offs3:CGFloat = 34
    @State var tapCount: Double = 0.5
    @State var tapCount2: Double = 0.5
    @State var tapCount3: Double = 0.5
    var adder : Double {
        if self.data.rxQty > 0 {
            return 0.2
        } else {
            return (1/3)
        }
    }
    @EnvironmentObject var data : DayData
    var string : String{
        if offs == -1 {
           return ""
        } else if offs == 66 {
            return ""
        } else {
            return ""
        }
    }

    @State var leads:CGFloat = 50

    @State var h3:CGFloat = 15
    @State var w3:CGFloat = 15
    let cols = [GridItem(.flexible()), GridItem(.fixed(100))]
    var body: some View {
        
        VStack(alignment:.leading, spacing:25){
           
            // MARK: - Option 1: NIL by SELECTION
            
            
            HStack{
                Text("Increased swelling of your feet, ankles, legs or stomach.")
                    .font(.system(size: 15, weight: .regular, design: .rounded))
                    .foregroundColor(cs == .light ? .grayText : Color.lairWhite.opacity(0.8))
                Spacer()
           
                  HStack(spacing:10){
                    HStack(spacing:0){
                        Button(action:{
                            w3 = 32
                             h3 = 32
                            self.data.swelling = 1
                            if self.tapCount < 0.9 {
                                self.data.percentage += adder
                                self.tapCount += 0.4
                                
                                }
                        }){
                            Image(self.data.swelling == 1 ? "checkyes2" : "checkyes")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
     
                                .cornerRadius(10)
        
                            
                           
                        }  .frame(width: 30)
                     
             
                    }
                   
                    
                    
                Button(action:{
                    offs = 66
                    w3 = 32
                     h3 = 32
                    self.data.swelling = 0
                    if self.tapCount < 0.9 {
                            self.data.percentage += adder
                        self.tapCount += 0.4
                        }
                }){
                    Image(self.data.swelling == 0 && tapCount > 0.5 ? "checknofill" : "checkno")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height:40)
                        .cornerRadius(10)

                }
                 
                    
            }
               
            } .padding(.horizontal, 20)
            
            HStack{
                Text("Feeling more short of breath than is normal for you.")
                    .font(.system(size: 15, weight: .regular, design: .rounded))
                    .foregroundColor(cs == .light ? .grayText : Color.lairWhite.opacity(0.8))
                Spacer()
           
                  HStack(spacing:10){
                    HStack(spacing:0){
                        Button(action:{
                            w3 = 32
                             h3 = 32
                            self.data.dyspnea = 1
                            if self.tapCount2 < 0.9 {
                                self.data.percentage += adder
                                self.tapCount2 += 0.4
                                
                                }
                        }){
                            Image(self.data.dyspnea == 1 ? "checkyes2" : "checkyes")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
     
                                .cornerRadius(10)
        
                            
                           
                        }  .frame(width: 30)
                     
             
                    }
                   
                    
                    
                Button(action:{
                    offs2 = 66
                    w3 = 32
                     h3 = 32
                    self.data.dyspnea = 0
                    if self.tapCount2 < 0.9 {
                            self.data.percentage += adder
                        self.tapCount2 += 0.4
                        }
                }){
                    Image(self.data.dyspnea == 0 && tapCount2 > 0.5 ? "checknofill" : "checkno")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height:40)
                        .cornerRadius(10)

                }
                 
                    
            }
               
            } .padding(.horizontal, 20)
            
            HStack{
                Text("Feeling more tired than normal and having no energy.")
                    .font(.system(size: 15, weight: .regular, design: .rounded))
                    .foregroundColor(cs == .light ? .grayText : Color.lairWhite.opacity(0.8))
                Spacer()
           
                  HStack(spacing:10){
                    HStack(spacing:0){
                        Button(action:{
                            w3 = 32
                             h3 = 32
                            self.data.fatigue = 1
                            if self.tapCount3 < 0.9 {
                                self.data.percentage += adder
                                self.tapCount3 += 0.4
                                
                                }
                        }){
                            Image(self.data.fatigue == 1 ? "checkyes2" : "checkyes")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
     
                                .cornerRadius(10)
        
                            
                           
                        }  .frame(width: 30)
                     
             
                    }
                   
                    
                    
                Button(action:{
                    offs3 = 66
                    w3 = 32
                     h3 = 32
                    self.data.fatigue = 0
                    if self.tapCount3 < 0.9 {
                            self.data.percentage += adder
                        self.tapCount3 += 0.4
                        }
                }){
                    Image(self.data.fatigue == 0 && tapCount3 > 0.5 ? "checknofill" : "checkno")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height:40)
                        .cornerRadius(10)

                }
                 
                    
            }
               
            } .padding(.horizontal, 20)
//            .offset(y:-10)
                
        }
}
}

struct ThreeSymptomsView_Previews: PreviewProvider {
    static var previews: some View {
        ThreeSymptomsView().environmentObject(DayData())
            .preferredColorScheme(.dark)
    }
}



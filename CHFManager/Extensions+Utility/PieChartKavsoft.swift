//
//  PieChartKavsoft.swift
//  Golgi-Splash
//
//  Created by Marwan Zaarab on 2020-12-19.
//


//MARK: dyspnea(red), fb(blue), energy(orange), steps(skyblue), running(purple), rx(green)
import SwiftUI

struct PieChartKavsoft_Previews: PreviewProvider {
    static var previews: some View {
        PieChartKavsoft(piedata: [
            Pie(id: 0, percent: 10, name: "JAN", color: Color.sand),
            Pie(id: 1, percent: 15, name: "FEB", color: .red),
            Pie(id: 2, percent: 15, name: "FEB", color: .green),
            Pie(id: 3, percent: 20, name: "MAR", color: .yellow),
            Pie(id: 4, percent: 20, name: "MAR", color: .blue)
            
        ], selected: .constant(2))
    }
}



struct PieChartKavsoft: View {
    @State var colors : [Color] = [Color.red, Color.green, .darkRed, .lightPink, .darkOceanBlue, .yellow, .orange, .lightBlue, .darkPink, .lightGray, .darkYellow, .mediumgray, .darkGreen]
    @State var piedata: [Pie]
    @State var offset : CGFloat = 20
    @Binding var selected : Int
    @State var tapped = false
    @State var colorPie = Color.gray
    @State var colorRec = Color.gray
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    @Environment(\.colorScheme) var cs
    var body: some View {
        VStack{
            Spacer(minLength: 50)
            HStack(alignment:.center) {
       
            
            VStack(alignment:.leading, spacing: 0){
            
                    ForEach(piedata.indices){i in
                     
                        HStack {
                            
//                            GeometryReader{g in
                                if piedata[i].percent > 0 {
                                   
                                   
                                    LazyVGrid(columns:columns) {
                                    HStack{
                                      
                                            Text(piedata[i].name.lowercased())
                                                .font(.system(size: ultra / 22, weight: selected == i || tapped ? .semibold : .thin, design:.rounded))
    //                                            .frame(width:100)
                                                .foregroundColor(tapped ?  piedata[i].color : (selected == i ? piedata[i].color : Color.gray))
                                        
                                        //fixed width...
                                        Spacer(minLength: 0)
                                    }
//                                        Spacer(minLength: 0)
                                        HStack{
                                            Spacer(minLength: 0)
                                        Rectangle()
                                            .fill(tapped ?  piedata[i].color : (selected == i ? piedata[i].color : Color.gray))
                                            
                                            .frame(maxWidth: self.getWidth(width: 200, value: piedata[i].percent), minHeight: 10, maxHeight : hulk > 700 ? 20 : 15)
//                                            .offset(x: -20)
                                            .onTapGesture {
                                                self.selected = i
                                            }
                                    }
                                        HStack{
//                                    .offset(x:20)
                                        Text("\(Int(piedata[i].percent))%")
                                            .font(.system(size: ultra / 25, weight: selected == i || tapped ? .semibold : .thin, design:.rounded))
                                            .foregroundColor(tapped ?  piedata[i].color : (selected == i ? piedata[i].color : Color.gray))
                                    }
//                                    }.frame(width: g.size.width, height: g.size.height*2)
                                    
                                
                                
                                
                            }
                        }
                        }
                    }
                }
            .padding()
            
           
            GeometryReader{g in
                
                ZStack{
                    
                    ForEach(0..<piedata.count) {i in
                        
                        DrawShape(color: tapped ?  piedata[i].color : (selected == i ? piedata[i].color : Color.gray), center: CGPoint(x: g.frame(in: .global).width / 2, y: g.frame(in: .global).height / 2), index: i, piedata: piedata)
                            .onTapGesture {
                                self.selected = i
                                print("selected = \(selected)")
                            }
                    }
                    Image(systemName: "circle.fill")
                        .font(.system(size: ultra / 25, weight: .heavy))
//                        .shadow(color: Color.black.opacity(0.7), radius: 5, x: -1, y: 2)
                        .overlay(Image(systemName: "circle.fill") .font(.system(size: ultra / 25))
                                  
                                            .foregroundColor(.trackColor) .hoverEffect(.lift))
//                                    .shadow(color: Color.black.opacity(0.7), radius: 5, x: -1, y: 2)
                       
                        .onTapGesture {
                            tapped.toggle()
                        }
                }
                
            }
            .frame(height: 360)
            .padding(.top, 20)
            // since it is in circle shape so we're going to clip it in circle...
            .clipShape(Circle())
//            .shadow(radius: 8)
            
        }
//            Spacer(minLength: 700)
            
            
        }
        
        .edgesIgnoringSafeArea(.all)
        
    }
 
    func getWidth(width: CGFloat, value: CGFloat) ->CGFloat {
       
            let temp = value / 100
            return temp * width
        
    }
    
    
}


struct DrawShape: View {
    var color: Color
    var center : CGPoint
    var index : Int
    @State var piedata: [Pie]
    
    var body: some View {
        
        Path{path in
            
            path.move(to: self.center)
            path.addArc(center: self.center, radius: hulk > 700 ? 80 : 50, startAngle: .init(degrees: self.from()), endAngle: .init(degrees : self.to()), clockwise: false)
        }
        .fill(color)
    }
    
    
    //since angle is continous so we need to calculate the angles before and add the current to get exact angle...
    func from()->Double{
        
        if index == 0{
            return 0
        } else {
            var temp : Double = 0
            
            for i in 0...index-1{
                
                temp += Double(piedata[i].percent / 100) * 360
            }
            return temp
        }
        
        
    }
    
    func to() -> Double{
        //convert percent to angle
        var temp : Double = 0
        // because we need the current degree...
        for i in 0...index{
            
            temp += Double(piedata[i].percent / 100) * 360
        }
        return temp
    }
}

struct Pie: Identifiable {
    var id: Int
    var percent: CGFloat
    var name: String
    var color: Color
}

var piedatas = [
    Pie(id: 0, percent: 10, name: "Swelling", color: Color.sand),
    Pie(id: 1, percent: 15, name: "Dyspnea", color: .red),
    Pie(id: 2, percent: 20, name: "Fatigue", color: .blue)
    
]

struct PieChartKav: View {
    @State var colors : [Color] = [Color.red, Color.green, .darkRed, .lightPink, .darkOceanBlue, .yellow, .orange, .lightBlue, .darkPink, .lightGray, .darkYellow, .mediumgray, .darkGreen]
    @State var piedata: [Pie]
    @State var offset : CGFloat = 20
    @Binding var selected : Int
    @State var tapped = false
    @State var colorPie = Color.gray
    @State var colorRec = Color.gray
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    @Environment(\.colorScheme) var cs
    var body: some View {
        VStack{
            
        VStack{
            
           
            GeometryReader{g in
                
                ZStack{
                    
                    ForEach(0..<piedata.count) {i in
                        
                        DrawShapeCharts(color: tapped ?  piedata[i].color : (selected == i ? piedata[i].color : Color.gray), center: CGPoint(x: g.frame(in: .global).width / 2, y: g.frame(in: .global).height / 2), index: i, piedata: piedata)
                            .onTapGesture {
                                self.selected = i
                                print("selected = \(selected)")
                            }
                    }
                    Button(action:{ tapped.toggle()})
                    {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 8))
                        .padding(8)
                        .shadow(color: Color.black.opacity(0.7), radius: 5, x: -1, y: 2)
                        .overlay(Image(systemName: "circle.fill")
                                    .renderingMode(.original)
                                    .resizable()
//                                    .frame(width: 12, height: 0)
                                    .padding(10)
                                     .hoverEffect(.lift))
//                                    .shadow(color: Color.black.opacity(0.3), radius: 2, x: -2, y: -2)
                    }.buttonStyle(OtherModifier2())
                }
                
            }
            .frame(height: 360)
            .padding(.top, 20)
            // since it is in circle shape so we're going to clip it in circle...
            .clipShape(Circle())
            .shadow(radius: 8)
            
            VStack(alignment:.leading, spacing: 0){
            
                    ForEach(piedata.indices){i in
                     
                        HStack {
                            
//                            GeometryReader{g in
                                if piedata[i].percent > 0 {
                                   
                                   
                                    LazyVGrid(columns:columns) {
                                    HStack{
                                        if i == 0 && cs == .light {
                                        Text(piedata[i].name.lowercased())
                                            .font(.system(size:18, weight: selected == i || tapped ? .semibold : .thin, design:.rounded))
//                                            .frame(width:100)
                                            .foregroundColor(tapped ?  Color.offWhite.opacity(0.3) : (selected == i ? Color.black.opacity(0.56) : Color.gray))
                                        } else {
                                            Text(piedata[i].name.lowercased())
                                                .font(.system(size:18, weight: selected == i || tapped ? .semibold : .thin, design:.rounded))
    //                                            .frame(width:100)
                                                .foregroundColor(tapped ?  piedata[i].color : (selected == i ? piedata[i].color : Color.gray))
                                        }
                                        //fixed width...
                                        Spacer(minLength: 0)
                                    }.padding(.leading, 20)
//                                        Spacer(minLength: 0)
                                        HStack{
                                            Spacer(minLength: 0)
                                        Rectangle()
                                            .fill(tapped ?  piedata[i].color : (selected == i ? piedata[i].color : Color.gray))
                                            
                                            .frame(maxWidth: self.getWidth(width: 200, value: piedata[i].percent),
                                                   minHeight: 10,
                                                   maxHeight : 20)
//                                            .offset(x: -20)
                                            .onTapGesture {
                                                self.selected = i
                                            }
                                    }
                                        HStack{
//                                    .offset(x:20)
                                            if i == 0 && cs == .light {
                                                Text("\(Int(piedata[i].percent))%")
                                                    .fontWeight(.bold)
                                                    .foregroundColor(tapped ?  Color.offWhite.opacity(0.3) : (selected == i ? Color.offWhite.opacity(0.3) : Color.gray))
                                            } else {
                                        Text("\(Int(piedata[i].percent))%")
                                            .fontWeight(.bold)
                                            .foregroundColor(tapped ?  piedata[i].color : (selected == i ? piedata[i].color : Color.gray))
                                            }
                                    }
//                                    }.frame(width: g.size.width, height: g.size.height*2)
                                    
                                
                                
                                
                            }
                        }
                        }
                    }
                }
            .padding()
        
            
        }
//            Spacer(minLength: 700)
            
            
        }
        
        .edgesIgnoringSafeArea(.all)
        
    }
 
    func getWidth(width: CGFloat, value: CGFloat) ->CGFloat {
       
            let temp = value / 100
            return temp * width
        
    }
    
    
}

struct DrawShapeCharts: View {
    var color: Color
    var center : CGPoint
    var index : Int
    @State var piedata: [Pie]
    
    var body: some View {
        
        Path{path in
            
            path.move(to: self.center)
            path.addArc(center: self.center, radius: hulk > 700 ? 150 : 120, startAngle: .init(degrees: self.from()), endAngle: .init(degrees : self.to()), clockwise: false)
        }
        .fill(color)
    }
    
    
    //since angle is continous so we need to calculate the angles before and add the current to get exact angle...
    func from()->Double{
        
        if index == 0{
            return 0
        } else {
            var temp : Double = 0
            
            for i in 0...index-1{
                
                temp += Double(piedata[i].percent / 100) * 360
            }
            return temp
        }
        
        
    }
    
    func to() -> Double{
        //convert percent to angle
        var temp : Double = 0
        // because we need the current degree...
        for i in 0...index{
            
            temp += Double(piedata[i].percent / 100) * 360
        }
        return temp
    }
}

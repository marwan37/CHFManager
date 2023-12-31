//
//  CareDashboard.swift
//  Golgi-Splash
//
//  Created by Deeb Zaarab on 2020-11-23.
//

import SwiftUI

struct CareDashboard: View {
    var body: some View {
        
        Home2()
    }
}

struct CareDashboard_Previews: PreviewProvider {
    static var previews: some View {
        CareDashboard()
    }
}

struct Home2 : View {
    
    @State var selected = 0
    var colors = [Color("Color1"),Color("Color")]
    var columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: 2)
    
    var body: some View{
        
        ScrollView(.vertical, showsIndicators: false) {
            
            VStack{
                
                HStack{
                    
                    Text("Hello Marwan")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer(minLength: 0)
                    
                    Button(action: {}) {
                        
                        Image("menu")
                            .renderingMode(.template)
                            .foregroundColor(.white)
                    }
                }
                .padding()
                
                // Bar Chart...
                
                VStack(alignment: .leading, spacing: 25) {
                    
                    Text("Daily Symptom Tracker")
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    HStack(spacing: 15){
                        
                        ForEach(workout_Data){work in
                            
                            // Bars...
                            
                            VStack{
                                
                                VStack{
                                    
                                    Spacer(minLength: 0)
                                    
                                    if selected == work.id{
                                        
                                        Text(getHrs(value: work.workout_In_Min))
                                            .foregroundColor(Color("Color"))
                                            .padding(.bottom,5)
                                    }
                                    
                                    RoundedShape()
                                        .fill(LinearGradient(gradient: .init(colors: selected == work.id ? colors : [Color.white.opacity(0.06)]), startPoint: .top, endPoint: .bottom))
                                    // max height = 200
                                        .frame(height: getHeight(value: work.workout_In_Min))
                                }
                                .frame(height: 220)
                                .onTapGesture {
                                    
                                    withAnimation(.easeOut){
                                        
                                        selected = work.id
                                    }
                                }
                                
                                Text(work.day)
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
                .padding()
                .background(Color.white.opacity(0.06))
                .cornerRadius(10)
                .padding()
                
                HStack{
                    
                    Text("Statistics")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer(minLength: 0)
                }
                .padding()
                
                // stats Grid....
                
                LazyVGrid(columns: columns,spacing: 30){
                    
                    ForEach(stats_Data){stat in
                        
                        VStack(spacing: 32){
                            
                            HStack{
                                
                                Text(stat.title)
                                    .font(.system(size: 22))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Spacer(minLength: 0)
                            }
                            
                            // Ring...
                            
                            ZStack{
                                
                                Circle()
                                    .trim(from: 0, to: 1)
                                    .stroke(stat.color.opacity(0.05), lineWidth: 10)
                                    .frame(width: (UIScreen.main.bounds.width - 150) / 2, height: (UIScreen.main.bounds.width - 150) / 2)
                                
                                Circle()
                                    .trim(from: 0, to: (stat.currentData / stat.goal))
                                    .stroke(stat.color, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                                    .frame(width: (UIScreen.main.bounds.width - 150) / 2, height: (UIScreen.main.bounds.width - 150) / 2)
                                
                                Text(getPercent(current: stat.currentData, Goal: stat.goal) + " %")
                                    .font(.system(size: 22))
                                    .fontWeight(.bold)
                                    .foregroundColor(stat.color)
                                    .rotationEffect(.init(degrees: 90))
                            }
                            .rotationEffect(.init(degrees: -90))
                            
                            Text(getDec(val: stat.currentData) + " " + getType(val: stat.title))
                                .font(.system(size: 22))
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        }
                        .padding()
                        .background(Color.white.opacity(0.06))
                        .cornerRadius(15)
                        .shadow(color: Color.white.opacity(0.2), radius: 10, x: 0, y: 0)
                    }
                }
                .padding()
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .preferredColorScheme(.dark)
        // status bar color is not changing
        // its still in beta...
    }
    
    // calculating Type...
    
    func getType(val: String)->String{
        
        switch val {
        case "Water": return "L"
        case "Sleep": return "Hrs"
        case "Swelling": return "edm"
        case "Dyspnea": return "dsp"
        case "Fatigue": return "ftg"
        default: return "avg"
        }
    }
    
    // converting Number to decimal...
    
    func getDec(val: CGFloat)->String{
        
        let format = NumberFormatter()
        format.numberStyle = .decimal
        
        return format.string(from: NSNumber.init(value: Float(val)))!
    }
    
    // calculating percent...
    
    func getPercent(current : CGFloat,Goal : CGFloat)->String{
        
        let per = (current / Goal) * 100
        
        return String(format: "%.1f", per)
    }
    
    // calculating Hrs For Height...
    
    func getHeight(value : CGFloat)->CGFloat{
        
        // the value in minutes....
        // 24 hrs in min = 1440
        
        let hrs = CGFloat(value * 100) / 5
        
        return hrs
    }
    
    // getting hrs...
    
    func getHrs(value: CGFloat)->String{
        
        let hrs = value / 10
        
        return String(format: "%.1f", hrs)
    }
}

struct RoundedShape : Shape {
    
    func path(in rect: CGRect) -> Path {
        

        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize(width: 5, height: 5))
        
        return Path(path.cgPath)
    }
}

// sample Data...

struct Daily : Identifiable {
    
    var id : Int
    var day : String
    var workout_In_Min : CGFloat
}

var workout_Data = [

    Daily(id: 0, day: "Day 1", workout_In_Min: 7),
    Daily(id: 1, day: "Day 2", workout_In_Min: 3),
    Daily(id: 2, day: "Day 3", workout_In_Min: 4),
    Daily(id: 3, day: "Day 4", workout_In_Min: 10),
    Daily(id: 4, day: "Day 5", workout_In_Min: 5),
    Daily(id: 5, day: "Day 6", workout_In_Min: 2),
    Daily(id: 6, day: "Day 7", workout_In_Min: 8)
]

// stats Data...

struct Stats : Identifiable {
    
    var id : Int
    var title : String
    var currentData : CGFloat
    var goal : CGFloat
    var color : Color
}

var stats_Data = [

    Stats(id: 0, title: "Dyspnea", currentData: 6.8, goal: 10, color: Color("running")),
    
    Stats(id: 1, title: "Water", currentData: 1.5, goal: 2, color: Color("water")),
    
    Stats(id: 2, title: "Energy", currentData: 5, goal: 10, color: Color("energy")),
    
    Stats(id: 3, title: "Rx Comp", currentData: 6.2, goal: 10, color: Color("sleep")),
    
    Stats(id: 4, title: "Swelling", currentData: 12.5, goal: 100, color: Color("cycle")),
    
    Stats(id: 5, title: "Mood", currentData: 3, goal: 7, color: Color("steps")),
]

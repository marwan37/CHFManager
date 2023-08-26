//
//  SymptomTracker.swift
//  Golgi-Splash
//
//  Created by Deeb Zaarab on 2020-11-25.
//

import SwiftUI


struct SwellingView : View{
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var data : DayData
    @Binding var isPresented: Bool
    @State var tapCount = 0.5
    @Environment(\.colorScheme) var cs : ColorScheme

var body: some View {
        VStack{
            Text("Did you notice any increased swelling around your legs and/or ankles today?")
                .font(.title2)
                .fontWeight(.regular).foregroundColor(.pulsatingColor)
                .frame(width: UIScreen.main.bounds.width / 1.1)
                .padding(.bottom, 15).padding(.top, 100)
            Divider()
            Button(action:{
//                self.data.swelling = "Yes"
                self.tapCount += 0.4
                if self.data.dayScore < 1 {
                    self.data.dayScore += 1
                }
                if self.tapCount < 1 {
                    self.data.percentage += 0.1
                }
                self.presentationMode.wrappedValue.dismiss()
            }){
                ZStack{

                Rectangle()
                    .frame(width: UIScreen.main.bounds.width, height: 50)
                    .foregroundColor(.clear)
                    HStack{
                        Text("Yes").foregroundColor( cs == .dark ? Color.white.opacity(0.5) : .grayText).offset(x: 15)
                        Spacer()
                        Image(systemName: "chevron.right").offset(x: -15)
                            .foregroundColor(.gray).opacity(0.8)
                    }
                }
            }
            Divider().offset(x: 15)

            Button(action:{
                self.tapCount += 0.4
//                self.data.swelling = "No"
                if self.data.dayFatScore > 0 {
                    self.data.dayFatScore -= 1
                }
                if self.tapCount < 1 {
                    self.data.percentage += 0.1
                }
                self.presentationMode.wrappedValue.dismiss()
            }){
                ZStack{
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width, height: 50)
                    .foregroundColor(.clear)
                    HStack{
                        Text("No").foregroundColor( cs == .dark ? Color.white.opacity(0.5) : .grayText).offset(x: 15)
                        Spacer()
                        Image(systemName: "chevron.right").offset(x: -15)
                            .foregroundColor(.gray).opacity(0.8)
                    }
                }
            }
                    Divider()
            Spacer()
        }


}
}

struct DyspneaView : View{
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var data: DayData
    @Binding var isPresented: Bool
        @State var tapCount = 0.5
    @Environment(\.colorScheme) var cs : ColorScheme
//    @State var master: Master
    var body: some View {


            VStack{
                Text("Did you experience any shortness of breath today, especially while active and/or when sleeping?").font(.title2).fontWeight(.regular)
                    .foregroundColor(.pulsatingColor)
                    .frame(width: UIScreen.main.bounds.width / 1.1)
                    .padding(.bottom, 15).padding(.top, 100)

                Divider()
                Button(action:{
//                    self.data.dyspnea = "Yes"
                    self.tapCount += 0.4
                    if self.data.daySobScore < 1 {
                        self.data.daySobScore += 1
                    }
                    if self.tapCount < 1 {
                        self.data.percentage += 0.05
                    }
                    self.presentationMode.wrappedValue.dismiss()
                }){
                    ZStack{
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width, height: 50)
                        .foregroundColor(.clear)
                        HStack{
                            Text("Yes").foregroundColor( cs == .dark ? Color.white.opacity(0.5) : .grayText).offset(x: 15)
                            Spacer()
                            Image(systemName: "chevron.right").offset(x: -15)
                                .foregroundColor(.gray).opacity(0.8)
                        }
                    }
                }
                Divider().offset(x: 15)

                Button(action:{
                    self.tapCount += 0.4
//                    self.data.dyspnea = "No"
                    if self.data.dayFatScore > 0 {
                        self.data.dayFatScore -= 1
                    }
                    if self.tapCount < 1 {
                        self.data.percentage += 0.05
                    }
                    self.presentationMode.wrappedValue.dismiss()
                }){
                    ZStack{
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width, height: 50)
                        .foregroundColor(.clear)
                        HStack{
                            Text("No").foregroundColor( cs == .dark ? Color.white.opacity(0.5) : .grayText).offset(x: 15)
                            Spacer()
                            Image(systemName: "chevron.right").offset(x: -15)
                                .foregroundColor(.gray).opacity(0.8)
                        }
                    }
                }
                        Divider()
                Spacer()
            }


    }
}

struct FatigueView: View{
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var data: DayData
    @Binding var isPresented: Bool
        @State var tapCount = 0.5
    @Environment(\.colorScheme) var cs : ColorScheme
//    @State var master: Master

    var body: some View {


            VStack(alignment: .leading){
                Text("Did you feel overwhelmingly tired today?")
                    .font(.title2)
                    .fontWeight(.regular)
                    .foregroundColor(.pulsatingColor)
                    .frame(width: UIScreen.main.bounds.width / 1.1)
                    .padding(.bottom, 15).padding(.top, 100)

                Divider()
                Button(action:{
                    self.tapCount += 0.4
//                    self.data.fatigue = "Yes"
                    if self.data.dayFatScore < 1 {
                        self.data.dayFatScore += 1
                    }
                    if self.tapCount < 1 {
                        self.data.percentage += 0.05
                    }
                    self.presentationMode.wrappedValue.dismiss()
                }){
                    ZStack{
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width, height: 50)
                        .foregroundColor(.clear)
                        HStack{
                            Text("Yes").foregroundColor( cs == .dark ? Color.white.opacity(0.5) : .grayText).offset(x: 15)
                            Spacer()
                            Image(systemName: "chevron.right").offset(x: -15)
                                .foregroundColor(.gray).opacity(0.8)
                        }
                    }
                }
                Divider().offset(x: 15)

                Button(action:{
                    self.tapCount += 0.4
//                    self.data.fatigue = "No"
                    if self.data.dayFatScore > 0 {
                        self.data.dayFatScore -= 1
                    }
                    if self.tapCount < 1 {
                        self.data.percentage += 0.05
                    }
                    self.presentationMode.wrappedValue.dismiss()
                }){
                    ZStack{
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width, height: 50)
                        .foregroundColor(.clear)
                        HStack{
                            Text("No").foregroundColor( cs == .dark ? Color.white.opacity(0.5) : .grayText).offset(x: 15)
                            Spacer()
                            Image(systemName: "chevron.right").offset(x: -15)
                                .foregroundColor(.gray).opacity(0.8)
                        }
                    }
                }
                        Divider()
                Spacer()
            }


    }
}



//MARK:- Single Radio Button Field
struct RadioButtonField: View {
    let id: String
    let label: String
    let size: CGFloat
    let color: Color
    let textSize: CGFloat
    let isMarked:Bool
    let callback: (String)->()

    init(
        id: String,
        label:String,
        size: CGFloat = 20,
        color: Color = Color.black,
        textSize: CGFloat = 14,
        isMarked: Bool = false,
        callback: @escaping (String)->()
        ) {
        self.id = id
        self.label = label
        self.size = size
        self.color = color
        self.textSize = textSize
        self.isMarked = isMarked
        self.callback = callback
    }

    var body: some View {
        Button(action:{
            self.callback(self.id)
        }) {
            HStack(alignment: .center, spacing: 10) {
                Image(systemName: self.isMarked ? "largecircle.fill.circle" : "circle")
                    .foregroundColor(self.color)
                    .frame(width: self.size, height: self.size)
                    .font(.system(size: self.size, weight: .ultraLight))

                Text(label)
                    .font(Font.system(size: textSize))
                    .fontWeight(.thin)
                    .foregroundColor(self.color)
                Spacer()
            }
        }
        .foregroundColor(Color.white)
    }
}

//MARK:- Group of Radio Buttons
enum Gender: String {
    case male = "Male"
    case female = "Female"
}

enum Boolean: String {
    case yes = "Yes"
    case no = "No"
}

struct RadioButtonGroups: View {
    let callback: (String) -> ()

    @State var selectedId: String = ""

    var body: some View {
        HStack{
           radioYesBoolean
            radioNoBoolean


        }
    }

    var radioMaleMajority: some View {
        RadioButtonField(
            id: Gender.male.rawValue,
            label: Gender.male.rawValue,
            isMarked: selectedId == Gender.male.rawValue ? true : false,
            callback: radioGroupCallback
        )
    }

    var radioFemaleMajority: some View {
        RadioButtonField(
            id: Gender.female.rawValue,
            label: Gender.female.rawValue,
            isMarked: selectedId == Gender.female.rawValue ? true : false,
            callback: radioGroupCallback
        )
    }

    var radioNoBoolean: some View {
        RadioButtonField(
            id: Boolean.no.rawValue,
            label: Boolean.no.rawValue,
            color: selectedId == Boolean.no.rawValue ? .blue : .black,
            isMarked: selectedId == Boolean.no.rawValue ? true : false,
            callback: radioGroupCallback

        )
    }

    var radioYesBoolean: some View {
        RadioButtonField(
            id: Boolean.yes.rawValue,
            label: Boolean.yes.rawValue,
            color: selectedId == Boolean.yes.rawValue ? .blue : .black,
            isMarked: selectedId == Boolean.yes.rawValue ? true : false,
            callback: radioGroupCallback
        )
    }



    func radioGroupCallback(id: String) {
        selectedId = id
        callback(id)
    }
}

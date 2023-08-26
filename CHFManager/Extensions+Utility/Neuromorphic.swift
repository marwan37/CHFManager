//
//  ContentView.swift
//  Neumorphism
//
//  Created by Paul Hudson on 25/02/2020.
//  Copyright © 2020 Paul Hudson. All rights reserved.
//

import SwiftUI

extension Color {
    static let offWhite = Color(red: 225 / 255, green: 225 / 255, blue: 235 / 255)

    static let darkStart = Color(red: 31 / 255, green: 11 / 255, blue: 139 / 255)
    static let darkEnd = Color(red: 25 / 255, green: 25 / 255, blue: 30 / 255)

    static let lightStart = Color(red: 60 / 255, green: 160 / 255, blue: 240 / 255)
    static let lightEnd = Color(red: 30 / 255, green: 80 / 255, blue: 120 / 255)
}

extension LinearGradient {
    init(_ colors: Color...) {
        self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

struct SimpleButtonStyle: ButtonStyle {
    @State var padding : CGFloat
    @Environment(\.colorScheme) var cs
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(padding)
            .contentShape(Circle())
            .background(
                Group {
                    if configuration.isPressed {
                        Circle()
                            .fill( LinearGradient.lairHorizontalDark)
                            .opacity(0.2)
                            .overlay(
                                Circle()
                                    .stroke(Color.gray, lineWidth: 4)
                                    .blur(radius: 4)
                                    .offset(x: 2, y: 2)
                                    .mask(Circle().fill(LinearGradient(Color.black, Color.clear)))
                                    .opacity(0.2)
                            )
                            .overlay(
                                Circle()
                                    .stroke(Color.black, lineWidth: 8)
                                    .blur(radius: 4)
                                    .offset(x: -2, y: -2)
                                    .mask(Circle().fill(LinearGradient(Color.clear, Color.black)))
                                    .opacity(0.2)
                            )
                    } else {
                        Circle()
                            .fill( LinearGradient.lairDiagonalDarkBorder)
                            .overlay(
                                Circle()
                                    .stroke(Color.gray, lineWidth: 4)
                                    .blur(radius: 4)
                                    .offset(x: 2, y: 2)
                                    .mask(Circle().fill(LinearGradient(Color.black, Color.clear)))
                            )
                            .overlay(
                                Circle()
                                    .stroke(Color.black, lineWidth: 8)
                                    .blur(radius: 4)
                                    .offset(x: -2, y: -2)
                                    .mask(Circle().fill(LinearGradient(Color.clear, Color.black)))
                            )
                    }
                }
            )
    }
}

struct DarkBackground<S: Shape>: View {
    var isHighlighted: Bool
    var shape: S

    var body: some View {
        ZStack {
            if isHighlighted {
                shape
                    .fill(LinearGradient(Color.offWhite, Color.darkStart))
                    .overlay(shape.stroke(LinearGradient(Color.darkStart, Color.darkEnd), lineWidth: 4))
                    .shadow(color: Color.darkStart, radius: 10, x: 5, y: 5)
                    .shadow(color: Color.darkEnd, radius: 10, x: -5, y: -5)
            } else {
                shape
                    .fill(LinearGradient(Color.offWhite, Color.darkEnd))
                    .overlay(shape.stroke(Color.darkEnd, lineWidth: 4))
                    .shadow(color: Color.darkStart, radius: 10, x: -10, y: -10)
                    .shadow(color: Color.darkEnd, radius: 10, x: 10, y: 10)
            }
        }
    }
}

struct ColorfulBackground<S: Shape>: View {
    var isHighlighted: Bool
    var shape: S

    var body: some View {
        ZStack {
            if isHighlighted {
                shape
                    .fill(LinearGradient(Color.lightEnd, Color.lightStart))
                    .overlay(shape.stroke(LinearGradient(Color.lightStart, Color.lightEnd), lineWidth: 4))
                    .shadow(color: Color.darkStart, radius: 10, x: 5, y: 5)
                    .shadow(color: Color.darkEnd, radius: 10, x: -5, y: -5)
            } else {
                shape
                    .fill(LinearGradient(Color.darkStart, Color.darkEnd))
                    .overlay(shape.stroke(LinearGradient(Color.lightStart, Color.lightEnd), lineWidth: 4))
                    .shadow(color: Color.darkStart, radius: 10, x: -10, y: -10)
                    .shadow(color: Color.darkEnd, radius: 10, x: 10, y: 10)
            }
        }
    }
}

struct DarkButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(30)
            .contentShape(Circle())
            .background(
                DarkBackground(isHighlighted: configuration.isPressed, shape: Circle())
            )
            .animation(nil)
    }
}

struct DarkToggleStyle: ToggleStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }) {
            configuration.label
                .padding(30)
                .contentShape(Circle())
        }
        .background(
            DarkBackground(isHighlighted: configuration.isOn, shape: Circle())
        )
    }
}

struct ColorfulButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(30)
            .contentShape(Circle())
            .background(
                ColorfulBackground(isHighlighted: configuration.isPressed, shape: Circle())
            )
            .animation(nil)
    }
}

struct ColorfulToggleStyle: ToggleStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }) {
            configuration.label
                .padding(30)
                .contentShape(Circle())
        }
        .background(
            ColorfulBackground(isHighlighted: configuration.isOn, shape: Circle())
        )
    }
}

struct ContentView: View {
//    @State private var isToggled = false
//    @Environment(\.colorScheme) var cs
    @Environment(\.colorScheme) var cs
    var body: some View {
        ZStack {
            if cs == .light {
            Color("ColorNeuro").opacity(0.99).edgesIgnoringSafeArea(.all)
            } else {
                Color.black
            }
            HStack(spacing: 25) {
                Button(action: {}) {
                    Image(cs == .dark ? "homey2" : "homey2")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 32, height: 32)
                        .padding(10)
                }.buttonStyle(OtherModifier())
                
                Button(action: {}) {
                    Image(cs == .dark ? "analytics-2" : "charts7")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 32, height: 32)
                        .padding(10)
                }.buttonStyle(OtherModifier())
                
                Button(action: {}) {
                    Image(cs == .dark ? "homey1" : "homey1")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 32, height: 32)
                        .padding(10)
                }.buttonStyle(OtherModifier())
            }.padding(.top, 15)
        }
        .edgesIgnoringSafeArea(.all)
    }
}
struct TopModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content.background(Color("ColorNeuro"))
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.2), radius: 6, x: 10, y: 10)
            .shadow(color: Color.white.opacity(0.5), radius: 6, x: -8, y: -8)
    }
}
struct TopModifierC: ViewModifier {
    @Environment(\.colorScheme) var cs
    @State var grad = LinearGradient.init(gradient: Gradient(colors: [Color.white, Color("ColorNeuro")]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: .bottomTrailing)
    @State var grad2 = LinearGradient.init(gradient: Gradient(colors: [Color.lilly, Color.trackColor]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: .bottomTrailing)
    func body(content: Content) -> some View {
        content.background(cs == .dark ? grad2 : grad)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.2), radius: 6, x: 10, y: 10)
            .shadow(color: Color.white.opacity(cs == .dark ? 0.2 : 0.5), radius: cs == .dark ? 2 : 6, x: cs == .dark ? -3 : -8, y: cs == .dark ? -3 : -8)
    }
}
struct TFModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .padding(20)
            .background(Color("ColorNeuro"))
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.black.opacity(0.05), lineWidth: 4)
                    .shadow(color: Color.black.opacity(0.2), radius: 3, x: 5, y: 5)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(color: Color.black.opacity(0.2), radius: 3, x: -5, y: -5)
        )
    }
}

struct TPMod: ViewModifier {
    @Environment(\.colorScheme) var cs
    func body(content: Content) -> some View {
        content
            .padding(20)
            .background(LinearGradient.overall(for: cs))
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.black.opacity(0.05), lineWidth: 4)
                    .shadow(color: Color.black.opacity(0.2), radius: 3, x: 5, y: 5)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(color: Color.black.opacity(0.2), radius: 3, x: -5, y: -5)
        )
    }
}

struct ButtonModifier: ButtonStyle {
   
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(Color("ColorNeuro"))
            .cornerRadius(15)
            .overlay(
                VStack {
                    if configuration.isPressed {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.black.opacity(0.05), lineWidth: 4)
                            .shadow(color: Color.black.opacity(0.2), radius: 3, x: 5, y: 5)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(color: Color.black.opacity(0.2), radius: 3, x: -5, y: -5)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                }
            }
        )
            .shadow(color: Color.black.opacity(configuration.isPressed ? 0 : 0.2), radius: 5, x: 5, y: 5)
            .shadow(color: Color.white.opacity(configuration.isPressed ? 0 : 0.7), radius: 5, x: -5, y: -5)
    }
}
struct ButtonModifier2: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(Color.black)
            .clipShape(Circle())
            .overlay(
                VStack {
                    if configuration.isPressed {
                        Circle()
                            .stroke(Color.black.opacity(0.05), lineWidth: 4)
                            .shadow(color: Color.black.opacity(0.2), radius: 3, x: 5, y: 5)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.2), radius: 3, x: -5, y: -5)
                            .clipShape(Circle())
                }
            }
        )
            .shadow(color: Color.black.opacity(configuration.isPressed ? 0 : 0.2), radius: 5, x: 5, y: 5)
            .shadow(color: Color.white.opacity(configuration.isPressed ? 0 : 0.7), radius: 5, x: -5, y: -5)
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView().previewLayout(.fixed(width: 200, height: 150))
            .preferredColorScheme(.light)
            
            ContentView().previewLayout(.fixed(width: 200, height: 150))
                .preferredColorScheme(.dark)
        }
    }
}
struct OtherModifier: ButtonStyle {
    @Environment(\.colorScheme) var cs
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(Color("ColorNeuro4"))
            .clipShape(Circle())
            .overlay(
                VStack {
                    if configuration.isPressed {
                        Circle()
                            .stroke(Color.black.opacity(0.05), lineWidth: 4)
                            .shadow(color: Color.black.opacity(0.2), radius: 3, x: 5, y: 5)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.2), radius: 3, x: -5, y: -5)
                            .clipShape(Circle())
                }
            }
        )
            .shadow(color: Color.black.opacity(configuration.isPressed ? 0 : 0.2), radius: 5, x: 5, y: 5)
            .shadow(color: cs == .dark ? Color.trackColor.opacity(0.1) : Color.white.opacity(configuration.isPressed ? 0 : cs == .dark ? 0.1 : 0.2), radius: cs == .dark ? 1 : 3, x: cs == .dark ? 0 : -2, y: cs == .dark ? 0 : -2)
    }
}

struct OtherModifier2: ButtonStyle {
    @Environment(\.colorScheme) var cs
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(Color("ColorNeuro"))
            .clipShape(Circle())
            .overlay(
                VStack {
                    if configuration.isPressed {
                        Circle()
                            .stroke(Color.black.opacity(0.05), lineWidth: 4)
                            .shadow(color: Color.black.opacity(0.2), radius: 3, x: 5, y: 5)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.2), radius: 3, x: -5, y: -5)
                            .clipShape(Circle())
                }
            }
        )
            .shadow(color: Color.black.opacity(configuration.isPressed ? 0 : 0.2), radius: 5, x: 5, y: 5)
            .shadow(color: Color.white.opacity(configuration.isPressed ? 0 : 0.3), radius: 3, x: -2, y: -2)
    }
}


struct OtherModifier3: ButtonStyle {
    @Environment(\.colorScheme) var cs
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(Color.red)
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .overlay(
                VStack {
                    if configuration.isPressed {
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.black.opacity(0.05), lineWidth: 4)
                            .shadow(color: Color.black.opacity(0.2), radius: 3, x: 5, y: 5)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                            .shadow(color: Color.black.opacity(0.2), radius: 3, x: -5, y: -5)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                }
            }
        )
            .shadow(color: Color.black.opacity(configuration.isPressed ? 0 : 0.2), radius: 5, x: 5, y: 5)
            .shadow(color: Color.white.opacity(configuration.isPressed ? 0 : 0.3), radius: 3, x: -2, y: -2)
    }
}

struct OtherModifie4: ButtonStyle {
    @Environment(\.colorScheme) var cs
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(Color.blue.opacity(0.7))
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .overlay(
                VStack {
                    if configuration.isPressed {
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.black.opacity(0.05), lineWidth: 4)
                            .shadow(color: Color.black.opacity(0.2), radius: 3, x: 5, y: 5)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                            .shadow(color: Color.black.opacity(0.2), radius: 3, x: -5, y: -5)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                }
            }
        )
            .shadow(color: Color.black.opacity(configuration.isPressed ? 0 : 0.2), radius: 5, x: 5, y: 5)
            .shadow(color: Color.white.opacity(configuration.isPressed ? 0 : 0.3), radius: 3, x: -2, y: -2)
    }
}
struct OtherModifie5: ButtonStyle {
    @Environment(\.colorScheme) var cs
    @State var color : Color
    @State var r : CGFloat
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: r))
            .overlay(
                VStack {
                    if configuration.isPressed {
                        RoundedRectangle(cornerRadius: r)
                            .stroke(Color.black.opacity(0.05), lineWidth: 4)
                            .shadow(color: Color.black.opacity(0.2), radius: 3, x: 5, y: 5)
                            .clipShape(RoundedRectangle(cornerRadius: r))
                            .shadow(color: Color.black.opacity(0.2), radius: 3, x: -5, y: -5)
                            .clipShape(RoundedRectangle(cornerRadius: r))
                }
            }
        )
            .shadow(color: Color.black.opacity(configuration.isPressed ? 0 : 0.2), radius: 5, x: 5, y: 5)
            .shadow(color: Color.white.opacity(configuration.isPressed ? 0 : 0.3), radius: 3, x: -2, y: -2)
    }
}

struct OtherModifiah: ButtonStyle {
    @Environment(\.colorScheme) var cs
    @State var color : Color
    @State var r : CGFloat
    @State var pressed = false
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: r))
            .overlay(
                VStack {
                if !pressed {
                
                    if configuration.isPressed {
                   
                        RoundedRectangle(cornerRadius: r)
                            .stroke(Color.black.opacity(0.05), lineWidth: 4)
                            .shadow(color: Color.black.opacity(0.2), radius: 3, x: 5, y: 5)
                            .clipShape(RoundedRectangle(cornerRadius: r))
                            .shadow(color: Color.black.opacity(0.2), radius: 3, x: -5, y: -5)
                            .clipShape(RoundedRectangle(cornerRadius: r))
                }
            } else {
                  
                
                     RoundedRectangle(cornerRadius: r)
                         .stroke(Color.black.opacity(0.05), lineWidth: 4)
                         .shadow(color: Color.black.opacity(0.2), radius: 3, x: 5, y: 5)
                         .clipShape(RoundedRectangle(cornerRadius: r))
                         .shadow(color: Color.black.opacity(0.2), radius: 3, x: -5, y: -5)
                         .clipShape(RoundedRectangle(cornerRadius: r))
                
                }
                }
        )
            .shadow(color: Color.black.opacity(pressed ? 0 : 0.2), radius: 5, x: 5, y: 5)
            .shadow(color: Color.white.opacity(pressed ? 0 : 0.3), radius: 3, x: -2, y: -2)
    }
}
struct ButtonModifierC: ButtonStyle {
    @State var color: Color
    @State var r: CGFloat
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(color)
            .cornerRadius(r)
            .overlay(
                VStack {
                    if configuration.isPressed {
                        RoundedRectangle(cornerRadius: r)
                            .stroke(Color.black.opacity(0.05), lineWidth: 4)
                            .shadow(color: Color.black.opacity(0.2), radius: 3, x: 5, y: 5)
                            .clipShape(RoundedRectangle(cornerRadius: r))
                            .shadow(color: Color.black.opacity(0.2), radius: 3, x: -5, y: -5)
                            .clipShape(RoundedRectangle(cornerRadius: r))
                }
            }
        )
            .shadow(color: Color.black.opacity(configuration.isPressed ? 0 : 0.2), radius: 5, x: 5, y: 5)
            .shadow(color: Color.white.opacity(configuration.isPressed ? 0 : 0.3), radius: 3, x: -2, y: -2)
    }
}

struct ChartModifier: ButtonStyle {
    @Environment(\.colorScheme) var cs
    @State var gradient : LinearGradient
    @State var r : CGFloat
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(gradient)
            .clipShape(RoundedRectangle(cornerRadius: r))
            .overlay(
                VStack {
                    if configuration.isPressed {
                        RoundedRectangle(cornerRadius: r)
                            .stroke(Color.black.opacity(0.05), lineWidth: 4)
                            .shadow(color: Color.black.opacity(0.2), radius: 3, x: 5, y: 5)
                            .clipShape(RoundedRectangle(cornerRadius: r))
                            .shadow(color: Color.black.opacity(0.2), radius: 3, x: -5, y: -5)
                            .clipShape(RoundedRectangle(cornerRadius: r))
                }
            }
        )
            .shadow(color: Color.black.opacity(configuration.isPressed ? 0 : 0.2), radius: 5, x: 5, y: 5)
            .shadow(color: cs == .dark ? Color.trackColor.opacity(0.1) : Color.white.opacity(configuration.isPressed ? 0 : 0.1), radius: 2, x: -1, y: -1)
    }
}
struct LineModifier: ButtonStyle {
    @Environment(\.colorScheme) var cs
    @State var grad: LinearGradient
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(grad)
            .clipShape(Circle())
            .overlay(
                VStack {
                    if configuration.isPressed {
                        Circle()
                            .stroke(Color.black.opacity(0.05), lineWidth: 4)
                            .shadow(color: Color.black.opacity(0.2), radius: 3, x: 5, y: 5)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.2), radius: 3, x: -5, y: -5)
                            .clipShape(Circle())
                }
            }
        )
            .shadow(color: Color.black.opacity(configuration.isPressed ? 0 : 0.2), radius: 5, x: 5, y: 5)
            .shadow(color: cs == .dark ? Color.trackColor.opacity(0.1) : Color.white.opacity(configuration.isPressed ? 0 : cs == .dark ? 0.1 : 0.2), radius: cs == .dark ? 1 : 3, x: cs == .dark ? 0 : -2, y: cs == .dark ? 0 : -2)
    }
}
struct TPModOpac: ViewModifier {
    @Environment(\.colorScheme) var cs
    @State var op: Double
    func body(content: Content) -> some View {
        content
            .padding(20)
            .background(Color.white.opacity(op))
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.black.opacity(0.05), lineWidth: 4)
                    .shadow(color: Color.black.opacity(0.2), radius: 3, x: 5, y: 5)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(color: Color.black.opacity(0.2), radius: 3, x: -5, y: -5)

        )
            .frame(height: hulk / 3)

    }
}

struct AppleModifier : ViewModifier {
    @Environment(\.colorScheme) var cs
    @State var grad: LinearGradient
    func body(content: Content) -> some View {
        content
            .background(grad)
            .clipShape(Circle())
         
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 5, y: 5)
            .shadow(color: cs == .dark ? Color.black.opacity(0.1) : Color.white.opacity(cs == .dark ? 0.1 : 0.2), radius: cs == .dark ? 1 : 3, x: cs == .dark ? 0 : -2, y: cs == .dark ? 0 : -2)
    }
}

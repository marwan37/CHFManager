//
//  Animations.swift
//  OCKSample
//
//  Created by Marwan Zaarab on 2020-11-19.
//  Copyright © 2020 Apple. All rights reserved.
//
import SwiftUI

struct Animations: View {
    
    @State var layers: [(Color,CGFloat)] = [] // New Color & Progress
    var animationType: SplashShape.SplashAnimation
       @State private var prevColor: Color // Stores background color
       @ObservedObject var colorStore: ColorStore // Send new color updates

       
       init(animationType: SplashShape.SplashAnimation, color: Color) {
           self.animationType = animationType
           self._prevColor = State<Color>(initialValue: color)
           self.colorStore = ColorStore(color: color)
       }

       var body: some View {
        Rectangle()
                .foregroundColor(self.prevColor) // Current Color
            .overlay(
                       ZStack {
                           ForEach(layers.indices, id: \.self) { x in
                               SplashShape(progress: self.layers[x].1, animationType: self.animationType)
                                   .foregroundColor(self.layers[x].0)
                           }

                       }
                , alignment: .leading)
                .onReceive(self.colorStore.$color) { color in
                    // Animate Color Update Here
                    self.layers.append((color, 0))
                                
                    withAnimation(.easeInOut(duration: 0.5)) {
                                    self.layers[self.layers.count-1].1 = 1.0
                                }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                self.prevColor = self.layers[0].0 // Finalizes background color of SplashView
                                self.layers.remove(at: 0) // removes itself from layers array
                            }

                }
       }

   }

   class ColorStore: ObservableObject {
       @Published var color: Color
       
       init(color: Color) {
           self.color = color
       }
   }




struct SplashShape: Shape {
    public enum SplashAnimation {
           case leftToRight
           case rightToLeft
        case topToBottom
            case bottomToTop
//            case angle(Angle)
            case circle
       }
    
    var progress: CGFloat
        var animationType: SplashAnimation
    var animatableData: CGFloat {
        get { return progress }
        set { self.progress = newValue}
    }
    
    func path(in rect: CGRect) -> Path {
        switch self.animationType {
                case .leftToRight:
                    return leftToRight(rect: rect)
                case .rightToLeft:
                    return rightToLeft(rect: rect)
                case .topToBottom:
                    return topToBottom(rect: rect)
                case .bottomToTop:
                    return bottomToTop(rect: rect)
//                case .angle(let splashAngle):
//                    return angle(rect: rect, angle: splashAngle)
                case .circle:
                    return circle(rect: rect)
            }
    }
    
    func leftToRight(rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0)) // Top Left
        path.addLine(to: CGPoint(x: rect.width * progress, y: 0)) // Top Right
        path.addLine(to: CGPoint(x: rect.width * progress, y: rect.height)) // Bottom Right
        path.addLine(to: CGPoint(x: 0, y: rect.height)) // Bottom Left
        path.closeSubpath() // Close the Path
        return path
    }

    func rightToLeft(rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width - (rect.width * progress), y: 0))
        path.addLine(to: CGPoint(x: rect.width - (rect.width * progress), y: rect.height))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.closeSubpath()
        return path
    }
    
    func topToBottom(rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height * progress))
        path.addLine(to: CGPoint(x: 0, y: rect.height * progress))
        path.closeSubpath()
        return path
    }

    func bottomToTop(rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.height))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height - (rect.height * progress)))
        path.addLine(to: CGPoint(x: 0, y: rect.height - (rect.height * progress)))
        path.closeSubpath()
        return path
    }
    func circle(rect: CGRect) -> Path {
        let a: CGFloat = rect.height / 2.0
        let b: CGFloat = rect.width / 2.0

        let c = pow(pow(a, 2) + pow(b, 2), 0.5) // a^2 + b^2 = c^2  --> Solved for 'c'
        // c = radius of final circle

        let radius = c * progress
        // Build Circle Path
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: radius, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 360), clockwise: true)
        return path

    }
//    func angle(rect: CGRect, angle: Angle) -> Path {
//
//        var cAngle = Angle(degrees: angle.degrees.truncatingRemainder(dividingBy: 90))
//
//        // Return Path Using Other Animations (topToBottom, leftToRight, etc) if angle is 0, 90, 180, 270
//        if angle.degrees == 0 || cAngle.degrees == 0 { return leftToRight(rect: rect)}
//        else if angle.degrees == 90 || cAngle.degrees == 90 { return topToBottom(rect: rect)}
//        else if angle.degrees == 180 || cAngle.degrees == 180 { return rightToLeft(rect: rect)}
//        else if angle.degrees == 270 || cAngle.degrees == 270 { return bottomToTop(rect: rect)}
//
//
//        // Calculate Slope of Line and inverse slope
//        let m = CGFloat(tan(cAngle.radians))
//        let m_1 = pow(m, -1) * -1
//        let h = rect.height
//        let w = rect.width
//
//        // tan (angle) = slope of line
//        // y = mx + b ---> b = y - mx   ~ 'b' = y intercept
//        let b = h - (m_1 * w) // b = y - (m * x)
//
//        // X and Y coordinate calculation
//        var x = b * m * progress
//        var y = b * progress
//
//        // Triangle Offset Calculation
//        let xOffset = (angle.degrees > 90 && angle.degrees < 270) ? rect.width : 0
//        let yOffset = (angle.degrees > 180 && angle.degrees < 360) ? rect.height : 0
//
//        // Modify which side the triangle is drawn from depending on the angle
//        if angle.degrees > 90 && angle.degrees < 180 { x *= -1 }
//        else if angle.degrees > 180 && angle.degrees < 270 { x *= -1; y *= -1 }
//        else if angle.degrees > 270 && angle.degrees < 360 { y *= -1 }
//
//        // Build Triangle Path
//        var path = Path()
//        path.move(to: CGPoint(x: xOffset, y: yOffset))
//        path.addLine(to: CGPoint(x: xOffset + x, y: yOffset))
//        path.addLine(to: CGPoint(x: xOffset, y: yOffset + y))
//        path.closeSubpath()
//        return path
//
//    }
}

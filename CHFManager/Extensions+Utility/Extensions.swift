//
//  Extensions.swift
//  Golgi-Splash
//
//  Created by Marwan Zaarab on 2020-11-24.
//

import SwiftUI
import UIKit

extension Color {
    static func rgb(r: Double, g: Double, b: Double) -> Color {
        return Color(red: r / 255, green: g / 255, blue: b / 255)
    }
    static let backgroundColor = Color.rgb(r: 21, g: 22, b: 33)
    static let outlineColor = Color.rgb(r: 54, g: 255, b: 203)
    static let trackColor = Color.rgb(r: 45, g: 56, b: 95)
    static let pulsatingColor = Color.rgb(r: 73, g: 113, b: 148)
    static let waterColor = Color.rgb(r: 22, g: 105, b: 122)
    static let grayText = Color.rgb(r: 57, g: 62, b: 70)
    static let cap = Color.rgb(r: 22, g: 162, b: 150)
    static let navy = Color.rgb(r: 0, g: 80, b: 134)
    static let lightBlues = Color.rgb(r: 188, g: 230, b: 235)
    static let goldenYellow = Color.rgb(r: 255, g: 223, b: 0)
    static let metallicGold = Color.rgb(r: 212, g: 185, b: 55)
    static let bubbleGum = Color.rgb(r: 253, g: 207, b: 223)
    
    static let darkBG = Color.rgb(r: 34, g: 40, b: 49)
    static let darkBG2 = Color.rgb(r: 28, g: 43, b: 45)
    static let darkBG3 = Color.rgb(r: 128, g: 273, b: 45)
    
    static let lillyblue = Color.rgb(r: 23, g: 22, b: 65)
    static let lillyblue2 = Color.rgb(r: 0, g: 1, b: 49)
    
    static let tealMe = Color.rgb(r: 31, g: 11, b: 139)
    static let grayMe = Color.rgb(r: 153, g: 168, b: 178)
    static let sand = Color.rgb(r: 230, g: 213, b: 184)
    static let lilly =  Color.rgb(r: 10, g: 4, b: 60)
    static let weight = Color.rgb(r: 255, g: 243, b: 230)
    
    public static var lairBackgroundGray: Color {
      Color(.lairBackgroundGray)
    }
    
    public static var lairDarkGray: Color {
      Color(.lairDarkGray)
    }
    
    public static var lairShadowGray: Color {
      Color(.lairShadowGray)
    }
    
    public static var lairGray: Color {
      Color(.lairGray)
    }
    
    public static var lairLightGray: Color {
      Color(.lairLightGray)
    }
    
    public static var lairWhite: Color {
      Color(.lairWhite)
    }
}


//MARK: EXTENSION UI COLOR
extension UIColor {

   convenience init(rgbColorCodeRed red: Int, green: Int, blue: Int, alpha: CGFloat) {

     let redPart: CGFloat = CGFloat(red) / 255
     let greenPart: CGFloat = CGFloat(green) / 255
     let bluePart: CGFloat = CGFloat(blue) / 255

     self.init(red: redPart, green: greenPart, blue: bluePart, alpha: alpha)

   }
    
    public class var lairBackgroundGray: UIColor {
      UIColor(red: 0.878, green: 0.918, blue: 0.957, alpha: 1.000)
    }
    
    public class var lairDarkGray: UIColor {
      UIColor(red: 0.192, green: 0.212, blue: 0.329, alpha: 1.000)
    }
    
    public class var lairShadowGray: UIColor {
      UIColor(red: 0.565, green: 0.608, blue: 0.667, alpha: 1.000)
    }
    
    public class var lairGray: UIColor {
      UIColor(red: 0.592, green: 0.651, blue: 0.710, alpha: 1.000)
    }
    
    public class var lairLightGray: UIColor {
      UIColor(red: 0.812, green: 0.851, blue: 0.890, alpha: 1.000)
    }
    
    public class var lairWhite: UIColor {
      UIColor(red: 0.929, green: 0.949, blue: 0.973, alpha: 1.000)
    }
}


//MARK: LINEAR GRADIENT EXTENSION
extension LinearGradient {
  public static var lairDiagonalDarkBorder: LinearGradient {
    LinearGradient(
      gradient: Gradient(colors: [.white, .lairGray]),
      startPoint: UnitPoint(x: -0.2, y: 0.5),
      endPoint: .bottomTrailing
    )
  }
  
  public static var lairDiagonalLightBorder: LinearGradient {
    LinearGradient(
      gradient: Gradient(colors: [.white, .lairLightGray]),
      startPoint: UnitPoint(x: 0.2, y: 0.2),
      endPoint: .bottomTrailing
    )
  }
  
  public static var lairHorizontalDark: LinearGradient {
    LinearGradient(
      gradient: Gradient(colors: [.lairShadowGray, .lairDarkGray]),
      startPoint: .leading,
      endPoint: .trailing
    )
  }
  
  public static var lairHorizontalDarkReverse: LinearGradient {
    LinearGradient(
      gradient: Gradient(colors: [.lairDarkGray, .lairShadowGray]),
      startPoint: .leading,
      endPoint: .trailing
    )
  }
  
  public static var lairHorizontalDarkToLight: LinearGradient {
    LinearGradient(
      gradient: Gradient(colors: [
        .lairShadowGray,
        Color.white.opacity(0.0),
        .white]),
      startPoint: .top,
      endPoint: .bottomTrailing
    )
  }
  
  public static var lairVerticalLightToDark: LinearGradient {
    LinearGradient(
      gradient: Gradient(colors: [
        .white,
        Color.white.opacity(0.0),
        .lairShadowGray]),
      startPoint: .top,
      endPoint: .bottom
    )
  }
  
  public static var lairHorizontalLight: LinearGradient {
    LinearGradient(
      gradient: Gradient(colors: [.lairWhite, .lairBackgroundGray]),
      startPoint: .leading,
      endPoint: .trailing
    )
  }
}


//MARK: EXTENSION VIEW

    extension View {
      func inverseMask<Mask>(_ mask: Mask) -> some View where Mask : View {
        self.mask(mask
          .foregroundColor(.black)
          .background(Color.white)
          .compositingGroup()
          .luminanceToAlpha()
        )
      }
    }



extension Color {

    static let lightTextColor = Color.black.opacity(0.9)
    static let darkTextColor = Color.lairWhite
    
    static let lightBackgroundColor = Color("ColorNeuro").opacity(0.95)
    static let darkBackgroundColor = Color.trackColor
    
    static let lightLairBackground = Color.lairBackgroundGray
    static let darkLairBackground = Color.lairShadowDark2
    
    static let lairShadowLight = Color.lairShadowGray
    static let lairShadowDark = Color.lairBackgroundGray
    
    
    static let lairShadowLight2 = Color.white.opacity(0.9)
    static let lairShadowDark2 =  Color.white.opacity(0.2)
    
    
    
    static func lairShadowColor2(for colorScheme: ColorScheme) -> Color {
        if colorScheme == .dark {
            return lairShadowDark2
        } else {
            return lairShadowLight2
        }
    }
    
    static func lairShadowColor(for colorScheme: ColorScheme) -> Color {
        if colorScheme == .dark {
            return lairShadowDark
        } else {
            return lairShadowLight
        }
    }
    
    
    static func backgroundColor(for colorScheme: ColorScheme) -> Color {
        if colorScheme == .dark {
            return darkBackgroundColor
        } else {
            return lightBackgroundColor
        }
    }
    
    static func lairBackgroundColor(for colorScheme: ColorScheme) -> Color {
        if colorScheme == .dark {
            return darkLairBackground
        } else {
            return lightLairBackground
        }
    }
    
    static func lairBackgroundColor2(for colorScheme: ColorScheme) -> Color {
        if colorScheme == .dark {
            return lightLairBackground
        } else {
            return darkLairBackground
        }
    }
    
    static func textColor(for colorScheme: ColorScheme) -> Color {
        if colorScheme == .dark {
            return darkTextColor
        } else {
            return lightTextColor
        }
    }
}

extension LinearGradient {
    static let diagonalLairColorLight = LinearGradient.lairHorizontalDark
    static let diagonalLairColorDark = LinearGradient.lairDiagonalDarkBorder
    
    static let lairGradientHorizontalDark = LinearGradient.lairHorizontalDarkReverse
    static let lairGradientHorizontalLight = LinearGradient.lairHorizontalDarkToLight
    
    static let overallLight =     LinearGradient.init(gradient: Gradient(colors: [Color("ColorNeuro"), Color.white]), startPoint: .bottomTrailing, endPoint: .topLeading)
    static let overallDark =   LinearGradient.init(gradient: Gradient(colors: [Color.trackColor, Color.lilly]), startPoint: .topLeading, endPoint: .bottomTrailing)
  
    static let overall2 =  LinearGradient.init(gradient: Gradient(colors: [Color.white, Color.white]), startPoint: .bottomTrailing, endPoint: .topLeading)
    static let overallDark2 =   LinearGradient.init(gradient: Gradient(colors: [Color.trackColor, Color.lilly]), startPoint: .topLeading, endPoint: .bottomTrailing)

    
    static let medsLight =  LinearGradient(gradient: .init(colors: [Color.waterColor, Color.pulsatingColor]), startPoint: .topLeading, endPoint: .bottomTrailing)
    static let medsDark =  LinearGradient(gradient: .init(colors: [Color.waterColor, Color.green.opacity(0.5)]), startPoint: .topLeading, endPoint: .bottomTrailing)
    
    static let liquidsLight =  LinearGradient(gradient: .init(colors: [Color("fb"), Color.trackColor]), startPoint: .topLeading, endPoint: .bottomTrailing)
    static let liquidsDark =  LinearGradient(gradient: .init(colors: [Color("fb").opacity(0.7), Color.trackColor.opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing)
    
    
    static let lairLightMode = LinearGradient(gradient: Gradient(colors: [Color.lairBackgroundGray, Color.lairWhite]), startPoint: .topLeading, endPoint: .bottomTrailing)
    static let lairDarkMode = LinearGradient(gradient: Gradient(colors: [Color.lairBackgroundGray.opacity(0.5), Color.lairWhite.opacity(0.7)]), startPoint: .topLeading, endPoint: .bottomTrailing)
    
    static let minimalistLight = LinearGradient(gradient: .init(colors: [.white, .lairWhite]), startPoint: .topLeading, endPoint: .bottomTrailing)
    static let minimalistDark = LinearGradient(gradient: .init(colors: [.black, .darkLairBackground]), startPoint: .topLeading, endPoint: .bottomTrailing)
    
    static func overall(for colorScheme: ColorScheme) -> LinearGradient {
        if colorScheme == .light {
            return overallLight
        } else {
            return overallDark
        }
    }
    
    static func minimalist(for colorScheme: ColorScheme) -> LinearGradient {
        if colorScheme == .light {
            return minimalistLight
        } else  {
            return minimalistDark
        }
    }
    static func overalls(for colorScheme: ColorScheme) -> LinearGradient {
        if colorScheme == .light {
            return overall2
        } else  {
            return overallDark2
        }
    }
    
    static func diagonalLairColor(for colorScheme: ColorScheme) -> LinearGradient {
        if colorScheme == .dark {
            return diagonalLairColorDark
        } else {
            return diagonalLairColorLight
        }
    }
    
    
    static func lairGradientReverse(for colorScheme: ColorScheme) -> LinearGradient {
        if colorScheme == .dark {
            return lairGradientHorizontalDark
        } else {
            return lairGradientHorizontalLight
        }
    }
    
    static func lairGradients(for cs: ColorScheme) -> LinearGradient {
        if cs == .dark {
            return lairDarkMode
        } else {
            return lairLightMode
        }
    }
}



extension Sequence where Element: Hashable {
    var frequency: [Element: Int] {
        return reduce(into: [:]) { $0[$1, default: 0] += 1 }
    }
    func frequency(of element: Element) -> Int {
        return frequency[element] ?? 0
    }
}

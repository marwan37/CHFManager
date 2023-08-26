//
//  File.swift
//
//
//  Created by András Samu on 2019. 07. 19..
//

import Foundation
import SwiftUI



public struct GradientColor {
    public let start: Color
    public let end: Color
    
    public init(start: Color, end: Color) {
        self.start = start
        self.end = end
    }
    
    public func getGradient() -> Gradient {
        return Gradient(colors: [start, end])
    }
}

extension GradientColor {
    public static let orange = GradientColor(start: Color.neonOrange, end: Color.neonRed)
    public static let blue = GradientColor(start: Color.neonPurple, end: Color.neonBlue)
    public static let green = GradientColor(start: Color(hexString: "0BCDF7"), end: Color(hexString: "A2FEAE"))
    public static let blu = GradientColor(start: Color(hexString: "0591FF"), end: Color(hexString: "29D9FE"))
    public static let bluPurpl = GradientColor(start: Color(hexString: "4ABBFB"), end: Color(hexString: "8C00FF"))
    public static let purple = GradientColor(start: Color(hexString: "741DF4"), end: Color(hexString: "C501B0"))
    public static let prplPink = GradientColor(start: Color(hexString: "BC05AF"), end: Color(hexString: "FF1378"))
    public static let prplNeon = GradientColor(start: Color(hexString: "FE019A"), end: Color(hexString: "FE0BF4"))
    public static let orngPink = GradientColor(start: Color(hexString: "FF8E2D"), end: Color(hexString: "FF4E7A"))
}

public struct GradientColors {
    public static let orange = GradientColor(start: Color.neonOrange, end: Color.neonRed)
    public static let blue = GradientColor(start: Color.neonPurple, end: Color.neonBlue)
    public static let green = GradientColor(start: Color(hexString: "0BCDF7"), end: Color(hexString: "A2FEAE"))
    public static let blu = GradientColor(start: Color(hexString: "0591FF"), end: Color(hexString: "29D9FE"))
    public static let bluPurpl = GradientColor(start: Color(hexString: "4ABBFB"), end: Color(hexString: "8C00FF"))
    public static let purple = GradientColor(start: Color(hexString: "741DF4"), end: Color(hexString: "C501B0"))
    public static let prplPink = GradientColor(start: Color(hexString: "BC05AF"), end: Color(hexString: "FF1378"))
    public static let prplNeon = GradientColor(start: Color(hexString: "FE019A"), end: Color(hexString: "FE0BF4"))
    public static let orngPink = GradientColor(start: Color(hexString: "FF8E2D"), end: Color(hexString: "FF4E7A"))
}

public struct Styles {
    public static let darkPrimary = ChartStyle(
        canvasBackgroundColor: Color.darkGray,
        lineGradient: GradientColor(start: Color.white, end: Color.white),
        chartBackgroundGradient: GradientColor(start: Color.darkGray, end: Color.darkGray),
        titleColor: Color.white,
        subtitleColor: Color.gray,
        numberColor: Color.white)
    
    public static let lineChartStyleTwo = ChartStyle(
        backgroundColor: Color.white,
        accentColor: Color.neonOceanBlue,
        gradientColor: GradientColor(start: Color.neonPurple, end: Color.neonOceanBlue),
        textColor: Color.black,
        legendTextColor: Color.gray,
        dropShadowColor: Color.gray,
        backgroundGradient: GradientColor(start: Color.blue.opacity(0.95), end: .white))

    public static let lineChartStyleThree = ChartStyle(
        backgroundColor: Color.white,
        accentColor: Color.neonOrange,
        gradientColor: GradientColor(start: Color.neonRed, end: Color.neonOrange),
        textColor: Color.black,
        legendTextColor: Color.gray,
        dropShadowColor: Color.gray,
        backgroundGradient: GradientColor(start: Color.lightRed, end: .white))
    
    public static let lineChartStyleFour = ChartStyle(
        backgroundColor: Color.white,
        accentColor: Color.white,
        gradientColor: GradientColor(start: Color.neonGreen, end: Color.neonOceanBlue),
        textColor: Color.black,
        legendTextColor: Color.gray,
        dropShadowColor: Color.gray,
        backgroundGradient: GradientColor(start: .white, end: .white))
    
    public static let fatigueChartStyle = ChartStyle(
        backgroundColor: Color.white,
        accentColor: Color.white,
        gradientColor: GradientColor(start: Color.orange, end: Color.orange),
        textColor: Color.black,
        legendTextColor: Color.gray,
        dropShadowColor: Color.orange,
        backgroundGradient: GradientColor(start: .white, end: .white))
    
    public static let swellingChartStyle = ChartStyle(
        backgroundColor: Color.white,
        accentColor: Color.white,
        gradientColor: GradientColor(start: Color.sand, end: Color.sand),
        textColor: Color.black,
        legendTextColor: Color.gray,
        dropShadowColor: Color.sand,
        backgroundGradient: GradientColor(start: .white, end: .white))
    
    public static let dyspneaChartStyle = ChartStyle(
        backgroundColor: Color.white,
        accentColor: Color.white,
        gradientColor: GradientColor(start: Color.red, end: Color.red),
        textColor: Color.black,
        legendTextColor: Color.gray,
        dropShadowColor: Color.red,
        backgroundGradient: GradientColor(start: .white, end: .white))
    
    public static let dyspneaChartStyle2 = ChartStyle(
        backgroundColor: Color.white,
        accentColor: Color.white,
        gradientColor: GradientColor(start: Color.red, end: Color.red),
        textColor: Color.black,
        legendTextColor: Color.gray,
        dropShadowColor: Color.red,
        backgroundGradient: GradientColor(start: .white, end: .white))
    
    
    public static let lineChartStyleOne = ChartStyle(
        backgroundColor: Color.white,
        accentColor: Color.neonOrange,
        secondGradientColor: Color.neonRed,
        textColor: Color.black,
        legendTextColor: Color.gray,
        dropShadowColor: Color.gray)
    
    public static let barChartStyleOrangeLight = ChartStyle(
        backgroundColor: Color.white,
        accentColor: Color.neonOrange,
        secondGradientColor: Color.neonRed,
        textColor: Color.black,
        legendTextColor: Color.gray,
        dropShadowColor: Color.gray)
    
    public static let barChartStyleOrangeDark = ChartStyle(
        backgroundColor: Color.black,
        accentColor: Color.neonOrange,
        secondGradientColor: Color.neonRed,
        textColor: Color.white,
        legendTextColor: Color.gray,
        dropShadowColor: Color.gray)
    
    public static let barChartStyleNeonBlueLight = ChartStyle(
        backgroundColor: Color.white,
        accentColor: Color.neonOceanBlue,
        secondGradientColor: Color.neonPurple,
        textColor: Color.black,
        legendTextColor: Color.gray,
        dropShadowColor: Color.gray)
    
    public static let barChartStyleNeonBlueDark = ChartStyle(
        backgroundColor: Color.black,
        accentColor: Color.neonOceanBlue,
        secondGradientColor: Color.neonPurple,
        textColor: Color.white,
        legendTextColor: Color.gray,
        dropShadowColor: Color.gray)
    
    public static let barChartMidnightGreenDark = ChartStyle(
        backgroundColor: Color(hexString: "#36534D"), //3B5147, 313D34
        accentColor: Color(hexString: "#FFD603"),
        secondGradientColor: Color(hexString: "#FFCA04"),
        textColor: Color.white,
        legendTextColor: Color(hexString: "#D2E5E1"),
        dropShadowColor: Color.gray)
    
    public static let barChartMidnightGreenLight = ChartStyle(
        backgroundColor: Color.white,
        accentColor: Color(hexString: "#84A094"), //84A094 , 698378
        secondGradientColor: Color(hexString: "#50675D"),
        textColor: Color.black,
        legendTextColor:Color.gray,
        dropShadowColor: Color.gray)
    
    public static let pieChartStyleOne = ChartStyle(
        backgroundColor: Color.white,
        accentColor: Color.neonRed,
        secondGradientColor: Color.neonOrange,
        textColor: Color.black,
        legendTextColor: Color.gray,
        dropShadowColor: Color.gray)
    
    public static let lineViewDarkMode = ChartStyle(
        backgroundColor: Color.black,
        accentColor: Color.neonOrange,
        secondGradientColor: Color.neonRed,
        textColor: Color.white,
        legendTextColor: Color.white,
        dropShadowColor: Color.gray)
}

public struct ChartForm {
    #if os(watchOS)
    public static let small = CGSize(maxWidth:120, maxHeight:90)
    public static let medium = CGSize(maxWidth:120, maxHeight:160)
    public static let large = CGSize(maxWidth:180, maxHeight:90)
    public static let extraLarge = CGSize(maxWidth:180, maxHeight:90)
    public static let detail = CGSize(maxWidth:180, maxHeight:160)
    #else
    public static let small = CGSize(width:180, height:120)
    public static let medium = CGSize(width:180, height:240)
    public static let large = CGSize(width:360, height:120)
    public static let extraLarge = CGSize(width:360, height:240)
    public static let detail = CGSize(width:180, height:120)
    #endif
}

public class ChartStyle {
    public var backgroundColor: Color
    public var backgroundGradient: GradientColor
    public var accentColor: Color
    public var lineGradient: GradientColor
    public var textColor: Color
    public var legendTextColor: Color
    public var dropShadowColor: Color
    public var numbersColor: Color
    public weak var darkModeStyle: ChartStyle?
    
    init(backgroundColor: Color = .white, accentColor: Color, secondGradientColor: Color, textColor: Color, legendTextColor: Color, dropShadowColor: Color, backgroundGradient: GradientColor = GradientColor(start: Color.neonOceanBlue, end: .white)){
        self.backgroundColor = backgroundColor
        self.accentColor = accentColor
        self.lineGradient = GradientColor(start: accentColor, end: secondGradientColor)
        self.textColor = textColor
        self.legendTextColor = legendTextColor
        self.dropShadowColor = dropShadowColor
        self.backgroundGradient = backgroundGradient
        self.numbersColor = Color.black
    }
    
    init(backgroundColor: Color, accentColor: Color = Color.white, gradientColor: GradientColor = GradientColor(start: Color.neonPurple, end: Color.neonOceanBlue), textColor: Color, legendTextColor: Color, dropShadowColor: Color = Color.white, backgroundGradient: GradientColor = GradientColor(start: Color.neonOceanBlue, end: .white)){
        self.backgroundColor = backgroundColor
        self.accentColor = accentColor
        self.lineGradient = gradientColor
        self.textColor = textColor
        self.legendTextColor = legendTextColor
        self.dropShadowColor = dropShadowColor
        self.backgroundGradient = backgroundGradient
        self.numbersColor = Color.black
    }
    
    public init(canvasBackgroundColor: Color = Color.white,
                lineGradient: GradientColor = GradientColor(start: Color.neonPurple, end: Color.neonOceanBlue),
                chartBackgroundGradient: GradientColor = GradientColor(start: Color.neonOceanBlue, end: Color.white),
                titleColor: Color = Color.black,
                subtitleColor: Color = Color.gray,
                numberColor: Color = Color.black) {
        self.backgroundColor = canvasBackgroundColor
        self.lineGradient = lineGradient
        self.backgroundGradient = chartBackgroundGradient
        self.textColor = titleColor
        self.legendTextColor = subtitleColor
        self.numbersColor = numberColor
        self.accentColor = Color.white
        self.dropShadowColor = Color.gray
    }
    
    init(formSize: CGSize){
        self.backgroundColor = Color.white
        self.accentColor = Color.neonOrange
        self.lineGradient = GradientColor.orange
        self.legendTextColor = Color.gray
        self.textColor = Color.black
        self.dropShadowColor = Color.gray
        self.backgroundGradient = GradientColor(start: Color.neonOceanBlue, end: .white)
        self.numbersColor = Color.black
    }
}

public class ChartData: ObservableObject, Identifiable {
    @Published var points: [(String,Double)]
    var valuesGiven: Bool = false
    var ID = UUID()
    
    public init<N: BinaryFloatingPoint>(points:[N]) {
        self.points = points.map{("", Double($0))}
    }
    public init<N: BinaryInteger>(values:[(String,N)]){
        self.points = values.map{($0.0, Double($0.1))}
        self.valuesGiven = true
    }
    public init<N: BinaryFloatingPoint>(values:[(String,N)]){
        self.points = values.map{($0.0, Double($0.1))}
        self.valuesGiven = true
    }
    public init<N: BinaryInteger>(numberValues:[(N,N)]){
        self.points = numberValues.map{(String($0.0), Double($0.1))}
        self.valuesGiven = true
    }
    public init<N: BinaryFloatingPoint & LosslessStringConvertible>(numberValues:[(N,N)]){
        self.points = numberValues.map{(String($0.0), Double($0.1))}
        self.valuesGiven = true
    }
    
    public func onlyPoints() -> [Double] {
        return self.points.map{ $0.1 }
    }
}

public class MultiLineChartData: ChartData {
    var gradient: GradientColor
    
    public init<N: BinaryFloatingPoint>(points:[N], gradient: GradientColor) {
        self.gradient = gradient
        super.init(points: points)
    }
    
    public init<N: BinaryFloatingPoint>(points:[N], color: Color) {
        self.gradient = GradientColor(start: color, end: color)
        super.init(points: points)
    }
    
    public func getGradient() -> GradientColor {
        return self.gradient
    }
}

public class TestData{
    static public var data:ChartData = ChartData(points: [37,72,51,22,39,47,66,85,50])
    static public var values:ChartData = ChartData(values: [("2017 Q3",220),
                                                            ("2017 Q4",1550),
                                                            ("2018 Q1",8180),
                                                            ("2018 Q2",18440),
                                                            ("2018 Q3",55840),
                                                            ("2018 Q4",63150), ("2019 Q1",50900), ("2019 Q2",77550), ("2019 Q3",79600), ("2019 Q4",92550)])
    
}

public extension Color {
    init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (r, g, b) = (int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (0, 0, 0)
        }
        self.init(red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255)
    }
}

class HapticFeedback {
    #if os(watchOS)
    //watchOS implementation
    static func playSelection() -> Void {
        WKInterfaceDevice.current().play(.click)
    }
    #else
    //iOS implementation
    let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
    static func playSelection() -> Void {
        UISelectionFeedbackGenerator().selectionChanged()
    }
    #endif
}

public struct ExampleData {
    static public var stockData: [Double] = [160.5331404754583, 160.40250727571717, 162.8506147726894, 161.92694191993948, 158.40048623320067, 153.9567743505621, 151.28123458390917, 152.02023865835056, 154.6197770997584, 152.0109551733966, 150.1851004932025, 148.8559937302199, 152.911828801144, 147.4429057165836, 150.70377510056963, 150.18102955156755, 156.21823212452531, 159.18526837217678, 160.01836267329438, 164.05346230247622, 168.09727898514257, 169.83196659534445, 172.67709320938704, 177.83531192598358, 178.86003325582215, 184.6853488455598, 185.41931532530313, 184.81211668204355, 192.80012413504093, 187.09796017435642, 190.93154884056318, 192.60120702829414, 194.18196058662664, 202.371384448484, 210.09328380932368, 206.1630505976593, 209.77078923730514, 214.05191477426584, 216.16367007415099, 223.07233826542154, 217.17161928603394, 224.98345884683306, 218.82768912189414, 219.84143804794022, 225.66682202648545, 230.66705086901376, 227.6548322082878, 226.77634783684357, 220.9112494672981, 218.87364956700705, 216.5262317676061, 218.69133294471456, 220.31892568748376, 228.9270799845026, 227.87330754663367, 228.43813542132406, 231.78856354004122, 229.32833540275533, 224.70326384684702, 217.2460701903257, 220.26762532899377, 217.81800195997116, 219.96237677033113, 222.257790526837, 225.31755194953143, 230.68965642786202, 233.93326150875487, 228.93736667537615, 224.86601307271752, 230.51672334294923, 222.6527238584736, 216.37287796927643, 217.6363043800111, 220.923745276521, 224.04466649190672, 216.308877936387, 210.4753161370458, 208.76333423633787, 201.5867470556164, 202.11892136139272, 198.46209966936553, 194.56803845779405, 202.23449917862166, 201.28661010268934, 202.19832519076866, 206.32635591516564, 208.30240145316174, 204.8390428646893, 209.87453924548097, 211.91128358923078, 214.04609937302644, 209.708958556725, 202.88790885762847, 201.5699424563367, 199.1636739049263, 200.94575022505873, 204.56733828312457, 204.91734251500642, 205.6281398269787, 198.40631401158353]
}



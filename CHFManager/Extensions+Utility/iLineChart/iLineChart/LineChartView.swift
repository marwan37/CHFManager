//
//  LineCard.swift
//  iLineChart
//
//  Created by András Samu on 2019. 08. 31..
//  Copyright © 2019. András Samu. All rights reserved.
//

import SwiftUI


struct LineChartView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @ObservedObject var data:ChartData
    public var title: String?
    public var legend: String?
    public var style: ChartStyle
    public var darkModeStyle: ChartStyle
    var indicatorKnob: Color
    
    private var rawData: [Double]
    public var formSize:CGSize
    public var dropShadow: Bool
    public var valueSpecifier:String
    public var curvedLines: Bool
    public var displayChartStats: Bool
    
    public var minWidth: CGFloat
    public var minHeight: CGFloat
    public var maxWidth: CGFloat
    public var maxHeight: CGFloat
    
    public var titleFont: Font
    public var subtitleFont: Font
    public var priceFont: Font
    
    private var contentHeight: CGFloat = 0
    private var topPadding: CGFloat = 0
    private var edgesIgnored: Edge.Set
    
    @State private var touchLocation:CGPoint = .zero
    @State private var showIndicatorDot: Bool = false
    @State private var currentValue: Double = 2 {
        didSet{
            if (oldValue != self.currentValue && showIndicatorDot) {
                HapticFeedback.playSelection()
            }
        }
    }
    var frame = CGSize(width: 180, height: 120)
    private var rateValue: Int?
    
    init(data: [Double],
                title: String? = nil,
                legend: String? = nil,
                style: ChartStyle = Styles.lineChartStyleOne,
                form: CGSize? = ChartForm.extraLarge,
                rateValue: Int? = 14,
                dropShadow: Bool? = false,
                valueSpecifier: String? = "%.1f",
                cursorColor: Color = Color.neonPink,
                curvedLines: Bool = true,
                displayChartStats: Bool = true,
                minWidth: CGFloat = 0,
                minHeight: CGFloat = 0,
                maxWidth: CGFloat = .infinity,
                maxHeight: CGFloat = .infinity,
                titleFont: Font = .system(size: 30, weight: .regular, design: .rounded),
                subtitleFont: Font = .system(size: 14, weight: .light, design: .rounded),
                priceFont: Font = .system(size: 16, weight: .bold, design: .monospaced),
                fullScreen: Bool = false
                ) {
        
        self.rawData = data
        self.data = ChartData(points: data)
        self.title = title
        self.legend = legend
        self.style = style
        self.darkModeStyle = style.darkModeStyle != nil ? style.darkModeStyle! : Styles.lineViewDarkMode
//        self.formSize = CGSize(width: width, height: height)
//        self.width = width
//        self.height = height
//        frame = CGSize(width: width, height: height)
        // MARK: DEBUG
        self.formSize = CGSize(width: maxWidth, height: maxHeight)
        self.maxWidth = maxWidth
        self.maxHeight = maxHeight
        frame = CGSize(width: maxWidth, height: maxHeight)
        self.dropShadow = dropShadow!
        self.valueSpecifier = valueSpecifier!
        self.rateValue = rateValue
        self.indicatorKnob = cursorColor
        self.curvedLines = curvedLines
        self.displayChartStats = displayChartStats
        self.subtitleFont = subtitleFont
        self.titleFont = titleFont
        self.priceFont = priceFont
        self.minHeight = minHeight
        self.minWidth = minWidth
        
        self.edgesIgnored = fullScreen ? .all : .bottom
    }
    
    private var internalRate: Int? {
        if (self.rawData.count > 0) && (self.rawData.first! == 0) {
            return nil
        }
        
        if !self.showIndicatorDot {
            if self.rawData.count > 1 {
                return Int(((self.rawData.last!/self.rawData.first!) - 1)*100)
            } else {
                return nil
            }
        } else {
            if self.rawData.count > 1 {
                return Int(((self.currentValue/self.rawData.first!) - 1)*100)
            } else {
                return nil
            }
        }
    }
    
    var body: some View {
        GeometryReader { g in
            ZStack(alignment: .center) {
                if (self.edgesIgnored == .all) {
                    Rectangle()
                        .fill(self.style.backgroundColor)
                        .edgesIgnoringSafeArea(self.edgesIgnored)
                }
                
                
                VStack(alignment: .leading) {
                    if ((self.title != nil) || (self.legend != nil) || (self.displayChartStats)) {
                        VStack(alignment: .leading, spacing: 0){
                            if (self.title != nil) {
                                Text(self.title!)
                                    .font(self.titleFont)
                                    .foregroundColor(self.colorScheme == .dark ? self.darkModeStyle.textColor : self.style.textColor)
                            }
                            
                            if (self.legend != nil){
                                Text(self.legend!)
                                    .font(self.subtitleFont)
                                    .foregroundColor(self.colorScheme == .dark ? self.darkModeStyle.legendTextColor :self.style.legendTextColor)
                            }
                            
                            HStack {
                                if ((self.displayChartStats)) {
                                    if (self.showIndicatorDot) {
                                        if (self.internalRate != nil) {
                                            Text("\(String(format: self.valueSpecifier, self.currentValue)) (\(self.internalRate!)%)")
                                        } else {
                                            Text("\(String(format: self.valueSpecifier, self.currentValue))")
                                        }
                                    } else if (self.rawData.last != nil) {
                                        if (self.internalRate != nil) {
                                            Text("\(String(format: self.valueSpecifier, self.rawData.last!)) (\(self.internalRate!)%)").font(self.priceFont)
                                        } else {
                                            Text("\(String(format: self.valueSpecifier, self.rawData.last!))")
                                        }
                                    } else if (self.internalRate != nil) {
                                        Text("(\(self.internalRate!)%)")
                                    } else {
                                        Text("nil")
                                    }
                                }
                            }.font(self.priceFont).foregroundColor(self.style.numbersColor).padding(.top)
                        }
                        .transition(.opacity)
                        .animation(.easeIn(duration: 0.1))
                        .padding([.leading, .top])
                        .padding(.top, self.topPadding)
                    }
                    

                    GeometryReader{ geometry in
                        Line(data: self.data,
                             frame: .constant(geometry.frame(in: .local)),
                             touchLocation: self.$touchLocation,
                             showIndicator: self.$showIndicatorDot,
                             minDataValue: .constant(nil),
                             maxDataValue: .constant(nil),
                             lineGradient: self.style.lineGradient,
                             backgroundGradient: self.style.backgroundGradient,
                             indicatorKnob: self.indicatorKnob,
                             curvedLines: self.curvedLines
                        )
                    }
                    .frame(minWidth: self.minWidth, maxWidth: self.maxWidth, minHeight: self.minHeight, maxHeight: self.maxHeight)
                    .padding(.bottom)
                    
                    
                    // MARK: Frames
    //                .clipShape(RoundedRectangle(cornerRadius: 0))
                    
                }
                .background(self.style.backgroundColor)
                .frame(width: (self.maxWidth == .infinity ? g.size.width : self.maxWidth), height: (self.maxHeight == .infinity ? g.size.height : self.maxHeight))
               
                
            }
            .gesture(DragGesture(minimumDistance: 0)
                .onChanged({ value in
                    self.touchLocation = value.location
                    self.showIndicatorDot = true
                    // MARK: Frames
                    self.getClosestDataPoint(toPoint: value.location,
                                             width:(self.maxWidth == .infinity ? g.size.width : self.maxWidth),
                                             height:(self.maxHeight == .infinity ? g.size.height : self.maxHeight))
                })
                .onEnded({ value in
                    self.showIndicatorDot = false
                })
                // MARK: Frames
                
            )
        }
    }
    
    @discardableResult func getClosestDataPoint(toPoint: CGPoint, width:CGFloat, height: CGFloat) -> CGPoint {
        let points = self.data.onlyPoints()
        let stepWidth: CGFloat = width / CGFloat(points.count-1)
        let stepHeight: CGFloat = height / CGFloat(points.max()! + points.min()!)
        
        let index:Int = Int(round((toPoint.x)/stepWidth))
        if (index >= 0 && index < points.count){
            self.currentValue = points[index]
            return CGPoint(x: CGFloat(index)*stepWidth, y: CGFloat(points[index])*stepHeight)
        }
        return .zero
    }
}

struct WidgetView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LineChartView(data: [8,23,54,32,12,37,7,23,43], title: "Line chart", legend: "Basic")
                .environment(\.colorScheme, .light)
            
            LineChartView(data: [282.502, 284.495, 283.51, 285.019, 285.197, 286.118, 288.737, 288.455, 289.391, 287.691, 285.878, 286.46, 286.252, 284.652, 284.129, 284.188], title: "Line chart", legend: "Basic")
            .environment(\.colorScheme, .light)
        }
    }
}

//
//  UnitConverter.swift
//  
//
//  Created by Deeb Zaarab on 2021-01-09.
//

import SwiftUI
import Combine

struct UnitConverter: View {
    @Environment(\.colorScheme) var cs
    @State private var inputValue = ""
    @State private var outputValue = ""
    let cupsUSKitchen = UnitVolume(symbol: "cupsUSKitchen", converter: UnitConverterLinear(coefficient: 0.236588))
    @State private var inputUnitValue = 2
    let inputUnits = ["fl. oz.", "mL", "L", "cc", "cup", "pint", "quart"]
    @State private var outputUnitValue = 2
    let outputUnits = ["fl. oz", "mL", "L", "cc", "cup", "pint", "quart"]
    var inputUnitAfterConversionToOutput: String {
        var output = ""
        var input = Measurement(value: 0, unit: UnitVolume.fluidOunces)
        
        switch inputUnits[inputUnitValue] {
        case "fl. oz.": input = Measurement(value: Double(inputValue) ?? 0, unit: UnitVolume.fluidOunces)
        case "mL": input = Measurement(value: Double(inputValue) ?? 0, unit: UnitVolume.milliliters)
        case "L": input = Measurement(value: Double(inputValue) ?? 0, unit: UnitVolume.liters)
        case "cc": input = Measurement(value: Double(inputValue) ?? 0, unit: UnitVolume.cubicMeters)
        case "cup": input = Measurement(value: Double(inputValue) ?? 0, unit: cupsUSKitchen)
        case "pint": input = Measurement(value: Double(inputValue) ?? 0, unit: UnitVolume.pints)
        case "quart": input = Measurement(value: Double(inputValue) ?? 0, unit: UnitVolume.quarts)
        default: input = Measurement(value: Double(inputValue) ?? 0, unit: UnitVolume.fluidOunces)
        }
        
        switch outputUnits[outputUnitValue] {
        case "fl. oz.": output = String(describing: input.converted(to: UnitVolume.fluidOunces))
        case "mL": output = String(describing: input.converted(to: UnitVolume.milliliters))
        case "L": output = String(describing: input.converted(to: UnitVolume.liters))
        case "cc": output = String(describing: input.converted(to: UnitVolume.cubicMeters))
        case "cup": output = String(describing: input.converted(to: UnitVolume.cups))
        case "pint": output = String(describing: input.converted(to: UnitVolume.pints))
        case "quart": output = String(describing: input.converted(to: UnitVolume.quarts))
        default: output = String(describing: input.converted(to: UnitVolume.fluidOunces))
        }
        return output
    }
   
    
    
    var body: some View {
        ZStack{
            Color.backgroundColor(for: cs)
        VStack {
            Form{
                Section(header:Text("Enter Input Value here")){
                    TextField("Input Value", text: $inputValue)
                    Picker("Input Unit - ", selection:$inputUnitValue){
                        ForEach(0..<inputUnits.count) {
                            Text("\(inputUnits[$0])")
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
               
                Section(header:Text("Output")){
                    Text(inputUnitAfterConversionToOutput)
                    Picker("Output Unit - ", selection:$outputUnitValue){
                        ForEach(0..<outputUnits.count) {
                            Text("\(outputUnits[$0])")
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
           
         
              
                
            }.font(.system(size: 14, weight: .light, design: .monospaced))
        }
        
        }
    }
  
   
   
}

struct UnitConverter_Previews: PreviewProvider {
    static var previews: some View {
        UnitConverter()
    }
}


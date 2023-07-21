//
//  RefactorView.swift
//  ScrumdingerDemo
//
//  Created by Pixel Mission on 27.06.23.
//

import SwiftUI

struct RefactorView: View {
    @State private var currentStep = 1
    @State private var task: String = ""
    @State private var sliderValue: Double = 100
    
    @StateObject private var mqtt = MQTTManager()
    
    var body: some View {
        VStack {
            
            //debug: show mqtt information
            if mqtt.isConnected {
                Text("Connected to MQTT broker")
                    .foregroundColor(.green)
            } else {
                Text("Disconnected from MQTT broker")
                    .foregroundColor(.red)
            }
            
            HeaderView(currentStep: currentStep, totalSteps: 6)
            
            if currentStep == 1 {
                StepOneView(currentStep: $currentStep, task: $task, sliderValue: $sliderValue)
            } else if currentStep == 2 {
                StepTwoView(currentStep: $currentStep, task: $task, sliderValue: $sliderValue)
            } else if currentStep == 3 {
                StepThreeView(currentStep: $currentStep, task: $task)
            }
            Spacer()
            FooterView(currentStep: $currentStep, task: $task)
        }
        .onAppear {
            mqtt.connect()
            mqtt.subscribeToTopic("ios/read")
        }
        .onChange(of: sliderValue) { newSliderValue in
            print("slider changed to: \(newSliderValue)")
            mqtt.publish(topic: "machine/servo_schlitten", message: "\(newSliderValue)")
        }
        .navigationTitle("Refactor")
    }
}


// ********** step views **********
struct StepOneView: View {
    @Binding var currentStep: Int
    @Binding var task: String
    @Binding var sliderValue: Double
    
    var body: some View {
        HStack {
            VStack {
                
                HStack {
                        Rectangle() //Auge
                            .foregroundColor(.gray)
                            .frame(width: 30, height: 50)
                            .offset(x: 0, y: +25)
              
                        
                        Rectangle() //Linse
                            .foregroundColor(.gray)
                            .frame(width: 30, height: 100)
                            .offset(x: 0, y: 0)
              
                        
                        Rectangle() //Schlitten
                            .foregroundColor(.blue)
                            .frame(width: 30, height: 100)
                            .offset(x: sliderValue, y: 0)
                            .animation(.easeInOut, value: sliderValue)
                }

              
                
                Image("ref")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                HStack {
                    Image(systemName: "lightbulb")
                        .font(.system(size: 25, weight: .bold))
                    Spacer()
                    SliderView(sliderValue: $sliderValue)
                        .frame(minWidth: 0)
                }
                
            }
            .onAppear {
                task = "In den Kreisstrukturen scharfe Stelle entdeckt?"
            }
        }
    }
}

struct StepTwoView: View {
    @Binding var currentStep: Int
    @Binding var task: String
    @Binding var sliderValue: Double
    
    var body: some View {
        VStack {
            Image("ref")
                .resizable()
                 .aspectRatio(contentMode: .fit)
           
            SliderView(sliderValue: $sliderValue)
                .frame(minWidth: 0)
        }
        .onAppear {
            task = "Scharfer Ringanteil nur noch im roten Bereich?"
        }
    }
}

struct StepThreeView: View {
    @Binding var currentStep: Int
    @Binding var task: String
    @State var degree: Double = 0
    
    var body: some View {
        VStack {
            Image("ref")
                .resizable()
                 .aspectRatio(contentMode: .fit)
           
            ProgressBar(degreeValue: $degree)
                .frame(minWidth: 0)
        }
        .onAppear {
            task = "Dreierlinie scharf?"
        }
    }
}

// ********** header, footer, main **********
struct HeaderView: View {
    let currentStep: Int
    let totalSteps: Int
    
    var body: some View {
        HStack(spacing: 20) {
            ForEach(1...totalSteps, id: \.self) { step in
                Circle()
                    .foregroundColor(
                        step == currentStep ? .blue :
                            step < currentStep ? .green : .gray
                    )
                    .frame(width: 30, height: 30)
                    .overlay(
                        Text("\(step)")
                            .font(.headline)
                            .foregroundColor(.white)
                    )
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 40)
    }
}

struct FooterView: View {
    @Binding var currentStep: Int
    @Binding var task: String
    
    var body: some View {
        VStack {
            Divider()
            HStack{
                Text("\(task)")
                .padding()
                
                Spacer()
                
                Button(action: {
                    currentStep += 1
                }) {
                    HStack {
                        Text("Ja")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.green)
                        Image(systemName: "arrow.right.circle.fill")
                            .foregroundColor(.green)
                    }
                    .padding()
                }
                
            }
        }
        //.font(.system(size: 70, weight: .bold))
        
        
        
    }
}

struct SliderView: View {
    var schlittenMaxPos: Double = 100
    var step: Double = 1
    @Binding var sliderValue: Double
    @State var schlittenPos: Int = 0
    
    var body: some View {
        VStack {
           
           Text("Schlitten Sehzeichen Position: \(schlittenPos) mm")
               .padding()
           
           HStack {
               
               Button(action: decreaseSliderValue) {
                   Image(systemName: "minus.circle")
                       .font(.largeTitle)
               }
               .disabled(sliderValue <= 0)
               
               Slider(value: Binding(
                    get: { self.sliderValue },
                    set: {
                        self.sliderValue = $0
                        self.schlittenPos = Int(schlittenMaxPos.rounded()) - Int($0.rounded())
                    }
                ), in: 0...schlittenMaxPos, step: step)
               .padding()
               //.disabled(true)
               
               Button(action: increaseSliderValue) {
                   Image(systemName: "plus.circle")
                       .font(.largeTitle)
               }
               .disabled(sliderValue >= schlittenMaxPos)
           }
           .padding()
            
       }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    }
    
    func decreaseSliderValue() {
        if sliderValue > 0 {
            sliderValue -= step
            self.schlittenPos = Int(schlittenMaxPos.rounded()) - Int(sliderValue.rounded())
        }
    }
    
    func increaseSliderValue() {
        if sliderValue < schlittenMaxPos {
            sliderValue += step
            self.schlittenPos = Int(schlittenMaxPos.rounded()) - Int(sliderValue.rounded())
        }
    }
}

struct ProgressBar: View {
    @GestureState private var isPressingDown: Bool = false
    @GestureState private var isButtonHold = false
    @Binding var degreeValue: Double
    private let step: Double = 1
    let holdIncrementDuration = 0.1
    
    var body: some View {
        VStack {
            Text(String(format: "%.0f °%", min(self.degreeValue, 360)))
                .bold()
            HStack {
                
                ProgressBarButton(degreeValue: $degreeValue, step: -1, img: "minus.circle")
                
                ZStack {
                    Circle()
                        .stroke(lineWidth: 10.0)
                        .opacity(0.3)
                        .foregroundColor(Color.red)
                    
                    Circle()
                        .trim(from: 0.0, to: CGFloat(min(self.degreeValue / 360.0, 1.0)))
                        .stroke(style: StrokeStyle(lineWidth: 10.0, lineCap: .round, lineJoin: .round))
                        .foregroundColor(Color.red)
                        .rotationEffect(Angle(degrees: 270.0))
                    
                    Image(systemName: "arrow.3.trianglepath")
                        .rotationEffect(.degrees(degreeValue))
                }
                .frame(width: 50.0, height: 50.0)
                
                ProgressBarButton(degreeValue: $degreeValue, step: 1, img: "plus.circle")
            }

        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    }
    

    

}

struct ProgressBarButton: View {
    @GestureState private var isPressingDown: Bool = false
    @Binding var degreeValue: Double
    var step: Double
    var img: String
    
    var body: some View {
        Button(action: {
            
        }) {
            Image(systemName: img)
                .font(.largeTitle)
        }
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 2.0)
                .sequenced(before:
                    LongPressGesture(minimumDuration: .infinity)
                )
                .updating($isPressingDown) { value, state, transaction in
                    switch value {
                        case .second(true, nil): //This means the first Gesture completed
                            state = true //Update the GestureState
                            //long press started
                        default: break
                    }
                }
            )
            .highPriorityGesture(
                TapGesture()
                    .onEnded { _ in //tap
                        updateDegreeValue()
                    }
            )
        
        .onAppear {
           startFunction()
       }
    }
    
    func startFunction() {
        DispatchQueue.global().async {
            while true {
                if(isPressingDown){ //long press
                    updateDegreeValue()
                    Thread.sleep(forTimeInterval: 0.1)
                }
            
                
            }
        }
    }
    
    func updateDegreeValue() {
        degreeValue += step
        if(degreeValue >= 360){
            degreeValue = 360
        }
        if(degreeValue <= 0){
            degreeValue = 0
        }
    }
}

// ********** preview **********
struct RefactorView_Previews: PreviewProvider {
    static var previews: some View {
        RefactorView()
    }
}

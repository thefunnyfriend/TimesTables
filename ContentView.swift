//
//  ContentView.swift
//  TimesTables
//

import SwiftUI

struct QuestionGenerator: View {

    @State var questions = [String]()
    @State var timesTables = 1
    @State var correctAnswer = 0
    @State var numberOfQuestions = 10.0
    
    var body: some View {
        Text("Hello World")
    }
    func questionGenerator() {
        for n1 in 1...12 {
            for n2 in 1...timesTables {
                questions.append("\(n1) x \(n2)")
                correctAnswer = n1 * n2
            }
        }
    }
}

struct ContentView: View {
    let qg = QuestionGenerator()
    var body: some View {
        NavigationView {
            VStack {
                Text("Choose your times tables:")
                
                Stepper(value: qg.$timesTables, in: 1...12, step: 1) {
                    Text("Up to: \(qg.timesTables)")
                }
                
                Slider(value: qg.$numberOfQuestions, in: 5...50)
                .labelsHidden()
                Text("Number of Questions: \(qg.numberOfQuestions, specifier: "%.g")")
                
                Spacer()
                
                NavigationLink(destination: GameView()) {
                    Text("Prepare for LiftOff")
                }
            }
        }
        .navigationBarTitle("Multiplication to Mars!")
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  GameView.swift
//  TimesTables
//

import SwiftUI

struct GameView: View {
    let qg = QuestionGenerator()
    @State private var userInput = ""
    @State private var currentQuestion = ""
    @State private var score = 0
    @State private var questionCounter = 0
    @State private var questionsAnsweredCorrect = [String]()
    @State private var questionsAnsweredWrong = [String]()
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text(currentQuestion)
                
                TextField("Answer", text: $userInput)
                    .keyboardType(.numberPad)
                
                Button("Enter") {
                    self.checkAnswer()
                    UIApplication.shared.endEditing()
                }
                
                Text("Score: \(score)")
                
                List {
                    Section(header:
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    ) {
                        ForEach(0 ..< questionsAnsweredCorrect.count) {
                            Text(self.questionsAnsweredCorrect[$0])
                        }
                    }
                    
                    Section(header:
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                    ) {
                        ForEach(0 ..< questionsAnsweredWrong.count) {
                            Text(self.questionsAnsweredWrong[$0])
                        }
                    }
                }
            }
        }
        .onAppear(perform: generateQuestions)
    }
    func generateQuestions() {
        // chooses random question from questions array
        currentQuestion = qg.questions.randomElement() ?? "1 x 1"
    }
    
    func checkAnswer() {
        let userAnswer = Int(userInput) ?? 0
        
        // add to question counter
        questionCounter += 1
        
        if userAnswer == qg.correctAnswer {
            // add one point to score
            score += 1
            // add to correct answers array
            questionsAnsweredCorrect.append("\(currentQuestion) = \(userInput)")
        } else {
            // add to wrong answers array
            questionsAnsweredWrong.append("\(currentQuestion) = \(userInput)")
            
        }
        // if questions answered total is less than number of questions specified, continue.
        
        if (questionsAnsweredWrong.count + questionsAnsweredCorrect.count) <= Int(qg.numberOfQuestions) {
            generateQuestions()
        }
        // else create an alert to indiciate user is finished. return to ContentView
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}

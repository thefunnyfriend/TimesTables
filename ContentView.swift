//
//  ContentView.swift
//  TimesTables
//

import SwiftUI

struct ContentView: View {
    @State private var gameActive = false
    @State private var userSettings = false
    
    @State var timesTables = 1
    @State var questionSelection = 2
    @State private var difficultySelection = 2
    
    @State var questions = [String]()
    
    
    let questionAmount = ["5", "10", "20", "All"]
    let difficultyLevel = ["Easy", "Medium", "Hard", "Any"]
    
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Choose your times tables:")
                
                Stepper(value: $timesTables, in: 1...12, step: 1) {
                    Text("Up to \(timesTables) times tables")
                    .padding(25)
                }
                    
                Text("Choose the number of questions:")
                    
                Picker("Number of Questions", selection: $questionSelection) {
                    ForEach(0 ..< questionAmount.count, id: \.self) { number in
                        Text("\(self.questionAmount[number])")
                    }
                }
            .pickerStyle(SegmentedPickerStyle())
            .padding(25)
                    
                Text("Choose your difficulty level:")
                Picker("Difficulty Level", selection: $difficultySelection) {
                    ForEach(0 ..< difficultyLevel.count, id: \.self) { level in
                        Text("\(self.difficultyLevel[level])")
                    }
                }
            .pickerStyle(SegmentedPickerStyle())
            .padding(25)
                    
                NavigationLink(destination: Question()) {
                    Text("Next")
                        .frame(width: 120, height: 80)
                        .background(Color.blue)
                        .font(.title)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
            }
        .navigationBarTitle("Welcome!")
        }
    }
    
    func generateQuestions() {
        
        if difficultySelection == 0 {
            for number in 1...self.timesTables {
                for otherNumber in 1...4 {
                    self.questions.append("\(number) x \(otherNumber)")
                }
            }
            
        } else if difficultySelection == 1 {
            for number in 1...self.timesTables {
                for otherNumber in 5...8 {
                    self.questions.append("\(number) x \(otherNumber)")
                }
            }
        } else if difficultySelection == 2 {
            for number in 1...self.timesTables {
                for otherNumber in 9...12 {
                    self.questions.append("\(number) x \(otherNumber)")
                }
            }
        } else {
            for number in 1...self.timesTables {
                for otherNumber in 1...12 {
                    self.questions.append("\(number) x \(otherNumber)")
                }
            }
        }
    }
}

struct Question: View {
   let contentView = ContentView()
    
    @State private var userInput = ""
    @State private var userAnswer = 0
    @State private var answers = [String]()
    @State private var correctAnswer = 1
    @State private var score = 0
    @State private var numberOfQuestions = 1
    @State private var questionCounter = 0
    @State private var imageName = ""
    @State private var showingButton = true

    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    @State private var currentQuestion = ""
    var body: some View {
        NavigationView {
            VStack {
                Button("Start", action: {
                    self.contentView.generateQuestions()
                    self.getNumberOfQuestions()
                    self.startGame()
                })
                    .frame(width: 120, height: 80)
                    .background(Color.blue)
                    .font(.title)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .onTapGesture {
                        self.showingButton = false
                        }
                .disabled(!showingButton)
                
                Spacer(minLength: 10)
                
                Text("\(currentQuestion) =")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                TextField("Your Answer", text: $userInput, onCommit: checkAnswer)
                    .keyboardType(.numberPad)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Enter", action: {
                    self.checkAnswer()
                    self.startGame()
                    UIApplication.shared.endEditing()
                })
                    
                Spacer()
                        
                List(answers, id: \.self) {
                    if self.userAnswer == self.correctAnswer {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    } else {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                    }
                    Text($0)
                }
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(self.alertTitle), message: Text(self.alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    func startGame() {
        currentQuestion = contentView.questions.randomElement() ?? "1 x 1"
    }
    func getNumberOfQuestions() {
        numberOfQuestions = Int(contentView.questionAmount[contentView.questionSelection]) ?? (contentView.timesTables * 12)
    }
        
    func checkAnswer() {
        
        let multiplier = currentQuestion.components(separatedBy: " ")
        // array should look like ["1", "x", "1"]
    
        let correctAnswer = (Int(multiplier[0]) ?? 1) * (Int(multiplier[2]) ?? 1)
        userAnswer = Int(userInput) ?? 0
            
        if userAnswer == correctAnswer {
            score += 1
            questionCounter += 1
            answers.insert(String(userAnswer), at: 0)
            imageName = "checkmark.circle.fill"
        } else {
            questionCounter += 1
            answers.insert(String(userAnswer), at: 0)
            imageName = "xmark.circle.fill"
        }
                
        if self.questionCounter == numberOfQuestions {
            alertTitle = "All Done"
            alertMessage = "Nice work, you completed the questions! Your score is: \(score)"
        showingAlert = true
        }
    }
}
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

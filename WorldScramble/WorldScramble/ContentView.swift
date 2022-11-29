//
//  ContentView.swift
//  WorldScramble
//
//  Created by Enrico Sousa Gollner on 20/11/22.
//
 
import SwiftUI
 
struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var newWord =  ""
    @State private var rootWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    @State private var score = 0
    
    var body: some View{
        NavigationStack{
            List{
                Section{
                    TextField("Enter your word", text: $newWord)
                        .autocapitalization(.none)
                }
                Section{
                    ForEach(usedWords, id: \.self){ word in
                        HStack{
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
            .navigationBarTitleDisplayMode(.large)
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showingError){
                Button("OK", role: .cancel){  }
            } message: {
                Text(errorMessage)
            }
            .toolbar{
                Button("Restart", action: startGame)
            }
            Text("Score: \(score)")
        }
    }
    
    func addNewWord(){
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Verifications:
        guard answer.count > 0 else{ return }
        
        guard isOriginal(word: answer) else{
            wordError(title: "Word already used", message: "Be more original! \nRemember:\nYou can't use the displayed word!")
            return
        }
        
        guard isPossible(word: answer) else{
            wordError(title: "Word not possible", message: "You can't spell that word from \(rootWord)!")
            return
        }
        
        guard isReal(word: answer) else{
            wordError(title: "Word not recognize", message: "You can't just make them up, you know!")
            return
        }
        
        guard isMore3letters(word: answer) else{
            wordError(title: "More than 3 letters", message: "You can do that!")
            return
        }
        
        withAnimation{
            usedWords.insert(answer, at: 0)
            score += newWord.count
        }
        
        newWord = ""
    }
    
    func startGame(){
        score = 0
        usedWords = []
        
        if let startUrl = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let startWords = try? String(contentsOf: startUrl){
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
            }
        }
    }
    
    func isOriginal(word: String) -> Bool{
        !usedWords.contains(word) && word != rootWord
    }
    
    func isPossible(word: String) -> Bool{
        var tempWord = rootWord
        
        for letter in word{
            if let pos = tempWord.firstIndex(of: letter){
                tempWord.remove(at: pos)
            } else{
                return false
            }
        }
        
        return true
    }
    
    func isReal(word: String) -> Bool{
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func isMore3letters(word: String) -> Bool{
        return word.count > 2
    }
    
    func wordError(title: String, message: String){
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}
 
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

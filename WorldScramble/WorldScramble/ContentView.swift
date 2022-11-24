//
//  ContentView.swift
//  WorldScramble
//
//  Created by Enrico Sousa Gollner on 20/11/22.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    var body: some View{
        NavigationStack{
            List{
                Section{
                    TextField("Enter your word", text: $newWord)
                        .autocapitalization(.none)  // disable automatic first letter capitalized
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
            .onSubmit(addNewWord)
        }
    }
    
    func addNewWord(){
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else { return }  // Making sure there's at least one charecter in here
        
        // Extra validation
        
        withAnimation{
            usedWords.insert(answer, at: 0)
        }
        
        newWord = ""  // Empty again
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

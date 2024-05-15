//
//  LetterInputView.swift
//  Test doing lines
//
//  Created by Steven Hertz on 5/15/24.
//

import SwiftUI

  // Initial View for Letter Input
  struct LetterInputView: View {
    
      @State private var inputLetters: String = ""
      @State private var showContentView: Bool = false
      
    
    var body: some View {
          NavigationView {
            
              VStack {
                getTextView()
                processNameButton()
                  
                  NavigationLink(destination: ShowTehillimView(categorizedLines: filterCategorizedLines(by: inputLetters), orderedLetters: Array(inputLetters.map { String($0) })),
                                 isActive: $showContentView) {
                      EmptyView()
                  }
              }
              .padding()
              .navigationTitle("Enter Letters")
          }
      }
      
      // Function to filter categorized lines by specified letters
      func filterCategorizedLines(by letters: String) -> [String: [String]] {
          guard let fileContents = readFileContents(fileName: "lines", fileExtension: "txt") else {
              return [:]
          }
          
          let lines = splitParagraphIntoLines(paragraph: fileContents)
          let categorizedLines = categorizeLinesByFirstLetter(lines: lines)
          
          return categorizedLines.filter { key, _ in
              letters.contains(key)
          }
      }
  }

// methods that return views in the stack view
extension LetterInputView {
  
//  get the name

  fileprivate func getTextView() -> some View {
    TextField("Enter letters (e.g., אבג)", text: $inputLetters)
      .padding()
      .textFieldStyle(RoundedBorderTextFieldStyle())
      .environment(\.layoutDirection, .rightToLeft)
  }
  
  fileprivate func processNameButton() -> some View {
    Button(action: {
      showContentView = true
    }) {
      Text("Submit")
        .foregroundColor(.white)
        .padding()
        .background(Color.blue)
        .cornerRadius(8)
    }
    .padding()
    .disabled(inputLetters.isEmpty)
  }

}

#Preview {
    LetterInputView()
}

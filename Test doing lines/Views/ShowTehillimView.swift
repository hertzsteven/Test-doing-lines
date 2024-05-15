//
//  ContentView.swift
//  Test doing lines
//
//  Created by Steven Hertz on 5/14/24.
//

import SwiftUI


  // ContentView updated to use orderedLetters and selected index
  struct ShowTehillimView: View {
      let categorizedLines: [String: [String]]
      let orderedLetters: [String]
      
      @State private var selectedIndices: [Int] = []
      @State private var selectedLine: String?
      
      var body: some View {
          VStack {
              ZStack {
                  RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                      .fill(Color.gray.opacity(0.2))
                      .frame(maxWidth: .infinity)
                      .frame(height: 50)
                      .overlay(
                          RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                              .stroke(Color.red, lineWidth: 2)
                      )
                      .padding(8)
                  
                  ScrollView(.horizontal, showsIndicators: false) {
                      HStack {
                          Spacer()
                          ForEach(orderedLetters.indices, id: \.self) { index in
                              Button(action: {
                                  withAnimation {
                                      selectedIndices = [index]
                                  }
                              }) {
                                  Text(orderedLetters[index])
                                      .font(.headline)
                                      .padding(.vertical)
                                      .padding(.horizontal, 8)
                                      .background(selectedIndices.contains(index) ? Color.blue : Color.clear)
                                      .foregroundColor(selectedIndices.contains(index) ? Color.white : Color.primary)
                                      .cornerRadius(8)
                                      .animation(.easeInOut(duration: 0.3), value: selectedIndices)
                              }

                          }
                      }
                      .padding()
                      .frame(maxWidth: .infinity)
                  }
                  .environment(\.layoutDirection, .rightToLeft)

  //                .frame(maxWidth: .infinity, alignment: .trailing)
              }
              
              List {
                  if let selectedIndex = selectedIndices.first, selectedIndex < orderedLetters.count {
                      let selectedLetter = orderedLetters[selectedIndex]
                      if let lines = categorizedLines[selectedLetter] {
                          Section(header: Text("Lines for \(selectedLetter)")) {
                              ForEach(lines, id: \.self) { line in
                                  Text(" " + line)
                                      .frame(maxWidth: .infinity, alignment: .trailing)
                                      .padding(.vertical, selectedLine == line ? 16 : 8)

                                      .background(selectedLine == line ? Color.gray.opacity(0.3) : Color.clear)
                                      .cornerRadius(8)
                                      .onTapGesture {
                                          withAnimation {
                                              selectedLine = line
                                          }
                                      }
                              }
                          }
                      }
                  }
              }
          }
          .navigationTitle("Select a Letter")
          .frame(maxWidth: .infinity, alignment: .trailing)
      }
  }

  // Preview Provider
  struct ContentView_Previews: PreviewProvider {
      static var previews: some View {
          // Sample dictionary for preview
          let sampleCategorizedLines: [String: [String]] = [
              "a": ["apple pie", "apricot jam", "avocado toast"],
              "b": ["banana bread", "blueberry muffin", "blackberry cobbler"],
              "c": ["cherry tart"]
          ]
          ShowTehillimView(categorizedLines: sampleCategorizedLines, orderedLetters: ["a", "c", "a"])
      }
  }

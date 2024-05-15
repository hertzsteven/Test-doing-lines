
import SwiftUI

// Function to split the paragraph into lines
func splitParagraphIntoLines(paragraph: String) -> [String] {
    return paragraph.components(separatedBy: .newlines)
}

// Function to remove nekudos from a Hebrew character
func removeNekudos(from text: String) -> String {
    return text.unicodeScalars.filter { scalar in
        // Hebrew nekudos are in the range U+0591 to U+05C7
        !(0x0591...0x05C7).contains(Int(scalar.value))
    }.map(String.init).joined()
}

// Function to categorize lines by their first letter
func categorizeLinesByFirstLetter(lines: [String]) -> [String: [String]] {
    var dictionary: [String: [String]] = [:]
    lines.forEach { line in
        if let firstLetter = line.first {
            dictionary[removeNekudos(from: String(firstLetter)), default: []].append(line)
        }
    }
    return dictionary
}

// Function to read the contents of a file from the app's resources
func readFileContents(fileName: String, fileExtension: String) -> String? {
    if let fileURL = Bundle.main.url(forResource: fileName, withExtension: fileExtension) {
        return try? String(contentsOf: fileURL)
    }
    return nil
}

// Initial View for Letter Input
struct LetterInputView: View {
    @State private var inputLetters: String = ""
    @State private var showContentView: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter letters (e.g., אבג)", text: $inputLetters)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .multilineTextAlignment(.trailing) // Ensure proper alignment
                    .environment(\.layoutDirection, .rightToLeft)

                
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
                
                NavigationLink(destination: ContentView(categorizedLines: filterCategorizedLines(by: inputLetters), orderedLetters: Array(inputLetters.map { String($0) })),
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

// ContentView updated to use orderedLetters and selected index
struct ContentView: View {
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
        ContentView(categorizedLines: sampleCategorizedLines, orderedLetters: ["a", "c", "a"])
    }
}

// SwiftUI App
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            LetterInputView()
        }
    }
}

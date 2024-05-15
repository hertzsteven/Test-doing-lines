
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


// SwiftUI App
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            LetterInputView()
        }
    }
}

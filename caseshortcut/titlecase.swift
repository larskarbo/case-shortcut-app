//
//  titlecase.swift
//  case-shortcut
//
//  Created by Lars Karbø on 26/02/2021.
//

import Foundation

fileprivate let badChars = CharacterSet.alphanumerics.inverted
public extension String {
    subscript(range: NSRange) -> Substring {
        get {
            if range.location == NSNotFound {
                return ""
            } else {
                let swiftRange = Range(range, in: self)!
                return self[swiftRange]
            }
        }
    }

    /// Title-cased string is a string that has the first letter of each word capitalised (except for prepositions, articles and conjunctions)
    var localizedTitleCasedString: String {
        var newStr: String = ""

        // create linguistic tagger
        let tagger = NSLinguisticTagger(tagSchemes: [.lexicalClass], options: 0)
        let range = NSRange(location: 0, length: self.utf16.count)
        tagger.string = self

        // enumerate linguistic tags in string
        tagger.enumerateTags(in: range, unit: .word, scheme: .lexicalClass, options: []) { tag, tokenRange, _ in
            let word = self[tokenRange]

            guard let tag = tag else {
                newStr.append(contentsOf: word)
                return
            }

            // conjunctions, prepositions and articles should remain lowercased
            if tag == .conjunction || tag == .preposition || tag == .determiner {
                newStr.append(contentsOf: word.localizedLowercase)
            } else {
                // any other words should be capitalized
                newStr.append(contentsOf: word.localizedCapitalized)
            }
        }
        return newStr
    }
    
    var uppercasingFirst: String {
            return prefix(1).uppercased() + dropFirst()
        }

    var lowercasingFirst: String {
        return prefix(1).lowercased() + dropFirst()
    }
    
    var camelized: String {
        guard !isEmpty else {
            return ""
        }

        let parts = self.components(separatedBy: badChars).map({String($0).lowercased()})

        let first = String(describing: parts.first!).lowercasingFirst
        let rest = parts.dropFirst().map({String($0).uppercasingFirst})

        return ([first] + rest).joined(separator: "")
    }
    
    var hyphenized: String {
        guard !isEmpty else {
            return ""
        }

        let parts = self.components(separatedBy: badChars)

        let words = parts.map({String($0).lowercased()})

        return words.joined(separator: "-")
    }
    
    var dotized: String {
        guard !isEmpty else {
            return ""
        }

        let parts = self.components(separatedBy: badChars)

        let words = parts.map({String($0).lowercased()})

        return words.joined(separator: ".")
    }
    
}

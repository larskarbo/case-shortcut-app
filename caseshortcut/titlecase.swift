//
//  titlecase.swift
//  case-shortcut
//
//  Created by Lars Karbø on 26/02/2021.
//

import Foundation

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
}

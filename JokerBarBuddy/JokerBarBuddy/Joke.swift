//
//  Joke.swift
//  Homework 2 (Joke App)
//
//  Copyright © 2017 Washington State University. All rights reserved.
//

import Foundation

class Joke {
    
    var firstLine: String
    var secondLine: String
    var thirdLine: String
    var answerLine: String
    
    init (first: String = "", second: String = "", third: String = "", ans: String = "") {
        self.firstLine = first
        self.secondLine = second
        self.thirdLine = third
        self.answerLine = ans
    }
}

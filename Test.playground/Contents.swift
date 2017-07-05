//: Playground - noun: a place where people can play

import UIKit

var str = "Hel lo"

var splitted = str.characters.split { $0 == " "}.map(String.init)
print(splitted)

let emptyString = "fd"

let firstLetter = emptyString.characters.prefix(1)

let firstLetterString = String(firstLetter)

"D" > "C"

"D" >= "D"
//: Playground - noun: a place where people can play

import UIKit

let allIndexTitles = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "#"]
let alphabet = Array(allIndexTitles.dropLast())

"D" > "5"

"A" < "100000"


let visibleSectionTitles = ["C", "F", "M", "R", "Y"]
let visibleSectionTitlesCount = visibleSectionTitles.count


let sectionsToJumpTo = allIndexTitles.map({
    indexTitle -> Int in
    
    // Start with the last section
    var sectionToJumpTo = visibleSectionTitlesCount - 1
    var previousVisibleSection = ""
    
    for (index, visibleSection) in visibleSectionTitles.enumerated() {
        
        if indexTitle == "#" {
            break
        }
        
        // If its the first visible section and the index title is before it, then section to jump to is 0
        if index == 0 && indexTitle < visibleSection {
            sectionToJumpTo = 0
            break
        }
        
        // If the index title is equal to the visible title, then that section index is the section to jump to
        if indexTitle == visibleSection {
            sectionToJumpTo = visibleSectionTitles.index(of: visibleSection) ?? 0
            break
        }
        
        // If the index title is greater than the previous visible section, but smaller than the current visible section, then the previous section index is the section to jump to
        if indexTitle > previousVisibleSection && indexTitle < visibleSection {
            sectionToJumpTo = visibleSectionTitles.index(of: previousVisibleSection) ?? 0
            break
        }
        
        previousVisibleSection = visibleSection
    }
    
    return sectionToJumpTo
})
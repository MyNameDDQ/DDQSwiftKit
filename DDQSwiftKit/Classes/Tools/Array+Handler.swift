//
//  Array+Handler.swift
//  DDQKitSwiftVersion
//
//  Created by MyNameDDQ on 2023/7/23.
//

import Foundation

public extension Array where Element: Equatable {
    func ddqIsBeyond(index: Int) -> Bool {
        if isEmpty || index < 0 {
            return true
        }
        
        return index >= self.count
    }
        
    mutating func ddqRemove(at: Int, length: Int = 0) {
        
        let end = length + at
        
        if ddqIsBeyond(index: at) || ddqIsBeyond(index: end) {
            return
        }
        
        removeSubrange(at...end)
    }
    
    mutating func ddqRemove(element: Element) {
        ddqRemoveObjectsInArray(array: [element])
    }
    
    mutating func ddqRemoveObjectsInArray(array: [Element]) {
        array.forEach { (element) in
            if let index = ddqIndex(element: element) {
                ddqRemove(at: index)
            }
        }
    }
    
    mutating func ddqAppend(element: Element) {
        ddqAppendObjectsFromArray(array: [element])
    }
    
    mutating func ddqAppendObjectsFromArray(array: [Element]) {
        self += array
    }
    
    mutating func ddqInsetObjectsFromArray(at: Int, array: [Element]) {
        if ddqIsBeyond(index: at) {
            return
        }
        
        insert(contentsOf: array, at: at)
    }
    
    mutating func ddqInset(at: Int, element: Element) {
        ddqInsetObjectsFromArray(at: at, array: [element])
    }
        
    mutating func ddqReplaceObjectsFromArray(at: Int, array: [Element]) {
        if ddqIsBeyond(index: at) {
            return
        }
        
        replaceSubrange(at...(at + array.count - 1), with: array)
    }
    
    mutating func ddqReplace(at: Int, element: Element) {
        ddqReplaceObjectsFromArray(at: at, array: [element])
    }
    
    mutating func ddqRemoveDuplicate() -> [Element] {
        return self.enumerated().filter { index, objc in
            self.firstIndex(of: objc) == index
        }.map { _, objc in
            objc
        }
    }
    
    func ddqObject(at: Int) -> Element? {
        if ddqIsBeyond(index: at) {
            return nil
        }
        
        return self[at]
    }
    
    func ddqIndex(element: Element) -> Int? {
        self.firstIndex(of: element)
    }
    
    func ddqIsFirst(element: Element) -> Bool {
        self.first == element
    }
    
    func ddqIsLast(element: Element) -> Bool {
        self.last == element
    }
}

public extension Array where Element: Equatable {
    func ddqForEach(block: (_ objc: Element, _ index: Int) -> Void) {
    
        self.enumerated().forEach { index, element in
            block(element, index)
        }
    }
}

public extension Array where Element: Comparable {
    func ddqSortedArray(ascending: Bool = true) -> [Element] {
        
        return self.sorted { (objc1, objc2) -> Bool in
            if ascending {
                return objc1 < objc2
            }
            
            return objc1 > objc2
        }
    }
}

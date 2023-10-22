//
//  Array+Handler.swift
//  DDQKitSwiftVersion
//
//  Created by MyNameDDQ on 2023/7/23.
//

import Foundation

public extension Array {
    func ddqIsBeyond(_ index: Int) -> Bool {
        if isEmpty || index < 0 {
            return true
        }
        
        return index >= self.count
    }
    
    func ddqElement(_ at: Int) -> Element? {
        if ddqIsBeyond(at) {
            return nil
        }
        
        return self[at]
    }
    
    func ddqForEach(_ block: (_ index:  Int, _ element: Element) -> Void) {
        for (i, e) in self.enumerated() {
            block(i, e)
        }
    }
    
    mutating func ddqRemove(_ at: Int, _ length: Int = 0) {
        
        let end = length + at
        
        if ddqIsBeyond(at) || ddqIsBeyond(end) {
            return
        }
        
        removeSubrange(at...end)
    }
        
    mutating func ddqAddElements(_ elements: [Element]) {
        self += elements
    }
    
    mutating func ddqAdd(_ element: Element) {
        ddqAddElements([element])
    }
    
    mutating func ddqInsertElements(_ at: Int, _ elements: [Element]) {
        if ddqIsBeyond(at) {
            if at > 0 {
                ddqAddElements(elements)
            }
            
            return
        }
        
        insert(contentsOf: elements, at: at)
    }
    
    mutating func ddqInsert(_ at: Int, _ element: Element) {
        ddqInsertElements(at, [element])
    }
    
    mutating func ddqReplaceElements(_ at: Int, _ elements: [Element]) {
        
        let end = at + elements.count - 1
        
        if ddqIsBeyond(at) || ddqIsBeyond(end) {
            return
        }
        
        replaceSubrange(at...end, with: elements)
    }
    
    mutating func ddqReplace(_ at: Int, _ element: Element) {
        ddqReplaceElements(at, [element])
    }
        
    /// let a: [Int] = xx.ddqFilter()
    /// loadObject(xx.ddqFilter())
    func ddqFilter<T>() -> [T] {
        self.filter { $0 is T }.map { $0 as! T }
    }
    
    /// let a: [Int] = .ddqFilter([1, 2, 3])
    /// loadObject(.ddqFilter([1, 2, 3]))
    static func ddqFilter<T>(_ array: [Any]) -> [T] {
        array.filter { $0 is T }.map { $0 as! T }
    }
    
    /// 详情参见joined()
    func ddqToString(separator: String = "") -> String {
        
        var string = ""

        if separator == "" {
            
            self.forEach { element in
                string.append("\(element)")
            }
            
            return string
        }
        
        self.enumerated().forEach { element in
            if element.offset == self.count - 1 {
                string.append("\(element.element)")
            } else {
                string.append("\(element.element)\(separator)")
            }
        }

        return string
    }
}

@available(iOS 13.0, *)
public extension Array where Element: Identifiable {
    mutating func ddqRemoveElements(_ elements: [Element]) {
        elements.ddqForEach { _, element in
            if let index = self.firstIndex(where: { $0.id == element.id}) {
                ddqRemove(index)
            }
        }
    }
    
    mutating func ddqRemove(_ element: Element) {
        ddqRemoveElements([element])
    }
    
    /// - Parameters:
    ///   - others: 另一个字典
    ///   - duplicates: 是不是去重。默认去重
    mutating func ddqMerge(_ others: [Element], duplicates: Bool = true) {
        ddqAddElements(duplicates ? others.filter { element in !self.contains { $0.id != element.id } } : others)
    }

    func ddqContain(_ element: Element) -> Bool {
        self.contains { $0.id == element.id }
    }
        
    func ddqRemoveDuplicates() -> [Element] {
        self.enumerated().filter { (index , element) in
            self.firstIndex(where: { $0.id == element.id}) == index
        }.map { $0.element }
    }
    
    func ddqIndex(_ element: Element) -> Int? {
        self.firstIndex(where: { $0.id == element.id})
    }
    
    func ddqIsFirst(_ element: Element) -> Bool {
        self.first?.id == element.id
    }
    
    func ddqIsLast(_ element: Element) -> Bool {
        self.last?.id == element.id
    }
}

public extension Array where Element: Equatable {
    mutating func ddqRemoveElements(_ elements: [Element]) {
        elements.ddqForEach { _, element in
            if let index = self.firstIndex(where: { $0 == element}) {
                ddqRemove(index)
            }
        }
    }
    
    mutating func ddqRemove(element: Element) {
        ddqRemoveElements([element])
    }
    
    /// - Parameters:
    ///   - others: 另一个字典
    ///   - duplicates: 是不是去重。默认去重
    mutating func ddqMerge(_ others: [Element], duplicates: Bool = true) {
        ddqAddElements(duplicates ? others.filter { element in !self.contains { $0 == element } } : others)
    }

    func ddqContain(_ element: Element) -> Bool {
        self.contains { $0 == element }
    }

    func ddqRemoveDuplicates() -> [Element] {
        self.enumerated().filter { self.firstIndex(of: $0.element) == $0.offset }.map { $0.element }
    }
                    
    func ddqIndex(_ element: Element) -> Int? {
        self.firstIndex(of: element)
    }
    
    func ddqIsFirst(_ element: Element) -> Bool {
        self.first == element
    }
    
    func ddqIsLast(_ element: Element) -> Bool {
        self.last == element
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

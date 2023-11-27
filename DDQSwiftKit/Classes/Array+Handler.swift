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
        
        return index >= count
    }
    
    func ddqElement(_ at: Int) -> Element? {
        if ddqIsBeyond(at) {
            return nil
        }
        
        return self[at]
    }
    
    func ddqForEach(_ block: (_ index:  Int, _ element: Element) -> Void) {
        enumerated().forEach {
            block($0.offset, $0.element)
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
        filter { $0 is T }.map { $0 as! T }
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
            
            forEach { element in
                string.append("\(element)")
            }
            
            return string
        }
        
        enumerated().forEach { element in
            if element.offset == count - 1 {
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
            if let index = firstIndex(where: { $0.id == element.id}) {
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
    mutating func ddqMerge(_ others: [Element], duplicates: Bool = true, filter: ((_ obj1: Element, _ obj2: Element) -> Bool)?) {
        
        var arr = others
        
        if duplicates {
            let sub = others.filter { obj1 in
                if let f = filter {
                    return !contains { obj2 in
                        f(obj1, obj2)
                    }
                } else {
                    return !contains { $0.id == obj1.id}
                }
            }
            
            arr = sub
        }
        
        ddqAddElements(arr)
    }

    func ddqContain(_ element: Element) -> Bool {
        contains { $0.id == element.id }
    }
        
    func ddqRemoveDuplicates(_ completed: ((_ index: Int, _ objc: Element) -> Bool)? = nil) -> [Element] {
        enumerated().filter { (index , element) in
            if let c = completed {
                return c(index, element)
            } else {
                return firstIndex(where: { $0.id == element.id}) == index
            }
        }.map { $0.element }
    }
    
    func ddqIndex(_ element: Element) -> Int? {
        firstIndex(where: { $0.id == element.id})
    }
    
    func ddqIsFirst(_ element: Element) -> Bool {
        first?.id == element.id
    }
    
    func ddqIsLast(_ element: Element) -> Bool {
        last?.id == element.id
    }
}

public extension Array where Element: Equatable {
    mutating func ddqRemoveElements(_ elements: [Element]) {
        elements.ddqForEach { _, element in
            if let index = firstIndex(where: { $0 == element}) {
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
    mutating func ddqMerge(_ others: [Element], duplicates: Bool = true, filter: ((_ obj1: Element, _ obj2: Element) -> Bool)?) {
        
        var arr = others
        
        if duplicates {
            let sub = others.filter { obj1 in
                if let f = filter {
                    return !contains { obj2 in
                        f(obj1, obj2)
                    }
                } else {
                    return !contains(obj1)
                }
            }
            
            arr = sub
        }
        
        ddqAddElements(arr)
    }

    func ddqContain(_ element: Element) -> Bool {
        contains { $0 == element }
    }

    func ddqRemoveDuplicates(_ completed: ((_ index: Int, _ objc: Element) -> Bool)? = nil) -> [Element] {
        enumerated().filter {
            if let c = completed {
                return c($0.offset, $0.element)
            } else {
                return firstIndex(of: $0.element) == $0.offset
            }
        }.map { $0.element }
    }
                    
    func ddqIndex(_ element: Element) -> Int? {
        firstIndex(of: element)
    }
    
    func ddqIsFirst(_ element: Element) -> Bool {
        first == element
    }
    
    func ddqIsLast(_ element: Element) -> Bool {
        last == element
    }
}

public extension Array where Element: Comparable {
    func ddqSortedArray(ascending: Bool = true) -> [Element] {
        
        return sorted { (objc1, objc2) -> Bool in
            if ascending {
                return objc1 < objc2
            }
            
            return objc1 > objc2
        }
    }
}

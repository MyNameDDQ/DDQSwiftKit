//
//  String+Handler.swift
//  DDQKitSwiftVersion
//
//  Created by MyNameDDQ on 2023/7/23.
//

import Foundation
import UIKit
import CoreTelephony
import SAMKeychain

public extension String {
    func ddqTrimmingWhitespacesAndNewlines() -> String {
        trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func ddqHTMLTextToAttributedString(dic: [NSAttributedString.Key: Any]? = nil) -> NSAttributedString? {
        
        var attributedString: NSAttributedString?
        
        do {
            if let data = ddqToData() {
                
                let html = try NSAttributedString.init(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil).mutableCopy() as? NSMutableAttributedString
                
                if let d = dic, let l = html?.length {
                    html?.addAttributes(d, range: .init(location: 0, length: l))
                }
                
                attributedString = html?.copy() as? NSAttributedString
            }
        } catch {
            #if DEBUG
                NSLog("转换html字符串失败")
            #endif
        }
        
        return attributedString
    }
    
    var ddqLength: Int {
        indices.count
    }
    
    func ddqSize(attributes: [NSAttributedString.Key: Any]? = nil) -> CGSize {
        
        let label = UILabel.ddqAttributedLabel(text: self, attributes: attributes)
        label.sizeToFit()
        return label.ddqSize
    }
    
    func ddqRemoveDuplicates() -> String {
        enumerated().filter { element in
            
            let index = firstIndex(of: element.element)
            return index?.utf16Offset(in: self) == element.offset
            
        }.map { $0.element }.ddqToString()
    }
    
    func ddqSubString(_ range: Range<Int>) -> String {
        if isEmpty {
            return ""
        }
        
        let start = range.startIndex
        let end = range.endIndex
        
        if start > count || end > count {
            return ""
        }
        
        let s = index(.init(utf16Offset: start, in: self), offsetBy: 0)
        let e = index(.init(utf16Offset: end, in: self), offsetBy: 0)
        return String(self[s..<e])
    }
    
    func ddqSubString(to: Int) -> String {
        ddqSubString(0..<to)
    }
    
    func ddqSubString(from: Int) -> String {
        ddqSubString(from..<count)
    }
    
    func ddqComponents(separtor: String = "") -> [String] {
        if separtor != "" {
            return components(separatedBy: separtor)
        }
        
        var components: [String] = []
        
        forEach { char in
            components.ddqAdd(String(char))
        }
        
        return components
    }
}

/**
 TimeStamp
 */
public extension String {
    enum DDQTimeStampType {
        
        /// 秒
        case second
        /// 毫秒
        case millisecond
        /// 微秒
        case microsecond
    }

    static func ddqGetTimeStamp(type: DDQTimeStampType = .second) -> Double {
        
        var timeStamp = Date().timeIntervalSince1970
        
        switch type {
        case .millisecond: timeStamp *= 1000
        case .microsecond: timeStamp *= (1000 * 1000)
        default: break
        }
                
        return timeStamp
    }
        
    func ddqToDateString(formatter: String? = nil) -> String {
        
        let date = Date(timeIntervalSince1970: ddqToDouble())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter ?? "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: date)
    }
    
    func ddqToTimeStamp(formatter: String? = nil) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter ?? "yyyy-MM-dd HH:mm:ss"
        
        if let date = dateFormatter.date(from: self) {
            return String(format: "%.f", date.timeIntervalSince1970)
        }
        
        return ""
    }
}

/**
 URL
 */
public extension String {
    func ddqGetUrlQueryItems() -> [URLQueryItem]? {
        URLComponents.init(string: self)?.queryItems
    }

    func ddqGetUrlQueryKeyValues() -> [String: String] {
        guard let items = ddqGetUrlQueryItems() else {
            return [:]
        }
        
        var keyValues: [String: String] = [:]
        
        for item in items {
            keyValues.updateValue(item.value ?? "", forKey: item.name)
        }
        
        return keyValues
    }

    func ddqGetUrlQueryValueForKey(_ key: String) -> String {
        ddqGetUrlQueryKeyValues().ddqStringFor(key)
    }
    
    func ddqGetUrlQueryValueForKeys(keys: [String]) -> [String: String] {
        ddqGetUrlQueryKeyValues().filter { element in keys.contains { element.key == $0 } }
    }
        
    func ddqAddUrlQueryWithKeyValues(dic: [String: String]) -> String {
        
        var components = URLComponents(string: self)
        
        guard components != nil else {
            return self
        }
        
        var items: [URLQueryItem] = []
        var existKeyValues = ddqGetUrlQueryKeyValues()
        existKeyValues.ddqAddEntries(dic)
        
        for (key, value) in existKeyValues {
            items.ddqAdd(.init(name: key, value: value))
        }
        
        components?.queryItems = items
        return components?.url?.absoluteString ?? self
    }
    
    func ddqRemoveUrlQueryWithKey(key: String) -> String {
        ddqRemoveUrlQueryWithKeys(keys: [key])
    }
    
    func ddqRemoveUrlQueryWithKeys(keys: [String]) -> String {
        
        var existKeyValues = ddqGetUrlQueryKeyValues()
        
        if existKeyValues.isEmpty {
            return self
        }
    
        var items: [URLQueryItem] = []
        existKeyValues.ddqRemoveForKeys(keys)
        
        for (key, value) in existKeyValues {
            
            let item = URLQueryItem(name: key, value: value)
            items.append(item)
        }
        
        var components = URLComponents(string: self)
        components?.queryItems = items
        return components?.url?.absoluteString ?? self
    }
}

/**
 infoPlist
 */
public extension String {
    enum DDQInfoPlistType {
        
        case appVersion
        case displayName
        case bundleId
        case deviceBrand
    }
    
    static func ddqGetInfoPlist(type: DDQInfoPlistType = .deviceBrand) -> String {
        switch type {
        case .appVersion: return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
        case .displayName: return Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? ""
        case .bundleId: return Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String ?? ""
        default: return UIDevice.current.model
        }
    }
        
    func ddqValidateNewestAppVersion(version: String) -> Bool {
        if isEmpty || version.isEmpty {
            return false
        }
        
        let current: [String] = components(separatedBy: ".")
    
        guard !current.isEmpty else {
            return false
        }
        
        let newest: [String] = version.components(separatedBy: ".")
        
        guard !newest.isEmpty else {
            return false
        }
        
        var need = false
        
        for cChar in current {
            
            let number: Int = Int(cChar) ?? 0
            let index = current.firstIndex(of: cChar) ?? 0
            let nChar = newest[index]
            let nNumber: Int = Int(nChar) ?? 0
            
            if nNumber > number {
                
                need = true
                break
            }
        }
        
        return need
    }
}
/**
 获取设备相关的信息
 */
public extension String {
    
    /// 获取设备类型
    static func ddqGetDeviceModel() -> String {
        
        var systemInfo = utsname()
        uname(&systemInfo)
        let machine = Mirror(reflecting: systemInfo.machine)
        let identifier = machine.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else {
                return identifier
            }
            
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        //https://blog.csdn.net/qq_19926599/article/details/86747401
        switch identifier {
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":
                return "iPhone4"
                
            case "iPhone4,1":
                return "iPhone4s"
                
            case "iPhone5,1", "iPhone5,2":
                return "iPhone5"
                
            case "iPhone5,3", "iPhone5,4":
                return "iPhone5c"
                
            case "iPhone6,1", "iPhone6,2":
                return "iPhone5s"
                
            case "iPhone7,2":
                return "iPhone6"
                
            case "iPhone7,1":
                return "iPhone6Plus"
                
            case "iPhone8,1":
                return "iPhone6s"
                
            case "iPhone8,2":
                return "iPhone6sPlus"
                
            case "iPhone9,1":
                return "iPhone7"
                
            case "iPhone9,2":
                return "iPhone7Plus"
                
            case "iPhone8,3", "iPhone8,4":
                return "iPhoneSE"
                
            case "iPhone10,1", "iPhone10,4":
                return "iPhone8"
                
            case "iPhone10,2", "iPhone10,5":
                return "iPhone8Plus"
                
            case "iPhone10,3", "iPhone10,6":
                return "iPhoneX"
                
            case "iPhone11,2":
                return "iPhoneXS"
                
            case "iPhone11.4", "iPhone11,6":
                return "iPhoneXSMax"
                
            case "iPhone11,8":
                return "iPhoneXR"
                
            case "iPhone12,1":
                return "iPhone11"
                
            case "iPhone12,3":
                return "iPhone11Pro"
                
            case "iPhone12,5":
                return "iPhone11ProMax"
                
            case "iPhone12,8":
                return "iPhoneSE"
                
            case "iPhone13,1":
                return "iPhone12Mini"
                
            case "iPhone13,2":
                return "iPhone12"
                
            case "iPhone13,3":
                return "iPhone12Pro"
                
            case "iPhone13,4":
                return "iPhone12ProMax"
                
            case "iPhone14,2":
                return "iPhone13Pro"

            case "iPhone14,3":
                return "iPhone13ProMax"

            case "iPhone14,4":
                return "iPhone13Mini"

            case "iPhone14,5":
                return "iPhone13"

            case "iPhone14,6":
                return "iPhoneSE"

            case "iPhone14,7":
                return "iPhone14"

            case "iPhone14,8":
                return "iPhone14Plus"

            case "iPhone15,2":
                return "iPhone14Pro"

            case "iPhone15,3":
                return "iPhone14ProMax"

            case "i386", "x86_64":
                return "Simulator"
                
            default:
                return identifier
        }
    }
    
    /// 运营商
    static func ddqGetDeviceProvider() -> String {
        
        let info = CTTelephonyNetworkInfo()
        var supplier: String = ""
        
        if #available(iOS 12.0, *) {
            if let carriers = info.serviceSubscriberCellularProviders {
                if carriers.keys.count == 0 {
                    return ""
                } else { // 获取运营商信息
                    for (index, carrier) in carriers.values.enumerated() {
                        if let carrierName = carrier.carrierName {
                            // 查看运营商信息 通过CTCarrier类
                            if index == 0 {
                                supplier = carrierName
                            } else {
                                supplier = supplier.appendingFormat(",%@", carrierName)
                            }
                        }
                    }
                    
                    return supplier
                }
            } else {
                return ""
            }
        } else {
            if let carrier = info.subscriberCellularProvider {
                guard carrier.carrierName != nil else {
                    return ""
                }
                
                return carrier.carrierName!
                
            } else {
                return ""
            }
        }
    }
    
    /// 获取设备Id
    static func ddqGetDeviceID() -> String {
        
        let service = String.ddqGetInfoPlist(type: .bundleId)
        
        guard let password = SAMKeychain.password(forService: service, account: "uuid") else {
            
            var uuid = UIDevice.current.identifierForVendor?.uuidString
            uuid = uuid?.replacingOccurrences(of: "-", with: "").lowercased()
            SAMKeychain.setPassword(uuid ?? "", forService: service, account: "uuid")
            return uuid ?? ""
        }
        
        return password
    }
    
    /// 获取设备ip
    static func ddqGetDeviceIP() -> String {
        
        var addresses: [String] = []
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        
        if getifaddrs(&ifaddr) == 0 {
            
            var ptr = ifaddr
            
            while ptr != nil {
                
                let flags = Int32(ptr!.pointee.ifa_flags)
                var addr = ptr!.pointee.ifa_addr.pointee
                
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        
                        if getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST) == 0 {
                            if let address = String(validatingUTF8: hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
                
                ptr = ptr!.pointee.ifa_next
            }
            
            freeifaddrs(ifaddr)
        }
        
        guard let ipStr = addresses.first else {
            return ""
        }
        
        return ipStr
    }
}

/**
 QRCode
 */
public extension String {
    func ddqToQRCodeImage(size: CGSize = .init(width: 512.0, height: 512.0)) -> UIImage? {
        
        let filter = CIFilter.init(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        let data = data(using: Encoding.utf8)
        filter?.setValue(data ?? Data(), forKey: "inputMessage")
        filter?.setValue("H", forKey: "inputCorrectionLevel")
        let ciImage = filter?.outputImage
        
        if ciImage == nil {
            return nil
        }
        
        return UIImage(ciImage: ciImage!)
    }
        
    func ddqBase64ToImage() -> UIImage? {
        if let data = ddqBase64StringToData() {
            return UIImage.init(data: data)
        }
    
        return nil
    }
}

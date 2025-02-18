//
//  Data+.swift
//  EvenConnect
//
//  Created by Whiskee on 2025/1/14.
//

extension Data {
    //  转十六进制字符串
    public func hexString() -> String {
        map {"\(String(format: "%02x", $0))"}.joined()
    }
}

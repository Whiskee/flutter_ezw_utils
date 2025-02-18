//
//  Dic.swift
//  Pods
//
//  Created by Whiskee on 2025/1/10.
//

extension Dictionary {
    
    /**
     *
     *  解码Json字符串
     *  - Returns: 解码后的对象，如果解码失败则返回 nil。
     */
    public func decodeTo<T: Codable>() -> T? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [])
            return try JSONDecoder().decode(T.self, from: jsonData)
        } catch {
            logger.error("Ble - common - string: Decode=\(self), error = \(error)")
            return nil
        }
    }
    
}

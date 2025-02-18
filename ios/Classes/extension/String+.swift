//
//  String.swift
//  EvenConnect
//
//  Created by Whiskee on 2025/1/6.
//

extension String {
    
    public var isNotEmpty: Bool {
        get {
            return !self.isEmpty
        }
    }
    
    /**
     *
     *  解码Json字符串
     *  - Returns: 解码后的对象，如果解码失败则返回 nil。
     */
    public func decodeTo<T: Codable>() -> T? {
        guard let data = self.data(using: .utf8) else {
            return nil
        }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            logger.error("Ble - common - string: Decode=\(self), error = \(error)")
            return nil
        }
    }
}

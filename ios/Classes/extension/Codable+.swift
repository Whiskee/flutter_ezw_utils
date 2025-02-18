//
//  Codable+.swift
//  EvenConnect
//
//  Created by Whiskee on 2025/1/6.
//

extension Encodable {
    
    /**
     *  解码对象
     *  - Returns: 解码后的Json数据
     */
    public func toJsonData(prettyPrinted: Bool = false) throws -> Data? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = prettyPrinted ? .prettyPrinted : .sortedKeys
        do {
            return try encoder.encode(self)
        } catch {
            logger.error("Ble - common - encodable: To data, error = \(error) ")
            return nil
        }
    }
    
    /**
     *  解码对象
     *  - Returns: 解码后的json字符串
     */
    public func toJsonString(prettyPrinted: Bool = false) throws -> String? {
        guard let data = try? toJsonData(prettyPrinted: prettyPrinted) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    /**
     *  解码对象
     *  - Returns: 解码成Dictionary
     */
    func toDic() throws -> [String:Any]? {
        do {
            guard let jsonData = try toJsonData() else {
                return nil
            }
            return try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
        } catch {
            logger.error("Ble - common - encodable: To dic, error = \(error) ")
            return nil
        }
    }
    
}

//
//  OCTJSON.swift
//  OCTJSON
//
//  Created by yuhan zhang on 7/18/16.
//  Copyright © 2016 octopus. All rights reserved.
//


public extension Json {
    
    public init(_ value: [String: AnyObject]) {
        self = decodeDictionary(value)
    }
    
    
    public init(_ value: [AnyObject]) {
        self = decodeArray(value)
    }
    
    
    
    
    var arrayObject: [AnyObject]? {
        guard case let .array(array) = self else { return nil }
        
        var ret = [AnyObject]()
        
        for obj in array {
            switch obj {
            case .string:
                ret.append(obj.string!)
            case .number:
                ret.append(obj.double!)
            case .bool:
                ret.append(obj.bool!)
            case .array:
                if let arrayObject = obj.arrayObject {
                    ret.append(arrayObject)
                }
            case .object:
                if let object = obj.dictionaryObject {
                    ret.append(object)
                }
            default: break
            }
        }
        
        return ret
    }
    
    
    var dictionaryObject: [String: AnyObject]? {
        guard case let .object(obj) = self else { return nil }
        
        var dict = [String: AnyObject]()
        
        obj.forEach { (k, v) in
            switch v {
            case .string:
                dict.updateValue(v.string!, forKey: k)
            case .number:
                dict.updateValue(v.double!, forKey: k)
            case .bool:
                dict.updateValue(v.bool!, forKey: k)
            case .array:
                if let arrayObject = v.arrayObject {
                    dict.updateValue(arrayObject, forKey: k)
                }
            case .object:
                if let object = v.dictionaryObject {
                    dict.updateValue(object, forKey: k)
                }
            default: break
                
            }
        }
        
        return dict
    }
    
}




private func decodeAnyObject(_ obj: AnyObject?) -> JSON {
    guard obj != nil else {
        return JSON.null
    }
    
    
    if obj is String {
        return JSON(obj as! String)
    } else if obj is Double {
        return JSON(obj as! Double)
    } else if obj is Int {
        return (JSON(Double(obj as! Int)))
    } else if obj is Float {
        return (JSON(Double(obj as! Float)))
    } else if obj is Bool {
        return JSON(obj as! Bool)
    } else {
        return JSON.null
    }
}


private func decodeDictionary(_ value: [String: AnyObject]) -> JSON {
    var json = Dictionary<String, JSON>()
    
    for (k, v) in value {
//        if let v = v {
        if let v = v as? [String: AnyObject] {
                json.updateValue(decodeDictionary(v), forKey: k)
            } else if let v = v as? [AnyObject] {
                json.updateValue(decodeArray(v), forKey: k)
            } else {
                json.updateValue(decodeAnyObject(v), forKey: k)
            }
//        }
    }
    
    return JSON(json)
    
    
}


private func decodeArray(_ value: [AnyObject]) -> JSON {
    var json = [JSON]()
    for obj in value {
        if obj is [AnyObject] {
            json.append(decodeArray(obj as! [AnyObject]))
        } else if obj is Dictionary<String, AnyObject?> {
            json.append(decodeDictionary(obj as! [String: AnyObject]))
        } else {
            json.append(decodeAnyObject(obj))
        }
    }
    
    return JSON(json)
}










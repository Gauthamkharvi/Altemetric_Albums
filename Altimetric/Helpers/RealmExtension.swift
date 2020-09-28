//
//  RealmExtension.swift
//  Altimetric
//
//  Created by gautham kharvi on 05/09/20.
//  Copyright © 2020 gautham kharvi. All rights reserved.
//

import Foundation
import RealmSwift

protocol DetachableObject: AnyObject {
    func detached() -> Self
}

extension Object: DetachableObject {
    public func detached() -> Self {
        let detached = type(of: self).init()
        for property in objectSchema.properties {
            guard let value = value(forKey: property.name) else {
                continue
            }
            if let detachable = value as? DetachableObject {
                detached.setValue(detachable.detached(), forKey: property.name)
            } else { // Then it is a primitive
                detached.setValue(value, forKey: property.name)
            }
        }
        return detached
    }
}

public extension Sequence where Iterator.Element: Object {
    func detached() -> [Element] {
        return self.map({$0.detached()})
    }
}


//
//  PropertyWrappers.swift
//  StackOverflowTags
//
//  Created by Innocent Magagula on 2021/05/19.
//

import Foundation

@propertyWrapper public struct InfoPlist<Value> {

    public var wrappedValue: Value {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? Value  else {
            fatalError("could not find value for key \(key)")
        }
        return value
    }

    let key: String

    init(_ key: String) {
        self.key = key
    }

    init<T: RawRepresentable>(_ representable: T) where T.RawValue == String {
        self.key = representable.rawValue
    }
}


@propertyWrapper public struct Inject<T> {
    public var wrappedValue: T {
        return instance
    }

    private var instance: T
    public init() {
        instance = DependencyInjection.shared.resolve(T.self)
    }
}

//
//  DependencyInjection.swift
//  StackOverflowTags
//
//  Created by Innocent Magagula on 2021/05/23.
//

import Foundation

class DependencyInjection {

    static let shared = DependencyInjection()
    private var factoryDict: [String: () -> Any] = [:]

    private init(){}

    func register<T>(type: T.Type, _ implementation: @escaping () -> T) {
        factoryDict[String(describing: type.self)] = implementation
    }

    func resolve<T>(_ type: T.Type) -> T {
        //FIXME: -bug on some Iphones not sure why app delegate didFinishLaunchingWithOptions is not getting invoked 
        if(factoryDict.isEmpty){
            registerAllDependancy()
        }
        guard let implementation: T = factoryDict[String(describing:T.self)]?() as? T else {
            preconditionFailure("No implementation was registered for protocol \(String(describing:T.self))")
        }
        return implementation
    }

    private func registerAllDependancy(){
        DependencyManager.registerDependencies()
    }
}

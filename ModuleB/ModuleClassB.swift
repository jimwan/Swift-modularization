//
//  ModuleClassB.swift
//  ModuleB
//
//  Created by jimwan on 2020/4/1.
//  Copyright © 2020 jimwan. All rights reserved.
//

import UIKit
import ModuleManger
import ModuleAService

public class ModuleBDelegate: NSObject,ModuleProtocol {
    
    override init() {
        super.init()
    }
    
    public static func create() -> ModuleProtocol? {
        return ModuleBDelegate.init()
    }

    public func applicationDidFinishLaunching(_ application: UIApplication) {
        print("ModuleBDelegate applicationDidFinishLaunching")
        
        let instanceList:[ModuleAServiceProtocol]? = ModuleManager.sharedInstance.servicesForProtocol(ModuleAServiceProtocol.self) as? [ModuleAServiceProtocol]
        if let instance:ModuleAServiceProtocol = instanceList?.first {
            instance.majorFunctionInModuleA()
        }
    }
}

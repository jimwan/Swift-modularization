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

public class ModuleClassB: NSObject,ModuleProtocol {
    
    override init() {
        super.init()
    }
    
    public static func create() -> ModuleProtocol? {
        return ModuleClassB.init()
    }

    public func applicationDidFinishLaunching(_ application: UIApplication) {
        print("ModuleClassB applicationDidFinishLaunching")
        
        let instanceList:[ModuleAService]? = ModuleManager.sharedInstance.servicesForProtocol(ModuleAService.self) as? [ModuleAService]
        if let instance:ModuleAService = instanceList?.first {
            instance.majorFunctionInModuleA()
        }
    }
}

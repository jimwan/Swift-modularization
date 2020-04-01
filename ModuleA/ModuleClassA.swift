//
//  ModuleClassA.swift
//  ModuleA
//
//  Created by jimwan on 2020/3/31.
//  Copyright © 2020 jimwan. All rights reserved.
//

import UIKit
import ModuleManger


public class ModuleADelegate: NSObject,ModuleProtocol{

    public static func create() -> ModuleProtocol? {
        return ModuleADelegate()
    }

    public func applicationDidFinishLaunching(_ application: UIApplication) {
        print("ModuleADelegate applicationDidFinishLaunching")
    }
    
    func majorFunctionInModuleA() {
        print("ModuleADelegate majorFunctionInModuleA")
    }

}

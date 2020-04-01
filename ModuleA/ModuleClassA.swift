//
//  ModuleClassA.swift
//  ModuleA
//
//  Created by jimwan on 2020/3/31.
//  Copyright © 2020 jimwan. All rights reserved.
//

import UIKit
import ModuleManger


public class ModuleClassA: NSObject,ModuleProtocol{

    public static func create() -> ModuleProtocol? {
        return ModuleClassA()
    }

    public func applicationDidFinishLaunching(_ application: UIApplication) {
        print("ModuleClassA applicationDidFinishLaunching")
    }
    
    func majorFunctionInModuleA() {
        print("ModuleClassA majorFunctionInModuleA")
    }

}

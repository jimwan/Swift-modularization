//
//  ModuleAServiceClass.swift
//  ModuleA
//
//  Created by jimwan on 2020/4/1.
//  Copyright © 2020 jimwan. All rights reserved.
//

import UIKit
import ModuleAService
import ModuleManger

public class ModuleAServiceClass: NSObject,ModuleAService  {
    public var singleton: Bool = true
    
    public func majorFunctionInModuleA() {
        let moduleA = ModuleClassA()
        moduleA.majorFunctionInModuleA()
    }
    
}

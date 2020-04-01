//
//  main.swift
//  Swift模块解藕
//
//  Created by 运满满 on 2020/4/1.
//  Copyright © 2020 yunmanman. All rights reserved.
//

import UIKit
import Foundation
import ModuleManger

private let pointer = UnsafeMutableRawPointer(CommandLine.unsafeArgv).bindMemory(
    to: UnsafeMutablePointer<Int8>?.self,
    capacity: Int(CommandLine.argc)
)


let result = ModuleManagerApplicationMain(
    CommandLine.argc,
    pointer,
    NSStringFromClass(UIApplication.self),
    NSStringFromClass(AppDelegate.self)
)


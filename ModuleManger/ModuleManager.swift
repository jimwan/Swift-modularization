//
//  ModuleManager.swift
//  ModuleManger
//
//  Created by jimwan on 2020/3/31.
//  Copyright © 2020 jimwan. All rights reserved.
//

import UIKit

@objc public protocol ModuleProtocol:UIApplicationDelegate {
   static func create() -> ModuleProtocol?
}

@objc public protocol ServiceProtocol{
    var singleton:Bool { get set }
}

struct ModuleContext {
    var moduleName:String?
    var moduleClass:AnyClass?
    var modueleObject:ModuleProtocol?
}

public class ModuleManager :NSObject, UIApplicationDelegate {
    
    var moduleContextArray:[ModuleContext] = [] // 所有模块类的数组
    var serviceClassDict:[String:AnyObject] = [:] // ["ModuleManger.ServiceProtocol": [ModuleA.ModuleClassA] ]
    var serviceDict:[String:ServiceProtocol?] = [:] // ["ModuleA.ModuleAServiceClass":ServiceProtocol]
    
    public static let sharedInstance: ModuleManager = {
        let instance = ModuleManager()
        // setup code
        
        instance.registerAllModules()
        instance.registerAllServices()

//        print(instance.serviceClassDict)
        return instance
    }()
    
    //MARK: - Private -
    private func registerAllModules(){
        if let url = Bundle.main.url(forResource: "ModuleList", withExtension: "plist") {
            if let contents = NSDictionary(contentsOf: url) as? [String:String] {
                for (key,value) in contents {
                    registerModule("\(key).\(value)")
                }
              }
        }
    }
    
    private func registerAllServices(){
        if let url = Bundle.main.url(forResource: "ServiceList", withExtension: "plist") {
            if let contents = NSDictionary(contentsOf: url) as? [String:String] {
                for (key,value) in contents {
                    registerService("\(key).\(value)")
                }
            }
        }
    }
    
    private func registerModule(_ moduleName:String){
        guard let moduleClass:AnyClass = NSClassFromString(moduleName) else{return}
        var moduleContext:ModuleContext = ModuleContext()
        moduleContext.moduleClass = moduleClass
        moduleContext.moduleName = NSStringFromClass(moduleClass)
        guard let moduleObject:ModuleProtocol = (moduleContext.moduleClass as! ModuleProtocol.Type).create() else {
            return
        }
        moduleContext.modueleObject = moduleObject
        moduleContextArray.append(moduleContext)
    }
    
    private func registerService(_ serviceName:String){
        guard let serviceClass:AnyClass = NSClassFromString(serviceName) else{
            return
        }
        var count:UInt32 = 0
        guard let protocolList = class_copyProtocolList(serviceClass, &count) else{
            return
        }
        var serviceProtocolList:[Protocol] = []
        for i in 0..<count {
            let foundServiceProtocols = findServiceProtocols(protocolList[Int(i)])
            serviceProtocolList.append(contentsOf: foundServiceProtocols)
        }
        
        for serviceProtocol in serviceProtocolList {
            setServiceClass(serviceClass, forProtocol: serviceProtocol)
        }
    }
    

    
    private func setServiceClass(_ serviceClass:AnyClass, forProtocol serviceProtocol:Protocol){
        let key = NSStringFromProtocol(serviceProtocol)
        var serviceClassList:[AnyClass] = []
        if let object = serviceClassDict[key] {
             if object is Array<AnyClass> {
                serviceClassList = object as! [AnyClass]
             }
        }
        
        if serviceClassList.isEmpty {
            serviceClassList.append(serviceClass)
            serviceClassDict[key] = serviceClassList as AnyObject
        }else{
            serviceClassList.append(serviceClass)
        }
    }
    
    private func findServiceProtocols(_ protocolIn:Protocol?) -> [Protocol]{
        var serviceProtocolList:[Protocol] = []
        if protocolIn == nil {
            return serviceProtocolList
        }
        
        let servicePortocol:Protocol = ServiceProtocol.self
        // 如果 protocolIn 已经遵循了 ServiceProtocol,就返回找到的这个 protocolIn
        if protocol_conformsToProtocol(protocolIn, servicePortocol) {
            serviceProtocolList.append(protocolIn!)
            return serviceProtocolList
        }
        
        var count:UInt32 = 0
        guard let protocolList = protocol_copyProtocolList(protocolIn!, &count) else{
            return serviceProtocolList
        }
        
        for i in 0..<count {
            let foundServiceProtocols:[Protocol] = findServiceProtocols(protocolList[Int(i)])
            serviceProtocolList.append(contentsOf: foundServiceProtocols)
        }
        
        return serviceProtocolList
    }
    
    //MARK: - Public -
    public func moduleFor(name:String) -> ModuleProtocol?{
        for context in moduleContextArray {
            if context.moduleName == name {
                return context.modueleObject
            }
        }
        return nil
    }
    
    public func servicesForProtocol(_ serviceProtocol:Protocol) -> [ServiceProtocol]?{
        var services:[ServiceProtocol] = []
        let key = NSStringFromProtocol(serviceProtocol)
        guard let object = serviceClassDict[key] else{
            return services
        }
        if object is Array<AnyClass>{
            let serviceClassList = object as! [AnyClass]
            for serviceClass in serviceClassList {
                let serviceClassKey = NSStringFromClass(serviceClass)
                let service:ServiceProtocol? = serviceDict[serviceClassKey] as? ServiceProtocol
                if service == nil {
                    if let s:ServiceProtocol = (serviceClass as! NSObject.Type).init() as? ServiceProtocol, s.singleton {
                        serviceDict[serviceClassKey] = s
                        services.append(s)
                    }
                }
            }
        }
        
        return services
    }
    
    //MARK: - UIApplicationDelegate -
    public func applicationDidFinishLaunching(_ application: UIApplication) {
        for context in moduleContextArray {
            if (context.modueleObject?.responds(to: #selector(applicationDidFinishLaunching(_:))))!{
                context.modueleObject?.applicationDidFinishLaunching?(application)
            }
        }
    }
}

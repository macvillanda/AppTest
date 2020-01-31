//
//  NSObject+ClassName.swift
//  AppTest
//
//  Created by macvillanda on 29/01/2020.
//  Copyright © 2020 macvillanda. All rights reserved.
//

import Foundation

protocol ClassNameProtocol {
    static var className: String { get }
    var className: String { get }
}

extension ClassNameProtocol {
    static var className: String {
        return String(describing: self)
    }

    var className: String {
        return type(of: self).className
    }
}

extension NSObject: ClassNameProtocol {}

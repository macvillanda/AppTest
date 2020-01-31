//
//  UITableViewCell+RegisterDequeue.swift
//  AppTest
//
//  Created by macvillanda on 29/01/2020.
//  Copyright © 2020 macvillanda. All rights reserved.
//

import Foundation
import UIKit

public extension UITableView {
    func register<T: UITableViewCell>(cellType: T.Type, bundle: Bundle? = nil) {
        let className = cellType.className
        if let xibBundle = bundle {
            let nib = UINib(nibName: className, bundle: xibBundle)
            register(nib, forCellReuseIdentifier: className)
            return
        }
        register(T.self, forCellReuseIdentifier: className)
    }

    func register<T: UITableViewCell>(cellTypes: [T.Type], bundle: Bundle? = nil) {
        cellTypes.forEach { register(cellType: $0, bundle: bundle) }
    }

    func dequeueReusableCell<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: type.className, for: indexPath) as! T
    }
}

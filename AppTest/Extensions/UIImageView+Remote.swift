//
//  UIImageView+Remote.swift
//  AppTest
//
//  Created by macvillanda on 31/01/2020.
//  Copyright © 2020 macvillanda. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

final class ViewPlaceHolder: UIView {}

extension ViewPlaceHolder: Placeholder {}


extension UIImageView {
    @discardableResult
    func loadImageFrom(url: String) -> DownloadTask? {
        if let imageURL = URL(string: url) {
            let placeHolder = ViewPlaceHolder()
            placeHolder.backgroundColor = UIColor.gray
            return kf.setImage(with: imageURL, placeholder: placeHolder)
        }
        return nil
    }
}

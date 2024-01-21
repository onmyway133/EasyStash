//
//  ImageGenerate.swift
//  EasyStash
//
//  Created by khoa on 27/05/2019.
//  Copyright © 2019 Khoa Pham. All rights reserved.
//

#if os(iOS) || os(tvOS) || os(visionOS)
import UIKit

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        if #available(iOS 10.0, tvOS 10.0, *) {
            return UIGraphicsImageRenderer(size: size).image { rendererContext in
                self.setFill()
                rendererContext.fill(CGRect(origin: .zero, size: size))
            }
        } else {
            return UIImage()
        }
    }
}

#elseif os(OSX)
import AppKit

extension NSImage {
    convenience init(color: NSColor, size: NSSize) {
        self.init(size: size)
        lockFocus()
        color.drawSwatch(in: NSRect(origin: .zero, size: size))
        unlockFocus()
    }
}
#endif


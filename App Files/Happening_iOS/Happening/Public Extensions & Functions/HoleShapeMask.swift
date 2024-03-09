//
//  HoleShapeMask.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2021-12-25.
//

import Foundation
import SwiftUI

func HoleShapeMask(in rect: CGRect) -> Path {
    var shape = Rectangle().path(in: rect)
    shape.addPath(Circle().path(in: rect))
    return shape
}

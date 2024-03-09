//
//  CheckImageAspectRatio.swift
//  Happening
//
//  Created by Mr. Kavinda Dilshan on 2022-03-07.
//

import Foundation
import SwiftUI

public func checkImageAspectRatio(image: UIImage) -> Bool{
    
    if(image.size.width > image.size.height){
        return true
    }
    else{
        return false
    }
}

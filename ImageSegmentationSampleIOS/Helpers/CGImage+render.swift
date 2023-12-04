//
//  CGImage+render.swift
//  ImageSegmentationSampleIOS
//
//  Created by Vladislav Yakubets on 04.12.2023.
//

import Foundation
import CoreImage

extension CGImage {
    
    static func render(ciImage img: CIImage) -> CGImage {
        guard let cgImage = CIContext(options: nil).createCGImage(img, from: img.extent) else {
            fatalError("Failed to render CIImage.")
        }
        return cgImage
    }
    
}


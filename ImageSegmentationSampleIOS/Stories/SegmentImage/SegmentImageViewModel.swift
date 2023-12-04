//
//  SegmentImageViewModel.swift
//  ImageSegmentationSampleIOS
//
//  Created by Vladislav Yakubets on 04.12.2023.
//

import Foundation
import Combine
import Vision
import CoreImage

class SegmentImageViewModel {
    
    func subjectMask(fromImage image: CIImage, atPoint point: CGPoint?) -> CIImage? {
        let request = VNGenerateForegroundInstanceMaskRequest()

        let handler = VNImageRequestHandler(ciImage: image)

        do {
            try handler.perform([request])
        } catch {
            print("Failed to perform Vision request.")
            return nil
        }

        guard let result = request.results?.first else {
            print("No subject observations found.")
            return nil
        }

        let instances = instances(atPoint: point, inObservation: result)

        do {
            let mask = try result.generateScaledMaskForImage(forInstances: instances, from: handler)
            return CIImage(cvPixelBuffer: mask)
        } catch {
            print("Failed to generate subject mask.")
            return nil
        }
    }
    
    private func instances(atPoint maybePoint: CGPoint?, inObservation observation: VNInstanceMaskObservation) -> IndexSet {
        guard let point = maybePoint else {
            return observation.allInstances
        }

        let instanceMap = observation.instanceMask
        let coords = VNImagePointForNormalizedPoint(
            point,
            CVPixelBufferGetWidth(instanceMap) - 1,
            CVPixelBufferGetHeight(instanceMap) - 1)

        CVPixelBufferLockBaseAddress(instanceMap, .readOnly)
        guard let pixels = CVPixelBufferGetBaseAddress(instanceMap) else {
            fatalError("Failed to access instance map data.")
        }
        let bytesPerRow = CVPixelBufferGetBytesPerRow(instanceMap)
        let instanceLabel = pixels.load(
            fromByteOffset: Int(coords.y) * bytesPerRow + Int(coords.x),
            as: UInt8.self)
        CVPixelBufferUnlockBaseAddress(instanceMap, .readOnly)

        return instanceLabel == 0 ? observation.allInstances : [Int(instanceLabel)]
    }
    
}

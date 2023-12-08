//
//  CareLabelsViewController.swift
//  ImageSegmentationSampleIOS
//
//  Created by Vladislav Yakubets on 08.12.2023.
//

import UIKit
import CoreML
import PhotosUI

class CareLabelsViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    private func configureUI() {
        let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                         primaryAction: UIAction(handler: { action in
            var pickerConfiguration = PHPickerConfiguration(photoLibrary: .shared())
            pickerConfiguration.selectionLimit = 1
            let picker = PHPickerViewController(configuration: pickerConfiguration)
            picker.delegate = self
            self.present(picker, animated: true)
        }))
        navigationItem.rightBarButtonItem = plusButton
        navigationItem.title = "Care labels"
        navigationItem.largeTitleDisplayMode = .always
    }

    @IBAction func didPressClassify(_ sender: UIButton) {
        guard 
            let model = try? CareLabels(),
            let cgImage = imageView.image?.cgImage
            
        else {
            return
        }
        let ciImage = CIImage(cgImage: cgImage)
        CIContext().render(ciImage, to: cvPixelBuffer)
        
        let a = try? model.prediction(image: cvPixelBuffer)
    }
    
    public func createPixelBuffer(width: Int, height: Int) -> CVPixelBuffer? {
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(nil, width, height,
                                         kCVPixelFormatType_32BGRA, nil,
                                         &pixelBuffer)
        if status != kCVReturnSuccess {
            print("Error: could not create resized pixel buffer", status)
            return nil
        }
        return pixelBuffer
    }
}

extension CareLabelsViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        var newSelection = [String: PHPickerResult]()
        for result in results {
            let identifier = result.assetIdentifier!
            newSelection[identifier] = result
        }
        
        let selectedAssetIdentifiers = results.map(\.assetIdentifier!)
        var selectedAssetIdentifierIterator = selectedAssetIdentifiers.makeIterator()
        
        guard
            let assetIdentifier = selectedAssetIdentifierIterator.next(),
            let itemProvider = newSelection[assetIdentifier]?.itemProvider
        else {
            return
        }
        
        if itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
            itemProvider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { data, error in
                guard
                    let data = data
                else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                }
            }
        }
    }
    
}

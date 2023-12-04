//
//  SegmentImageViewController.swift
//  ImageSegmentationSampleIOS
//
//  Created by Vladislav Yakubets on 04.12.2023.
//

import UIKit
import PhotosUI

class SegmentImageViewController: UIViewController {
    
    @IBOutlet weak var segmentImageView: UIImageView!
    
    private var viewModel: SegmentImageViewModel = SegmentImageViewModel()
    
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
        navigationItem.title = "Image segmentation"
        navigationItem.largeTitleDisplayMode = .always
    }
    
}

extension SegmentImageViewController: PHPickerViewControllerDelegate {
    
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
                    self.segmentImageView.image = UIImage(data: data)
                }
            }
        }
    }
    
}

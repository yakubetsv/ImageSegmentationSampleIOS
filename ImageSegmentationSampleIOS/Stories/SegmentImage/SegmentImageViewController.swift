//
//  SegmentImageViewController.swift
//  ImageSegmentationSampleIOS
//
//  Created by Vladislav Yakubets on 04.12.2023.
//

import UIKit

class SegmentImageViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    private func configureUI() {
        let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                         primaryAction: UIAction(handler: { action in
            print("Plus pressed!")
        }))
        navigationItem.rightBarButtonItem = plusButton
        navigationItem.title = "Image segmentation"
        navigationItem.largeTitleDisplayMode = .always
    }
    
}

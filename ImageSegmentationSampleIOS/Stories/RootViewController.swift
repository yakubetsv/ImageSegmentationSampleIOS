//
//  RootViewController.swift
//  ImageSegmentationSampleIOS
//

import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func imageSegmentationDidPress(_ sender: UIButton) {
        let vc = SegmentImageViewController.initial()
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func careLabelsDidPress(_ sender: UIButton) {
        let vc = CareLabelsViewController.initial()
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

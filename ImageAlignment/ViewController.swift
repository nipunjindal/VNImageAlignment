//
//  ViewController.swift
//  ImageAlignment
//
//  Created by njindal on 10/23/17.
//  Copyright © 2017 adobe. All rights reserved.
//

import UIKit
import Vision

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let request = VNTranslationalImageRegistrationRequest.init(targetedCGImage: #imageLiteral(resourceName: "straight").cgImage!, orientation: CGImagePropertyOrientation.up, options: [VNImageOption:Any]()) { (vnRequest, error) in
            if let errorMsg = error {
                print ("Error: during translational \(errorMsg)")
                return;
            }
            
            guard let observation = vnRequest.results else {
                print ("Error: No observation found")
                return;
            }
            
            for translationObservation in observation as! [VNImageTranslationAlignmentObservation] {
                print ("Transform information \(translationObservation.alignmentTransform)")
                let ciImage = CIImage.init(cgImage: #imageLiteral(resourceName: "rotated").cgImage!)
                let transformedCiImage = ciImage.transformed(by: translationObservation.alignmentTransform)
                let image = UIImage.init(ciImage: transformedCiImage)
                self.imageView.image = image;
            }
        }
        
        do {
            let requestHandler = VNImageRequestHandler.init(cgImage: #imageLiteral(resourceName: "rotated").cgImage!, options: [VNImageOption:Any]())
            try requestHandler.perform([request])
        } catch {
            print ("Error: Image request handler issue")
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


//
//  ViewController.swift
//  FaceDetection
//
//  Created by Surya Kukkapalli on 9/1/19.
//  Copyright © 2019 Surya Kukkapalli. All rights reserved.
//

import UIKit
import Vision

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let image = UIImage(named: "sample3") else { return }
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        
        let scaledHeight = view.frame.width / image.size.width * image.size.height
        imageView.frame = CGRect(x: 0, y: 150, width: view.frame.width, height: scaledHeight)
        
        view.addSubview(imageView)
        
        let request = VNDetectFaceRectanglesRequest { (req, err) in
            if let err = err {
                print("Failed to detect faces", err)
                return
            }
            
            req.results?.forEach({ (res) in
                
                DispatchQueue.main.async {
                    guard let faceObservation = res as? VNFaceObservation else { return }
                    
                    let x = self.view.frame.width * faceObservation.boundingBox.origin.x
                    let width = self.view.frame.width * faceObservation.boundingBox.width
                    let height = scaledHeight * faceObservation.boundingBox.height
                    let y = scaledHeight * (1 - faceObservation.boundingBox.origin.y) - height + 150
                    
                    let redView = UIView()
                    redView.backgroundColor = .red
                    redView.alpha = 0.4
                    redView.frame = CGRect(x: x, y: y, width: width, height: height)
                    self.view.addSubview(redView)
                }
            })
        }
        
        guard let cgImage = image.cgImage else { return }
        
        // Running on a background thread to make app load faster on startup
        DispatchQueue.global(qos: .background).async {
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([request])
            } catch let reqErr {
                print("Failed to perform request",reqErr)
            }
        }
    }


}


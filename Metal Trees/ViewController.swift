//
//  ViewController.swift
//  Metal Trees
//
//  Created by Laurence Wingo on 5/26/18.
//  Copyright © 2018 Cosmic Arrows, LLC. All rights reserved.
//
import Metal
import UIKit
import QuartzCore




class ViewController: UIViewController {
    
    var device: MTLDevice! = nil
    var metalLayer: CAMetalLayer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        device = MTLCreateSystemDefaultDevice()
        metalLayer = CAMetalLayer.init()
        //this layer will interact with the device I created earlier.  The reason for this is because in order to work with the GPU, you need to use a MTLDevice which is a protocol of behaviors that serves as the interface for the GPU or Metal App.
        metalLayer.device = device
        metalLayer.pixelFormat = .bgra8Unorm
        metalLayer.framebufferOnly = true
        metalLayer.frame = view.layer.frame
        view.layer.addSublayer(metalLayer)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


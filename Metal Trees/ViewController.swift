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
    
    //create the device to interact wih the GPU
    var device: MTLDevice! = nil
    //create the layer that will be passed to the GPU
    var metalLayer: CAMetalLayer?
    //creating a vertex buffer to hold all of the vertextData because it must be encoded first by this buffer
    var vertexBuffer: MTLBuffer! = nil
    
    //an array to hold positional data of a triangle I'm drawing....this is considered a vertex
    let vertexData: [Float] = [0.0, 0.5, 0.0, -0.5, -0.5, 0.0, 0.5, -0.5, 0.0]
    
    //setup your reder pipline for the GPU
    var pipelineState: MTLRenderPipelineState! = nil
    
    var commandQueue: MTLCommandQueue! = nil
    
    //timer so the view knows to redraw
    var timer: CADisplayLink! = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        device = MTLCreateSystemDefaultDevice()
        metalLayer = CAMetalLayer.init()
        //this layer will interact with the device I created earlier.  The reason for this is because in order to work with the GPU, you need to use a MTLDevice which is a protocol of behaviors that serves as the interface for the GPU or Metal App.
        metalLayer?.device = device
        metalLayer?.pixelFormat = .bgra8Unorm
        metalLayer?.framebufferOnly = true
        metalLayer?.frame = view.layer.frame
        view.layer.addSublayer(metalLayer!)
        
        let dataSize = vertexData.count * MemoryLayout.size(ofValue: vertexData[0])
        vertexBuffer = device.makeBuffer(bytes: vertexData, length: dataSize, options: .storageModePrivate)
        
        //the actual code that you write that instructs the GPU how to process data comes in the form of shaders which utilizes the Metal Shading Language
        let defaultLibrary = device.makeDefaultLibrary()
        let fragmentProgram = defaultLibrary!.makeFunction(name: "basic_fragment")
        let vertexProgram = defaultLibrary!.makeFunction(name: "basic_vertex")
        
        //rendering the pipeline
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        do {
            try pipelineState = device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        } catch let error {
            print("Failed to create pipeline state, error \(error)")
        }
        
        //initialize the command queue which is an expensive object to create, so create only one and use it.
        commandQueue = device.makeCommandQueue()
        
        //the timer calls the game loop function everytime the screen refreshes, which signals the GPU that it has work to do:
        timer = CADisplayLink.init(target: self, selector: #selector(ViewController.gameLoop))
        timer.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func render(){
        let renderPassDescriptor = MTLRenderPassDescriptor()
        guard let drawable = metalLayer?.nextDrawable() else {return}
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor.init(red: 221.0/255.0, green: 160.0/255.0, blue: 221.0/255.0, alpha: 1.0)
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        
        //bringing it all together
        let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        renderEncoder?.setRenderPipelineState(pipelineState)
        renderEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
        renderEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
    
    @objc func gameLoop(){
        autoreleasepool(invoking: {
            self.render()
        })
    }


}


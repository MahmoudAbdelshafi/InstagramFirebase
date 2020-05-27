//
//  CameraController.swift
//  InstagramFirebase
//
//  Created by Mahmoud on 5/26/20.
//  Copyright © 2020 Mahmoud. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: UIViewController,AVCapturePhotoCaptureDelegate, UIViewControllerTransitioningDelegate {
  
    
    //MARK:- Properties
    let output = AVCapturePhotoOutput()
    
    let dismissButton:UIButton = {
           let button = UIButton(type: .system)
           let image = UIImage(named: "right_arrow_shadow")
           button.setImage(image, for: .normal)
           button.addTarget(self, action: #selector(handelDismissButton), for: .touchUpInside)
           return button
       }()
    
    let capturePhotoButton:UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "capture_photo")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(handelCapturePhoto), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtonsConstraints()
        setupCaptureSession()
        transitioningDelegate = self
     
    }
    
    

    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    
    
    let customAnimationPresenter = CustomAnimationPresentor()
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customAnimationPresenter
    }
    let customAnimationDismisser = CustomAnimationDismisser()
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customAnimationDismisser
    }
    
    
  
 

}


//MARK:- Private Functions
extension CameraController{
    @objc fileprivate func handelDismissButton(){
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func setupButtonsConstraints(){
        view.addSubview(capturePhotoButton)
        capturePhotoButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 30, paddingRight: 0, width: 80, height: 80)
        capturePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        view.addSubview(dismissButton)
        dismissButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 20 , width: 40, height: 40)
        
    }
    @objc fileprivate func handelCapturePhoto(){
        let settings = AVCapturePhotoSettings()
        settings.previewPhotoFormat = settings.embeddedThumbnailPhotoFormat
        output.capturePhoto(with: settings, delegate: self)
       }
    
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        let imageDate = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
        let perviewImage = UIImage(data: imageDate!)
        let continaerView = PerviewPhotoContinaerView()
        view.addSubview(continaerView)
        
        continaerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        let perviewImageView = UIImageView(image: perviewImage)
        continaerView.perviewImageView.image = perviewImageView.image
        
    }
    
    fileprivate func setupCaptureSession(){
        let captureSession = AVCaptureSession()
        // 1. Set up Input
        guard let captureDevice = AVCaptureDevice.default(for:AVMediaType.video) else { return}
        do{
            let input = try AVCaptureDeviceInput(device:captureDevice)
            if captureSession.canAddInput(input){
             captureSession.addInput(input)
            }
        }catch let err{
            print("Camera Error",err)
        }
       // 2. Set up Output
        if captureSession.canAddOutput(output){
        captureSession.addOutput(output)
        }
        // 3. Set up output Perview
        let perviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        perviewLayer.frame = view.frame
        view.layer.addSublayer(perviewLayer)
        captureSession.startRunning()
    }
}

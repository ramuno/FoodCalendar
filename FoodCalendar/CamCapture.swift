//
//  CamCapture.swift
//  CameraTest
//
//  Created by 石郷 祐介 on 2015/02/25.
//  Copyright (c) 2015年 Yusk. All rights reserved.
//

import UIKit
import AVFoundation
import CoreVideo

class CamCapture
{
	private var captureSession:AVCaptureSession?
	private var dataOutput:AVCaptureStillImageOutput?
	private var videoConnection:AVCaptureConnection?
	private var isCapturing:Bool = false
	
	init()
	{
		self.setupAVCapture()
	}
	
	deinit
	{
		self.disposeAVCapture()
	}
	
	/*
	 * 初期化処理
	*/
	func setupAVCapture()
	{
		self.captureSession = AVCaptureSession()
		
		if let captureSession = self.captureSession
		{
			captureSession.sessionPreset = AVCaptureSessionPresetPhoto
			
			let input:AVCaptureDeviceInput? = self.captureDeviceInput()
			if (captureSession.canAddInput(input))
			{
				captureSession.addInput(input)
			}
			
			self.dataOutput = captureDataOutput()
			if (captureSession.canAddOutput(self.dataOutput))
			{
				captureSession.addOutput(self.dataOutput)
			}
			
			self.videoConnection = self.dataOutput?.connection(withMediaType: AVMediaTypeVideo)
			self.videoConnection?.videoOrientation = AVCaptureVideoOrientation.portrait
			
			captureSession.startRunning()
		}
	}
	
	/*
	 * 終了処理
	*/
	func disposeAVCapture()
	{
		if let captureSession = self.captureSession
		{
			captureSession.stopRunning()
			
			for output in captureSession.outputs
			{
				captureSession.removeOutput(output as! AVCaptureOutput)
			}
			
			for input in captureSession.inputs
			{
				captureSession.removeInput(input as! AVCaptureInput)
			}
		}
		self.dataOutput = nil
	}
	
	/*
	 * プレビューレイヤーを返す
	*/
	func previewLayerWithFrame(frame:CGRect) -> AVCaptureVideoPreviewLayer
	{
		let videoPreviewLayer:AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
		videoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientation.portrait
		
		// 指定したframeと実際のカメラ画像のサイズ（captureSession.sessionPresetに指定）を比較して、
		// 差が少ない辺に合わせ、アスペクト比を変更しないで、はみ出した部分は隠す
		videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
		videoPreviewLayer.frame = frame

		return videoPreviewLayer
	}
	
	/*
	 * キャプチャする
	*/
	func capture(capture:@escaping (_ img:UIImage)->Void)
	{
		if (self.isCapturing)
		{
			return
		}
		
		self.isCapturing = true

		var err:NSErrorPointer = nil
		self.dataOutput?.captureStillImageAsynchronously(
			from: self.videoConnection,
			completionHandler: { (imageDataSampleBuffer:CMSampleBuffer!, err) -> Void in
				let imageDataJpeg = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
				let img:UIImage? = UIImage(data: imageDataJpeg!)

				capture(img!)
				self.isCapturing = false
		})
	}
	
	private func captureDeviceInput() -> AVCaptureDeviceInput?
	{
		let captureDevice:AVCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)

		var err:NSErrorPointer = nil
		let deviceInput:AVCaptureDeviceInput = (try! AVCaptureDeviceInput(device: captureDevice))
		return deviceInput
	}
	
	private func captureDataOutput() -> AVCaptureStillImageOutput
	{
		let dataOutput:AVCaptureStillImageOutput = AVCaptureStillImageOutput()
		dataOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]

		for connection in dataOutput.connections
		{
			if ((connection as! AVCaptureConnection).isVideoOrientationSupported)
			{
				(connection as! AVCaptureConnection).videoOrientation = AVCaptureVideoOrientation.portrait
			}
		}
		
		return dataOutput
	}
}

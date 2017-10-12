//
//  CameraViewController.swift
//  FoodCalendar
//
//  Created by Student on 2017/07/21.
//  Copyright © 2017年 Student. All rights reserved.
//

import UIKit
import Photos

class CameraViewController: UIViewController
{
    var camera:CamCapture = CamCapture()
    var previewLayer:CALayer?
    
    var resultImg:UIImageView?
    var returnBtn:UIButton?
    
    var isProcessing = false
    var isResult = false
    
    var request: PHCollectionListChangeRequest!
    
    /* -------------------------------------------------
     * ビューが読み込まれたときに呼び出される
     ------------------------------------------------- */
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.resultImg = UIImageView()
        self.resultImg?.frame = self.view.frame
        self.resultImg?.alpha = 0.0
        self.view.addSubview(self.resultImg!)
        
        // カメラをセットアップする
        self.setupCamera(cameraSize: self.view.frame.size)
        
        self.returnBtn = UIButton()
        self.returnBtn?.frame = CGRect(x: 0, y: 0, width: 84.0, height: 66.0)
        self.returnBtn?.setImage(UIImage(named: "mark_arrow_left"), for: .normal)
        self.returnBtn?.addTarget(self, action: #selector(self.returnBtnAction(sender:)), for: UIControlEvents.touchUpInside)
        
        self.view.addSubview(self.returnBtn!)
    }
    
    func returnBtnAction(sender:AnyObject)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        PHPhotoLibrary.requestAuthorization { (status) -> Void in
            switch (status)
            {
            case .authorized:
                print("authorized")
            case .denied:
                print("denied")
            case .notDetermined:
                print("notDetermined")
            case .restricted:
                print("restricted")
            }
        }
    }
    
    /* -------------------------------------------------
     * カメラをセットアップする
     ------------------------------------------------- */
    private func setupCamera(cameraSize:CGSize)
    {
        self.previewLayer = self.camera.previewLayerWithFrame(
            frame: CGRect(
                x: self.view.frame.size.width/2.0 - cameraSize.width/2.0,
                y: self.view.frame.size.height/2.0 - cameraSize.height/2.0,
                width: cameraSize.width,
                height: cameraSize.height))
        
        if let previewLayer = self.previewLayer
        {
            self.view.layer.addSublayer(previewLayer)
        }
    }
    
    /* -------------------------------------------------
     * 撮影する
     ------------------------------------------------- */
    private func shoot()
    {
        if (self.isProcessing)
        {
            return
        }
        
        // キャプチャ
        self.camera.capture { (img) in
            self.isProcessing = true
            
            if let resultImg = self.resultImg
            {
                resultImg.image = img
                resultImg.alpha = 1.0
                self.view.bringSubview(toFront: resultImg)
                
                self.isResult = true
            }
            
            self.isProcessing = false
        }
    }
    
    /* -------------------------------------------------
     * タップして指を離したときに呼び出される
     ------------------------------------------------- */
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if (self.isResult)
        {
            if let resultImg = self.resultImg
            {
                let alert = UIAlertController(title: "確認", message: "保存しますか？", preferredStyle: UIAlertControllerStyle.alert)
                
                // はいを押したとき
                let alertActionYes = UIAlertAction(title: "はい", style: UIAlertActionStyle.default, handler: { (action) in
                        resultImg.alpha = 0.0
                        self.view.sendSubview(toBack: resultImg)
                        self.isResult = false
                    
                        // 写真を保存する
                        if let img = resultImg.image
                        {
                            self.savePhoto(img: img)
                        }
                })
            
                // いいえを押したとき
                let alertActionNo = UIAlertAction(title: "いいえ", style: UIAlertActionStyle.cancel, handler: { (action) in
                    self.resultImg?.alpha = 0.0
                    self.view.sendSubview(toBack: self.resultImg!)
                    self.isResult = false
                })
                alert.addAction(alertActionYes)
                alert.addAction(alertActionNo)
                self.present(alert, animated: true, completion: nil)
            }
        }
        else
        {
            // 撮影する
            self.shoot()
        }
    }
        
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //------------------------------------------------------------------------------
    // 写真を保存する
    //------------------------------------------------------------------------------
    func savePhoto(img:UIImage)
    {
        let albumName = "FoodCalendar"
        
        self.getAlbumAsset(name: albumName) { (asset) in
            // アルバムがなかったら作る
            if (asset == nil)
            {
                PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
            }
            
            self.getAlbumAsset(name: albumName, completionHandler: { (asset) in
                if let asset = asset
                {
                    let imgAsset = PHAssetChangeRequest.creationRequestForAsset(from: img)
                    if let assetPlaceholder = imgAsset.placeholderForCreatedAsset
                    {
                        // どのアルバムに入れるか選択する
                        let request = PHAssetCollectionChangeRequest(for: asset)

                        let enumeration:NSArray = [assetPlaceholder]
                        request?.addAssets(enumeration)
                    }
                }
            })
        }
    }

    //------------------------------------------------------------------------------
    // 指定したアルバムが存在するかどうかを調べる
    //------------------------------------------------------------------------------
    func getAlbumAsset(name:String, completionHandler: @escaping (_ asset:PHAssetCollection?) -> Void)
    {
        PHPhotoLibrary.shared().performChanges({
            
            // アルバムリストを取得する
            let list = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.album,
                                                               subtype: PHAssetCollectionSubtype.any,
                                                               options: nil)
            var assetAlbum:PHAssetCollection? = nil
            
            // アルバムを検索する
            list.enumerateObjects({ (album, index, isStop) in
                
                if (album.localizedTitle == name)
                {
                    assetAlbum = album
                    
                    let stop:ObjCBool = false
                    isStop.initialize(to: stop)
                }
            })

            completionHandler(assetAlbum)
            
        }, completionHandler: nil)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}


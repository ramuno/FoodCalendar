//
//  ViewController.swift
//  FoodCalendar
//
//  Created by Student on 2017/07/12.
//  Copyright © 2017年 Student. All rights reserved.
//

import UIKit
import Photos
import AssetsLibrary

class ViewController: UIViewController ,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    let dateManager = DateManager()
    
    let weekArray = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    let numOfDays = 7
    let cellMargin: CGFloat = 2.0
    
    //var fetchAssetWithMediaType = [PHAsset]()
    
    var assets:[PHAsset]?
    
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
        
        headerTitle.text = dateManager.CalendarHeader()

        // 指定したアルバムから写真をとってくる
        self.assets = getAllPhotosInfo(albumName: "FoodCalendar")
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        self.calendarCollectionView.reloadData()
    }
    
    //------------------------------------------------------------------------------
    // 日本時間に変換する
    //------------------------------------------------------------------------------
    func convertToJpDate(_ date:Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return dateFormatter.string(from: date)
    }
    
    //------------------------------------------------------------------------------
    // 指定したアルバムから写真を取得して返す
    //------------------------------------------------------------------------------
    private func getAllPhotosInfo(albumName:String) -> [PHAsset]
    {
        var photoAssets = [PHAsset]()
        
        let collections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
        collections.enumerateObjects( { (collection, index, stop) in
            if (collection.localizedTitle == albumName)
            {
                let assets = PHAsset.fetchAssets(in: collection, options: nil)
                assets.enumerateObjects({(asset, index, stop) in
                    photoAssets.append(asset)
                })
            }else{
                print(index,"skip")
            }
        })
        
        return photoAssets
    }
    
    enum PHAssetMediaType: Int{
        case Image
 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Section毎にCellの総数を変える.
        if (section == 0){
            return numOfDays
        } else {
            return dateManager.daysAcquisition() //ここは月によって異なる
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        if (indexPath.row % 7 == 0) {
            cell.textLabel.textColor = UIColor.red
        } else if(indexPath.row % 7 == 6) {
            cell.textLabel.textColor = UIColor.blue
        } else {
            cell.textLabel.textColor = UIColor.black
        }
        
        cell.imageView.image = nil
        
        let calendar = Calendar.current;
        let date = self.dateManager.conversionDateFormat(index: indexPath.row)

        if (indexPath.section == 0){             //曜日表示
            cell.backgroundColor = UIColor.green
            cell.textLabel.text = weekArray[indexPath.row]
            
        }else{                                  //日付表示
            cell.backgroundColor = UIColor.white
            cell.textLabel.text = calendar.component(.day, from: date!).description
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            
            if  let assets = self.assets
            {
                for (index, element) in assets.enumerated()
                {
                    if let creationDate = element.creationDate
                    {
                        // 日付（文字列）
                        let dateString = self.convertToJpDate(creationDate)
                        
                        if let assetDate = dateFormatter.date(from: dateString), let date = date
                        {
                            if (calendar.isDate(assetDate, inSameDayAs: date))
                            {
                                // ここで表示
                                cell.imageView.image = self.getAssetThumbnail(asset: element)
                            }
                        }
                    }
                }
            }
        }
        
        return cell
    }

    func getAssetThumbnail(asset:PHAsset) -> UIImage
    {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.isSynchronous = true
        var thumbnail = UIImage()
        
        manager.requestImage(for: asset,
                             targetSize: CGSize(width: 100.0, height: 100.0),
                            contentMode: .aspectFit,
                            options: option) { (result, info) in
                                thumbnail = result!
                            }
        return thumbnail
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Num：\(indexPath.row) Section:\(indexPath.section)")
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfMargin:CGFloat = 8.0
        let widths:CGFloat = (collectionView.frame.size.width - cellMargin * numberOfMargin)/CGFloat(numOfDays)
        let heights:CGFloat = widths * 0.8
    
        return CGSize(width:widths,height:heights)
    }
    
    //セルのアイテムのマージンを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0.0 , 0.0 , 0.0 , 0.0 )  //マージン(top , left , bottom , right)
    }
    
    //セルの水平方向のマージンを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellMargin
    }
    //セルの垂直方向のマージンを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellMargin
    }
    
    @IBAction func tappedHeaderPrevBtn(_ sender: UIButton) {
        dateManager.preMonthCalendar()
        calendarCollectionView.reloadData()
        headerTitle.text = dateManager.CalendarHeader()
        self.calendarCollectionView.reloadData()
    }
    
    @IBAction func tappedHeaderNextBtn(_ sender: UIButton) {
        dateManager.nextMonthCalendar()
        calendarCollectionView.reloadData()
        headerTitle.text = dateManager.CalendarHeader()
        self.calendarCollectionView.reloadData()
    }


}

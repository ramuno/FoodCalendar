//
//  BalanceViewController.swift
//  FoodCalendar
//
//  Created by Student on 2017/07/21.
//  Copyright © 2017年 Student. All rights reserved.
//

import UIKit

class BalanceViewController: UIViewController {

    @IBOutlet weak var RedLabel: UILabel!
    @IBOutlet weak var GreenLabel: UILabel!
    @IBOutlet weak var YellowLabel: UILabel!
    @IBOutlet weak var BlackLabel: UILabel!
    @IBOutlet weak var WhiteLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        RedLabel.adjustsFontSizeToFitWidth = true
        GreenLabel.adjustsFontSizeToFitWidth = true
        YellowLabel.adjustsFontSizeToFitWidth = true
        BlackLabel.adjustsFontSizeToFitWidth = true
        WhiteLabel.adjustsFontSizeToFitWidth = true
        
        RedLabel.text="鶏肉　豚肉　牛肉　たこ　えび　まぐろ　鮭\n赤味噌　にんじん　トマト　など…"
        
        GreenLabel.text="きぬさや　わらび　万能ねぎ　しそ　セリ　キャベツ\n春菊　ほうれん草　ピーマン　ブロッコリー　みつば\nカボス　など…"
        
        YellowLabel.text="たまご　生姜　かぼちゃ　タケノコ　さつま揚げ　油類\nとうもろこし　味噌　レモン　ゆず　ぎんなん　など…"
        
        BlackLabel.text="わかめ　昆布　ひじき　こんにゃく　しいたけ　しめじ\nまいたけ　きくらげ　黒ゴマ　いわし(つみれ)　など…"
        
        WhiteLabel.text="米　めん類　かに　イカ　うなぎ　豆腐　ちくわ\nはんぺん　白菜　大根　ねぎ　なす　白身の魚　など…"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}

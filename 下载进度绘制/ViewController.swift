//
//  ViewController.swift
//  下载进度绘制
//
//  Created by susnm on 16/9/13.
//  Copyright © 2016年 susnm. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet var progressView: ProgressView!
  @IBOutlet var sliderView: UISlider!
  
  @IBAction func slideValueChange(_ sender: UISlider) {
    progressView.progress = CGFloat(sender.value)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
//    let proView = ProgressView(frame: CGRect(x: 20, y: 20, width: 200, height: 100))
//    view.addSubview(proView)
    
  }

  @IBAction func changeProgress(_ sender: UIButton) {
    
    sliderView.setValue(0.4, animated: true)
    progressView.setProgress(progress: 0.4, withAnimated: true)
  }

}


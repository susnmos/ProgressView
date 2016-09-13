//
//  ProgressView.swift
//  下载进度绘制
//
//  Created by susnm on 16/9/13.
//  Copyright © 2016年 susnm. All rights reserved.
//

import UIKit

@IBDesignable
class ProgressView: UIView {
  
  var link: CADisplayLink?
  
  /// 进度 0.0...1.0
  @IBInspectable var progress: CGFloat = 0 {
    didSet {
      print(progress)
      self.setNeedsDisplay()
    }
  }
  
  @IBInspectable var preferColor: UIColor! = UIColor.lightGray {
    didSet {
      self.setNeedsDisplay()
    }
  }
  
  private var toProgress: CGFloat!
		
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    setProgress(progress: 0.0, withAnimated: true)
  }
  // MARK: - setProgress设置进度
  /// 设置进度
  ///
  /// - parameter progress: 设置的进度
  /// - parameter animated: 是否需要动画
  func setProgress(progress: CGFloat, withAnimated animated: Bool) {
    self.toProgress = progress
    
    if Int(self.toProgress*100) == Int(self.progress*100) {
      return
    }
    if animated {
      self.animatedToChangeProgress()
    }else {
      self.progress = progress
    }
  }
  
  
  /// 动画设置进度
  @objc private func animatedToChangeProgress() {
    if toProgress > self.progress && self.progress != 1 {
      self.progress += 0.01
    }else if toProgress < self.progress && self.progress != 0 {
      self.progress -= 0.01
    }
    
    self.link?.isPaused = Int(self.progress*100) == Int(toProgress*100) ? true : false
    
    // 复位0的时候，放置出现progress<0.01的情况，因为在上面一行代码中，当相等时（相等的判断舍去了两位小数点后的数据，因此progress会在<0.01的某个值时停止渲染）定时器暂停了
    if self.progress < 0.01 {
      self.progress = 0
    }
    
    // 1s 60    1/60s 1 progress*100
    if link == nil {
      let link = CADisplayLink(target: self, selector: #selector(ProgressView.animatedToChangeProgress))
      link.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
      self.link = link
    }
    
  }
		
  // MARK: - init
  override init(frame: CGRect) {
    
    super.init(frame: frame)
    self.backgroundColor = UIColor.clear
  }
  
  required init?(coder aDecoder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
    super.init(coder: aDecoder)
  }
  
  // MARK: - draw
  override func draw(_ rect: CGRect) {
    
    let radiusBig = (min(rect.size.width, rect.size.height) - 20) / 2
    let center = CGPoint(x: rect.size.width/2, y: rect.size.height/2)
    
    let endAngle = CGFloat(-M_PI_2) + progress * CGFloat(M_PI*2)
    
    let strokePath = UIBezierPath(arcCenter: center, radius: radiusBig, startAngle: CGFloat(0), endAngle: CGFloat(M_PI*2), clockwise: true)
    strokePath.lineWidth = 2
    preferColor.set()
    strokePath.stroke()
    
    let path = UIBezierPath()
    path.move(to: center)
    path.addArc(withCenter: center, radius: radiusBig-10, startAngle: CGFloat(-M_PI_2), endAngle: CGFloat(endAngle), clockwise: true)
    path.fill()
    
  }
  
  override func removeFromSuperview() {
    super.removeFromSuperview()
    self.link?.remove(from: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
    self.link?.invalidate()
    self.link = nil
  }
}

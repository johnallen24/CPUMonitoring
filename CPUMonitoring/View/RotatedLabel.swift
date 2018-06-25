////
////  RotatedLabel.swift
////  CPUMonitoring
////
////  Created by John Allen on 6/21/18.
////  Copyright © 2018 jallen.studios. All rights reserved.
////
//
//import UIKit
//
//class RotatedLabel: UIView {
//    
//    
//    let rotationView = UIView()
//    
//    let label: UILabel = {
//        let lb = UILabel()
//        //lb.translatesAutoresizingMaskIntoConstraints = false
//        lb.backgroundColor = UIColor.green
//        return lb
//    }()
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//    
//    override init(frame: CGRect){
//        super.init(frame: frame)
//        self.setup()
//    }
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        self.setup()
//    }
//    
//    func setup() {
//        
//        self.addSubview(rotationView)
//        rotationView.addSubview(label)
//        label.frame = rotationView.bounds
//        // add constraints to pin TextView to rotation view edges.
//
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        rotationView.transform = CGAffineTransform.identity
//        rotationView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: self.bounds.height, height: self.bounds.width))
//        rotationView.transform = translateRotateFlip()
//        
//    
//    }
//    
//    func translateRotateFlip() -> CGAffineTransform {
//        
//        var transform = CGAffineTransform.identity
//        
//        // translate to new center
//        transform = transform.translatedBy(x: (self.bounds.width / 2)-(self.bounds.height / 2), y: (self.bounds.height / 2)-(self.bounds.width / 2))
//        // rotate counterclockwise around center
//        transform = transform.rotated(by: CGFloat(-M_PI_2))
//        // flip vertically
//        transform = transform.scaledBy(x: -1, y: 1)
//        
//        return transform
//    }
//
//}
//


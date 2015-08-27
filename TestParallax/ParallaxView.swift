//
//  ParallaxView.swift
//  TestParallax
//
//  Created by Igor Puliaiev on 8/9/15.
//  Copyright (c) 2015 Igor Puliaiev. All rights reserved.
//

import UIKit

class ParallaxView: UIView {
    
    internal struct LayerType {
        static let LAYER_BACKGROUND = String("background");
        static let LAYER_MOVING_PART = String("moving part");
        static let LAYER_OTHER = String("other");
    }
    
    internal struct DictionaryKeys {
        static let KEY_IMAGE = String("image");
        static let KEY_LAYER = String("layer");
    }
    
    // parallax settings:
    let highValue = Float(1.1);
    let lowerValue = Float(0.2);
    var numberOfImages:(Int);
    
    // animate settings:
    let duration: NSTimeInterval = 1.0;
    let delay: NSTimeInterval = 0.0;
    let dampingRatio: CGFloat = 0.4;
    let velocity: CGFloat = 0.2;
    let options: UIViewAnimationOptions = UIViewAnimationOptions.BeginFromCurrentState;
    
    var arrayOfHorizontalCenterAlignmentConstraint: Array<NSLayoutConstraint>;
    
    func scaleFactorForIndex(index: Int) -> CGFloat {
        return CGFloat(self.lowerValue + Float(index) * (self.highValue - self.lowerValue) / Float(numberOfImages));
    }
    
    func addConstraintToArray(constraint: NSLayoutConstraint) {
        self.arrayOfHorizontalCenterAlignmentConstraint.append(constraint);
    }
    
    func setOffset(translation:CGPoint) {
        for var index = 0; index <  self.arrayOfHorizontalCenterAlignmentConstraint.count; index++ {
            arrayOfHorizontalCenterAlignmentConstraint[index].constant = translation.x * scaleFactorForIndex(index);
        }
    }
    
    func resetWithAnimation() {
        self.layoutIfNeeded();
        UIView.animateWithDuration(self.duration, delay: self.delay, usingSpringWithDamping: self.dampingRatio, initialSpringVelocity: self.velocity, options: self.options, animations:
            {
                for item in self.arrayOfHorizontalCenterAlignmentConstraint {
                    item.constant = 0;
                }
                self.layoutIfNeeded();
            }, completion: nil);
    }
    
    convenience init (array: [[String: Any]]) {
        self.init();
        self.numberOfImages = array.count;
        for item in array {
            var imageName: String = item[DictionaryKeys.KEY_IMAGE] as! String;
            var image: UIImage = UIImage(named: imageName)!;
            var layer: String = item[DictionaryKeys.KEY_LAYER] as! String;
            var imageView: UIImageView = UIImageView(image: image);

            self.addSubview(imageView);
            
            // constraints
            let horizontalCenterAlignmentConstraint = makeHorizontalCenterAlignmentConstraint(imageView);
            let verticalCenterAlignmentConstraint = makeVerticalCenterAlignmentConstraint(imageView);
            
            switch layer {
            case LayerType.LAYER_BACKGROUND:
                let widthsConstraint = makeWidthsConstraint(imageView);
                let heightConstraint = makeHeightConstraint(imageView);
                
                NSLayoutConstraint.activateConstraints([horizontalCenterAlignmentConstraint, verticalCenterAlignmentConstraint, widthsConstraint, heightConstraint]);
                
            case LayerType.LAYER_MOVING_PART:
                let aspectRatioConstraint = makeAspectRatioConstraint(imageView);
                let widthsConstraint = makeWidthsConstraint(imageView);
                let heightConstraint = makeHeightConstraint(imageView);
            
                NSLayoutConstraint.activateConstraints([horizontalCenterAlignmentConstraint, verticalCenterAlignmentConstraint, aspectRatioConstraint, widthsConstraint, heightConstraint]);
                
                addConstraintToArray(horizontalCenterAlignmentConstraint);
                
            case LayerType.LAYER_OTHER:
                let aspectRatioConstraint = makeAspectRatioConstraint(imageView);
                let widthsConstraint = makeWidthsConstraint(imageView);
                let heightConstraint = makeHeightConstraint(imageView);
                
                NSLayoutConstraint.activateConstraints([horizontalCenterAlignmentConstraint, verticalCenterAlignmentConstraint, aspectRatioConstraint, widthsConstraint, heightConstraint]);
            
            default:
                println("\(layer) is not standart layer");
            }
            
            imageView.setTranslatesAutoresizingMaskIntoConstraints(false);
        }
    }
    
    func makeHorizontalCenterAlignmentConstraint(imageView: UIImageView) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0);
    }
    
    func makeVerticalCenterAlignmentConstraint(imageView: UIImageView) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0);
    }
    
    func makeAspectRatioConstraint(imageView: UIImageView) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: imageView, attribute: NSLayoutAttribute.Width, multiplier: CGFloat(imageView.frame.height / imageView.frame.width), constant: 0);
    }
    
    func makeWidthsConstraint(imageView: UIImageView) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.LessThanOrEqual, toItem: self, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0);
    }
    
    func makeHeightConstraint(imageView: UIImageView) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.LessThanOrEqual, toItem: self, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0);
    }
    
    required init(coder aDecoder: NSCoder) {
        self.arrayOfHorizontalCenterAlignmentConstraint = Array<NSLayoutConstraint>();
        self.numberOfImages = 0;
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        self.arrayOfHorizontalCenterAlignmentConstraint = Array<NSLayoutConstraint>();
        self.numberOfImages = 0;
        super.init(frame: frame)
    }
    
}

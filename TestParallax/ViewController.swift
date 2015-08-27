//
//  ViewController.swift
//  TestParallax
//
//  Created by Igor Puliaiev on 8/8/15.
//  Copyright (c) 2015 Igor Puliaiev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var parallaxView = ParallaxView();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        var array: [[String:Any]] = [
            [
                ParallaxView.DictionaryKeys.KEY_IMAGE: "par-back.png",
                ParallaxView.DictionaryKeys.KEY_LAYER: ParallaxView.LayerType.LAYER_BACKGROUND
            ],
            [
                ParallaxView.DictionaryKeys.KEY_IMAGE: "par-text.png",
                ParallaxView.DictionaryKeys.KEY_LAYER: ParallaxView.LayerType.LAYER_OTHER
            ],
            [
                ParallaxView.DictionaryKeys.KEY_IMAGE: "par-3.png",
                ParallaxView.DictionaryKeys.KEY_LAYER: ParallaxView.LayerType.LAYER_MOVING_PART
            ],
            [
                ParallaxView.DictionaryKeys.KEY_IMAGE: "par-2.png",
                ParallaxView.DictionaryKeys.KEY_LAYER: ParallaxView.LayerType.LAYER_MOVING_PART
            ],
            [
                ParallaxView.DictionaryKeys.KEY_IMAGE: "par-1.png",
                ParallaxView.DictionaryKeys.KEY_LAYER: ParallaxView.LayerType.LAYER_MOVING_PART
            ]
        ];
        
        parallaxView = ParallaxView(array: array);
        self.view.addSubview(parallaxView);
        
        setConstrains(parallaxView);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translationInView(self.view);
        parallaxView.setOffset(translation);
        
        if (recognizer.state == UIGestureRecognizerState.Ended) {
            parallaxView.resetWithAnimation();
        }
        
    }
    
    func setConstrains(parView: ParallaxView) {
        let horizontalConstraint = NSLayoutConstraint(item: parView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0);
        
        let verticalConstraint = NSLayoutConstraint(item: parView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0);
        
        let widthConstraint = NSLayoutConstraint(item: parView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0);
        
        let heightConstraint = NSLayoutConstraint(item: parView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0);
        
        parView.setTranslatesAutoresizingMaskIntoConstraints(false);
        
        NSLayoutConstraint.activateConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint]);
    }
}


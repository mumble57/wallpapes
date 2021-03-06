// RMParallax
//

typealias RMParallaxCompletionHandler = () -> Void

enum ScrollDirection: Int {
    case right = 0, left
}

let rm_text_span_width: CGFloat = 320.0
let rm_percentage_multiplier: CGFloat = 0.4
let rm_percentage_multiplier_text: CGFloat = 0.8

let rm_motion_frame_offset: CGFloat = 15.0
let rm_motion_magnitude: CGFloat = rm_motion_frame_offset / 3.0

import UIKit

class RMParallax : UIViewController, UIScrollViewDelegate {
    
    var completionHandler: RMParallaxCompletionHandler!
    var items: [RMParallaxItem]!
    var motion = false
    
    var scrollView: UIScrollView!
    var dismissButton: UIButton!
    
    var currentPageNumber = 0
    var otherPageNumber = 0
    var viewWidth: CGFloat = 0.0
    var lastContentOffset: CGFloat = 0.0
    
    
    /**
    *  Designated initializer.
    *
    *  @param items  - an array of RMParallaxItems to page through.
    *  @param motion - if set to TRUE, a very subtle motion effect will be added to the image view.
    */
    required init(items: [RMParallaxItem], motion: Bool) {
        super.init(nibName: nil, bundle: nil)
        self.items = items
        self.motion = motion
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Use init with items, motion.")
    }
 
    // MARK : Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupRMParallax()
    }
    
    // MARK : Setup
    
    func setupRMParallax() {
        
        self.dismissButton = UIButton(frame: CGRect(x: self.view.frame.size.width / 2.0 - 11.5, y: self.view.frame.size.height - 20.0 - 25, width: 23.0, height: 23.0))
        self.dismissButton.setImage(UIImage(named: "close_button"), for: UIControl.State())
        self.dismissButton.addTarget(self, action: #selector(RMParallax.closeButtonSelected(_:)), for: UIControl.Event.touchUpInside)
        
        self.scrollView = UIScrollView(frame: self.view.frame)
        self.scrollView.showsHorizontalScrollIndicator = false;
        self.scrollView.isPagingEnabled = true;
        self.scrollView.delegate = self;
        self.scrollView.bounces = false;
        
        self.viewWidth = self.view.frame.size.width
        
        self.view.addSubview(self.scrollView)
        self.view.insertSubview(self.dismissButton, aboveSubview: self.scrollView)
        
        for (index, item) in self.items.enumerated() {
            
            let diff: CGFloat = 0.0
            let frame = CGRect(x: (self.view.frame.size.width * CGFloat(index)), y: 0.0, width: self.viewWidth, height: self.view.frame.size.height)
            let subview = UIView(frame: frame)
            
            let internalScrollView = UIScrollView(frame: CGRect(x: diff, y: 0.0, width: self.viewWidth - (diff * 2.0), height: self.view.frame.size.height))
            internalScrollView.isScrollEnabled = false
            
            let internalTextScrollView = UIScrollView(frame: CGRect(x: diff, y: 0.0, width: self.viewWidth - (diff * 2.0), height: self.view.frame.size.height))
            internalTextScrollView.isScrollEnabled = false
            internalTextScrollView.backgroundColor = UIColor.clear
            
            //
            
            let imageViewFrame = self.motion ?
                CGRect(x: 0.0, y: 0.0, width: internalScrollView.frame.size.width + rm_motion_frame_offset, height: self.view.frame.size.height + rm_motion_frame_offset) :
                CGRect(x: 0.0, y: 0.0, width: internalScrollView.frame.size.width, height: self.view.frame.size.height)
            let imageView = UIImageView(frame: imageViewFrame)
            if self.motion { self.addMotionEffectToView(imageView, magnitude: rm_motion_magnitude) }
            imageView.contentMode = UIView.ContentMode.scaleAspectFill
            internalScrollView.tag = (index + 1) * 10
            internalTextScrollView.tag = (index + 1) * 100
            imageView.tag = (index + 1) * 1000
            
            //
            
            let attributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 30.0)]
            let context = NSStringDrawingContext()
            _ = (item.text as NSString).boundingRect(with: CGSize(width: rm_text_span_width, height: CGFloat.greatestFiniteMagnitude),
                options: NSStringDrawingOptions.usesLineFragmentOrigin,
                attributes: attributes,
                context: context)
            
            //
            
            let textView = UITextView(frame: CGRect(x: 15, y: self.view.frame.size.height / 2.0 + 50, width: 200, height: 100))
            textView.text = item.text
            textView.textColor = UIColor.white
            textView.backgroundColor = UIColor.clear
            textView.isUserInteractionEnabled = false
            imageView.image = item.image
            textView.font = UIFont.systemFont(ofSize: 40)

            internalTextScrollView.addSubview(textView)
            internalScrollView.bringSubviewToFront(textView)
            
            internalScrollView.addSubview(imageView)
            internalScrollView.addSubview(internalTextScrollView)
            
            subview.addSubview(internalScrollView)
            self.scrollView.addSubview(subview)
        }
        self.scrollView.contentSize = CGSize(width: self.view.frame.size.width * CGFloat(self.items.count), height: self.view.frame.size.height)
    }
    
    // MARK : Action Functions
    
    @objc func closeButtonSelected(_ sender: UIButton) {
        self.completionHandler()
        print("close", terminator: "")
        navigationController?.isNavigationBarHidden = true
        UIApplication.shared.isStatusBarHidden = true

    }
    
    // MARK : UIScrollViewDelegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let internalScrollView = scrollView.viewWithTag((self.currentPageNumber + 1) * 10) as? UIScrollView
        let otherScrollView = scrollView.viewWithTag((self.otherPageNumber + 1) * 10) as? UIScrollView
        let internalTextScrollView = scrollView.viewWithTag((self.currentPageNumber + 1) * 100) as? UIScrollView
        let otherTextScrollView = scrollView.viewWithTag((self.otherPageNumber + 1) * 100) as? UIScrollView
        
        if let internalScrollView = internalScrollView {
            internalScrollView.contentOffset = CGPoint(x: 0.0, y: 0.0)
        }
        
        if let otherScrollView = otherScrollView {
            otherScrollView.contentOffset = CGPoint(x: 0.0, y: 0.0)
        }
        
        if let internalTextScrollView = internalTextScrollView {
            internalTextScrollView.contentOffset = CGPoint(x: 0.0, y: 0.0)
        }
        
        if let otherTextScrollView = otherTextScrollView {
            otherTextScrollView.contentOffset = CGPoint(x: 0.0, y: 0.0)
        }
        
        self.currentPageNumber = Int(scrollView.contentOffset.x) / Int(scrollView.frame.size.width)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var direction: ScrollDirection!
        var multiplier: CGFloat = 1.0
        
        let offset: CGFloat = scrollView.contentOffset.x

        if self.lastContentOffset > scrollView.contentOffset.x {
            direction = .right
            
            if self.currentPageNumber > 0 {
                if offset >  CGFloat(self.currentPageNumber - 1) * viewWidth{
                    self.otherPageNumber = self.currentPageNumber + 1
                    multiplier = 1.0
                } else {
                    self.otherPageNumber = self.currentPageNumber - 1
                    multiplier = -1.0
                }
            }
            
        } else if self.lastContentOffset < scrollView.contentOffset.x {
            direction = .left
            
            if offset <  CGFloat(self.currentPageNumber - 1) * viewWidth{
                self.otherPageNumber = self.currentPageNumber - 1
                multiplier = -1.0
            } else {
                self.otherPageNumber = self.currentPageNumber + 1
                multiplier = 1.0
            }
        }
        
        self.lastContentOffset = scrollView.contentOffset.x
        
        let internalScrollView = scrollView.viewWithTag((self.currentPageNumber + 1) * 10) as? UIScrollView
        let otherScrollView = scrollView.viewWithTag((self.otherPageNumber + 1) * 10) as? UIScrollView
        let internalTextScrollView = scrollView.viewWithTag((self.currentPageNumber + 1) * 100) as? UIScrollView
        let otherTextScrollView = scrollView.viewWithTag((self.otherPageNumber + 1) * 100) as? UIScrollView
        
        if let internalScrollView = internalScrollView {
            internalScrollView.contentOffset = CGPoint(x: -rm_percentage_multiplier * (offset - (self.viewWidth * CGFloat(self.currentPageNumber))), y: 0.0)
        }
        
        if let otherScrollView = otherScrollView {
            otherScrollView.contentOffset = CGPoint(x: multiplier * rm_percentage_multiplier * self.viewWidth - (rm_percentage_multiplier * (offset - (self.viewWidth * CGFloat(self.currentPageNumber)))), y: 0.0)
        }

        if let internalTextScrollView = internalTextScrollView {
            internalTextScrollView.contentOffset = CGPoint(x: -rm_percentage_multiplier_text * (offset - (self.viewWidth * CGFloat(self.currentPageNumber))), y: 0.0)
        }
        
        if let otherTextScrollView = otherTextScrollView {
            otherTextScrollView.contentOffset = CGPoint(x: multiplier * rm_percentage_multiplier_text * self.viewWidth - (rm_percentage_multiplier_text * (offset - (self.viewWidth * CGFloat(self.currentPageNumber)))), y: 0.0)
        }
        
    }
    
    // MARK : Motion Effects
    
    func addMotionEffectToView(_ view: UIView, magnitude: CGFloat) -> Void {
        let xMotion = UIInterpolatingMotionEffect(keyPath: "center.x", type: UIInterpolatingMotionEffect.EffectType.tiltAlongHorizontalAxis)
        let yMotion = UIInterpolatingMotionEffect(keyPath: "center.y", type: UIInterpolatingMotionEffect.EffectType.tiltAlongVerticalAxis)
        xMotion.minimumRelativeValue = (-magnitude)
        xMotion.maximumRelativeValue = (magnitude)
        yMotion.minimumRelativeValue = (-magnitude)
        yMotion.maximumRelativeValue = (magnitude)
        let motionGroup = UIMotionEffectGroup()
        motionGroup.motionEffects = [xMotion, yMotion]
        view.addMotionEffect(motionGroup)
    }
}

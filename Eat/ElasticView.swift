import UIKit

class ElasticView: UIView {
    
    fileprivate let topControlPointView = UIView()
    fileprivate let leftControlPointView = UIView()
    fileprivate let bottomControlPointView = UIView()
    fileprivate let rightControlPointView = UIView()
    
    fileprivate let elasticShape = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupComponents()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupComponents()
    }
    
    fileprivate func setupComponents() {
        elasticShape.fillColor = backgroundColor?.cgColor
        elasticShape.path = UIBezierPath(rect: self.bounds).cgPath
        layer.addSublayer(elasticShape)
        
        for controlPoint in [topControlPointView, leftControlPointView,
                             bottomControlPointView, rightControlPointView] {
                                addSubview(controlPoint)
                                controlPoint.frame = CGRect(x: 0.0, y: 0.0, width: 5.0, height: 5.0)
        }
        
        positionControlPoints()
        backgroundColor = UIColor.clear
        clipsToBounds = false
    }
    
    fileprivate func positionControlPoints(){
        topControlPointView.center = CGPoint(x: bounds.midX, y: 0.0)
        leftControlPointView.center = CGPoint(x: 0.0, y: bounds.midY)
        bottomControlPointView.center = CGPoint(x:bounds.midX, y: bounds.maxY)
        rightControlPointView.center = CGPoint(x: bounds.maxX, y: bounds.midY)
    }
    
    fileprivate func bezierPathForControlPoints()->CGPath {
        let path = UIBezierPath()
        
        let top = topControlPointView.layer.presentation()!.position
        let left = leftControlPointView.layer.presentation()!.position
        let bottom = bottomControlPointView.layer.presentation()!.position
        let right = rightControlPointView.layer.presentation()!.position
        
        let width = frame.size.width
        let height = frame.size.height
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addQuadCurve(to: CGPoint(x: width, y: 0), controlPoint: top)
        path.addQuadCurve(to: CGPoint(x: width, y: height), controlPoint:right)
        path.addQuadCurve(to: CGPoint(x: 0, y: height), controlPoint:bottom)
        path.addQuadCurve(to: CGPoint(x: 0, y: 0), controlPoint: left)
        
        return path.cgPath
    }
    
    fileprivate lazy var displayLink : CADisplayLink = {
        let displayLink = CADisplayLink(target: self, selector: #selector(ElasticView.updateLoop))
        displayLink.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
        return displayLink
    }()
    
    func updateLoop() {
        elasticShape.path = bezierPathForControlPoints()
    }
    
    fileprivate func startUpdateLoop() {
        displayLink.isPaused = false
    }
    
    fileprivate func stopUpdateLoop() {
        displayLink.isPaused = true
    }
    
    @IBInspectable var overshootAmount : CGFloat = 10
    
    func animateControlPoints() {
        let overshootAmount = self.overshootAmount
        UIView.animate(withDuration: 0.25, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1.5,
                                   options: UIViewAnimationOptions(), animations: {
                                    self.topControlPointView.center.y -= overshootAmount
                                    self.leftControlPointView.center.x -= overshootAmount
                                    self.bottomControlPointView.center.y += overshootAmount
                                    self.rightControlPointView.center.x += overshootAmount
            },
                                   completion: { _ in
                                    UIView.animate(withDuration: 0.45, delay: 0.0, usingSpringWithDamping: 0.15, initialSpringVelocity: 5.5,
                                        options: UIViewAnimationOptions(), animations: {
                                            self.positionControlPoints()
                                        },
                                        completion: { _ in
                                            self.stopUpdateLoop()
                                    })
        })
    }
    
    override func touchesBegan(_ touches: Set< UITouch >, with event: UIEvent? ) {
        startUpdateLoop()
        animateControlPoints()
    }
    
    override var backgroundColor: UIColor? {
        willSet {
            if let newValue = newValue {
                elasticShape.fillColor = newValue.cgColor
                super.backgroundColor = UIColor.clear
            }
        }
    }
    
    
}

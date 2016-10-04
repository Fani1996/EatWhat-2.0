import UIKit

class ElasticTextField: UITextField {
    
    var elasticView : ElasticView!
    
    @IBInspectable var overshootAmount: CGFloat = 10 {
        didSet {
            elasticView.overshootAmount = overshootAmount
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupView()
    }
    
    func setupView() {
        clipsToBounds = false
        borderStyle = .none
        
        elasticView = ElasticView(frame: bounds)
        elasticView.frame = CGRect(x: 0, y: 0, width: 230, height: 54)
        elasticView.backgroundColor = backgroundColor
        addSubview(elasticView)
        
        backgroundColor = UIColor.clear
        
        elasticView.isUserInteractionEnabled = false
    }
    
    override func touchesBegan(_ touches: Set< UITouch >, with event: UIEvent?) {
        elasticView.touchesBegan(touches, with: event)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }
}

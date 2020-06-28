import Foundation
import UIKit

class FloatingLabelTextField: UITextField {
    
    private var borderLayer: CALayer?
    private var borderColor: UIColor = .lightGray
    
    var floatingLabel: UILabel = UILabel(frame: CGRect.zero)
    var floatingLabelHeight: CGFloat = 14
        
    private var floatingLabelColor: UIColor = UIColor.lightGray
    private var floatingLabelFont: UIFont = UIFont.systemFont(ofSize: 14)
    
    private var  _placeholder: String?

    private var floatingLabelActive: Bool = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.backgroundColor = UIColor.white.cgColor
        layer.cornerRadius = 0
        self.borderStyle = .none
        updateBorder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.floatingLabel = UILabel(frame: CGRect.zero)
        self._placeholder = placeholder
        self.addTarget(self, action: #selector(self.editingChangeLabel), for: .editingChanged)
    }
    
    @objc func addFloatingLabel() {
        self.floatingLabel.textColor = floatingLabelColor
        self.floatingLabel.font = floatingLabelFont
        self.floatingLabel.text = self._placeholder
        self.floatingLabel.layer.backgroundColor = UIColor.white.cgColor
        self.floatingLabel.translatesAutoresizingMaskIntoConstraints = false
        self.floatingLabel.clipsToBounds = true
        self.floatingLabel.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.floatingLabelHeight)
        self.addSubview(self.floatingLabel)
        self.floatingLabel.bottomAnchor.constraint(equalTo:
        self.topAnchor, constant: -10).isActive = true
        self.placeholder = ""
        self.floatingLabelActive = true
        self.setNeedsDisplay()
    }
    
    private func removeFloatingLabel() {
        UIView.animate(withDuration: 0.13) {
            self.subviews.forEach{ $0.removeFromSuperview() }
            self.setNeedsDisplay()
        }
        self.placeholder = self._placeholder
        self.floatingLabelActive = false
    }
    
    @objc private func editingChangeLabel() {
        if self.text == "" {
            removeFloatingLabel()
        } else {
            if !floatingLabelActive {
                addFloatingLabel()
            }
        }
    }

    private func updateBorder() {
        if let borderLayer = borderLayer {
            borderLayer.backgroundColor =  borderColor.cgColor
            return
        }
        borderLayer = CALayer()
        if let borderLayer = borderLayer {
            borderLayer.backgroundColor =  borderColor.cgColor
            borderLayer.frame = CGRect(x: 0, y: self.frame.size.height - 2, width: self.frame.size.width, height: 1)
            self.layer.addSublayer(borderLayer)
        }
    }
   
    func isEmpty() -> Bool {
        return text == nil || text?.isEmpty == true
    }
}

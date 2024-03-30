import UIKit

class ToastLabel: UILabel {
    
    // 新增可變屬性，用於設定圓角半徑
    var cornerRadius: CGFloat = 5.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    // 新增可變屬性，用於設定標籤文字大小
    var labelTextSize: CGFloat = 15.0 {
        didSet {
            font = UIFont.systemFont(ofSize: labelTextSize)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    private func setupView() {
        self.numberOfLines = 0
        self.lineBreakMode = .byWordWrapping
        self.backgroundColor = .black.withAlphaComponent(0.8)
        self.textColor = UIColor.white
        self.textAlignment = .center
        self.layer.cornerRadius = self.cornerRadius
        self.layer.masksToBounds = true
        self.font = UIFont.systemFont(ofSize: self.labelTextSize)
    }
}


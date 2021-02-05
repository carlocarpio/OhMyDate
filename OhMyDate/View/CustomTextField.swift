//
//  CustomTextField.swift
//  OhMyDate
//
//  Created by Carlo Carpio on 2/2/21.
//

import UIKit

class CustomTextField: UITextField {
    init(placeholder: String) {
        super.init(frame: .zero)
        
        let spacer = UIView()
        spacer.setDimensions(height: 50, width: 12)
        leftView = spacer
        leftViewMode = .always
        
        translatesAutoresizingMaskIntoConstraints = false
        borderStyle = .none
        textColor = .white
        backgroundColor = UIColor(white: 1, alpha: 0.1)
        keyboardAppearance = .dark
        setHeight(height: 50)
        
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor(white: 1.0, alpha: 0.7)])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

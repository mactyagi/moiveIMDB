//
//  LaoderView.swift
//  moiveIMDB
//
//  Created by manukant tyagi on 30/11/24.
//

import Foundation
import UIKit


class LoaderView: UIView {
    private let loader = UIActivityIndicatorView(style: .large)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLoader()
    }
    
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLoader()
    }
    
    
    func setupLoader() {
        backgroundColor = UIColor(white: 0, alpha: 0.5)   // semi transparent background
        loader.color = .white
        loader.translatesAutoresizingMaskIntoConstraints = false
        addSubview(loader)
        
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: centerYAnchor)
            
        ])
    }
    
    
    func show(on view: UIView) {
        DispatchQueue.main.async {
            self.frame = view.bounds
            view.addSubview(self)
            self.loader.startAnimating()
        }
    }
    
    func hide() {
        DispatchQueue.main.async {
            self.loader.stopAnimating()
            self.removeFromSuperview()
        }
        
    }
    
}

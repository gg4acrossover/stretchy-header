//
//  MEScrollViewHeader.swift
//  MEHeaderVC
//
//  Created by viethq on 4/27/18.
//  Copyright © 2018 viethq. All rights reserved.
//

import UIKit

// MARK: ScrollView category
extension UIScrollView {
    private struct MEAssociatedObject {
        static var key = "me_headerview"
    }
    
    private(set) var stretchyHeader: MEStretchyHeader {
        get {
            if let header = objc_getAssociatedObject(self, &MEAssociatedObject.key) as? MEStretchyHeader {
                return header
            }
            
            let newHeader = MEStretchyHeader()
            newHeader.scrollView = self
            self.stretchyHeader = newHeader
            return newHeader
        }
        
        set {
            objc_setAssociatedObject(self, &MEAssociatedObject.key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

// MARK: Object manager
class MEStretchyHeader: NSObject {
    var minimumHeight: CGFloat = 0.0
    weak var delegate: MEStretchyHeaderDelegate?
    weak var view: UIView? {
        didSet {
            guard let _ = scrollView else {
                fatalError("init scrollview first")
            }
            
            if let container = self.containerHeaderView {
                container.removeFromSuperview()
                self.containerHeaderView = nil
                self.scrollView?.removeObserver(self, forKeyPath: "contentOffset")
            }
            
            guard let v = view else {
                return
            }
            
            self.scrollView?.contentInset = UIEdgeInsets(top: v.frame.height, left: 0.0, bottom: 0.0, right: 0.0)
            let container = MEHeaderContainerView(view: v)
            container.frame = CGRect(x: 0.0, y: -v.frame.height, width: v.frame.width, height: v.frame.height)
            self.scrollView?.addSubview(container)
            self.containerHeaderView = container
            self.scrollView?.addObserver(self, forKeyPath: "contentOffset", options: .new, context: &MEStretchyHeader.observerContext)
        }
    }
    
    /// Dealloc
    deinit {
        self.containerHeaderView = nil
    }
    
    // MARK: KVO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let _ = context, let _ = self.scrollView else {
            return
        }
        
        if keyPath == "contentOffset" {
            self.updateHeaderFrame()
        }
    }
    
    // MARK: Private
    private static var observerContext = 0
    fileprivate(set) weak var scrollView: UIScrollView?
    fileprivate weak var containerHeaderView: MEHeaderContainerView?
    
    private func updateHeaderFrame() {
        guard let scrollView = self.scrollView, let container = self.containerHeaderView else {
            return
        }
        
        let minimumHeight = min(self.minimumHeight,scrollView.contentInset.top)
        let relativeYOffset = scrollView.contentOffset.y
        let relativeHeight = -relativeYOffset
        print("ofset \(relativeYOffset)")
        let frame = CGRect(
            x: 0,
            y: relativeYOffset,
            width: scrollView.frame.size.width,
            height: max(relativeHeight, minimumHeight)
        )
        
        self.delegate?.willHeaderUpdateFrame(rec: frame)
        
        container.frame = frame
        
        self.delegate?.didHeaderUpdateFrame(rec: frame)
    }
}

// MARK: Object manager delegate
protocol MEStretchyHeaderDelegate: class {
    func willHeaderUpdateFrame(rec: CGRect)
    func didHeaderUpdateFrame(rec: CGRect)
}

// MARK: Header container
private class MEHeaderContainerView: UIView {
    override init(frame: CGRect) {
        fatalError()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    fileprivate var headerView: UIView
    init(view: UIView) {
        // assign properties
        self.headerView = view
        
        //
        super.init( frame: CGRect( x: 0.0,
                                   y: 0.0,
                                   width: view.frame.width,
                                   height: view.frame.height))
        self.commonInit()
    }
}

private extension MEHeaderContainerView {
    func commonInit() {
        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.headerView)
        
        self.headerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.headerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.headerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.headerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    }
}

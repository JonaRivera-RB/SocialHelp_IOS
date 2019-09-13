

import UIKit

protocol ScrollViewControllerDelegate  {
    var viewControllers: [UIViewController?] { get }
    var inicialviewController: UIViewController { get }
    
    func scrollViewDidScroll()
}

class ScrollViewController: UIViewController {
    
    var scrollView: UIScrollView {
        return view as! UIScrollView
    }
    
    var pageSize: CGSize {
        return scrollView.frame.size
    }
    var viewControllers: [UIViewController?]!
    var delegate:ScrollViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        
        view = scrollView
        view.backgroundColor = .clear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewControllers = delegate?.viewControllers
        for (index, controller) in viewControllers.enumerated() {
            if let controller = controller {
                addChild(controller)
                controller.view.frame = frame(for: index)
                scrollView.addSubview(controller.view)
                controller.didMove(toParent: self)
            }
        }
        
        scrollView.contentSize = CGSize(width: pageSize.width * CGFloat(viewControllers.count), height: pageSize.height)
        if let controller = delegate?.inicialviewController {
            configurarController(to: controller, animacion: false)
        }
    }
    
    public func setController(to controller: UIViewController, animated: Bool) {
        guard let index = indexFor(controller: controller) else { return }
        
        let contentOffset = CGPoint(x: pageSize.width * CGFloat(index), y: 0)
        
        if animated {
            UIView.animate(withDuration: 0.2, delay: 0, options: [UIView.AnimationOptions.curveEaseOut], animations: {
                self.scrollView.setContentOffset(contentOffset, animated: false)
            })
        } else {
            scrollView.setContentOffset(contentOffset, animated: animated)
        }
    }
    
    public func estaVisibleController(_ controller:UIViewController?) -> Bool {
        guard controller != nil else { return false }
        for i in 0..<viewControllers.count {
            if viewControllers[i] == controller {
                let controllerFrame = frame(for: i)
                return controllerFrame.intersects(scrollView.bounds)
            }
        }
        return false
    }
}

fileprivate extension ScrollViewController {
    
    func frame(for index: Int) -> CGRect {
        return CGRect(x: CGFloat(index) * pageSize.width,
                      y: 0,
                      width: pageSize.width,
                      height: pageSize.height)
    }
    
    func indexFor(controller: UIViewController?) -> Int? {
        return viewControllers.firstIndex(where: {$0 == controller } )
    }
    
}

extension ScrollViewController {
    public func configurarController(to controller:UIViewController, animacion: Bool) {
        guard let index = indexFor(controller: controller) else { return }
        
        let contentOffSet = CGPoint(x: pageSize.width * CGFloat(index), y: 0)
        scrollView.setContentOffset(contentOffSet, animated: animacion)
        
        if animacion {
            UIView.animate(withDuration: 0.2, delay: 0, options: [UIView.AnimationOptions.curveEaseOut], animations: {
                self.scrollView.setContentOffset(contentOffSet, animated: false)
            })
        } else {
            scrollView.setContentOffset(contentOffSet, animated: animacion)
        }
    }
}

extension ScrollViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidScroll()
    }
}

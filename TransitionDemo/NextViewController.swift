//
//  NextViewController.swift
//  TransitionDemo
//
//  Created by mr.zhou on 2020/11/12.
//

import UIKit

class NextViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let tableView = MyTableView()
    
    var percent: UIPercentDrivenInteractiveTransition?
    var dele: TransitionDelegate?
    
    var lastPosition: CGFloat = 0
    
    var begin: Bool = false
    var startTrans: CGFloat = 0
    
    var panges: UIPanGestureRecognizer!
    
    var isDragging: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        dele = self.transitioningDelegate as? TransitionDelegate
        
        panges = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        tableView.frame = view.bounds
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.addGestureRecognizer(panges!)
        tableView.panGestureRecognizer.delegate = tableView
        view.addSubview(tableView)
    }
    
    @objc
    func handlePan(_ pan: UIPanGestureRecognizer) {
        let transition = pan.translation(in: view).y
        let progress = transition/view.bounds.height
        switch pan.state {
        case .began:
            break
        case .changed:
            if begin {
                let trans = transition - startTrans
                let progres = trans / view.bounds.height
                percent?.update(progres)
            }
            break
        default:
            let trans = transition - startTrans
            let progres = trans / view.bounds.height
            if progres > 0.5 {
                percent?.finish()
            } else {
                
                lastPosition = 0
                begin = false
                startTrans = 0
                isDragging = false
                percent?.cancel()
            }
            break
            
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "111111"
        cell.backgroundColor = .yellow
        return cell
    }
    
    func record() {
        startTrans = panges.translation(in: tableView).y
        dismiss(animated: true, completion: nil)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.panGestureRecognizer.velocity(in: scrollView).y != 0 {
            if begin == true {
                scrollView.contentOffset = CGPoint(x: 0, y: 0)
                return
            }
            if lastPosition > scrollView.contentOffset.y {
                // 开始
                if scrollView.contentOffset.y <= 0 {
                    begin = true
                    record()
                }
            }
        }
        lastPosition = scrollView.contentOffset.y
    }
}

class MyTableView: UITableView, UIGestureRecognizerDelegate {
    var similataneourly: Bool = false
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

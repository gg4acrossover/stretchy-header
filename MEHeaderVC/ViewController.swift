//
//  ViewController.swift
//  MEHeaderVC
//
//  Created by viethq on 4/17/18.
//  Copyright © 2018 viethq. All rights reserved.
//

import UIKit

let kHeaderTag: Int = 100
let kTitleTag: Int = 200

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let defaultRect = CGRect(x:0.0,y:64.0,width: UIScreen.main.bounds.width, height: 300.0)
    let titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 18.0, weight: .bold)
        lbl.text = "music"
        lbl.sizeToFit()
        lbl.textColor = .white
        return lbl
    }()
    
    let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        return blurEffectView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.styleUI()
    }
}

// MARK: Style UI
private extension ViewController {
    func styleUI() {
        self.styleHeaderView()
        self.styleTableView()
    }
    
    func styleTableView() {
        self.tableView.contentInset = UIEdgeInsets(top: self.tableView.contentInset.top + 200.0, left: 0.0, bottom: 0.0, right: 0.0)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func styleHeaderView() {
        // add image as header view
        let imgView = UIImageView(image: #imageLiteral(resourceName: "headerImage.png"))
        imgView.frame = defaultRect
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        self.view.addSubview(imgView)
        imgView.tag = kHeaderTag
        
        // add blur effect
        imgView.addSubview(blurEffectView)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.topAnchor.constraint(equalTo: imgView.topAnchor).isActive = true
        blurEffectView.bottomAnchor.constraint(equalTo: imgView.bottomAnchor).isActive = true
        blurEffectView.leadingAnchor.constraint(equalTo: imgView.leadingAnchor).isActive = true
        blurEffectView.trailingAnchor.constraint(equalTo: imgView.trailingAnchor).isActive = true
        blurEffectView.alpha = 0.0
        
        // add title to header
        imgView.addSubview(titleLbl)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        titleLbl.centerXAnchor.constraint(equalTo: imgView.centerXAnchor).isActive = true
        titleLbl.centerYAnchor.constraint(equalTo: imgView.centerYAnchor).isActive = true
    }
}

// MARK: Tableview delegate, datasource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if let reusedCell = tableView.dequeueReusableCell(withIdentifier: "cell") {
            cell = reusedCell
        } else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "Chờ yêu thương về ngang đời ta\nChờ nắng lên vội vàng"
        cell.detailTextLabel?.text = "Lạc - Hà Anh Tuấn \(indexPath.row)"
        
        return cell
    }
}

// MARK: ScrollView delegate
extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let headerView = self.view.viewWithTag(kHeaderTag) else {
            return
        }

        let y = -scrollView.contentOffset.y
        let minH: CGFloat = 64.0
        let maxH: CGFloat = 400.0
        let newHeight = min(max(y, minH), maxH)
        headerView.frame = CGRect(x: 0.0, y: defaultRect.minY, width: UIScreen.main.bounds.width, height: newHeight)
        self.blurEffectView.alpha = (maxH - newHeight)/(maxH - minH)
    }
}


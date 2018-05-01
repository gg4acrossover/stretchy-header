//
//  MEHomeVC.swift
//  MEHeaderVC
//
//  Created by viethq on 4/27/18.
//  Copyright © 2018 viethq. All rights reserved.
//

import UIKit

class MEHomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func usingViewOnly(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func usingScrollViewExt(_ sender: Any) {
        let vc = MEStretchyHeaderVC(nibName: nil, bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

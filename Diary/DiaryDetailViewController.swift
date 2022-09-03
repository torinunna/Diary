//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by YUJIN KWON on 2022/08/29.
//

import UIKit

class DiaryDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentsTextview: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
  
    var diary: Diary?
    var indexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func editPressed(_ sender: UIButton) {
    }
    @IBAction func deletePressed(_ sender: UIButton) {
    }
    

}

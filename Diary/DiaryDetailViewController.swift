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
    
    var favoriteButton: UIBarButtonItem?
    
    var diary: Diary?
    var indexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    private func configureView() {
        guard let diary = self.diary else { return }
        self.titleLabel.text = diary.title
        self.contentsTextview.text = diary.contents
        self.dateLabel.text = self.dateToString(date: diary.date)
        self.favoriteButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(favoritePressed))
        self.favoriteButton?.image = diary.isFavorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        self.favoriteButton?.tintColor = .orange
        self.navigationItem.rightBarButtonItem = self.favoriteButton
    }
    
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    @objc func editDiaryNotification(_ notification: Notification) {
        guard let diary = notification.object as? Diary else { return }
        guard let row = notification.userInfo?["indexPath.row"] as? Int else { return }
        self.diary = diary
        self.configureView()
    }
    
    @IBAction func editPressed(_ sender: UIButton) {
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "WriteDiaryViewController") as? WriteDiaryViewController else { return }
        guard let indexPath = self.indexPath else { return }
        guard let diary = self.diary else { return }
        viewController.diaryEditorMode = .edit(indexPath, diary)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(editDiaryNotification(_:)),
            name: NSNotification.Name("editDiary"),
            object: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func deletePressed(_ sender: UIButton) {
        guard let indexPath = self.indexPath else { return }
        NotificationCenter.default.post(
            name: NSNotification.Name("deleteDiary"),
            object: indexPath,
            userInfo: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func favoritePressed() {
        guard let isFavorite = self.diary?.isFavorite else { return }
        guard let indexPath = self.indexPath else { return }
        if isFavorite {
            self.favoriteButton?.image = UIImage(systemName: "star")
        } else {
            self.favoriteButton?.image = UIImage(systemName: "star.fill")
        }
        self.diary?.isFavorite = !isFavorite
        NotificationCenter.default.post(
            name: NSNotification.Name("favoriteDiary"),
            object: [
                "diary": self.diary,
                "isFavorite": self.diary?.isFavorite ?? false,
                "indexPath": indexPath
            ],
            userInfo: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

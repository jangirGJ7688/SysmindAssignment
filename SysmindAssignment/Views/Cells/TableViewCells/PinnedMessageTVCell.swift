//
//  PinnedMessageTVCell.swift
//  SysmindAssignment
//
//  Created by Ganpat Jangir on 02/05/25.
//

import UIKit

class PinnedMessageTVCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var pinnedMessages: [Message] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "PinnedMessageCVCell", bundle: nil), forCellWithReuseIdentifier: "PinnedMessageCVCell")
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 10
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(pinnedMessages: [Message]) {
        self.pinnedMessages = pinnedMessages
        self.collectionView.reloadData()
    }
    
}

extension PinnedMessageTVCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pinnedMessages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PinnedMessageCVCell", for: indexPath) as? PinnedMessageCVCell else {
            return UICollectionViewCell()
        }
        cell.configureCell(msg: self.pinnedMessages[indexPath.row].content)
        return cell
    }
    
    
}

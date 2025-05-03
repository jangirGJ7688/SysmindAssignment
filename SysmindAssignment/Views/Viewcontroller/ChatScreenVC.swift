//
//  ChatScreenVC.swift
//  SysmindAssignment
//
//  Created by Ganpat Jangir on 01/05/25.
//

import UIKit
import Combine

class ChatScreenVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = ChatViewModel()
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "MessageTVCell", bundle: nil), forCellReuseIdentifier: "MessageTVCell")
        self.tableView.register(UINib(nibName: "OtherUserMessageTVCell", bundle: nil), forCellReuseIdentifier: "OtherUserMessageTVCell")
        self.tableView.register(UINib(nibName: "PinnedMessageTVCell", bundle: nil), forCellReuseIdentifier: "PinnedMessageTVCell")
        // Do any additional setup after loading the view.
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        tableView.addGestureRecognizer(longPress)
        
        viewModel.$messages
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in self?.tableView.reloadData() }
            .store(in: &cancellables)
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state != .began { return }
        
        let touchPoint = gestureRecognizer.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: touchPoint) {
            print("Long press at row \(indexPath.row)")
            let message = viewModel.messages[indexPath.item]
            viewModel.togglePin(for: message)
        }
    }

}

extension ChatScreenVC: UITableViewDelegate ,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return self.viewModel.pinnedMessages.isEmpty ? 0.0 : 50.0
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PinnedMessageTVCell", for: indexPath) as? PinnedMessageTVCell else {
                return UITableViewCell()
            }
            cell.configureCell(pinnedMessages: self.viewModel.pinnedMessages)
            cell.selectionStyle = .none
            return cell
        }
        if indexPath.row % 2 == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "OtherUserMessageTVCell", for: indexPath) as? OtherUserMessageTVCell else {
                return UITableViewCell()
            }
            cell.configureCell(message: self.viewModel.messages[indexPath.row].content)
            cell.selectionStyle = .none
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTVCell", for: indexPath) as? MessageTVCell else {
            return UITableViewCell()
        }
        cell.configureCell(message: self.viewModel.messages[indexPath.row].content)
        cell.selectionStyle = .none
        return cell
    }
}

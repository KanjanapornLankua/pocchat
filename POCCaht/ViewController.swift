//
//  ViewController.swift
//  POCChat
//
//  Created by KANJANAPORN LANKUA on 13/5/2564 BE.
//

import UIKit
import FirebaseFirestore

class ViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var textView: UITextView!
  lazy var fireStore: FireStore = FireStore.shared
  var arrayMessage: [Chat] = []
  
  @IBAction func getText () {
    if !textView.text.isEmpty {
      fireStore.sendMessage(text: textView.text) {[weak self] result in
        switch result {
        case .success(let dataArray):
          self?.arrayMessage = dataArray.chat
          self?.tableView.reloadData()
          self?.scrollToBottom()
        default:
          print("error")
        }
      }
      textView.text = ""
    }
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    getMessage()
    setTableView()
  }
  
  func setTableView() {
    tableView.rowHeight = UITableView.automaticDimension
  }
  
  func getMessage() {
    fireStore.subscribe() { [weak self] result in
      switch result {
      case .success(let dataArray):
        self?.arrayMessage = dataArray.chat
        self?.tableView.reloadData()
        self?.scrollToBottom()
      default:
        print("error")
      }
    }
  }
  
  func scrollToBottom()  {
    DispatchQueue.main.async {
      let indexPath = IndexPath(row: self.arrayMessage.count-1, section: 0)
      self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
  }
}

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return arrayMessage.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
    let chat = arrayMessage[indexPath.row]
    cell.setupView(chatView: chat)
    return cell
  }
}

extension ViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

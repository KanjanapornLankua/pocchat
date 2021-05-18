//
//  ChatCell.swift
//  POCChat
//
//  Created by KANJANAPORN LANKUA on 14/5/2564 BE.
//

import UIKit

class ChatCell: UITableViewCell {
  @IBOutlet weak var labelRecieve: UILabel!
  @IBOutlet weak var labelSender: UILabel!
  @IBOutlet weak var viewChatSender: UIView!
  @IBOutlet weak var viewChatReceive: UIView!
  
  func setupView(chatView: Chat) {
    if !chatView.text.isEmpty {
      if chatView.sendBy == "ball" {
        displayRecieve(text: chatView.text)
      } else if chatView.sendBy == "bam" {
        displaySender(text: chatView.text)
      }
      
      viewChatReceive.layer.cornerRadius = 5
      viewChatSender.layer.cornerRadius = 5
    }
  }
  
  func displaySender(text: String) {
    labelSender.text = text
    labelSender.isHidden = false
    viewChatSender.isHidden = false
    viewChatReceive.isHidden = true
    labelRecieve.isHidden = true
  }
  
  func displayRecieve(text: String) {
    labelRecieve.text = text
    labelRecieve.isHidden = false
    viewChatReceive.isHidden = false
    viewChatSender.isHidden = true
    labelSender.isHidden = true
  }
}

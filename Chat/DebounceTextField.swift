//
//  DebounceTextField.swift
//  Chat
//
//  Created by Kang Seongchan on 2021/03/23.
//

import Foundation
import UIKit

final class DebounceTextField: UITextField {

    deinit {
        self.removeTarget(self, action: #selector(self.editingChanged), for: .editingChanged)
    }

    private var workItem: DispatchWorkItem?
    private var delay: Double = 0
    private var callback: ((String?) -> Void)? = nil

    func debounce(delay: Double, callback: @escaping ((String?) -> Void)) {
        self.delay = delay
        self.callback = callback
        DispatchQueue.main.async {
            self.callback?(self.text)
        }
        self.addTarget(self, action: #selector(self.editingChanged), for: .editingChanged)
    }

    @objc private func editingChanged(_ sender: UITextField) {
      self.workItem?.cancel()
      let workItem = DispatchWorkItem(block: { [weak self] in
          self?.callback?(sender.text)
      })
      self.workItem = workItem
      DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: workItem)
    }
}


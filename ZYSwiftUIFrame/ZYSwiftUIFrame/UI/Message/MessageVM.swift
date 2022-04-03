//
//  MessageVM.swift
//  ZYSwiftUIFrame
//
//  Created by lzy on 2022/3/31.
//

import Foundation

class MessageVM: CommonVM<Message> {
    init() {
        super.init(item: Message(), apiObj: MessageAPIObj(moduleUrl: "message"))
    }
}

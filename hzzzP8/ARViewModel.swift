//
//  ARViewModel.swift
//  hzzzP8
//
//  Created by Zheng Hwang on 2023/5/16.
//

import SwiftUI

struct ARContentModel
{
    var id = UUID()
    var text : String
}


class ARViewModel: ObservableObject
{
    @Published var arDisplayString = "(None)"
    @Published var arDisplayEmoji = ""
    @Published var arDisplayOCRText = ""
    @Published var arDisplayResText = ""
    @Published var isEdited = 0
    @Published var arDisplayImage : UIImage? = nil
}




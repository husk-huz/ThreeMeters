//
//  GlobalValues.swift
//  hzzzP8
//
//  Created by Zheng Hwang on 2023/5/17.
//

import Foundation
import SwiftUI

var appConfig = ["" : ""]

var nameDict = HzzzJSON.JsonStartFromOrigin(filename: "zh.json")

var configDict = ["" : ""]

var good_listener : PeerListener? = nil

var globalConnecter : Connecter? = nil

var globalHostControl : HostControl? = nil

var sharedConnection: PeerConnection?

var sharedBrowser: PeerBrowser?

var bonjourListener: PeerListener?

var applicationServiceListener: PeerListener?


var globalARViewModel = ARViewModel()

var globalUIViewModel = GlobalUIViewModel()

var globalURL = ""

var globalThreeMeterUIModel = ThreeMeterUIModel()

var av = ARViewController()


class GlobalUIViewModel : ObservableObject
{
    @Published var isShowingThreeMeterARView = false
    
    @Published var isShowingUserConfigView = false
    
    @Published var isShowingLanguageView = false
    
    @Published var isIntoThreeMeterView = true
}


















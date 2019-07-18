//
//  SpeechDelegate.swift
//  SmartFriend
//
//  Created by iMac on 7/18/19.
//  Copyright © 2019 tung hoang. All rights reserved.
//

import Foundation
import Speech
import AVFoundation
@objc protocol SpeechDelegate {
    func onStart()
    
    @objc optional func onAllTranscriptions(transcriptions: [SFTranscription]);
    func onResults(results: String, isFinal: Bool);
    
    func onError(error: NSError);
    
    func onPartialResults(partialResults: String);
    func onStop();
}

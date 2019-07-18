//
//  SpeechService.swift
//  SmartFriend
//
//  Created by iMac on 7/18/19.
//  Copyright © 2019 tung hoang. All rights reserved.
//

import Foundation
import AVFoundation
import Speech
class SpeechService : NSObject{
    static let shared = SpeechService();
    var recognitionTask: SFSpeechRecognitionTask?
    var audioEngine: AVAudioEngine?;
    var detectionTimer: Timer?;
    var request: SFSpeechAudioBufferRecognitionRequest?;
    var lastResult: String = "";
    var delegate: SpeechDelegate?;
    private override init(){
        super.init();
        audioEngine = AVAudioEngine()
        request = SFSpeechAudioBufferRecognitionRequest()
        let node = audioEngine?.inputNode;
        let recordingFormat = node?.outputFormat(forBus: 0)
        node!.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat, block: { buffer, _  in
            self.request!.append(buffer);
        })
        audioEngine?.prepare();
        
    }
    func start(_ delegate: SpeechDelegate? = nil){
        self.delegate = delegate;
        
        do {
           
            try audioEngine?.start()
             delegate?.onStart();
        } catch {
            print(error);
              delegate?.onError(error: NSError(domain: "com.iotapplication.SmartFriend", code: 1, userInfo: [ "message": error ]))
        }
        guard let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US")) else {
             delegate?.onError(error: NSError(domain: "com.iotapplication.SmartFriend", code: 1, userInfo: [ "message": "Speech recognize not initizale"]))
            return
        }
        if !speechRecognizer.isAvailable {
            delegate?.onError(error: NSError(domain: "com.iotapplication.SmartFriend", code: 1, userInfo: [ "message": "Speech is not available"]))
        }
        
        
        self.recognitionTask = speechRecognizer.recognitionTask(with: request!, resultHandler: { result, error in
            var isFinal = false;
            if let result = result {
                self.lastResult = result.bestTranscription.formattedString;
                
                delegate?.onAllTranscriptions?(transcriptions: result.transcriptions);
                delegate?.onPartialResults(partialResults: self.lastResult);
                isFinal = result.isFinal
                
            }
            if isFinal {
                
                self.detectionTimer?.invalidate()
                delegate?.onResults(results: self.lastResult, isFinal: true);
            }
            else if error == nil {
                self.detectionTimer?.invalidate();
                self.detectionTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: {(timer) in
                    isFinal = true;
                    delegate?.onResults(results: self.lastResult, isFinal: true);
                })
            }
            else if let error = error {
                delegate?.onError(error: NSError(domain: "com.iotapplication.SmartFriend", code: 1, userInfo: [ "message": error]))
            }
        })
    }
    func stop(){
        self.delegate?.onStop();
        self.audioEngine?.stop();
        self.recognitionTask?.cancel();
        
    }
}

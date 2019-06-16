//
//  ViewController.swift
//  SmartFriend
//
//  Created by tùng hoàng on 5/18/19.
//  Copyright © 2019 tung hoang. All rights reserved.
//

import UIKit
import AVFoundation
import Speech
class ViewController: UIViewController {
    @IBOutlet weak var textRecord: UILabel!
    
    var myUtterance = AVSpeechUtterance(string: "")
    var recognitionTask: SFSpeechRecognitionTask?
    var audioEngine: AVAudioEngine?;
    var request: SFSpeechAudioBufferRecognitionRequest?;
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        // Do any additional setup after loading the view.
      
    }
    @IBAction func speakToText(_ sender: Any) {
        audioEngine = AVAudioEngine()
        request = SFSpeechAudioBufferRecognitionRequest()
        let node = audioEngine?.inputNode;
        let recordingFormat = node?.outputFormat(forBus: 0)
        node!.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat, block: { buffer, _  in
            self.request!.append(buffer);
        })
        audioEngine?.prepare();
        do {
            try audioEngine?.start()
        } catch {
            print(error);
        }
        guard let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US")) else {
            print("speech recognize not initizale");
            return
        }
        if !speechRecognizer.isAvailable {
            print("not available");
        }
 
        
        self.recognitionTask = speechRecognizer.recognitionTask(with: request!, resultHandler: { result, error in
            if let result = result {
                self.textRecord.text = result.bestTranscription.formattedString;
            } else if let error = error {
                print(error);
            }
        })
        
    }
    func recordAndRecognizeSpeech(){
        
        
        
        
        
    }
    @IBAction func textToSpeak(_ sender: Any) {
        self.audioEngine?.stop();
        recognitionTask?.cancel();
        self.textRecord.layoutIfNeeded();
        
        myUtterance = AVSpeechUtterance(string: self.textRecord.text!)
        myUtterance.rate = AVSpeechUtteranceDefaultSpeechRate;
        
        let synth = AVSpeechSynthesizer()
        myUtterance.volume = 1.0;
        synth.speak(myUtterance)
    }
    
    @IBAction func clearText(_ sender: Any) {
        
        recognitionTask?.cancel();
        self.textRecord.text = "";
    }
    
}


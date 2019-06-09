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
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
      
    }
    @IBAction func speakToText(_ sender: Any) {
        
        audioEngine.prepare();
        do {
           try audioEngine.start()
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
        let request = SFSpeechAudioBufferRecognitionRequest()
        let node = audioEngine.inputNode;
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat, block: { buffer, _  in
            request.append(buffer);
        })
        self.recognitionTask = speechRecognizer.recognitionTask(with: request, resultHandler: { result, error in
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
        myUtterance = AVSpeechUtterance(string: textView.text)
        myUtterance.rate = 0.3
        synth.speak(myUtterance)
    }
    

}


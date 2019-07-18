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
        SpeechService.shared.stop();
        SpeechService.shared.start(self);
    }
    @IBAction func textToSpeak(_ sender: Any) {
        self.audioEngine?.stop();
        recognitionTask?.cancel();
        
        
        myUtterance = AVSpeechUtterance(string: self.textRecord.text!)
        myUtterance.rate = AVSpeechUtteranceDefaultSpeechRate;
        
        let synth = AVSpeechSynthesizer()
        myUtterance.volume = 1.0;
        synth.speak(myUtterance)
    }
    
    @IBAction func clearText(_ sender: Any) {
        
        self.textRecord.text = "";
    }
    
}

extension ViewController : SpeechDelegate {
    func onStart() {
        self.textRecord.text = "";
    }
    
    func onResults(results: String, isFinal: Bool) {
        
        self.textRecord.text = results;
        self.textRecord.layoutIfNeeded();
    }
    
    func onError(error: NSError) {
        
    }
    
    func onPartialResults(partialResults: String) {
        self.textRecord.text = partialResults;
        self.textRecord.layoutIfNeeded();
    }
    
    func onStop() {
        
    }
    
    
}

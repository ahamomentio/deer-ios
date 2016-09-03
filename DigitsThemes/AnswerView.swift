//
//  AnswerView.swift
//  Deer
//
//  Created by Jacob Sansbury on 9/3/16.
//  Copyright © 2016 Fabric. All rights reserved.
//

import UIKit
import TwitterKit
import FirebaseDatabase
import Firebase
import TwitterKit
import Speech

class AnswerView: UIViewController, SFSpeechRecognizerDelegate {
    
    @IBOutlet var qTitle: UILabel!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private let speechRecognizer = SFSpeechRecognizer(locale: NSLocale(localeIdentifier: "en-US"))

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.qTitle.text = currentQuestion?.questions
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in  //4
            
            var isButtonEnabled = false
        
            self.speechRecognizer!.delegate = self
            
            switch authStatus {  //5
            case .Authorized:
                isButtonEnabled = true
                
            case .Denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .Restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .NotDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
        }
        
    }
    
    func startRecording() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, withOptions: .NotifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else {
            fatalError("Audio engine has no input node")
        }
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTaskWithRequest(recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                
                print((result?.bestTranscription.formattedString)!)
                FIRDatabase.database().reference().child("/user-answers").child((Twitter.sharedInstance().sessionStore.session()?.userID)!).child(currentSurvey).child(String(currentQNumber)).setValue((result?.bestTranscription.formattedString)!)
                
                
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTapOnBus(0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
            }
        })
        
        let recordingFormat = inputNode.outputFormatForBus(0)
        inputNode.installTapOnBus(0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.appendAudioPCMBuffer(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        print("Say something, I'm listening!")
        
    }
    
    @IBAction func microphoneTapped(sender: AnyObject) {
        if audioEngine.running {
            audioEngine.stop()
            recognitionRequest?.endAudio()
        } else {
            startRecording()
        }
    }
    
}

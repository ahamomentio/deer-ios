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
 
    @IBOutlet weak var qTitle: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var microphoneButton: UIButton!
    private let speechRecognizer = SFSpeechRecognizer(locale: NSLocale(localeIdentifier: "en-US"))
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dbRef: FIRDatabaseReference = FIRDatabase.database().reference().child("/user-answers").child((Twitter.sharedInstance().sessionStore.session()?.userID)!).child(currentSurvey).child(String(currentQNumber))
        
        dbRef.observeSingleEventOfType(.Value) { (snapshot, error) in
            
            if snapshot.value == nil {
                print("No previous answer")
            } else {
                self.textView.text = snapshot.value! as! String
            }
            
        }
        
        qTitle.text = currentQuestion?.questions
        
        microphoneButton.enabled = false  //2
        
        speechRecognizer!.delegate = self  //3
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in  //4
            
            var isButtonEnabled = false
            
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
            
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.microphoneButton.enabled = isButtonEnabled
            }
        }
        
    }
    
    @IBAction func microphoneTapped() {
        if audioEngine.running {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            microphoneButton.enabled = false
            microphoneButton.setTitle("Start Recording", forState: .Normal)
        } else {
            startRecording()
            microphoneButton.setTitle("Stop Recording", forState: .Normal)
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
        
        recognitionTask = speechRecognizer!.recognitionTaskWithRequest(recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                
                self.textView.text = result?.bestTranscription.formattedString
                FIRDatabase.database().reference().child("/user-answers").child((Twitter.sharedInstance().sessionStore.session()?.userID)!).child(currentSurvey).child(String(currentQNumber)).setValue((result?.bestTranscription.formattedString)!)
                
                isFinal = (result?.final)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTapOnBus(0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.microphoneButton.enabled = true
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
        
        textView.text = "Say something, I'm listening!"
        
    }

    
    func speechRecognizer(speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            microphoneButton.enabled = true
        } else {
            microphoneButton.enabled = false
        }
    }
    
}

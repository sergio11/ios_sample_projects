//
//  ViewController.swift
//  ElAdivino
//
//  Created by Sergio Sánchez Sánchez on 08/09/2019.
//  Copyright © 2019 Sergio Sánchez Sánchez. All rights reserved.
//

import UIKit
import AVFoundation
import Speech

class ViewController: UIViewController, SFSpeechRecognizerDelegate {

    @IBOutlet weak var imageViewWizard: UIImageView!
    @IBOutlet weak var userQuestionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var makeAQuestionButton: UIButton!
    
    var thunderSound: AVAudioPlayer?
    
    // Listado con todas las repuestas del mago
    let answersArray = ["Sí", "No", "Puede Ser", "Pregunta otra vez", "No tengo ni idea",
        "Ni lo sueñes", "¿Cómo me preguntas eso?", "No lo recuerdo", "Perdona, me están llamando", "Eres como mi mujer", "Hablas como un tío de izquierdas", "¿Cómo voy a saber eso?"]
    
    var randomAnswerNumber = 0
    var nAnswers = 0
    
    // Speech recognition
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale.init(identifier: "es-ES"))
    var request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    required init?(coder aDecoder: NSCoder) {
        self.nAnswers = answersArray.count
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Inicializamos el sonido para las respuestas del mago
        thunderSound = self.setupAudioPlayer(withFile: "thunder_sound", type: "mp3")
    }


    @IBAction func onAskQuestionClicked(_ sender: UIButton) {
        startQuestion()
    
    }
    
    func startQuestion() {
        // El mago empieza a escuchar
        self.answerLabel.text = "Te estoy escuchando ..."
        self.recordAndRecognizeSpeech()
    }
    
    // Pide al mago que responda a la pregunta
    func answerQuestion(question: String) {
        
        self.userQuestionLabel.text = question
        self.answerLabel.text = "Espera ... lo estoy viendo"
        
        // Obtenemos las respuesta
        let answer = self.answersArray[Int(arc4random_uniform(UInt32(self.nAnswers)))]
        
        self.imageViewWizard.bounceAndShake(onFinished: {
            
            if self.thunderSound?.isPlaying == true {
                self.thunderSound?.stop()
            }
            
            self.thunderSound?.play()
            // Mostramos la respuesta con una animación
            self.answerLabel.shake()
            self.answerLabel.text = answer
        })
    }
    
    // Inicializa un audio
    func setupAudioPlayer(withFile file: String, type: String) -> AVAudioPlayer? {
        let path = Bundle.main.path(forResource: file, ofType: type)
        let url = NSURL.fileURL(withPath: path!)
        return try? AVAudioPlayer(contentsOf: url)
    }

    
    //MARK: - Recognize Speech
    func recordAndRecognizeSpeech() {
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            self.sendAlert(message: "There has been an audio engine error.")
            return print(error)
        }
        guard let myRecognizer = SFSpeechRecognizer() else {
            self.sendAlert(message: "Speech recognition is not supported for your current locale.")
            return
        }
        if !myRecognizer.isAvailable {
            self.sendAlert(message: "Speech recognition is not currently available. Check back at a later time.")
            // Recognizer is not available right now
            return
        }
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if let result = result {
                
                if(result.isFinal) {
                    
                    print("Result from speech recognizer -> \(result.bestTranscription.formattedString)")
                    
                    let questionString = result.bestTranscription.formattedString
                    
                    self.answerQuestion(question: questionString)
                }
                
            } else if let error = error {
                self.sendAlert(message: "There has been a speech recognition error.")
                print(error)
            }
            
            
            self.cancelRecording()
            
            
        })
    }
    
    func cancelRecording() {
        recognitionTask?.finish()
        recognitionTask = nil
        
        // stop audio
        request.endAudio()
        request = SFSpeechAudioBufferRecognitionRequest()
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
    
    //MARK: - Check Authorization Status
    func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                    case .authorized:
                        self.makeAQuestionButton.isEnabled = true
                    case .denied:
                        self.makeAQuestionButton.isEnabled = false
                    case .restricted:
                        self.makeAQuestionButton.isEnabled = false
                    case .notDetermined:
                        self.makeAQuestionButton.isEnabled = false
                    @unknown default:
                        print("Unknown auth status")
                }
            }
        }
    }
    
    //MARK: - Alert
    
    func sendAlert(message: String) {
        let alert = UIAlertController(title: "Speech Recognizer Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        if motion == .motionShake{
            startQuestion()
        }
        
    }

}

// Extensiones para facilitar el uso de las animaciones
extension UIView {
    
    static let BOUNCE_ANIMATION_DURATION = 0.5
    static let SHAKE_ANIMATION_DURATION = 0.4
    
    
    func bounceAndShake(onFinished: @escaping () -> Void) {
        bounce(onFinished: {
            self.shake()
            onFinished()
        })
    }
    
    func bounce(onFinished: @escaping () -> Void) {
        UIView.animate(
            withDuration: UIView.BOUNCE_ANIMATION_DURATION,
            delay: 0,
            options: UIView.AnimationOptions.autoreverse,
            animations: {
                
                self.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                
                self.alpha = 0.5
                
        }) { (completed) in
            
            self.transform = CGAffineTransform.identity
            
            self.alpha = 1.0
            
            onFinished()
        }
    }
    
    func shake() {
        self.transform = CGAffineTransform(translationX: 20, y: 0)
        UIView.animate(withDuration: UIView.SHAKE_ANIMATION_DURATION, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}


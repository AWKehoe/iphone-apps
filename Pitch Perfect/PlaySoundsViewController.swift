//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Anthony Kehoe on 31/05/2015.
//  Copyright (c) 2015 Anthony Kehoe. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var slowAudio: UIButton!
    
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var error: NSError?
        
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: &error)
        audioPlayer?.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSoundFast(sender: UIButton) {
        //Play audio quickly....
            playBackSpeed(2.0)
    }

    @IBAction func playSoundSlowly(sender: UIButton) {
        //Play audio sloooowly here....
            playBackSpeed(0.5)
    }
    
    func playBackSpeed(speed: Float) {
        if let player = audioPlayer {
            audioEngine.stop()
            audioEngine.reset()
            player.stop()
            player.rate = speed
            player.currentTime = 0.0
            player.play()
        }
    }
    @IBAction func stopAudio(sender: UIButton) {
        //Stop the audio player
        if let player = audioPlayer {
            player.stop()
            audioEngine.stop()
            audioEngine.reset()
        }
    }
    
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        var changePitchEffect = AVAudioUnitTimePitch()
        var reverbEffect = AVAudioUnitReverb()
        
        changePitchEffect.pitch = pitch
        reverbEffect.loadFactoryPreset(AVAudioUnitReverbPreset.Cathedral)
        reverbEffect.wetDryMix = 50
        
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(changePitchEffect)
        audioEngine.attachNode(reverbEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: reverbEffect, format: nil)
        audioEngine.connect(reverbEffect, to: audioEngine.outputNode, format: nil)
        
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
        
    }
    
}

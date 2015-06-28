//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Anthony Kehoe on 31/05/2015.
//  Copyright (c) 2015 Anthony Kehoe. All rights reserved.
//

import UIKit
import AVFoundation


/// Class to control playback of sounds using various effects.
///
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
    
    /// Common function missed by the previous udacity reviewer despite his feedback
    /// Anyway is a function to set the rate of playback of the audio player
    func playBackSpeed(speed: Float) {
        stopAll()
        audioPlayer.rate = speed
        audioPlayer.play()

    }
    
    /// Stops the audio player
    @IBAction func stopAudio(sender: UIButton) {
       
        stopAll()
    }
    
    /// Create a chipmunk sound
    /// Sets the pitch to 1000
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    /// Create a Darth Vader sound
    /// Sets the pitch to -1000
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    
    /// Function to set the audioplayer for applying two sounds enhancers
    /// Changing the pitch of the sound and for adjusting the reverb sound.
    /// The pitch set from the only floating point parameter passed.
    /// The reverb is set to the cathedral style
    ///
    func playAudioWithVariablePitch(pitch: Float) {
        // stop the player and engine
        stopAll()
        
        // Setup the node and effects - pitch and reverb.
        var audioPlayerNode = AVAudioPlayerNode()
        var changePitchEffect = AVAudioUnitTimePitch()
        var reverbEffect = AVAudioUnitReverb()
        
        changePitchEffect.pitch = pitch
        reverbEffect.loadFactoryPreset(AVAudioUnitReverbPreset.Cathedral)
        reverbEffect.wetDryMix = 50
        
        // Set the audio engine
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(changePitchEffect)
        audioEngine.attachNode(reverbEffect)
        
        // Connect it all together
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: reverbEffect, format: nil)
        audioEngine.connect(reverbEffect, to: audioEngine.outputNode, format: nil)
        
        // Stuff in the file name and play
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
        
    }
    
    /// Function to abstract the stop and reset functions on the audioplayer and the audioengine.
    /// No parameters
    /// Stops the audioPlayer and sets currentTime parameter to 0.0
    /// Stop and Resets the audioengine
    func stopAll(){
        
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.currentTime = 0.0
    }
    
}

//
//  ViewController.swift
//  White Noise
//
//  Created by 陳佩琪 on 2023/7/23.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    let sounds = ["muyu","bell"]
    let lables = ["木魚","掛鐘"]
    var soundIndex = 0
    var soundUrl = Bundle.main.url(forResource: "muyu", withExtension: "mp3")!
    
    
    @IBOutlet var soundImage: UIImageView!
    @IBOutlet var soundLabel: UILabel!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var volumnSlider: UISlider!
    @IBOutlet var frequencySlider: UISlider!
    
    @IBOutlet var durationSegmentedControl: UISegmentedControl!
    @IBOutlet var countDownTimer: UILabel!
    
    
    var audioPlayer = AVAudioPlayer()
    var playCount = 0
    var totalCount = 1
    var duration = 5.0
    var interval = 3.0
    
    var countDownTimeRemaining = 5.0
    var countDownTimeRemainingInt = 5
    var clickPlayCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        soundUrl = Bundle.main.url(forResource: sounds[soundIndex], withExtension: "mp3")!
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundUrl)
        } catch {
            print("播放音效檔案出現錯誤：\(error)")
        }
        
        
        volumnSlider.value = 1
        volumnSlider.minimumValue = 0
        volumnSlider.maximumValue = 2
        
        frequencySlider.minimumValue = 1
        frequencySlider.maximumValue = 5
        frequencySlider.value = (frequencySlider.minimumValue + frequencySlider.maximumValue) / 2
        frequencySlider.isContinuous = false
        
        durationSegmentedControl.selectedSegmentIndex = 0
    }
    
    
    @IBAction func selectDuration(_ sender: Any) {
        
        switch durationSegmentedControl.selectedSegmentIndex {
        case 0:
            duration = 5
            countDownTimer.text = "00:05"
        case 1:
            duration = 30
            countDownTimer.text = "00:30"
        case 2:
            duration = 60
            countDownTimer.text = "01:00"
        default:
            duration = 300
            countDownTimer.text = "05:00"
        }
        
        countDownTimeRemaining = duration
    }
    
    
    @IBAction func updatePlayMode(_ sender: Any) {
        print("countDownTimeRemaining",countDownTimeRemainingInt)
        
        
        interval = Double(frequencySlider.value)
        //print("frequencySlider",frequencySlider.value)
        
        totalCount = Int(countDownTimeRemaining / interval)
        print("totalCount",totalCount)
        
        countDownTimeRemainingInt = Int(countDownTimeRemaining)
    }

        
    @IBAction func play(_ sender: Any) {
        audioPlayer.play()
        clickPlayCount += 1
        print("clickPlayCount",clickPlayCount)
        
        
        playCount = 0
        print("countDownTimeRemaining",countDownTimeRemaining)
        countDownTimeRemainingInt = Int(countDownTimeRemaining)
        frequencySlider.isEnabled = false
        
        switch clickPlayCount % 2 {
        case 1:
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            
            Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [self] timer in
                
                print("playCount",playCount,"totalCount",totalCount)
                
                if playCount >= totalCount || clickPlayCount % 2 == 0 {
                    timer.invalidate()
                } else {
                    audioPlayer.play()
                    audioPlayer.stop()
                    audioPlayer.currentTime = 0
                    audioPlayer.play()
                    playCount += 1
                    //print("playCount",playCount)
                    
                }
            }
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] timer in
                
                if clickPlayCount % 2 == 0 {
                    timer.invalidate()
                    playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
                    frequencySlider.isEnabled = true
                    
                } else if
                    countDownTimeRemainingInt == 0 {
                    timer.invalidate()
                        clickPlayCount += 1
                    playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
                    frequencySlider.isEnabled = true
                }
                    else {
                    countDownTimeRemainingInt -= 1
                }
                
                let min = String(format: "%02d",    countDownTimeRemainingInt / 60)
                //print("min",min)
                let sec = String(format: "%02d", countDownTimeRemainingInt % 60)
                //print("sec",sec)
                countDownTimer.text = "\(min):\(sec)"
                
            }

        default:
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            
        }
        
    }
    
        @IBAction func adjustVolume(_ sender: Any) {
            audioPlayer.volume = volumnSlider.value
        }
        
        
    fileprivate func updateSound() {
        soundUrl = Bundle.main.url(forResource: sounds[soundIndex], withExtension: "mp3")!
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundUrl)
        } catch {
            print("播放音效檔案出現錯誤：\(error)")
        }
        
        soundImage.image = UIImage(named: sounds[soundIndex])
        soundLabel.text = lables[soundIndex]
    }
    
    @IBAction func next(_ sender: Any) {
            soundIndex = (soundIndex + 1) % sounds.count
        print("index",soundIndex)
            
        updateSound()
            
        }
        
    @IBAction func previous(_ sender: Any) {
        soundIndex = (soundIndex + sounds.count - 1) % sounds.count
        print("index",soundIndex)
        updateSound()
        
    }
    
}


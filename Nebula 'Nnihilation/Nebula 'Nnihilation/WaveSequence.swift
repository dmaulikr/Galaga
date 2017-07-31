//
//  WaveSequence.swift
//  Nebula 'Nnihilation
//
//  Created by Jack Hamilton on 7/26/17.
//  Copyright © 2017 App Camp. All rights reserved.
//

import Foundation

class WaveSequence {
    
    var waves: [TimedWave] = []
    var startingFrame: Int
    var currentFrame: Int
    //Index of the next wave to spawn
    var nextWave = 0
    //When to spawn it
    var framesToNextSpawn = 0
    var totalSequenceFrames = 0
    
    init (waves: [TimedWave], startingFrame: Int) {
        var startingFrame = startingFrame
        for wave in waves {
            wave.wave.startingFrameCount = startingFrame
            totalSequenceFrames += wave.duration
            startingFrame += wave.duration
            self.waves.append(TimedWave(wave: wave.wave, duration: wave.duration))
        }
        self.startingFrame = startingFrame
        currentFrame = startingFrame
    }
    
    //Return waves that start this tick
    func step(frame: Int) -> [Wave] {
        currentFrame = frame
        var retWaves: [Wave] = []
        //Don't do it if it's past the final wave. Otherwise, spawn.
        while (framesToNextSpawn == 0 && nextWave < waves.count) {
            retWaves.append(waves[nextWave].wave)
            framesToNextSpawn = waves[nextWave].duration
            nextWave += 1
        }
        if (nextWave < waves.count || framesToNextSpawn > 0) {
            framesToNextSpawn -= 1
        }
        return retWaves
    }
    
    func isComplete() -> Bool {
        if (nextWave >= waves.count && framesToNextSpawn <= 0) {
            return true
        }
        return false
    }
    
    func addWaves(timedWaves: [TimedWave]) {
        for timedWave in timedWaves {
            timedWave.wave.startingFrameCount = totalSequenceFrames
            totalSequenceFrames += timedWave.duration
            waves.append(TimedWave(wave: timedWave.wave, duration: timedWave.duration))
        }
    }
}

//Duration in frames
class TimedWave {
    let wave: Wave
    let duration: Int
    init(wave: Wave, duration: Int) {
        self.duration = duration
        self.wave = wave
    }
}

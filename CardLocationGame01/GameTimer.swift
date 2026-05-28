//
//  GameTimer.swift
//  CardLocationGame01

//
//  Created by שני שלו on 25/05/2026.


import Foundation

protocol CallBack_GameTimer {
      func timerTick(counter: Int)
      func timerFinished()
  }

  class GameTimer {
      
      var cb: CallBack_GameTimer?
      var timer: Timer?
      var counter = 3

      init(cb: CallBack_GameTimer) {
          self.cb = cb
      }

      func start() {
          stop()
          counter = 3
          cb?.timerTick(counter: counter)
          timer = Timer.scheduledTimer(withTimeInterval: 1,
                   repeats: true, block: secondly(t:))
      }

      func stop() {
          timer?.invalidate()
          timer = nil
      }

      func secondly(t: Timer) {
          counter -= 1
          cb?.timerTick(counter: counter)
          if counter == 0 {
              t.invalidate()
              cb?.timerFinished()
          }
      }
      
      func resume() {
            // continue from current counter without resetting
          stop()
            cb?.timerTick(counter: counter)
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats:
        true, block: secondly(t:))
        }

  }

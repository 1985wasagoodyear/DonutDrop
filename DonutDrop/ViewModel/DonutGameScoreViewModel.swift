//
//  DonutGameScoreViewModel.swift
//  DonutDrop
//
//  Created by mac on 6/19/19.
//

import Foundation

protocol DonutGameUIDelegate: AnyObject {
    func startGame()
    func stopGame()
    func endGame(_ score: Int?)
    func pauseGame()
    func unpauseGame()
    func showError(for index: Int)
    func setupUI()
    func scoreDidChange(_ score: Int)
}

private let DONUT_SCORE_VALUE = DonutConstants.DONUT_SCORE_VALUE

final class DonutGameScoreViewModel {
    
    var score: Int = 0 {
        didSet {
            delegate.scoreDidChange(score)
        }
    }
    
    var errorCount = 0 {
        didSet {
            if errorCount <= 3 {
                delegate.showError(for: errorCount - 1)
            }
            if errorCount >= 3 {
                delegate.endGame(score)
                score = 0
            }
        }
    }
    
    let delegate: DonutGameUIDelegate
    
    var imageService = DonutService()
    
    init(delegate: DonutGameUIDelegate) {
        self.delegate = delegate
    }
    
    func setup() {
        errorCount = 0
        score = 0
        delegate.setupUI()
    }
    
    func start() {
        delegate.startGame()
    }
    
    func pause() {
        delegate.pauseGame()
    }
    
    func unpause() {
        delegate.unpauseGame()
    }
    
    func stop() {
        delegate.endGame(score)
    }
    
    func didScore() {
        score += DONUT_SCORE_VALUE
    }
    
    func didMiss() {
        errorCount += 1
    }
}

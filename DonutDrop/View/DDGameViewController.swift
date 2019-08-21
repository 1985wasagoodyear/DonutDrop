import UIKit

private let DONUT_WIDTH = DonutConstants.DONUT_WIDTH
private let DONUT_VELOCITY = DonutConstants.DONUT_VELOCITY
private let DROP_INTERVAL: TimeInterval = 1.0 / 2.25

typealias DonutView = UIImageView

final class DDGameViewController: UIViewController {

    // MARK: - UI Elements
    
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var faultViews: [UIImageView]!
    
    // MARK: - Properties
    
    var donutsCount = 0
    var donutViews = [(DonutView, TimeInterval)]()
    var shownDonuts = Set<Int>()
    var isPlaying: Bool = false
    var didShowGameStartAlert = false   // one-time flag
    var timer: Timer!                   // donuts are fired on regular intervals
    
    var scoreService: DonutGameScoreViewModel!
    
    // MARK: - UIViewController Lifecycle Methods
    
    override func loadView() {
        super.loadView()
        scoreService = DonutGameScoreViewModel(delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showGameStartAlert()
    }
    
    func setupUI() {
        scoreLabel.text = "0"
        faultViews.forEach { $0.isHidden = true }
        donutViews.forEach { $0.0.removeFromSuperview() }
    }
    
    func makeAndFireDonut() {
        var i = 0
        while shownDonuts.contains(i) == true && i < donutsCount {
            i += 1
        }
        if i >= donutsCount {
            let image = scoreService.randomDonutImage()
            let frame = CGRect(x: -DONUT_WIDTH, y: -DONUT_WIDTH,
                               width: DONUT_WIDTH, height: DONUT_WIDTH)
            let newDonut = DonutView(frame: frame)
            newDonut.image = image
            newDonut.isUserInteractionEnabled = true
            newDonut.tag = donutsCount
            donutsCount += 1
            let timeMultiplier = DONUT_VELOCITY / Int.random(in: 1...5)
            let donut = (newDonut, timeMultiplier)
            donutViews.append(donut)
            fireDonutHelper(donut)
        }
        else {
            var donut = donutViews[i]
            let timeMultiplier = DONUT_VELOCITY / Int.random(in: 1...5)
            donut.1 = timeMultiplier
            donutViews[i] = donut
            fireDonutHelper(donut)
        }
    }
    
    func fireDonutHelper(_ donut: (DonutView, TimeInterval)) {
        shownDonuts.insert(donut.0.tag)
        donut.0.transform = .identity
        // choose initial direction
        let size = view.frame.size
        let w1 = Int.random(in: -Int(DONUT_WIDTH/2)...Int(size.width - DONUT_WIDTH/2))
        let frame = CGRect(x: Double(w1), y: -DONUT_WIDTH,
                           width: DONUT_WIDTH, height: DONUT_WIDTH)
        donut.0.frame = frame
        view.addSubview(donut.0)
        let transform = CGAffineTransform(translationX: 0.0,
                                          y: size.height + DONUT_WIDTH)
        UIView.animate(withDuration: donut.1,
                       delay: .zero,
                       options: .allowUserInteraction, animations: {
                        donut.0.transform = transform
        }) { (completed) in
            if completed == true {
                if self.isPlaying == true {
                    self.removeDonut(donut.0.tag, didScore: false)
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let touchLocation = touch.location(in: self.view)
        
        for id in shownDonuts {
            if donutViews[id].0.layer.presentation()!.frame.contains(touchLocation) {
                removeDonut(id, didScore: true)
            }
        }
    }
    
    func removeDonut(_ id: Int, didScore: Bool) {
        if shownDonuts.contains(id) {
            shownDonuts.remove(id)
            donutViews[id].0.removeFromSuperview()
        }
        if didScore == false {
            scoreService.didMiss()
        }
        else {
            scoreService.didScore()
        }
    }
    
    func stopGame(_ score: Int) {
        let gameStartPrompt: ()->() = {
            self.showAlert(text: "Ready to give another try?!",
                           okAction: self.startGame)
        }
        
        showAlert(text: "Game Over! Final score: \(score)",
                  okAction: gameStartPrompt)
    }
    
    func showGameStartAlert() {
        guard didShowGameStartAlert == false else { return }
        
        let gameStartPrompt: ()->() = {
            self.showAlert(text: "Are you ready?!",
                           okAction: self.startGame)
        }
        
        showAlert(text: "Catch as many donuts as you can!",
                  okAction: gameStartPrompt)
        didShowGameStartAlert = true
    }
    
    func showAlert(text: String,
                   okAction: (()->())? = nil) {
        let alert = UIAlertController(title: text,
                                      message: nil,
                                      preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK",
                               style: .default) { _ in
            okAction?()
        }
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension DDGameViewController: DonutGameUIDelegate {
    
    func startGame() {
        scoreService.setup()
        isPlaying = true
        timer = Timer.scheduledTimer(withTimeInterval: DROP_INTERVAL,
                                     repeats: true,
                                     block: { (timer) in
                                        guard timer.isValid == true else { return }
                                        self.makeAndFireDonut()
        })
    }
    
    func endGame(_ score: Int?) {
        isPlaying = false
        timer.invalidate()
        view.layer.removeAllAnimations()
        donutViews.forEach {
            $0.0.layer.removeAllAnimations()
        }
        shownDonuts.removeAll(keepingCapacity: true)
        stopGame(score ?? 0)
    }
    
    func showError(for index: Int) {
        faultViews[index].isHidden = false
    }
    
    func scoreDidChange(_ score: Int) {
        scoreLabel.text = "\(score)"
    }
    
    func stopGame() {
        print("unimplemented")
    }
    
    func pauseGame() {
        print("unimplemented")
    }
    
    func unpauseGame() {
        print("unimplemented")
    }
}

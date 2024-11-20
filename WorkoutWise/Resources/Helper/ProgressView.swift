import ProgressHUD

class ProgressView {
  static let shared = ProgressView()

  private init() {}

  func showProgressHud(animate: Bool) {
    ProgressHUD.colorProgress = gray
    ProgressHUD.colorBackground = .clear
    ProgressHUD.colorAnimation = gray
    ProgressHUD.colorHUD = red
    ProgressHUD.animationType = .circleStrokeSpin
    if animate {
      ProgressHUD.animate()
    } else {
      ProgressHUD.remove()
    }
  }
}

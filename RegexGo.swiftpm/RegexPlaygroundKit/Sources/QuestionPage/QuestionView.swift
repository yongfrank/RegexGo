//
//  QuestionView.swift
//  
//
//  Created by Chu Yong on 4/20/23.
//

import SwiftUI
import AVKit

struct VideoPlayerView: UIViewControllerRepresentable {
    let player: AVPlayer

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.modalPresentationStyle = .fullScreen
        controller.player?.play()
        
        return controller
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {

    }
}

//struct QuestionView: View {
//    @Binding var isShowHelp: Bool
//
//    var body: some View {
//        VideoPlayer(player: AVPlayer(url:  Bundle.main.url(forResource: "help", withExtension: "mp4")!)) {
//            if #available(iOS 16.0, *) {
//                VStack {
//                    HStack {
//                        Button {
//                            isShowHelp = false
//                        } label: {
//                            Image(systemName: "xmark")
//                                .resizable()
//                                .renderingMode(.template)
//                                .frame(width: 15, height: 15)
//                                .foregroundColor(.white)
//                        }
//                        .padding()
//                        
//                        Spacer()
//                    }
//                    
//                    Spacer()
//                }
//            }
//        }
//    }
//}

//struct QuestionView_Previews: PreviewProvider {
//    static var previews: some View {
//        QuestionView()
//    }
//}

// MARK: - Function of check is new version

func getCurrentAppVersion() -> String {
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
    let version = (appVersion as! String)
    
    return version
}

func checkForUpdate() -> Bool {
    let version = getCurrentAppVersion()
    let savedVersion = UserDefaults.standard.string(forKey: "savedVersion")
    
    if savedVersion == version {
//        print("App is up to date!")
        return false
//        return true
    } else {
        UserDefaults.standard.set(version, forKey: "savedVersion")
        return true
    }
}

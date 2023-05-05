//
//  MailView.swift
//  UniversityHousing
//
//  Created by Saikiran Reddy Doddeni on 5/4/23.
//

import Foundation
import MessageUI
import UIKit
import SwiftUI

struct MailView : UIViewControllerRepresentable {
    @Binding var isShowing: Bool
        var recipients: [String]
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
            let mailComposeVC = MFMailComposeViewController()
            mailComposeVC.setToRecipients(recipients)
            mailComposeVC.mailComposeDelegate = context.coordinator
            return mailComposeVC
        }
        
        func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<MailView>) {
            // No need to update anything
        }
        
        func makeCoordinator() -> Coordinator {
            Coordinator(isShowing: $isShowing)
        }
}
class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var isShowing: Bool
        
        init(isShowing: Binding<Bool>) {
            _isShowing = isShowing
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            isShowing = false
        }
    }

//
//  DismissGuardian.swift
//  DailyRewards
//
//  Created by Joao Gabriel Pereira on 18/02/20.
//  Copyright © 2020 Joao Gabriel Medeiros Perei. All rights reserved.
//

import SwiftUI

struct DismissGuardian<Content: View>: UIViewControllerRepresentable {
    @Binding var preventDismissal: Bool
    @Binding var didUpdated: Bool
    @Binding var isPresented: Bool
    var contentView: Content
    
    init(preventDismissal: Binding<Bool>, didUpdated: Binding<Bool>, isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) {
        self.contentView = content()
        self._preventDismissal = preventDismissal
        self._didUpdated = didUpdated
        self._isPresented = isPresented
    }
        
    func makeUIViewController(context: UIViewControllerRepresentableContext<DismissGuardian>) -> UIViewController {
        return DismissGuardianUIHostingController(rootView: contentView, preventDismissal: preventDismissal)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<DismissGuardian>) {
        (uiViewController as! DismissGuardianUIHostingController).rootView = contentView
        (uiViewController as! DismissGuardianUIHostingController<Content>).preventDismissal = preventDismissal
        (uiViewController as! DismissGuardianUIHostingController<Content>).dismissGuardianDelegate = context.coordinator
    }
    
    func makeCoordinator() -> DismissGuardian<Content>.Coordinator {
        return Coordinator(didUpdated: $didUpdated, isPresented: $isPresented)
    }
    
    class Coordinator: NSObject, DismissGuardianDelegate {
        @Binding var didUpdated: Bool
        @Binding var isPresented: Bool
        
        init(didUpdated: Binding<Bool>, isPresented: Binding<Bool>) {
            self._didUpdated = didUpdated
            self._isPresented = isPresented
        }
        
        func isPresented(flag: Bool) {
            self.isPresented = flag
        }
    
        func didUpdate(flag: Bool) {
            self.didUpdated = flag
        }
    }
}

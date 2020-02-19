//
//  MyView.swift
//  DailyRewards
//
//  Created by Joao Gabriel Pereira on 18/02/20.
//  Copyright © 2020 Joao Gabriel Medeiros Perei. All rights reserved.
//

import Foundation
import SwiftUI
struct MyView: View {
    @State private var modal1 = false
    @State private var modal2 = false
    @ObservedObject var model = MyModel()
    
    var body: some View {
        DismissGuardian(preventDismissal: $model.preventDismissal, didUpdated: $model.didUpdate, isPresented: $model.isPresented) {
            VStack {
                Text("Dismiss Guardian").font(.title)

                Button("Modal Without Feedback") {
                    self.modal1 = true
                }.padding(20)
                .sheet(isPresented: self.$modal1, content: { MyModal().environmentObject(self.model) })

                Button("Modal With Feedback") {
                    self.modal2 = true
                }
                .sheet(isPresented: self.$modal2, content: { MyModalWithFeedback().environmentObject(self.model) })
            }
        }
    }
}

struct MyModal: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var model: MyModel

    var body: some View {
        NavigationView {
            Form {
                TextField("First name", text: $model.firstname)
                TextField("Last name", text: $model.lastname)
            }
            .navigationBarTitle("Form (without feedback)", displayMode: .inline)
            .navigationBarItems(trailing:
                Button("Save") {
                    self.model.save()
                    self.presentationMode.wrappedValue.dismiss() }
            )
        }
        .environment(\.horizontalSizeClass, .compact)
    }
}

struct MyModalWithFeedback: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var model: MyModel

    var body: some View {
        NavigationView {
            Form {
                TextField("First name", text: $model.firstname)
                TextField("Last name", text: $model.lastname)
            }
            .alert(isPresented: self.$model.isPresented) {
                Alert(title: Text("Unsaved Changes"),
                      message: Text("You have made changes to the form that have not been saved. If you continue, those changes will be lost."),
                      primaryButton: .destructive(Text("Delete Changes"), action: {
                        self.model.resetForm()
                        self.presentationMode.wrappedValue.dismiss()
                      }),
                      secondaryButton: .cancel(Text("Continue Editing")))
            }
            .navigationBarTitle("Form (with feedback)", displayMode: .inline)
            .navigationBarItems(trailing:
                Button("Save") {
                    self.model.save()
                    self.presentationMode.wrappedValue.dismiss() }
            )
        }
        .environment(\.horizontalSizeClass, .compact)
    }
}

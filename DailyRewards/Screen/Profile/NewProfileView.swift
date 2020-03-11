//
//  SUIJEWNPSView.swift
//  DailyRewards
//
//  Created by Joao Gabriel Pereira on 20/01/20.
//  Copyright © 2020 Joao Gabriel Medeiros Perei. All rights reserved.
//

import SwiftUI
import JewFeatures

enum TypeSelected {
    case authentication
    case notification
    case vote
    case undefined
}

struct NewProfileView: View {
    //MARK: Models
    let npsValues: [NPS] = [NPS(id: 1),NPS(id: 2),NPS(id: 3),NPS(id: 4),NPS(id: 5),NPS(id: 6),NPS(id: 7),NPS(id: 8),NPS(id: 9),NPS(id: 10)]
    @State var cellsSelected = [false,false,false,false,false,false,false,false,false,false]
    //MARK: GridView Constants
    @State var columns: CGFloat = 7.0
    @State var vSpacing: CGFloat = 8.0
    @State var hSpacing: CGFloat = 8.0
    @State var vPadding: CGFloat = 8.0
    @State var vStackPadding: CGFloat = 8.0
    @State var hPadding: CGFloat = 8.0
    //MARK: GridView Properties
    @State var transition = AnyTransition.moveUpWardsWhileFadingIn
    @State var shouldDelay = true
    @State var alignmentCenter = true
    //MARK:  Navigation View
    @State private var rightNavigationItemImage = Image(systemName: "arrow.right.square")
    @State private var leftNavigationItemImage = Image(systemName: "xmark")
    //MARK: Booleans Properties
    @State var switchTouchID = JEWKeyChainWrapper.retrieveBool(withKey: JEWConstants.LoginKeyChainConstants.hasEnableBiometricAuthentication.rawValue) ?? false
    @State var switchNotification = false
    @State private var showSheet = false
    @State private var typeSelected = TypeSelected.undefined
    @Binding var isPresented: Bool
    //MARK: Controller
    @State var controller: NewProfileViewController?
    @EnvironmentObject var model: MyModel
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ZStack {
                    Color(UIColor.JEWBackground())
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        HStack(alignment: .center, spacing: 8) {
                            Image(uiImage: JEWSession.session.user?.photoImage ?? UIImage())
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .background(Color.clear)
                                .foregroundColor(.white)
                                .frame(height:80).clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 3))
                            VStack(alignment: .center, spacing: 8) {
                                Text(JEWSession.session.user?.email ?? "")
                                Text(JEWSession.session.user?.fullName ?? "")
                            }.foregroundColor(Color.white)
                        }.frame(width: geometry.size.width, height: 100).background(Color(.JEWDefault()))
                        VStack(alignment: .trailing, spacing: 8) {
                            Toggle("", isOn: self.$switchTouchID)
                                .toggleStyle(
                                    SUICustomizedToggleStyle(label: "Habilitar Touch ID",
                                                             onColor: Color(.JEWDefault()),
                                                             offColor: .secondary,
                                                             thumbColor: .white, isSelected: { (isSelected) in
                                                                self.controller?.interactor?.biometric(isOn: isSelected)
                                    }))
                            Toggle("", isOn: self.$switchNotification)
                                .toggleStyle(
                                    SUICustomizedToggleStyle(label: "Habilitar Notificação",
                                                             onColor: Color(.JEWDefault()),
                                                             offColor: .secondary,
                                                             thumbColor: .white, isSelected: { (isSelected) in
                                                                self.showSheet = isSelected
                                                                self.typeSelected = .notification
                                    }))
                        }.foregroundColor(.white).frame(width: geometry.size.width * 0.95, alignment: .trailing)
                        self.gridView(geometry)
                    }
                }
                .navigationBarTitle(Text("Profile").foregroundColor(.white))
                .navigationBarItems(leading: self.setupLeftNavigationItem(), trailing: self.setupRightNavigationItem()).foregroundColor(Color.white)
                
            }.onAppear{
                self.controller = NewProfileViewController(withDelegate: self)
            }.actionSheet(isPresented: self.$showSheet) {
                self.presentActionSheet()
            }.onDisappear {
                self.showSheet = false
            }
        }
    }
    
    private func gridView(_ geometry: GeometryProxy) -> some View {
        GridView<[NPS], GridNPSCell>(data: npsValues,
                                     columns: Int(self.columns),
                                     columnsInLandscape: Int(self.columns),
                                     vSpacing: 8,
                                     hSpacing: 0,
                                     vPadding: 0,
                                     vStackPadding: 8,
                                     hPadding: 8,
                                     shouldDelay: shouldDelay,
                                     transition: $transition, alignmentCenter: $alignmentCenter) {
                                        return self.setupCell(cellNPS: $0)
        }
    }
    
    func setupCell(cellNPS: NPS) -> GridNPSCell {
        let index = cellNPS.id - 1
        let cell = GridNPSCell(value: cellNPS, isSelected: self.$cellsSelected[index])
        cell.cellCallback.didTap = { selectedIndex, isSelected in
            self.controller?.interactor?.vote(index: selectedIndex)
        }
        return cell
    }
    
    func setupRightNavigationItem() -> NavigationImageItem {
        
        let rightNavigationItem = NavigationImageItem(image: $rightNavigationItemImage)
        rightNavigationItem.callback.didTap = {
            self.controller?.interactor?.signOut()
        }
        return rightNavigationItem
    }
    
    func setupLeftNavigationItem() -> NavigationImageItem {
       let leftNavigationItem = NavigationImageItem(image: $leftNavigationItemImage)
        leftNavigationItem.callback.didTap = {
            self.isPresented.toggle()
        }
        return leftNavigationItem
    }
    
    private func presentActionSheet() -> ActionSheet {
        
        
        switch self.typeSelected {
            
        case .authentication:
            return ActionSheet(title: Text(JEWConstants.Default.title.rawValue), message: Text(JEWConstants.EnableBiometricViewController.biometricMessageType()), buttons: [.destructive(Text("Cancelar"), action: {
                self.switchTouchID.toggle()
            }), .default(Text("Confirmar"), action: {
                JEWKeyChainWrapper.saveBool(withValue: true, andKey: JEWConstants.LoginKeyChainConstants.hasEnableBiometricAuthentication.rawValue)
            })])
        case .notification:
            return ActionSheet(title: Text(JEWConstants.Default.title.rawValue), message: Text("TODO: NOTIFICATION"), buttons: [.destructive(Text("Cancelar"), action: {
                self.switchNotification.toggle()
            }), .default(Text("Confirmar"), action: {
            })])
        case .vote:
            return ActionSheet(title: Text(JEWConstants.Default.title.rawValue), message: Text(ProfileConstants.messageAlert.rawValue), buttons: [.destructive(Text("Cancelar"), action: {
                self.deselectAllCells()
                
            }), .default(Text("Confirmar"), action: {
            })])
        case .undefined:
            return ActionSheet(title: Text(""))
        }
    }
    
    func deselectAllCells() {
        for (cellIndex, _) in self.cellsSelected.enumerated() {
            withAnimation {
                    self.cellsSelected[cellIndex] = false
            }
        }
    }
}

extension NewProfileView: NewProfileViewControllerDelegate {
    func displayProfile(image: UIImage) {
        
    }
    
    func displayProfile(email: String) {
        
    }
    
    func displayProfile(name: String) {
        
    }
    
    func displaySignOut() {
        
    }
    
    func displayVote(index: Int) {
        self.showSheet = true
        self.typeSelected = .vote
        for (cellIndex, _) in self.cellsSelected.enumerated() {
            withAnimation {
                if cellIndex <= index - 1  {
                    self.cellsSelected[cellIndex] = true
                } else {
                    self.cellsSelected[cellIndex] = false
                }
            }
        }
    }
    
    func displayBiometricOn() {
        self.typeSelected = .authentication
        self.showSheet = true
    }
    
    func displayBiometricOff() {
        JEWKeyChainWrapper.clear()
    }
    
    
}

#if DEBUG
struct NewProfileView_Previews: PreviewProvider {
    @State static var isPresented = true
    static var previews: some View {
        
        ForEach(["iPhone SE", "iPhone 8", "iPhone 11", "iPhone 11 Pro Max"], id: \.self) {
            NewProfileView(isPresented: $isPresented)
                .previewDevice(.init(rawValue: $0))
                .previewDisplayName($0)
        }
    }
}
#endif


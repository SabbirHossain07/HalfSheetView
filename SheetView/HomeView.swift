//
//  HomeView.swift
//  SheetView
//
//  Created by Sopnil Sohan on 25/12/21.
//

import SwiftUI

struct HomeView: View {
    
    @State var showSheet: Bool = false
    
    var body: some View {
        NavigationView {
            Button {
                showSheet.toggle()
            } label: {
                Text("Next")
                    .frame(width: 180, height: 50)
                    .background(Color.green.opacity(0.3))
                    .cornerRadius(10)
//                    .padding()
            }
            .navigationTitle("Half Model Sheet")
            .halfSheet(showSheet: $showSheet) {
                //Half Sheet View...
                ZStack {
                    Color.red
                    
                    VStack {
                        Spacer()
                        Text("Hey Promel!")
                            .font(.title.bold())
                            .foregroundColor(.white)
                        Spacer()
                        Button {
                            showSheet.toggle()
                        } label: {
                            Image(systemName: "xmark.app.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.white.opacity(0.8))      
                        }
                        .padding()
                    }
                }
                .ignoresSafeArea()
                
            } onEnd: {
                print("Dismissed")}
        }
    }
}

extension View {
    
    func halfSheet<SheetView: View>(showSheet: Binding<Bool>,@ViewBuilder sheetView: @escaping ()-> SheetView,onEnd: @escaping()->())->some View {
        
        return self
            .background(
                HalfSheetHelper(sheetView: sheetView(),showSheet: showSheet, onEnd: onEnd)
            )
    }
}

struct HalfSheetHelper<SheetView: View>: UIViewControllerRepresentable {
    
    var sheetView: SheetView
    @Binding var showSheet: Bool
    var onEnd: ()->()
    
    let controller = UIViewController()
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        
        controller.view.backgroundColor = .clear
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
        if showSheet {
            
            let sheetController = CustomHostingController(rootView: sheetView)
            sheetController.presentationController?.delegate = context.coordinator
            //Presinting model View...
            uiViewController.present(sheetController, animated: true)
        }
        else {
            //Closeing View when showsheet Togggled again...
            uiViewController.dismiss(animated: true)
        }
    }
    class Coordinator: NSObject, UISheetPresentationControllerDelegate {
        var parent: HalfSheetHelper
        
        init(parent: HalfSheetHelper) {
            self.parent = parent
        }
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            parent.showSheet = false
            parent.onEnd()
        }
    }
}

//Custom UIHostingController For Halfsheet...
class CustomHostingController<Content: View>: UIHostingController<Content>{
    override func viewDidLoad() {
        
        view.backgroundColor = .clear
        //setting presentation controller properties...
        if let presentationController = presentationController as?
            UISheetPresentationController {
            presentationController.detents = [
                .medium(),
                .large()
            ]
            //To show grab protion...
            presentationController.prefersGrabberVisible = true
        }
    }
}
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}



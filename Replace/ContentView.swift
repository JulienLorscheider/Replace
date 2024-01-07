//
//  ContentView.swift
//  Replace
//
//  Created by Julien on 07/01/2024.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @State private var documentURL: URL?
    @State private var originalWord: String = ""
    @State private var newWord: String = ""
    @State private var showAlert = false
    @State private var alertMessage: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            // Titre de l'application
            Text("Replace")
                .font(.largeTitle) // Taille de la police
                .fontWeight(.bold) // Poids de la police
                .foregroundColor(Color.blue) // Couleur du texte
                .padding(.top, 50) // Espacement du haut

            Spacer()

            // Zones de texte
            Group {
                TextField("Mot à remplacer", text: $originalWord)
                TextField("Nouveau mot", text: $newWord)
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal)
            
            // Sélecteur de fichier
            Button(action: presentDocumentPicker) {
                HStack {
                    Image(systemName: "folder")
                    Text("Choisir un fichier")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }

            // Bouton pour lancer l'opération
            Button("Remplacer", action: replaceWordsInFile)
                .disabled(documentURL == nil || originalWord.isEmpty || newWord.isEmpty)
                .padding()
                .frame(maxWidth: .infinity)
                .background(documentURL == nil || originalWord.isEmpty || newWord.isEmpty ? Color.gray : Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)

            Spacer()
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Information"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    // Extension pour intégrer UIDocumentPickerViewController
    func presentDocumentPicker() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.plainText], asCopy: true)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            documentPicker.delegate = rootViewController as? UIDocumentPickerDelegate
            rootViewController.present(documentPicker, animated: true, completion: nil)
        }
    }

    private func replaceWordsInFile() {
        guard let documentURL = documentURL else {
            alertMessage = "Erreur : Aucun fichier sélectionné."
            showAlert = true
            return
        }

        let path = documentURL.path

        // Appel de la fonction processFile du code C
        processFile(path, originalWord, newWord)

        alertMessage = "Les mots ont été remplacés avec succès."
        showAlert = true

        // Réinitialisation des champs après l'opération
        originalWord = ""
        newWord = ""
        self.documentURL = nil
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

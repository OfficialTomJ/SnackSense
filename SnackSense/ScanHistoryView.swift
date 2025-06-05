//
//  ScanHistoryView.swift
//  SnackSense
//
//  Created by Ronan Soh  on 12/05/2025.
//

import SwiftUI
import SwiftData
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

struct ScanHistoryView: View {
    @State private var fetchedScans: [(id: String, timestamp: TimeInterval, nutritionText: String, insights: [String], imageURL: String?)] = []

    var body: some View {
        List(fetchedScans, id: \.id) { scan in
            NavigationLink(destination: ResultView(rawText: scan.nutritionText, imageURL: scan.imageURL.flatMap(URL.init(string:)), isFromHistory: true, savedInsights: scan.insights)) {
                VStack(alignment: .leading) {
                    Text(Date(timeIntervalSince1970: scan.timestamp).formatted(date: .abbreviated, time: .shortened))
                        .font(.headline)
                    Text("Scan ID: \(scan.id)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .onAppear {
            guard let user = Auth.auth().currentUser else { return }
            let dbRef = Database.database().reference().child("scans").child(user.uid)
            dbRef.observeSingleEvent(of: .value) { snapshot in
                var tempScans: [(id: String, timestamp: TimeInterval, nutritionText: String, insights: [String], imageURL: String?)] = []
                for child in snapshot.children {
                    if let snap = child as? DataSnapshot,
                       let value = snap.value as? [String: Any],
                       let timestamp = value["timestamp"] as? TimeInterval,
                       let nutritionText = value["nutritionText"] as? String,
                       let insights = value["insights"] as? [String] {
                        
                        let imageURL = value["imageURL"] as? String
                        tempScans.append((id: snap.key, timestamp: timestamp, nutritionText: nutritionText, insights: insights, imageURL: imageURL))
                    }
                }
                self.fetchedScans = tempScans.sorted { $0.timestamp > $1.timestamp }
            }
        }
    }
}
#Preview {
    StartView()
}

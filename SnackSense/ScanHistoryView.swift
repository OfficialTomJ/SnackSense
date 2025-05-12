//
//  ScanHistoryView.swift
//  SnackSense
//
//  Created by Ronan Soh  on 12/05/2025.
//

import SwiftUI
import SwiftData

struct ScanHistoryView: View {
    @Query(sort: \ScanData.timestamp, order: .reverse) var scans: [ScanData]

    var body: some View {
        List(scans) { scan in
            NavigationLink(destination: ResultView(selectedScan: scan)) {
                VStack(alignment: .leading) {
                    Text(scan.timestamp.formatted(date: .abbreviated, time: .shortened))
                        .font(.headline)
                    Text(scan.rawText.prefix(100) + "...")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("Scan History")
    }
}
#Preview {
    StartView()
}


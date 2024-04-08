//
//  ContentView.swift
//  PushToTalkApp
//
//  Created by lakshita sodhi on 08/04/24.
//

import SwiftUI
import Foundation
import UIKit
import AVFoundation
import PushToTalk

struct ContentView: View {
    @StateObject var channelManagerWrapper = ChannelManagerWrapper()

    var body: some View {
            VStack {
                Toggle(isOn: $channelManagerWrapper.isTransmitting) {
                    Text("Push to Talk")
                }
                .padding()
            }
            .onChange(of: channelManagerWrapper.isTransmitting) { newValue in
                if newValue {
                    channelManagerWrapper.startTransmitting()
                } else {
                    channelManagerWrapper.stopTransmitting()
                }
            }
            .onAppear {
                // Initialize ChannelManagerWrapper synchronously
                channelManagerWrapper.setupChannelManager()
            }
        }
    
}

class ChannelManagerWrapper: NSObject, ObservableObject, PTChannelManagerDelegate, PTChannelRestorationDelegate {
    func channelDescriptor(restoredChannelUUID channelUUID: UUID) -> PTChannelDescriptor {
        // Implement logic to retrieve the channel descriptor for the restored channelUUID
        // You may want to return a cached descriptor or fetch it from a database
        
        // Placeholder code
        let channelImage = UIImage(named: "ChannelIcon")
        return PTChannelDescriptor(name: "Restored Channel", image: channelImage)
    }
    
    
    
   
    
    @Published var isTransmitting = false
    let channelUUID = UUID() // Assuming you have a channel UUID
    var channelManager: PTChannelManager!

    override init() {
        super.init()
        setupChannelManager()
    }

    func setupChannelManager() {
        Task {
            do {
                channelManager = try await PTChannelManager.channelManager(delegate: self,
                                                                           restorationDelegate: self)
            } catch {
                print("Error initializing channel manager: \(error)")
            }
        }
    }
    
    func joinChannel(channelUUID: UUID) {
            let channelImage = UIImage(named: "ChannelIcon")
            let channelDescriptor = PTChannelDescriptor(name: "Awesome Crew", image: channelImage)
          
            // Ensure that your channel descriptor and UUID are persisted to disk for later use.
            channelManager.requestJoinChannel(channelUUID: channelUUID,
                                              descriptor: channelDescriptor)
        }

    func channelManager(_ channelManager: PTChannelManager, didJoinChannel channelUUID: UUID, reason: PTChannelJoinReason) {
        print("Joined channel with UUID: \(channelUUID)")
    }
    func channelManager(_ channelManager: PTChannelManager, receivedEphemeralPushToken pushToken: Data) {
        // Handle the received ephemeral push token
        // This method is called when the channel manager receives a push token
        
        // Placeholder code
        print("Received push token")
    }

    func channelManager(_ channelManager: PTChannelManager, failedToJoinChannel channelUUID: UUID, error: Error) {
        let error = error as NSError

        switch error.code {
        case PTChannelError.channelLimitReached.rawValue:
            print("The user has already joined a channel")
        default:
            break
        }
    }

    func channelManager(_ channelManager: PTChannelManager, didLeaveChannel channelUUID: UUID, reason: PTChannelLeaveReason) {
        print("Left channel with UUID: \(channelUUID)")
    }

    func getCachedChannelDescriptor(_ channelUUID: UUID) -> PTChannelDescriptor {
        // Implement logic to retrieve the cached channel descriptor
        // For example, you might retrieve it from UserDefaults or another storage mechanism
        
        // Dummy implementation returning a placeholder descriptor
        let channelImage = UIImage(named: "CachedChannelIcon")
        return PTChannelDescriptor(name: "Cached Channel", image: channelImage)
    }

    func updateChannel(_ channelDescriptor: PTChannelDescriptor) async throws {
        try await channelManager.setChannelDescriptor(channelDescriptor,
                                                      channelUUID: channelUUID)
    }

    func reportServiceIsReconnecting() async throws {
        try await channelManager.setServiceStatus(.connecting, channelUUID: channelUUID)
    }

    func reportServiceIsConnected() async throws {
        try await channelManager.setServiceStatus(.ready, channelUUID: channelUUID)
    }
    
    
    
    func startTransmitting() {
        channelManager.requestBeginTransmitting(channelUUID: channelUUID)
    }

    func channelManager(_ channelManager: PTChannelManager,
                        failedToBeginTransmittingInChannel channelUUID: UUID,
                        error: Error) {
        let error = error as NSError

        switch error.code {
        case PTChannelError.callActive.rawValue:
            print("The system has another ongoing call that is preventing transmission.")
        default:
            break
        }
    }


    func stopTransmitting() {
        channelManager.stopTransmitting(channelUUID: channelUUID)
    }
    
    func channelManager(_ channelManager: PTChannelManager,
                        failedToStopTransmittingInChannel channelUUID: UUID,
                        error: Error) {
        let error = error as NSError

        switch error.code {
        case PTChannelError.transmissionNotFound.rawValue:
            print("The user was not in a transmitting state")
        default:
            break
        }
    }

    func channelManager(_ channelManager: PTChannelManager,
                        channelUUID: UUID,
                        didBeginTransmittingFrom source: PTChannelTransmitRequestSource) {
        print("Did begin transmission from: \(source)")
    }

    func channelManager(_ channelManager: PTChannelManager,
                        didActivate audioSession: AVAudioSession) {
        print("Did activate audio session")
        // Configure your audio session and begin recording
    }

    func channelManager(_ channelManager: PTChannelManager,
                        channelUUID: UUID,
                        didEndTransmittingFrom source: PTChannelTransmitRequestSource) {
        print("Did end transmission from: \(source)")
    }

    func channelManager(_ channelManager: PTChannelManager,
                        didDeactivate audioSession: AVAudioSession) {
        print("Did deactivate audio session")
        // Stop recording and clean up resources
    }

    func incomingPushResult(channelManager: PTChannelManager,
                            channelUUID: UUID,
                            pushPayload: [String : Any]) -> PTPushResult {

        guard let activeSpeaker = pushPayload["activeSpeaker"] as? String else {
            // If no active speaker is set, the only other valid operation
            // is to leave the channel
            return .leaveChannel
        }

        let activeSpeakerImage = getActiveSpeakerImage(activeSpeaker)
        let participant = PTParticipant(name: activeSpeaker, image: activeSpeakerImage)
        return .activeRemoteParticipant(participant)
    }
    func getActiveSpeakerImage(_ speakerName: String) -> UIImage? {
        // Implement logic to retrieve the image of the active speaker
        // For example, you might have a dictionary mapping speaker names to image names
        
        // Dummy implementation returning nil
        // You should replace this with your actual logic to fetch the image
        return nil
    }

    func stopReceivingAudio() {
        channelManager.setActiveRemoteParticipant(nil, channelUUID: channelUUID)
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

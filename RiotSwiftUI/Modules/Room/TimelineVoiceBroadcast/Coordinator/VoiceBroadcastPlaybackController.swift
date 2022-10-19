//
// Copyright 2021 New Vector Ltd
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Combine
import MatrixSDK
import SwiftUI

struct VoiceBroadcastPlaybackControllerParameters {
    let session: MXSession
    let room: MXRoom
    let voiceBroadcastStartEvent: MXEvent
}

final class VoiceBroadcastPlaybackController: Coordinator, Presentable, VoiceBroadcastAggregatorDelegate {
    // MARK: - Properties
    
    // MARK: Private
    
    private let parameters: VoiceBroadcastPlaybackControllerParameters
    private let selectedAnswerIdentifiersSubject = PassthroughSubject<[String], Never>()
    
    private var voiceBroadcastAggregator: VoiceBroadcastAggregator
    private var viewModel: TimelineVoiceBroadcastViewModelProtocol!
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Public

    // Must be used only internally
    var childCoordinators: [Coordinator] = []
    
    // MARK: - Setup
    
    init(parameters: VoiceBroadcastPlaybackControllerParameters) throws {
        self.parameters = parameters
        
        try voiceBroadcastAggregator = VoiceBroadcastAggregator(session: parameters.session, room: parameters.room, voiceBroadcastStartEventId: parameters.voiceBroadcastStartEvent.eventId)
        voiceBroadcastAggregator.delegate = self
        
        viewModel = TimelineVoiceBroadcastViewModel(timelineVoiceBroadcastDetails: buildTimelineVoiceBroadcastFrom(voiceBroadcastAggregator.voiceBroadcast))
        
        viewModel.completion = { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .played:
                // TODO: VB Add player and playing chunk files
                MXLog.debug("click on play")
            case .paused:
                // TODO: VB stop playing chunk files
                MXLog.debug("click on pause")
            }
        }

    }
    
    // MARK: - Public

    func start() { }
    
    func toPresentable() -> UIViewController {
        VectorHostingController(rootView: TimelineVoiceBroadcastView(viewModel: viewModel.context),
                                forceZeroSafeAreaInsets: true)
    }
    
    func canEndVoiceBroadcast() -> Bool {
        // TODO: VB check is voicebroadcast stopped
        return false
    }
    
    func canEditVoiceBroadcast() -> Bool {
        return false
    }
    
    func endVoiceBroadcast() {}
    
    // MARK: - VoiceBroadcastAggregatorDelegate
    
    func voiceBroadcastAggregatorDidUpdateData(_ aggregator: VoiceBroadcastAggregator) {
        viewModel.updateWithVoiceBroadcastDetails(buildTimelineVoiceBroadcastFrom(aggregator.voiceBroadcast))
    }
    
    func voiceBroadcastAggregatorDidStartLoading(_ aggregator: VoiceBroadcastAggregator) { }
    
    func voiceBroadcastAggregatorDidEndLoading(_ aggregator: VoiceBroadcastAggregator) { }
    
    func voiceBroadcastAggregator(_ aggregator: VoiceBroadcastAggregator, didFailWithError: Error) { }
    
    // MARK: - Private
    
    // VoiceBroadcast is intentionally not available in the SwiftUI target as we don't want
    // to add the SDK as a dependency to it. We need to translate from one to the other on this level.
    func buildTimelineVoiceBroadcastFrom(_ voiceBroadcast: VoiceBroadcast) -> TimelineVoiceBroadcastDetails {
        
        return TimelineVoiceBroadcastDetails(chunks: Array(voiceBroadcast.chunks), type: voiceBroadcastKindToTimelineVoiceBroadcastType(voiceBroadcast.kind))
    }
    
    private func voiceBroadcastKindToTimelineVoiceBroadcastType(_ kind: VoiceBroadcastKind) -> TimelineVoiceBroadcastType {
        let mapping = [VoiceBroadcastKind.player: TimelineVoiceBroadcastType.player,
                       VoiceBroadcastKind.recorder: TimelineVoiceBroadcastType.recorder]
        
        return mapping[kind] ?? .player
    }
}

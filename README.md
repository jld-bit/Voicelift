# VoiceLift (SwiftUI)

VoiceLift is an original SwiftUI iPhone app concept for recording and improving voice notes.

## Legal & design disclaimer
This project intentionally uses original naming, copy, iconography, and interaction flows.
It does **not** copy protected branding, copyrighted assets, trade dress, or exact UX from any existing app.

## Implemented scope
- Record audio with pause/resume
- Save notes with local JSON metadata + local audio file URLs
- Voice note list with colorful rounded gradient cards
- Tags to organize notes
- Note detail with playback + waveform visualization
- API-ready transcription service and auto title/summary generation
- Freemium model wiring using StoreKit 2 (free weekly cap, premium unlock path)
- Onboarding flow and seeded sample notes
- MVVM architecture

## Project structure
- `VoiceLift/App` – App entry, root routing
- `VoiceLift/Models` – Voice note + subscription tier models
- `VoiceLift/ViewModels` – Main recordings view model
- `VoiceLift/Services` – Audio recording, playback, storage, transcription, purchases
- `VoiceLift/Views` – Screens and reusable UI components
- `VoiceLift/Utilities` – App file path utilities

## Integration notes
1. Add this folder to an Xcode iOS App target (iOS 17+ recommended).
2. Enable capabilities:
   - In-App Purchase
   - Microphone usage key in `Info.plist` (`NSMicrophoneUsageDescription`)
3. Configure StoreKit product ID: `com.voicelift.premium.monthly`
4. Inject your transcription endpoint/API key by initializing `TranscriptionService.Config`.
5. Add actual sample `.m4a` files if desired under app resources.

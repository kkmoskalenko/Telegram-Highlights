# Dust Effect

![Dust effect preview](../../Assets/dust-effect-preview.gif)

`DustEffectLayer` creates the effect often known as the Thanos Snap: it takes a `UIImage` snapshot of any content, vaporizes it into a million tiny Metal-rendered pixels, and makes it disappear.

The implementation is derived from Telegram iOS and uses `MetalEngine` for Metal scheduling, compute, and rendering.

## API

- `addItem(frame:image:)` adds a snapshot item to dissolve. The frame must be in the dust layer's coordinate space.
- `animationSpeed` scales the dissolve sweep. The particle simulation continues at its own rate so the final grains can finish. The default value is `1.0`.
- `animateDown` changes the particle direction from upward to downward. The default value is `false`.
- `becameEmpty` is called after all active items finish and are removed.

## Setup

Install `MetalEngine.shared.rootLayer` once somewhere in your app's layer hierarchy. A common place is `application(_:didFinishLaunchingWithOptions:)`, after creating the root view controller:

```swift
let rootView = rootViewController.view
rootView.layer.addSublayer(MetalEngine.shared.rootLayer)
```

`DustEffectLayer` renders into its own layer surfaces, but `MetalEngine` still needs its root layer in the hierarchy to drive display work.

## Usage

1. Render the content you want to dissolve into a `UIImage`.
2. Add a `DustEffectLayer` over the area where particles should appear. The layer can be larger than the original content so particles have room to drift.
3. Call `addItem(frame:image:)` with the snapshot frame in the dust layer's coordinate space.
4. Hide or remove the original content.
5. Remove the dust layer from `becameEmpty`.

A complete SwiftUI/UIKit wrapper is available in [`Examples/TelegramHighlights/Views/DustEffectView.swift`](../../Examples/TelegramHighlights/Views/DustEffectView.swift).

## How It Works

`addItem(frame:image:)` creates an internal item with the supplied frame and a Metal texture loaded from the image's `cgImage`. If the image cannot be converted into a texture, the item is ignored.

When the layer is in the hierarchy and has active items, it runs from `SharedDisplayLinkDriver` at the maximum available frame rate. Each tick advances the item's `phase` and elapsed duration, then requests a Metal update. An item is removed once its phase reaches `4.0` and its duration reaches `0.8 / animationSpeed + 2.1` seconds, allowing the last grains to fade. If that was the last item, the fluid state is released and `becameEmpty` is called.

During the Metal update, the layer allocates one shared particle buffer per item. The particle grid uses the integer point size of the item frame, so a `120 x 80` frame produces `9,600` rendered particles. The item frame is flipped vertically before rendering because UIKit layer coordinates and Metal clip-space mapping use different origins.

The initialization shader gives each particle a starting offset of zero, a randomized radial velocity, and a lifetime between `2.0` and `4.1` simulation seconds. A soft sweep mixes horizontal position with noise and randomness to release the grains gradually. Grains just ahead of the sweep tremble before breaking away.

One coarse GPU fluid simulation covers the layer and is shared by its items. Pushes along the dissolve front stir the fluid; the particle update samples a stream function derived from the fluid's curl, carrying the grains through uneven currents alongside their own drift. The simulation runs twice as fast as elapsed time and follows UIKit's animation-duration factor.

The render pass initially draws each particle as its original square of the snapshot. Released grains become round, shrink at different rates to a single pixel, and twinkle with occasional small blooms. They slow near the end of their lifetime, fade during the last `0.3` simulation seconds, and collapse outside the viewport once invisible.

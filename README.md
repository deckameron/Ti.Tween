# Ti.Tween

High-performance multi-property tween animation engine for Titanium SDK with native 120Hz support via CADisplayLink.

![Titanium](https://img.shields.io/badge/Titanium-13.0+-red.svg) ![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg) ![License](https://img.shields.io/badge/license-MIT-blue.svg) ![Maintained](https://img.shields.io/badge/Maintained-Yes-green.svg)

---

### Roadmap

- [x] iOS support
- [ ] Android support

## Features

-   **High FPS**: Synchronized with device refresh rate (60Hz/90Hz/120Hz on ProMotion displays)
-   **Multi-property animations**: Animate multiple properties simultaneously with independent values
-   **Rich easing library**: 30+ built-in easing functions + custom cubic-bezier support
-   **Sequences**: Chain animations in serial or run them in parallel
-   **Height/Width animations**: Unlike Ti.UI.Animation, properly animates height and width
-   **Human-like motion**: Back easing for natural overshoot/undershoot behavior
-   **Full control**: Pause, resume, stop individual tweens or kill all at once

## Supported Properties

### Position & Size

-   `top`  - Y position
-   `left`  - X position
-   `width`  - View width
-   `height`  - View height
-   `centerX`  - Center X coordinate
-   `centerY`  - Center Y coordinate

### Visual

-   `opacity`  - Alpha transparency (0.0 to 1.0)
-   `backgroundColor`  - Background color (hex string: "#ff0000")
-   `tintColor`  - Tint color (hex string: "#00ff00")
-   `textColor`  - Text color for labels and buttons (hex string: "#000000", can also use alias  `color`)

### Transform

-   `scaleX`  - Horizontal scale
-   `scaleY`  - Vertical scale
-   `rotation`  - Rotation in degrees
-   `anchorPoint`  - Transform anchor point ({x: 0.5, y: 0.5} or [0.5, 0.5])
-   `zPosition`  - Layer depth (z-index)

### Border

-   `borderRadius`  - Corner radius
-   `borderWidth`  - Border thickness
-   `borderColor`  - Border color (hex string: "#0000ff")

### Shadow

-   `shadowOpacity`  - Shadow alpha (0.0 to 1.0)
-   `shadowRadius`  - Shadow blur radius
-   `shadowOffsetX`  - Shadow horizontal offset
-   `shadowOffsetY`  - Shadow vertical offset
-   `shadowColor`  - Shadow color (hex string: "#00000080")

## Installation

1.  Copy the module to your project's  `modules/iphone/`  folder
2.  Add to  `tiapp.xml`:

```xml
<modules>
    <module platform="iphone">ti.tween</module>
</modules>

```

3.  In your JS code:

```javascript
const TiTween = require('ti.tween');

```

## Basic Usage

### Simple Tween

```javascript
const myView = Ti.UI.createView({
    backgroundColor: '#ff0000',
    width: 100,
    height: 100,
    top: 50
});

// Animate to new position with easing
const tweenId = TiTween.start({
    target: myView,
    properties: { 
        top: 300, 
        height: 200 
    },
    duration: 600,          // milliseconds
    easing: TiTween.EASE_OUT_CUBIC,
    onComplete: () => {
        console.log('Animation completed!');
    }
});

```

### Human-Like Motion (Back Easing)

This is what you described - goes past the target and comes back:

```javascript
TiTween.start({
    target: myView,
    properties: { left: 200 },
    duration: 800,
    easing: TiTween.EASE_OUT_BACK,  // Overshoots and returns
    onComplete: () => {
        console.log('Natural motion complete');
    }
});

```

### Multi-Property Complex Animation

```javascript
TiTween.start({
    target: myView,
    properties: {
        top: 400,
        left: 150,
        width: 200,
        height: 200,
        opacity: 0.3,
        rotation: 180,
        borderRadius: 100,
        backgroundColor: '#ff0000',  // Animate to red
        borderColor: '#0000ff',       // Animate to blue border
        borderWidth: 5
    },
    duration: 1200,
    delay: 500,
    easing: TiTween.EASE_IN_OUT_QUART,
    onUpdate: (data) => {
        console.log('Progress:', data.progress);
    },
    onComplete: () => {
        console.log('Done!');
    }
});

```

### Color Transitions

```javascript
// Smooth color fade
TiTween.start({
    target: myView,
    properties: {
        backgroundColor: '#e74c3c',  // Red
        borderColor: '#3498db',      // Blue
        shadowColor: '#2c3e50'       // Dark gray
    },
    duration: 800,
    easing: TiTween.EASE_IN_OUT_SINE
});

// Text color animation (works on labels and buttons)
TiTween.start({
    target: myLabel,
    properties: {
        textColor: '#e74c3c',        // Red text
        backgroundColor: '#ecf0f1'   // Light gray background
    },
    duration: 600,
    easing: TiTween.EASE_OUT_CUBIC
});

// Using 'color' alias for textColor
TiTween.start({
    target: myButton,
    properties: {
        color: '#ffffff'  // Same as textColor
    },
    duration: 400,
    easing: TiTween.EASE_IN_OUT_QUAD
});

// With RGBA support
TiTween.start({
    target: myView,
    properties: {
        backgroundColor: '#ff000080',  // Red with 50% alpha
        shadowColor: '#00000040'       // Black shadow with 25% alpha
    },
    duration: 600,
    easing: TiTween.EASE_OUT_CUBIC
});

```

### Complete Shadow Animation

```javascript
TiTween.start({
    target: myView,
    properties: {
        shadowOpacity: 0.5,
        shadowRadius: 20,
        shadowOffsetX: 10,
        shadowOffsetY: 15,
        shadowColor: '#000000'
    },
    duration: 800,
    easing: TiTween.EASE_OUT_QUART
});

```

### Center-Based Positioning

```javascript
// Animate from center instead of top/left
TiTween.start({
    target: myView,
    properties: {
        centerX: Ti.Platform.displayCaps.platformWidth / 2,
        centerY: Ti.Platform.displayCaps.platformHeight / 2,
        scaleX: 1.5,
        scaleY: 1.5
    },
    duration: 600,
    easing: TiTween.EASE_OUT_BACK
});

```

### Custom Anchor Point for Rotation

```javascript
// Rotate from bottom-left corner
TiTween.start({
    target: myView,
    properties: {
        anchorPoint: [0, 1],  // or {x: 0, y: 1}
        rotation: 90
    },
    duration: 800,
    easing: TiTween.EASE_IN_OUT_CUBIC
});

```

### Layer Depth Animation

```javascript
// Card stack with parallax
TiTween.sequence([
    {
        target: card1,
        properties: { zPosition: 100 },
        duration: 400,
        easing: TiTween.EASE_OUT_QUART
    },
    {
        target: card2,
        properties: { zPosition: 200 },
        duration: 400,
        easing: TiTween.EASE_OUT_QUART
    }
], {
    mode: TiTween.SEQUENCE_SERIAL
});

```

### Custom Cubic Bezier Easing

```javascript
TiTween.start({
    target: myView,
    properties: { top: 500 },
    duration: 800,
    easing: {
        type: TiTween.CUBIC_BEZIER,
        points: [0.25, 0.1, 0.25, 1.0]  // CSS cubic-bezier values
    }
});

```

## Sequences

### Serial Sequence (one after another)

```javascript
const sequenceId = TiTween.sequence([
    {
        target: myView,
        properties: { top: 100 },
        duration: 400,
        easing: TiTween.EASE_OUT_QUAD
    },
    {
        target: myView,
        properties: { left: 200 },
        duration: 300,
        easing: TiTween.EASE_IN_CUBIC
    },
    {
        target: myView,
        properties: { opacity: 0 },
        duration: 500,
        easing: TiTween.EASE_OUT_EXPO
    }
], {
    mode: TiTween.SEQUENCE_SERIAL,
    onComplete: () => {
        console.log('All animations completed in sequence');
    }
});

```

### Parallel Sequence (all at once)

```javascript
const sequenceId = TiTween.sequence([
    {
        target: view1,
        properties: { top: 200 },
        duration: 600,
        easing: TiTween.EASE_OUT_BACK
    },
    {
        target: view2,
        properties: { left: 300 },
        duration: 800,
        easing: TiTween.EASE_IN_OUT_SINE
    },
    {
        target: view3,
        properties: { opacity: 0.5 },
        duration: 400,
        easing: TiTween.EASE_OUT_QUAD
    }
], {
    mode: TiTween.SEQUENCE_PARALLEL,
    onComplete: () => {
        console.log('All parallel animations completed');
    }
});

```

## Control Methods

```javascript
// Individual tween control
TiTween.pause(tweenId);
TiTween.resume(tweenId);
TiTween.stop(tweenId);

// Sequence control
TiTween.pauseSequence(sequenceId);
TiTween.resumeSequence(sequenceId);
TiTween.stopSequence(sequenceId);

// Kill everything (useful for screen transitions)
TiTween.killAll();

```

## Available Easing Constants

### Linear

-   `TiTween.EASE_LINEAR`

### Quad (Power of 2)

-   `TiTween.EASE_IN_QUAD`
-   `TiTween.EASE_OUT_QUAD`
-   `TiTween.EASE_IN_OUT_QUAD`

### Cubic (Power of 3)

-   `TiTween.EASE_IN_CUBIC`
-   `TiTween.EASE_OUT_CUBIC`
-   `TiTween.EASE_IN_OUT_CUBIC`

### Quart (Power of 4)

-   `TiTween.EASE_IN_QUART`
-   `TiTween.EASE_OUT_QUART`
-   `TiTween.EASE_IN_OUT_QUART`

### Quint (Power of 5)

-   `TiTween.EASE_IN_QUINT`
-   `TiTween.EASE_OUT_QUINT`
-   `TiTween.EASE_IN_OUT_QUINT`

### Expo (Exponential)

-   `TiTween.EASE_IN_EXPO`
-   `TiTween.EASE_OUT_EXPO`
-   `TiTween.EASE_IN_OUT_EXPO`

### Sine (Sinusoidal)

-   `TiTween.EASE_IN_SINE`
-   `TiTween.EASE_OUT_SINE`
-   `TiTween.EASE_IN_OUT_SINE`

### Elastic (Spring-like wobble)

-   `TiTween.EASE_IN_ELASTIC`
-   `TiTween.EASE_OUT_ELASTIC`
-   `TiTween.EASE_IN_OUT_ELASTIC`

### Back (Overshoot - natural motion)

-   `TiTween.EASE_IN_BACK`  - Pulls back before starting
-   `TiTween.EASE_OUT_BACK`  -  Goes past target and returns
-   `TiTween.EASE_IN_OUT_BACK`  - Both behaviors combined

### Bounce (Ball bouncing)

-   `TiTween.EASE_IN_BOUNCE`
-   `TiTween.EASE_OUT_BOUNCE`
-   `TiTween.EASE_IN_OUT_BOUNCE`

## Real-World Examples

### Card Flip with Height Animation

```javascript
function flipCard(cardView) {
    TiTween.sequence([
        {
            target: cardView,
            properties: { 
                scaleX: 0,
                height: 250
            },
            duration: 300,
            easing: TiTween.EASE_IN_CUBIC
        },
        {
            target: cardView,
            properties: { scaleX: 1 },
            duration: 300,
            easing: TiTween.EASE_OUT_CUBIC
        }
    ], {
        mode: TiTween.SEQUENCE_SERIAL,
        onComplete: () => {
            console.log('Card flipped');
        }
    });
}

```

### Modal Dialog with Natural Motion

```javascript
function showModal(modalView) {
    modalView.opacity = 0;
    modalView.top = -300;
    
    TiTween.start({
        target: modalView,
        properties: { 
            top: 100,
            opacity: 1
        },
        duration: 600,
        easing: TiTween.EASE_OUT_BACK,  // Natural overshoot
        onComplete: () => {
            console.log('Modal displayed');
        }
    });
}

```

### Button Press Effect

```javascript
function animateButtonPress(button) {
    TiTween.sequence([
        {
            target: button,
            properties: { scaleX: 0.95, scaleY: 0.95 },
            duration: 100,
            easing: TiTween.EASE_OUT_QUAD
        },
        {
            target: button,
            properties: { scaleX: 1, scaleY: 1 },
            duration: 200,
            easing: TiTween.EASE_OUT_ELASTIC
        }
    ], {
        mode: TiTween.SEQUENCE_SERIAL
    });
}

```

### Screen Transition

```javascript
function transitionToNextScreen(currentScreen, nextScreen) {
    // Kill any existing animations
    TiTween.killAll();
    
    // Parallel animation for smooth transition
    TiTween.sequence([
        {
            target: currentScreen,
            properties: { 
                left: -Ti.Platform.displayCaps.platformWidth,
                opacity: 0
            },
            duration: 400,
            easing: TiTween.EASE_IN_OUT_CUBIC
        },
        {
            target: nextScreen,
            properties: { 
                left: 0,
                opacity: 1
            },
            duration: 400,
            easing: TiTween.EASE_IN_OUT_CUBIC
        }
    ], {
        mode: TiTween.SEQUENCE_PARALLEL,
        onComplete: () => {
            currentScreen.visible = false;
        }
    });
}

```

### Text Highlight / Error State

```javascript
// Highlight text when user searches
function highlightSearchTerm(label) {
    TiTween.start({
        target: label,
        properties: {
            textColor: '#f39c12',  // Yellow
            backgroundColor: '#fff3cd'
        },
        duration: 300,
        easing: TiTween.EASE_OUT_QUAD
    });
}

// Show error state
function showErrorState(label) {
    TiTween.sequence([
        {
            target: label,
            properties: { textColor: '#e74c3c' },  // Red
            duration: 200,
            easing: TiTween.EASE_OUT_QUAD
        },
        {
            target: label,
            properties: { textColor: '#000000' },  // Back to black
            duration: 200,
            delay: 2000,  // Wait 2 seconds
            easing: TiTween.EASE_IN_QUAD
        }
    ], {
        mode: TiTween.SEQUENCE_SERIAL
    });
}

// Animated counter with color change
function animateCounter(label, fromValue, toValue) {
    let currentValue = fromValue;
    
    TiTween.start({
        target: label,
        properties: {
            textColor: toValue > fromValue ? '#2ecc71' : '#e74c3c'  // Green if up, red if down
        },
        duration: 800,
        easing: TiTween.EASE_OUT_CUBIC,
        onUpdate: (data) => {
            // Update the number text during animation
            currentValue = Math.round(fromValue + (toValue - fromValue) * data.progress);
            label.text = currentValue.toString();
        },
        onComplete: () => {
            label.text = toValue.toString();
        }
    });
}

```

## Performance Notes

-   All animations run on the main thread via CADisplayLink
-   Automatically syncs with device refresh rate (60/90/120Hz)
-   Display link pauses automatically when no animations are active
-   Memory efficient - completed tweens are removed automatically
-   Suitable for complex multi-view animations

## Common Patterns

### Fade In/Out

```javascript
// Fade in
TiTween.start({
    target: view,
    properties: { opacity: 1 },
    duration: 300,
    easing: TiTween.EASE_OUT_SINE
});

// Fade out
TiTween.start({
    target: view,
    properties: { opacity: 0 },
    duration: 300,
    easing: TiTween.EASE_IN_SINE
});

```

### Text Color Transition

```javascript
// Fade text to gray (disabled state)
TiTween.start({
    target: label,
    properties: { textColor: '#95a5a6' },  // Gray
    duration: 200,
    easing: TiTween.EASE_OUT_QUAD
});

// Highlight on press
TiTween.start({
    target: button,
    properties: { color: '#e74c3c' },  // Red (using alias)
    duration: 150,
    easing: TiTween.EASE_OUT_CUBIC
});

```

### Slide In from Top

```javascript
view.top = -view.height;
TiTween.start({
    target: view,
    properties: { top: 50 },
    duration: 500,
    easing: TiTween.EASE_OUT_BACK
});

```

### Scale Up (Zoom In)

```javascript
view.scaleX = 0;
view.scaleY = 0;
TiTween.start({
    target: view,
    properties: { scaleX: 1, scaleY: 1 },
    duration: 400,
    easing: TiTween.EASE_OUT_ELASTIC
});
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request
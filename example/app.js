/**
 * Ti.Tween v1.0.1 - Modern Demo App
 * Professional example showcasing all animation features
 */

const TiTween = require('ti.tween');

// ==========================================
// DESIGN SYSTEM
// ==========================================
const COLORS = {
    background: '#0A0E27',
    surface: '#151B3B',
    surfaceLight: '#1E2749',
    primary: '#6366F1',
    primaryLight: '#818CF8',
    success: '#10B981',
    warning: '#F59E0B',
    danger: '#EF4444',
    textPrimary: '#F9FAFB',
    textSecondary: '#9CA3AF',
    textTertiary: '#6B7280',
    border: '#2D3451'
};

const SPACING = {
    xs: 4,
    sm: 8,
    md: 16,
    lg: 24,
    xl: 32
};

const TYPOGRAPHY = {
    h1: { fontSize: 28, fontWeight: 'bold' },
    h2: { fontSize: 20, fontWeight: '600' },
    h3: { fontSize: 16, fontWeight: '600' },
    body: { fontSize: 14, fontWeight: '400' },
    caption: { fontSize: 12, fontWeight: '400' }
};

// ==========================================
// MAIN WINDOW
// ==========================================
const win = Ti.UI.createWindow({
    layout: "vertical",
    backgroundColor: COLORS.background,
    statusBarStyle: Ti.UI.iOS.StatusBar.LIGHT_CONTENT
});

// Safe area calculation
const statusBarHeight = Titanium.UI.statusBarHeight;

// ==========================================
// HEADER
// ==========================================
const header = Ti.UI.createView({
    top: statusBarHeight,
    height: 100,
    backgroundColor: COLORS.background,
    width: Ti.UI.FILL
});
win.add(header);

const headerTitle = Ti.UI.createLabel({
    text: 'Ti.Tween',
    font: TYPOGRAPHY.h1,
    color: COLORS.textPrimary,
    top: SPACING.md,
    left: SPACING.lg
});
header.add(headerTitle);

const headerSubtitle = Ti.UI.createLabel({
    text: 'High-performance animations for Titanium',
    font: TYPOGRAPHY.body,
    color: COLORS.textSecondary,
    top: 55,
    left: SPACING.lg
});
header.add(headerSubtitle);


// ==========================================
// DEMO AREA
// ==========================================
const demoArea = Ti.UI.createView({
    top: 36,
    height: 200,
    backgroundColor: COLORS.background,
    width: Ti.UI.FILL
});
win.add(demoArea);

const demoLabel = Ti.UI.createLabel({
    text: 'Demo Area',
    font: TYPOGRAPHY.h3,
    color: COLORS.textPrimary,
    top: SPACING.md,
    left: SPACING.lg
});
demoArea.add(demoLabel);

// Demo boxes container
const boxesContainer = Ti.UI.createView({
    top: 50,
    height: 120,
    width: Ti.UI.FILL,
    layout: 'horizontal'
});
demoArea.add(boxesContainer);

// Box 1 - Primary
const box1 = Ti.UI.createView({
    backgroundColor: COLORS.primary,
    width: 100,
    height: 100,
    left: SPACING.lg,
    borderRadius: 12,
    shadowColor: '#000',
    shadowOpacity: 0.3,
    shadowRadius: 10,
    shadowOffset: { x: 0, y: 4 }
});
boxesContainer.add(box1);

// Box 2 - Success
const box2 = Ti.UI.createView({
    backgroundColor: COLORS.success,
    width: 80,
    height: 80,
    left: SPACING.md,
    borderRadius: 12,
    shadowColor: '#000',
    shadowOpacity: 0.3,
    shadowRadius: 8,
    shadowOffset: { x: 0, y: 4 }
});
boxesContainer.add(box2);

// Box 3 - Warning
const box3 = Ti.UI.createView({
    backgroundColor: COLORS.warning,
    width: 60,
    height: 60,
    left: SPACING.md,
    borderRadius: 12,
    shadowColor: '#000',
    shadowOpacity: 0.3,
    shadowRadius: 6,
    shadowOffset: { x: 0, y: 4 }
});
boxesContainer.add(box3);

// Demo text label
const demoTextLabel = Ti.UI.createLabel({
    text: 'Text Animation',
    font: { fontSize: 18, fontWeight: '600' },
    color: COLORS.textPrimary,
    left: SPACING.md,
    textAlign: 'left'
});
boxesContainer.add(demoTextLabel);

// ==========================================
// CONTROLS SCROLL VIEW
// ==========================================
const controlsScroll = Ti.UI.createScrollView({
    top: 0,
    bottom: 0,
    backgroundColor: COLORS.background,
    contentHeight: 'auto',
    showVerticalScrollIndicator: true
});
win.add(controlsScroll);

const controlsContainer = Ti.UI.createView({
    layout: 'vertical',
    height: Ti.UI.SIZE,
    width: Ti.UI.FILL
});
controlsScroll.add(controlsContainer);

// ==========================================
// HELPER FUNCTIONS
// ==========================================
function createSectionHeader(title) {

    const header = Ti.UI.createView({
        height: 50,
        width: Ti.UI.FILL,
        top: SPACING.lg
    });
    
    const label = Ti.UI.createLabel({
        text: title,
        font: TYPOGRAPHY.h2,
        color: COLORS.textPrimary,
        left: SPACING.lg
    });
    header.add(label);

    return header;
}

function createCard(title, description) {

    const card = Ti.UI.createView({
        backgroundColor: COLORS.surface,
        borderRadius: 16,
        height: Ti.UI.SIZE,
        width: Ti.Platform.displayCaps.platformWidth - (SPACING.lg * 2),
        left: SPACING.lg,
        top: SPACING.sm,
        layout: 'vertical'
    });
    
    const titleLabel = Ti.UI.createLabel({
        text: title,
        font: TYPOGRAPHY.h3,
        color: COLORS.textPrimary,
        left: SPACING.md,
        top: SPACING.md,
        width: Ti.UI.FILL
    });
    card.add(titleLabel);
    
    const descLabel = Ti.UI.createLabel({
        text: description,
        font: TYPOGRAPHY.caption,
        color: COLORS.textSecondary,
        left: SPACING.md,
        top: SPACING.xs,
        right: SPACING.md,
        width: Ti.UI.FILL
    });
    card.add(descLabel);
    
    return card;
}

function createButton(title, color) {

    return Ti.UI.createButton({
        title: `  ${title}  `,
        backgroundColor: color,
        color: COLORS.textPrimary,
        font: { fontSize: 13, fontWeight: '600' },
        borderRadius: 8,
        height: 36,
        width: Ti.UI.SIZE,
        left: SPACING.md,
        top: SPACING.sm,
        bottom: SPACING.md
    });
}

function createButtonRow(buttons) {

    const row = Ti.UI.createView({
        layout: 'horizontal',
        height: Ti.UI.SIZE,
        width: Ti.UI.FILL,
        top: SPACING.md
    });
    
    buttons.forEach(btn => row.add(btn));
    
    return row;
}

// ==========================================
// SECTION 1: COLOR ANIMATIONS
// ==========================================
controlsContainer.add(createSectionHeader('🎨 Color Animations'));

const colorCard = createCard(
    'Color Transitions',
    'Smooth RGB interpolation with hex color support'
);

const btnBgColor = createButton('Background', COLORS.primary);
btnBgColor.addEventListener('click', () => {
    TiTween.killAll();
    TiTween.start({
        target: box1,
        properties: { backgroundColor: '#9333EA' },
        duration: 800,
        easing: TiTween.EASE_IN_OUT_SINE,
        onComplete: () => {
            setTimeout(() => {
                TiTween.start({
                    target: box1,
                    properties: { backgroundColor: COLORS.primary },
                    duration: 800,
                    easing: TiTween.EASE_IN_OUT_SINE
                });
            }, 500);
        }
    });
});

const btnTextColor = createButton('Text Color', COLORS.success);
btnTextColor.addEventListener('click', () => {
    TiTween.killAll();
    TiTween.start({
        target: demoTextLabel,
        properties: { textColor: COLORS.warning },
        duration: 600,
        easing: TiTween.EASE_OUT_CUBIC,
        onComplete: () => {
            setTimeout(() => {
                TiTween.start({
                    target: demoTextLabel,
                    properties: { textColor: COLORS.textPrimary },
                    duration: 600,
                    easing: TiTween.EASE_IN_CUBIC
                });
            }, 800);
        }
    });
});

const btnRainbow = createButton('Rainbow', COLORS.warning);
btnRainbow.addEventListener('click', () => {
    TiTween.killAll();
    TiTween.sequence([
        { target: box2, properties: { backgroundColor: '#EF4444' }, duration: 300 },
        { target: box2, properties: { backgroundColor: '#F59E0B' }, duration: 300 },
        { target: box2, properties: { backgroundColor: '#10B981' }, duration: 300 },
        { target: box2, properties: { backgroundColor: '#3B82F6' }, duration: 300 },
        { target: box2, properties: { backgroundColor: '#8B5CF6' }, duration: 300 },
        { target: box2, properties: { backgroundColor: COLORS.success }, duration: 300 }
    ], { mode: TiTween.SEQUENCE_SERIAL });
});

colorCard.add(createButtonRow([btnBgColor, btnTextColor, btnRainbow]));
controlsContainer.add(colorCard);

// ==========================================
// SECTION 2: TRANSFORM & MOTION
// ==========================================
controlsContainer.add(createSectionHeader('✨ Transform & Motion'));

const transformCard = createCard(
    'Advanced Transforms',
    'Scale, rotation, anchor points, and natural motion'
);

const btnBounce = createButton('Bounce', COLORS.primary);
btnBounce.addEventListener('click', () => {
    TiTween.killAll();
    TiTween.start({
        target: box1,
        properties: { top: 80 },
        duration: 1000,
        easing: TiTween.EASE_OUT_BOUNCE
    });
});

const btnElastic = createButton('Elastic', COLORS.success);
btnElastic.addEventListener('click', () => {
    TiTween.killAll();
    TiTween.start({
        target: box2,
        properties: { scaleX: 1.5, scaleY: 1.5, rotation: 180 },
        duration: 1200,
        easing: TiTween.EASE_OUT_ELASTIC
    });
});

const btnCorner = createButton('Corner Spin', COLORS.warning);
btnCorner.addEventListener('click', () => {
    TiTween.killAll();
    TiTween.sequence([
        { target: box3, properties: { anchorPoint: [0, 1] }, duration: 100 },
        { target: box3, properties: { rotation: 90 }, duration: 600, easing: TiTween.EASE_OUT_BACK },
        { target: box3, properties: { rotation: 0 }, duration: 600, easing: TiTween.EASE_IN_OUT_CUBIC },
        { target: box3, properties: { anchorPoint: [0.5, 0.5] }, duration: 100 }
    ], { mode: TiTween.SEQUENCE_SERIAL });
});

transformCard.add(createButtonRow([btnBounce, btnElastic, btnCorner]));
controlsContainer.add(transformCard);

// ==========================================
// SECTION 3: SHADOW SYSTEM
// ==========================================
controlsContainer.add(createSectionHeader('📦 Shadow System'));

const shadowCard = createCard(
    'Material Design Shadows',
    'Complete shadow control: opacity, radius, offset, color'
);

const btnMaterial = createButton('Material', COLORS.primary);
btnMaterial.addEventListener('click', () => {
    TiTween.killAll();
    box1.layer.shadowOpacity = 0;
    TiTween.start({
        target: box1,
        properties: {
            shadowOpacity: 0.5,
            shadowRadius: 20,
            shadowOffsetY: 12,
            shadowColor: '#000000'
        },
        duration: 800,
        easing: TiTween.EASE_OUT_CUBIC
    });
});

const btnColorShadow = createButton('Colored', COLORS.danger);
btnColorShadow.addEventListener('click', () => {
    TiTween.killAll();
    TiTween.start({
        target: box2,
        properties: {
            shadowOpacity: 0.8,
            shadowRadius: 25,
            shadowOffsetX: 15,
            shadowOffsetY: 15,
            shadowColor: COLORS.danger
        },
        duration: 1000,
        easing: TiTween.EASE_OUT_BACK
    });
});

shadowCard.add(createButtonRow([btnMaterial, btnColorShadow]));
controlsContainer.add(shadowCard);

// ==========================================
// SECTION 4: SEQUENCES
// ==========================================
controlsContainer.add(createSectionHeader('🎬 Sequences'));

const sequenceCard = createCard(
    'Serial & Parallel Animations',
    'Chain multiple animations together'
);

const btnSerial = createButton('Serial', COLORS.primary);
btnSerial.addEventListener('click', () => {
    TiTween.killAll();
    TiTween.sequence([
        { target: box1, properties: { top: 100 }, duration: 400, easing: TiTween.EASE_OUT_QUAD },
        { target: box1, properties: { scaleX: 1.3, scaleY: 1.3 }, duration: 400, easing: TiTween.EASE_OUT_BACK },
        { target: box1, properties: { top: 50, scaleX: 1, scaleY: 1 }, duration: 600, easing: TiTween.EASE_IN_OUT_CUBIC }
    ], { mode: TiTween.SEQUENCE_SERIAL });
});

const btnParallel = createButton('Parallel', COLORS.success);
btnParallel.addEventListener('click', () => {
    TiTween.killAll();
    TiTween.sequence([
        { target: box1, properties: { top: 90 }, duration: 800, easing: TiTween.EASE_OUT_BOUNCE },
        { target: box2, properties: { top: 80, rotation: 180 }, duration: 600, easing: TiTween.EASE_OUT_BACK },
        { target: box3, properties: { top: 70, scaleX: 1.5, scaleY: 1.5 }, duration: 1000, easing: TiTween.EASE_OUT_ELASTIC }
    ], { mode: TiTween.SEQUENCE_PARALLEL });
});

sequenceCard.add(createButtonRow([btnSerial, btnParallel]));
controlsContainer.add(sequenceCard);

// ==========================================
// SECTION 5: PRACTICAL EXAMPLES
// ==========================================
controlsContainer.add(createSectionHeader('💡 Practical Examples'));

const practicalCard = createCard(
    'Real-World Use Cases',
    'Common animation patterns for production apps'
);

const btnPulse = createButton('Pulse', COLORS.primary);
btnPulse.addEventListener('click', () => {
    TiTween.killAll();
    TiTween.sequence([
        { target: box1, properties: { scaleX: 1.2, scaleY: 1.2, opacity: 0.7 }, duration: 400 },
        { target: box1, properties: { scaleX: 1, scaleY: 1, opacity: 1 }, duration: 400 },
        { target: box1, properties: { scaleX: 1.2, scaleY: 1.2, opacity: 0.7 }, duration: 400 },
        { target: box1, properties: { scaleX: 1, scaleY: 1, opacity: 1 }, duration: 400 }
    ], { mode: TiTween.SEQUENCE_SERIAL });
});

const btnShake = createButton('Shake', COLORS.danger);
btnShake.addEventListener('click', () => {
    TiTween.killAll();
    const originalLeft = box2.left;
    TiTween.sequence([
        { target: box2, properties: { left: originalLeft + 10 }, duration: 50 },
        { target: box2, properties: { left: originalLeft - 10 }, duration: 50 },
        { target: box2, properties: { left: originalLeft + 10 }, duration: 50 },
        { target: box2, properties: { left: originalLeft - 10 }, duration: 50 },
        { target: box2, properties: { left: originalLeft }, duration: 50 }
    ], { mode: TiTween.SEQUENCE_SERIAL });
});

const btnFadeOut = createButton('Fade Out', COLORS.textTertiary);
btnFadeOut.addEventListener('click', () => {
    TiTween.killAll();
    TiTween.start({
        target: box3,
        properties: { opacity: 0 },
        duration: 600,
        easing: TiTween.EASE_IN_SINE,
        onComplete: () => {
            setTimeout(() => {
                TiTween.start({
                    target: box3,
                    properties: { opacity: 1 },
                    duration: 600,
                    easing: TiTween.EASE_OUT_SINE
                });
            }, 500);
        }
    });
});

practicalCard.add(createButtonRow([btnPulse, btnShake, btnFadeOut]));
controlsContainer.add(practicalCard);

// ==========================================
// SECTION 6: CONTROLS
// ==========================================
controlsContainer.add(createSectionHeader('⚙️ Controls'));

const controlCard = createCard(
    'Animation Control',
    'Reset all animations or stop everything'
);

const btnReset = createButton('Reset All', COLORS.primary);
btnReset.addEventListener('click', () => {
    TiTween.killAll();
    
    TiTween.sequence([
        {
            target: box1,
            properties: {
                top: 50, left: SPACING.lg, width: 100, height: 100,
                opacity: 1, rotation: 0, scaleX: 1, scaleY: 1,
                backgroundColor: COLORS.primary,
                shadowOpacity: 0.3, shadowRadius: 10, shadowOffsetX: 0, shadowOffsetY: 4,
                zPosition: 0, anchorPoint: [0.5, 0.5]
            },
            duration: 600,
            easing: TiTween.EASE_OUT_CUBIC
        },
        {
            target: box2,
            properties: {
                top: 60, left: SPACING.md, width: 80, height: 80,
                opacity: 1, rotation: 0, scaleX: 1, scaleY: 1,
                backgroundColor: COLORS.success,
                shadowOpacity: 0.3, shadowRadius: 8, shadowOffsetX: 0, shadowOffsetY: 4,
                zPosition: 0
            },
            duration: 600,
            easing: TiTween.EASE_OUT_CUBIC
        },
        {
            target: box3,
            properties: {
                top: 70, left: SPACING.md, width: 60, height: 60,
                opacity: 1, rotation: 0, scaleX: 1, scaleY: 1,
                backgroundColor: COLORS.warning,
                zPosition: 0
            },
            duration: 600,
            easing: TiTween.EASE_OUT_CUBIC
        }
    ], {
        mode: TiTween.SEQUENCE_PARALLEL,
        onComplete: () => {
            demoTextLabel.text = 'Text Animation';
            demoTextLabel.color = COLORS.textPrimary;
            Ti.API.info('✅ All reset!');
        }
    });
});

const btnKillAll = createButton('Kill All', COLORS.danger);
btnKillAll.addEventListener('click', () => {
    TiTween.killAll();
    Ti.API.info('⛔ All animations killed!');
});

controlCard.add(createButtonRow([btnReset, btnKillAll]));
controlsContainer.add(controlCard);

// Bottom padding
const bottomPadding = Ti.UI.createView({
    height: 40,
    width: Ti.UI.FILL
});
controlsContainer.add(bottomPadding);

// ==========================================
// OPEN WINDOW
// ==========================================
win.open();
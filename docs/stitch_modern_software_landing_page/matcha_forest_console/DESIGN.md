---
name: Matcha Forest Console
colors:
  surface: '#0c1510'
  surface-dim: '#0c1510'
  surface-bright: '#323b34'
  surface-container-lowest: '#07100b'
  surface-container-low: '#151e18'
  surface-container: '#19221b'
  surface-container-high: '#232c26'
  surface-container-highest: '#2e3730'
  on-surface: '#dbe5db'
  on-surface-variant: '#bdcabd'
  inverse-surface: '#dbe5db'
  inverse-on-surface: '#29332c'
  outline: '#879488'
  outline-variant: '#3e4a40'
  surface-tint: '#6bdc96'
  primary: '#6bdc96'
  on-primary: '#00391d'
  primary-container: '#48bb78'
  on-primary-container: '#004625'
  inverse-primary: '#006d3c'
  secondary: '#72d7cb'
  on-secondary: '#003732'
  secondary-container: '#34a095'
  on-secondary-container: '#00302b'
  tertiary: '#74db9d'
  on-tertiary: '#00391f'
  tertiary-container: '#53ba7f'
  on-tertiary-container: '#004627'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#88f9b0'
  primary-fixed-dim: '#6bdc96'
  on-primary-fixed: '#00210f'
  on-primary-fixed-variant: '#00522c'
  secondary-fixed: '#8ff4e7'
  secondary-fixed-dim: '#72d7cb'
  on-secondary-fixed: '#00201d'
  on-secondary-fixed-variant: '#005049'
  tertiary-fixed: '#91f8b8'
  tertiary-fixed-dim: '#74db9d'
  on-tertiary-fixed: '#002110'
  on-tertiary-fixed-variant: '#00522f'
  background: '#0c1510'
  on-background: '#dbe5db'
  surface-variant: '#2e3730'
typography:
  display:
    fontFamily: Geist
    fontSize: 40px
    fontWeight: '600'
    lineHeight: 48px
    letterSpacing: -0.03em
  headline-lg:
    fontFamily: Geist
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
    letterSpacing: -0.025em
  headline-lg-mobile:
    fontFamily: Geist
    fontSize: 26px
    fontWeight: '600'
    lineHeight: 34px
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Geist
    fontSize: 24px
    fontWeight: '500'
    lineHeight: 32px
    letterSpacing: -0.02em
  headline-sm:
    fontFamily: Geist
    fontSize: 18px
    fontWeight: '500'
    lineHeight: 26px
    letterSpacing: -0.015em
  body-lg:
    fontFamily: Geist
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
    letterSpacing: -0.01em
  body-md:
    fontFamily: Geist
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
    letterSpacing: -0.005em
  body-sm:
    fontFamily: Geist
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 18px
    letterSpacing: '0'
  code-md:
    fontFamily: JetBrains Mono
    fontSize: 13px
    fontWeight: '400'
    lineHeight: 20px
    letterSpacing: -0.01em
  code-sm:
    fontFamily: JetBrains Mono
    fontSize: 11px
    fontWeight: '400'
    lineHeight: 16px
    letterSpacing: '0'
  label-md:
    fontFamily: JetBrains Mono
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.02em
  label-sm:
    fontFamily: JetBrains Mono
    fontSize: 10px
    fontWeight: '500'
    lineHeight: 14px
    letterSpacing: 0.04em
rounded:
  sm: 0.125rem
  DEFAULT: 0.25rem
  md: 0.375rem
  lg: 0.5rem
  xl: 0.75rem
  full: 9999px
spacing:
  gutter: 1rem
  gutter-desktop: 1.5rem
  margin: 1rem
  margin-tablet: 1.5rem
  margin-desktop: 2rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 0.75rem
  space-lg: 1.25rem
  space-xl: 2rem
---

## Brand & Style

This design system expresses a refined, focused, and high-performance technical developer environment. Rooted in deep forest tones, mossy obsidian surfaces, and luminous matcha accents, it bridges organic calm with rigorous computational precision.

The emotional goal is quiet velocity and reduced cognitive fatigue during sustained monitoring, debugging, and terminal operations. Instead of cold, sterile carbon-blacks or harsh synthetics, the interface leverages rich chlorophyll-tinged darks that feel grounded and tactile.

The design movement combines **Modern Technical Minimalism** with **Atmospheric Layering**:
- Precise 1px micro-borders to demarcate dense information zones without visual bloat.
- Restrained, deliberate matcha luminescence deployed exclusively for system state, execution progress, and high-order actions.
- Density-first architecture optimized for code blocks, telemetry charts, stream logs, and multi-pane developer workflows.

## Colors

The palette employs deep mossy slate foundations paired with high-efficiency luminescent matcha and teal-mint accents.

### Palette Architecture
- **Canvas Base (`#0d1410`)**: Root foundation for terminal backdrops, root canvas, and inset shells.
- **Surface Elevation 1 (`#131c16`)**: Default component container background, navigation panels, and toolbars.
- **Surface Elevation 2 (`#1a251f`)**: Raised panels, cards, dropdowns, contextual popovers.
- **Surface Elevation 3 (`#223028`)**: Active hover states, interactive node backgrounds, modal windows.
- **Borders & Dividers (`#2d3e33`)**: Structural containment lines, grid column dividers, micro-separators.
- **Primary Matcha (`#48bb78`)**: Active triggers, focused inputs, active branch labels, primary CTAs.
- **Matcha High-Light (`#68d391`)**: Interactive hover states, glowing indicators, telemetry spikes.
- **Secondary Mint Cyan (`#81e6d9`)**: Auxiliary telemetry, query keywords, secondary badge identifiers.
- **Text Primary (`#e6f4ea`)**: Crisp high-legibility display headers, log output values, active labels.
- **Text Secondary / Muted (`#a7c4b5`)**: Metadata, table headers, inactive panel labels, timestamp keys.
- **Text Inactive / Tertiary (`#5f7a6c`)**: Structural syntax tokens, disabled controls, line numbers.

## Typography

The type hierarchy couples the hyper-clean proportional grotesque **Geist** for natural reading, navigational headers, and structural UI with **JetBrains Mono** for all telemetry, code streams, status metrics, and micro-labels.

### Implementation Rules
- Always use `JetBrains Mono` for IDs, commit hashes, ports, latency stats, memory addresses, and status badges.
- Strict optical baseline alignment: when pairing numeric telemetry alongside body prose, ensure mono characters match the `body-md` or `body-sm` cap height.
- Code blocks must maintain a minimum 1.5 relative line-height to guarantee high scan efficiency across stack traces and configuration files.

## Layout & Spacing

The layout operates on a strict 4px/8px modular cadence configured for dense multi-pane workstation workflows. 

### Grid & Breakpoints
- **Desktop (>= 1280px)**: Fluid multi-panel frame spanning up to 1600px max width or full-bleed split view (terminal/editor/inspector). 12-column layout with `gutter-desktop` (24px) and `margin-desktop` (32px).
- **Tablet (768px - 1279px)**: 8-column layout with collapsable auxiliary sidebar. Gutters shift to `gutter` (16px), margins to `margin-tablet` (24px).
- **Mobile (< 768px)**: 4-column stacked architecture. Navigation collapses into an off-canvas drawer or bottom app sheet. Lateral margin compresses to `margin` (16px).

### Spacing Rules
- Dense telemetry panels, table cells, and code rows strictly utilize `space-xs` (4px) and `space-sm` (8px).
- Form blocks, configuration panels, and terminal cards rely on `space-md` (12px) for internal padding.
- Section modules use `space-lg` (20px) and `space-xl` (32px) for structural separation.

## Elevation & Depth

Visual hierarchy does not rely on heavy drop shadows; rather, it uses a system of **tonal surface stratification** and **subtle low-contrast borders** combined with localized matcha illumination.

### Tonal Stratification
1. **Level 0 (Base Canvas - `#0d1410`)**: Bottom layer for the terminal viewport, code editor background, and overall workspace void.
2. **Level 1 (Docked Containers - `#131c16`)**: Persistent elements such as sidebars, persistent logs, filter ribbons, and card bodies. Outlined with `1px solid #2d3e33`.
3. **Level 2 (Active/Floating Surfaces - `#1a251f`)**: Tooltips, context menus, combobox dropdowns, and draggable panels. Bordered by `1px solid #38a169` at 30% opacity with ambient shadow: `0 8px 24px rgba(0, 0, 0, 0.45)`.
4. **Level 3 (Modals & Overlays - `#223028`)**: Critical dialogs and query editors. Outlined with `1px solid #48bb78` at 40% opacity with ambient shadow: `0 16px 40px rgba(13, 20, 16, 0.8)`.

### Luminescent Glows
Focused states, active build bars, and live health monitors cast a soft ambient green glow:
- Focus ring: `0 0 0 1px #48bb78, 0 0 12px rgba(72, 187, 120, 0.25)`.
- Live status indicator: `0 0 8px rgba(104, 211, 145, 0.6)`.

## Shapes

The design system embraces a **Soft (Level 1)** geometric geometry. Corners are tightly clipped to reinforce an engineered, high-precision aesthetic suitable for dense data and telemetry.

### Radius Assignments
- **Micro UI (`2px`)**: Inline status dots, sub-tags, code badges, scrollbar thumbs.
- **Default Base (`4px` / `0.25rem`)**: Standard buttons, input fields, checkboxes, table cell selectors, tab triggers.
- **Containers (`8px` / `0.5rem`)**: Telemetry cards, code editor shells, modal wrappers, logs terminals.
- **Pill (`9999px`)**: Reserved exclusively for dynamic status pips, avatar fallbacks, and connection state badges.

## Components

### Buttons
- **Primary**: Background `#48bb78`, text `#0d1410`, font `JetBrains Mono` 500 weight. Hover: `#68d391` with subtle glow `0 0 14px rgba(72, 187, 120, 0.35)`. Active: `#38a169`.
- **Secondary / Ghost**: Background `#1a251f`, border `1px solid #2d3e33`, text `#e6f4ea`. Hover: border `#48bb78` (60%), background `#223028`.
- **Danger**: Background transparent, border `1px solid #e53e3e`, text `#fc8181`. Hover: background `rgba(229, 62, 62, 0.12)`.

### Chips & Status Badges
- Displayed in `JetBrains Mono` uppercase micro-type (`label-sm`).
- **Live / Healthy**: Background `rgba(72, 187, 120, 0.12)`, border `1px solid rgba(72, 187, 120, 0.3)`, text `#68d391`. Includes a 6px pulsing dot with shadow `0 0 6px #48bb78`.
- **Degraded / Running**: Background `rgba(129, 230, 217, 0.12)`, border `1px solid rgba(129, 230, 217, 0.3)`, text `#81e6d9`.
- **Inactive / Stopped**: Background `#131c16`, border `1px solid #2d3e33`, text `#a7c4b5`.

### Input Fields & Search Bars
- Background `#0d1410`, border `1px solid #2d3e33`, text `#e6f4ea`, placeholder `#5f7a6c`.
- Focus state: border `#48bb78`, box-shadow `0 0 0 1px #48bb78, 0 0 10px rgba(72, 187, 120, 0.2)`.
- Monospace mode: Built-in prefix glyphs (`>`, `$`, `λ`) rendered in `#48bb78`.

### Checkboxes & Switches
- **Checkboxes**: 16x16px, background `#0d1410`, border `1px solid #2d3e33`, radius 2px. Checked: background `#48bb78`, icon mark `#0d1410`.
- **Switches**: 32x18px track in `#1a251f` with `1px solid #2d3e33`. Toggle thumb: 14x14px `#a7c4b5`. Active state: track `#223028`, border `#48bb78`, thumb `#48bb78` with green luminescence.

### Data Tables & Log Streams
- Alternating subtle row striping optional; default uses pure row separation with `1px solid #1a251f`.
- Table header: `JetBrains Mono` label-sm in `#a7c4b5`, border-bottom `1px solid #2d3e33`, background `#131c16`.
- Log stream view: Full dark `#0d1410`, timestamp column in `#5f7a6c`, line numbers right-aligned in `#2d3e33`, active execution highlights highlighted with border-left `2px solid #48bb78`.

### Telemetry Cards
- Background `#131c16`, border `1px solid #2d3e33`, radius `8px`.
- Card header features integrated action menu and metric sparkline rendered in primary matcha `#48bb78` with a vertical gradient fading to transparent.
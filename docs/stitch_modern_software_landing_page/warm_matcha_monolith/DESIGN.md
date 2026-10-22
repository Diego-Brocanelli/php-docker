---
name: Warm Matcha Monolith
colors:
  surface: '#fff9ee'
  surface-dim: '#e0d9cd'
  surface-bright: '#fff9ee'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#faf3e6'
  surface-container: '#f4ede0'
  surface-container-high: '#eee8db'
  surface-container-highest: '#e8e2d5'
  on-surface: '#1e1b14'
  on-surface-variant: '#414942'
  inverse-surface: '#333028'
  inverse-on-surface: '#f7f0e3'
  outline: '#717971'
  outline-variant: '#c1c9c0'
  surface-tint: '#3b684a'
  primary: '#144227'
  on-primary: '#ffffff'
  primary-container: '#2d5a3d'
  on-primary-container: '#9ed0ab'
  inverse-primary: '#a1d2ad'
  secondary: '#3f665c'
  on-secondary: '#ffffff'
  secondary-container: '#bee8dc'
  on-secondary-container: '#436a60'
  tertiary: '#1f412a'
  on-tertiary: '#ffffff'
  tertiary-container: '#365840'
  on-tertiary-container: '#a7cdae'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#bceec8'
  primary-fixed-dim: '#a1d2ad'
  on-primary-fixed: '#00210f'
  on-primary-fixed-variant: '#224f33'
  secondary-fixed: '#c1ebdf'
  secondary-fixed-dim: '#a6cfc3'
  on-secondary-fixed: '#00201a'
  on-secondary-fixed-variant: '#274e45'
  tertiary-fixed: '#c5eccc'
  tertiary-fixed-dim: '#aad0b1'
  on-tertiary-fixed: '#00210e'
  on-tertiary-fixed-variant: '#2c4e36'
  background: '#fff9ee'
  on-background: '#1e1b14'
  surface-variant: '#e8e2d5'
typography:
  display:
    fontFamily: Geist
    fontSize: 3.5rem
    fontWeight: '600'
    lineHeight: 4rem
    letterSpacing: -0.04em
  display-mobile:
    fontFamily: Geist
    fontSize: 2.25rem
    fontWeight: '600'
    lineHeight: 2.75rem
    letterSpacing: -0.03em
  headline-lg:
    fontFamily: Geist
    fontSize: 2.25rem
    fontWeight: '600'
    lineHeight: 2.75rem
    letterSpacing: -0.03em
  headline-lg-mobile:
    fontFamily: Geist
    fontSize: 1.75rem
    fontWeight: '600'
    lineHeight: 2.25rem
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Geist
    fontSize: 1.5rem
    fontWeight: '500'
    lineHeight: 2rem
    letterSpacing: -0.02em
  headline-sm:
    fontFamily: Geist
    fontSize: 1.25rem
    fontWeight: '500'
    lineHeight: 1.75rem
    letterSpacing: -0.015em
  body-lg:
    fontFamily: Geist
    fontSize: 1.125rem
    fontWeight: '400'
    lineHeight: 1.75rem
    letterSpacing: -0.01em
  body-md:
    fontFamily: Geist
    fontSize: 0.9375rem
    fontWeight: '400'
    lineHeight: 1.5rem
    letterSpacing: -0.005em
  body-sm:
    fontFamily: Geist
    fontSize: 0.8125rem
    fontWeight: '400'
    lineHeight: 1.25rem
    letterSpacing: 0em
  code-inline:
    fontFamily: JetBrains Mono
    fontSize: 0.8125rem
    fontWeight: '400'
    lineHeight: 1.25rem
    letterSpacing: 0em
  code-block:
    fontFamily: JetBrains Mono
    fontSize: 0.875rem
    fontWeight: '400'
    lineHeight: 1.5rem
    letterSpacing: 0em
  label-md:
    fontFamily: JetBrains Mono
    fontSize: 0.8125rem
    fontWeight: '500'
    lineHeight: 1rem
    letterSpacing: 0.02em
  label-sm:
    fontFamily: JetBrains Mono
    fontSize: 0.6875rem
    fontWeight: '500'
    lineHeight: 0.875rem
    letterSpacing: 0.04em
rounded:
  sm: 0.125rem
  DEFAULT: 0.25rem
  md: 0.375rem
  lg: 0.5rem
  xl: 0.75rem
  full: 9999px
spacing:
  gutter: 1.25rem
  gutter-mobile: 0.75rem
  margin: 2rem
  margin-mobile: 1rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2.5rem
---

## Brand & Style

This design system synthesizes the warmth and deliberate craftsmanship of heritage publishing with the precision, density, and utilitarian discipline of next-generation developer tooling. It bridges tactile organic materiality and technical execution: a tactile parchment console engineered for sustained focus, high code readability, and quiet authority.

### Target Audience & Emotional Intent
Built for engineers, technical architects, and product builders who operate in code and data consoles for hours at a time. The interface deliberately departs from cold synthetic blues and sterile grays, cultivating an emotional atmosphere of focused calm, organic tactile grounding, and surgical precision. 

### Design Philosophy
The aesthetic unifies **Organic Minimalism** with **Technical Precision**:
- **Parchment Surface Tiers:** Layered warm papers replace synthetic white and harsh charcoal, reducing ocular strain across long sessions.
- **Matcha Botanicals:** Deep botanical greens (#2D5A3D, #3B6E4C) replace traditional terminal cyan or electric blues for primary interactive cues, code tokens, and system states.
- **Surgical Grid Discipline:** Borders are razor-thin, hair-line low-contrast rules that structure information with the density of technical blueprints and editorial tables.

## Colors

The palette draws entirely from natural parchment tones, botanical chlorophylls, and deep mineral carbon. Contrast ratios exceed WCAG AAA standards for text against all parchment layers.

### Color Hierarchy & Roles
- **Base Canvas (`#FAF7F2`):** Primary window backdrop representing warm virgin vellum.
- **Surface Elevation 1 (`#F4EFE6`):** Card panels, sidebar navigation, and contained groupings.
- **Surface Elevation 2 / Borders (`#EAE3D2`):** Interactive inputs, nested cells, code block backgrounds, and hair-line structure lines.
- **Deep Mineral Charcoal (`#3E3B32`):** Primary typography, high-priority icons, and structural anchors. Replaces raw pitch black (#000000) to eliminate chromatic aberration against cream.
- **Primary Deep Matcha (`#2D5A3D`):** Primary action buttons, active indicator pills, primary syntax variables, and selected tabs.
- **Secondary Sage (`#52796F`):** Secondary controls, interactive hovered states, and code block tags.
- **Tertiary Soft Matcha (`#84A98C`):** Subdued badges, diff-insert backgrounds, telemetry graphs, and subtle borders.
- **Muted Umber (`#767165`):** Secondary meta-text, placeholder values, and timestamp indicators.

### Application Rules
Never layer pure white (`#FFFFFF`) or cold gray (`#F3F4F6`) into this system. Pure white creates an unintentional glare artifact against parchment. For code blocks and data displays, use `#F4EFE6` with an `#EAE3D2` border for light-mode terminals, preserving warm cohesion across both prose and monospaced readouts.

## Typography

The typography pairs **Geist** for structural prose and interface hierarchy with **JetBrains Mono** for developer metrics, navigation metadata, and code inspection.

### Hierarchy & Usage
- **Display & Headings:** Geist with tighter letter tracking (-0.02em to -0.04em) brings a chiselled, technical presence to dashboards and documentation intros.
- **Body:** Geist at 15px (0.9375rem) serves as the primary data and copy size, yielding balanced scanning speeds without ocular clutter.
- **Data & Microcopy:** JetBrains Mono is mandatory for all interface badges, metric counters, runtime indicators, status stamps, table columns, and terminal payloads. Monospaced tabular alignment guarantees predictable horizontal rhythms across streaming console logs.

## Layout & Spacing

The layout is grounded in a flexible 12-column console grid that scales between wide analytical monitors and compact mobile inspect-sheets.

### Grid & Density
- **Desktop (1024px+):** 12-column fluid grid. Max container width capped at 1440px for readable documentation and console traces. Gutter is `1.25rem` (20px), outer margins are `2rem` (32px).
- **Tablet (768px - 1023px):** 8-column layout. Split views collapse into stacked dock panels. Gutter remains `1.25rem`, outer margins are `1.5rem`.
- **Mobile (< 768px):** 4-column layout. Margins compress to `1rem` (16px), and gutters to `0.75rem` (12px). Sidebars become sliding bottom sheets.

### Spacing Principles
Vertical rhythm strictly follows multiples of `0.25rem` (4px base unit). Console panels and telemetry strips favor compact padding (`space-xs` and `space-sm`) to maximize visible information per viewport, while editorial documentation relies on `space-lg` and `space-xl` to ensure cognitive ease.

## Elevation & Depth

This system rejects floating blur dropshadows in favor of an **architectural planar model**: depth is created purely through warm paper tonal stacking and crisp, hair-line boundary borders.

### Elevation Layers
- **Elevation 0 (Base Bed):** `#FAF7F2` (Parchment vellum). Used for the overarching root viewport.
- **Elevation 1 (Panels & Shell):** `#F4EFE6` with a solid 1px border of `#EAE3D2`. Used for primary workbenches, sidebars, query editors, and cards.
- **Elevation 2 (Floating Popovers, Dropdowns & Modals):** `#FAF7F2` surface, flanked by a 1px solid border of `#3B6E4C` (at 20% opacity) combined with a warm ambient shadow: `0 8px 24px -4px rgba(62, 59, 50, 0.08)`. The shadow is tinted with the neutral umber pigment rather than neutral black, maintaining paper materiality.
- **Elevation Inset (Terminals, Log Windows, Input Trays):** `#EAE3D2` at 50% opacity, bordered with 1px `#EAE3D2`. Gives sunken dimensional depth suitable for data input and console output.

## Shapes

The interface adopts a **Soft Geometric (Level 1)** posture. In an information-dense developer console, large border radii waste screen territory and distort visual alignment. 

### Geometric Rationale
- Standard interactive elements (buttons, badge tags, input fields) use `0.25rem` (4px).
- Containers, card panels, code panes, and modal dialogs use `0.5rem` (8px).
- Inner elements nested inside cards always use `0.25rem` to preserve concentric mathematical balance.
- Circular radii (`rounded-full`) are strictly restricted to status avatar indicators, network ping dots, and live runtime beacons.

## Components

### Buttons
- **Primary:** Background `#2D5A3D`, text `#FAF7F2`, font `JetBrains Mono` 13px weight 500. Hover transitions to `#3B6E4C`. Active state settles on `#1F3E2B`.
- **Secondary:** Background `#F4EFE6`, border 1px solid `#EAE3D2`, text `#3E3B32`. Hover: border color turns to `#84A98C`, background changes to `#FAF7F2`.
- **Ghost / Utility:** Transparent background, text `#52796F`. Hover: background `#EAE3D2` at 40% opacity.

### Input Fields & Controls
- **Text Inputs:** Background `#FAF7F2`, border 1px solid `#EAE3D2`, text `#3E3B32`, placeholder `#767165`. Focus ring: 1px border `#2D5A3D` with an offset outline of 2px `#84A98C` at 30% opacity.
- **Checkboxes & Radios:** 16x16px boxes. Unchecked: 1px border `#767165` on `#FAF7F2`. Checked: Solid `#2D5A3D` fill with `#FAF7F2` geometric checkmark. Radius for checkboxes is 3px.

### Cards & Code Panes
- **Card Shell:** Background `#F4EFE6`, border 1px solid `#EAE3D2`, padding `space-md` (16px).
- **Code Block / Console Cell:** Header strip `#EAE3D2` (height 32px, `JetBrains Mono` label-sm text in `#3E3B32`), interior body `#FAF7F2`, left line-number rail in `#767165` with a vertical 1px divider in `#EAE3D2`.

### Chips & Badges
- **Status Pills:** Background `#FAF7F2`, border 1px solid `#84A98C`, text `#2D5A3D`, font `JetBrains Mono` 11px uppercase with `0.04em` tracking.
- **Metric Tag:** Background `#EAE3D2`, text `#3E3B32`, rounded 4px, padding 2px 6px.

### Key-Value Data Lists
- Alternating subtle rows: Even rows `#FAF7F2`, odd rows `#F4EFE6`.
- Row borders: 1px bottom border `#EAE3D2`.
- Keys set in `Geist` regular `#767165`; values set in `JetBrains Mono` `#3E3B32`.
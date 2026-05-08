# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

AAST Smart Parking System — a mobile-first React/TypeScript web app (390×844 px viewport) for managing parking spot reservations at AAST. Generated from Figma (Design to Code via Figma Make). The UI is complete but has no backend integration; forms and navigation are purely client-side.

Original Figma design: https://www.figma.com/design/tLHT7Wo8RTXhx8XdJyQHYf/AAST-Smart-Parking-System

## Commands

```bash
# Install dependencies
npm i

# Start dev server (Vite, default port :5173)
npm run dev

# Production build
npm run build
```

No test runner or linter is configured.

## Architecture

### Entry Chain

`index.html` → `src/main.tsx` → `src/app/App.tsx` (React Router v7 routes)

### App Modes

`App.tsx` supports two rendering modes toggled at the top of the file:
- **Grid mode** — renders all 12 screens side-by-side for design review
- **Interactive mode** — single-screen navigation, default route redirects `/` → `/login`

### Screens (`src/app/screens/`)

12 screens cover the full user journey: `SplashScreen` → `LoginScreen` / `RegisterScreen` → `HomeScreen` → `MapScreen` → `SpotDetailsScreen` → `BookingScreen` → `ConfirmationScreen`, plus `BookingsScreen`, `WaitingListScreen`, `NotificationsScreen`, `ProfileScreen`.

### Navigation

`BottomNav.tsx` provides the 4-tab persistent navigation (Home, Map, Bookings, Profile). `MobileContainer.tsx` constrains the viewport to 390×844 px and centers it on wider screens.

### Styling System

- **Tailwind CSS v4** (configured via `@tailwindcss/vite` plugin — no separate config file)
- **Design tokens** live in `src/styles/theme.css` as CSS custom properties
- Key brand colors: Primary `#2563eb`, Available `#10b981`, Reserved `#f59e0b`, Occupied `#ef4444`
- Dark mode is supported via the OkLCH color space variables in `theme.css`
- `src/styles/index.css` imports all style partials in order

### Components

- `src/app/components/ui/` — 45+ shadcn/ui components (Radix UI primitives); edit these only if a component needs project-specific behavior
- `src/app/components/figma/ImageWithFallback.tsx` — image component with SVG placeholder fallback
- Icons come from `lucide-react`; additional icons from `@mui/icons-material`

### Asset Imports

Vite is configured with a custom plugin that resolves `figma:asset/` prefixed imports to local files. Static assets (logos) live in `src/imports/`. SVG and CSV files are imported as raw strings.

`@` is aliased to `./src`.

## Key Dependencies

| Package | Purpose |
|---|---|
| `react-hook-form` | Form state & validation |
| `sonner` | Toast notifications |
| `motion` | Animations |
| `recharts` | Data charts |
| `date-fns` | Date formatting |
| `react-dnd` | Drag-and-drop |
| `@mui/material` | Additional UI components |

## Adding New Screens

1. Create `src/app/screens/YourScreen.tsx`
2. Add a route in `App.tsx`
3. If it needs bottom navigation, it's already rendered by `MobileContainer` — no extra work needed

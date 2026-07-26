# Sasheco Dashboard UI Specifications

## Overview
This document outlines the UI specifications for the `sasheco_dashboard_web` application, adhering to WCAG guidelines and utilizing a glassmorphic design system.

## Design Tokens
- **Colors**: Defined in `lib/core/theme/app_colors.dart`. Includes high contrast combinations for WCAG AAA/AA compliance. 
- **Typography**: Defined in `lib/core/theme/app_typography.dart`. Uses `Inter` Google font mapped to Material 3 tokens.
- **Spacing**: Defined in `lib/core/theme/app_spacing.dart`. Uses an 8pt grid system.

## Accessibility (WCAG Compliance)
- **Contrast**: All text over the glass backgrounds must maintain at least a 4.5:1 contrast ratio (AA) for normal text and 3:1 for large text.
- **Touch Targets**: All interactive elements (buttons, form fields, icon buttons) have a minimum touch target size of 48x48dp.
- **Semantics**: Utilize Flutter's `Semantics` widget for critical paths, especially forms and data tables.

## Screen Layout Specs

### 1. Dashboard
- **Background**: Dynamic or gradient background (underneath the glass layers).
- **Layout**: 
  - Side Navigation (Fixed width: 280dp on Desktop, Drawer on Mobile).
  - Main Content Area (Scrollable, max-width constrained for ultra-wide screens to 1200dp).
- **Widgets**:
  - `GlassContainer` used for summary cards (KPIs, metrics).
  - Cards should have `AppSpacing.md` (16dp) padding.
  - Empty states for charts/graphs must show a clear illustration and text message.

### 2. Data Tables
- **Container**: Wrapped in a `GlassContainer` with `AppSpacing.radiusLG` (16dp).
- **Headers**: Sticky headers with `titleSmall` typography, `textSecondary` color.
- **Rows**: 
  - Hover effects on web (subtle background color change).
  - Status pills (Success/Warning/Error) for contract statuses.
- **Pagination**: Positioned at the bottom right of the table container.
- **Empty State**: Centered text "No data available" with an action button (e.g., "Add New").

### 3. Forms (Contract Creation, Profile)
- **Layout**: Centered within a `GlassContainer` or side-drawer pane. Max width of 600dp for readability.
- **Input Fields**:
  - Use `AppTheme`'s `inputDecorationTheme` (filled, 0.2 opacity white background).
  - Active/Focus state highlighted with `AppColors.primary` border.
  - Error state clearly marked with `AppColors.error` border and text.
- **Validation**: Inline error text appearing below the input field.
- **Submission**: Primary action button (ElevatedButton, pill-shaped) at the bottom, aligned right. Disabled state should be visually distinct (opacity reduced, color desaturated).

## Edge States
- **Loading**: Use shimmer effects for data tables and dashboard cards instead of infinite spinners when possible.
- **Offline/Error**: A global snackbar or banner indicating network loss. Empty state graphics for failed data loads.
- **Text Overflow**: Use `TextOverflow.ellipsis` on table columns, and provide tooltips for truncated text.

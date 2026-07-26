## Design System: SASHECO Web Dashboard (Glassmorphism)

### Pattern
- **Name:** Glassmorphism Web App
- **Layout:** Desktop/Web first. Sidebar navigation on the left, main content area on the right. Large, spacious layouts.
- **Style:** Frosted glass panels over abstract, colorful backgrounds (blobs of orange, soft yellow, and light gray). The panels are translucent with soft borders.
- **Controls:** Pill-shaped buttons, rounded input fields with translucent backgrounds. Use the provided brand colors for primary actions and accents.

### Colors
| Role | Hex | CSS Variable |
|------|-----|--------------|
| Primary | `#1C2B54` | `--color-primary` |
| On Primary | `#FFFFFF` | `--color-on-primary` |
| Secondary/Accent| `#F3C340` | `--color-accent` |
| Background | `#FDFDFD` | `--color-background` |
| Glass Panel | `rgba(255, 255, 255, 0.45)` | `--color-glass` |
| Glass Border | `rgba(255, 255, 255, 0.3)` | `--color-glass-border` |
| Text Primary | `#1C2B54` | `--color-text-primary` |
| Text Secondary| `#4A5568` | `--color-text-secondary` |

### Typography
- **Heading:** Poppins, modern and geometric
- **Body:** Inter or Roboto
- **Mood:** Modern, premium, airy, professional

### Key Effects
- **Glassmorphism:** Use `backdrop-filter: blur(24px)` on panels. Background of panels should be `rgba(255, 255, 255, 0.45)`. Borders should be `1px solid rgba(255, 255, 255, 0.3)`. Box shadow `0 8px 32px rgba(0, 0, 0, 0.05)`. Ensure background elements (abstract color blobs) are visible through the frosted glass.
- **Corners:** High border-radius for panels (`24px` or `32px`), buttons (`9999px` / pill-shaped), and inputs (`16px`).

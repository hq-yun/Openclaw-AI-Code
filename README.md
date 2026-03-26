# Tetris - Classic HTML5 Game

A fully functional Tetris game built with pure HTML5, CSS3, and JavaScript. Features a modern dark theme, smooth animations, and responsive design.

![Tetris Game](./screenshot.png)

## Features

### Core Gameplay
- **7 Standard Tetromino Pieces**: I, O, T, S, Z, J, L - each with unique colors
- **Piece Rotation**: 90-degree clockwise rotation with wall-kick support
- **Ghost Piece**: Visual indicator showing where the piece will land
- **Line Clearing**: Remove completed lines for points
- **Level Progression**: Speed increases every 10 lines cleared
- **Next Piece Preview**: See what's coming next

### Scoring System
| Action | Points (Base) |
|--------|---------------|
| Single Line | 100 |
| Double Lines | 300 |
| Triple Lines | 500 |
| Tetris (4 lines) | 800 |
| Soft Drop | 1 per cell |
| Hard Drop | 2 per cell |

### Controls
| Key | Action |
|-----|--------|
| ← → | Move left/right |
| ↑ | Rotate piece |
| ↓ | Soft drop (faster fall) |
| Space | Hard drop (instant) |
| P | Pause/Resume |
| Enter | Start/Restart game |

### Additional Features
- **Pause/Resume**: Press P or use the Pause button
- **Touch Controls**: Swipe on mobile devices
- **Responsive Design**: Works on desktop and mobile
- **Modern UI**: Dark theme with gradient effects
- **Smooth Animations**: Line clear and level-up effects

## Project Structure

```
Tetris/
├── index.html          # Main HTML file
├── README.md           # This documentation
├── css/
│   └── style.css       # Game styles and animations
├── js/
│   ├── game.js         # Main game logic
│   └── pieces.js       # Tetromino definitions and rotation
├── .gitignore          # Git ignore file
└── deploy.sh           # Deployment script
```

## Getting Started

### Running Locally

1. Clone or download this repository
2. Open `index.html` in a modern web browser
3. Click "Start Game" to begin playing!

No build process or dependencies required - just open the HTML file!

### Browser Support

- Chrome 90+
- Firefox 88+
- Safari 14+
- Edge 90+

## Technical Details

### Game Architecture

The game is built using vanilla JavaScript with no external frameworks:

- **Game Loop**: Uses `requestAnimationFrame` for smooth 60fps rendering
- **Canvas Rendering**: HTML5 Canvas for high-performance graphics
- **State Management**: Simple state object for game control
- **Collision Detection**: Grid-based collision system with wall kicks

### Key Components

#### pieces.js
Defines all tetromino shapes, colors, and rotation logic:
- Shape matrices for each piece type
- Wall-kick algorithm for rotation near boundaries
- Random piece generation using bag system

#### game.js
Main game engine handling:
- Board management (10x20 grid)
- Movement and collision detection
- Line clearing and scoring
- Level progression
- UI updates

### Scoring Formula
```
Score = Base Points × Level
```
Where base points depend on lines cleared in single action.

## Deployment

### GitHub Pages

1. Push code to GitHub repository
2. Go to Settings → Pages
3. Select branch and folder (usually `main` root)
4. Your game will be available at `https://username.github.io/repo-name/`

### Manual Deployment

Use the included `deploy.sh` script:

```bash
chmod +x deploy.sh
./deploy.sh
```

This will:
- Create a dist folder with optimized files
- Initialize git in the dist folder
- Commit and push to the gh-pages branch

## Development

### Building Features

The codebase is designed for easy extension:

1. **Adding Custom Pieces**: Edit `pieces.js` TETROMINOS object
2. **Customizing Colors**: Modify color values in pieces.js or CSS
3. **Adjusting Speed**: Change DROP_INTERVAL or level progression in game.js

### Code Style

- ES6+ JavaScript syntax
- Modular function design
- Comprehensive JSDoc comments
- Clean separation of concerns (pieces vs game logic)

## License

This project is open source and available for educational purposes.

## Credits

Built with HTML5 Canvas, CSS3, and Vanilla JavaScript. Inspired by the classic Tetris game created by Alexey Pajitnov in 1984.

---

**Enjoy playing!** If you encounter any issues or have suggestions for improvement, feel free to contribute.

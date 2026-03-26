/**
 * Tetris Game Logic
 * Main game engine handling board management, piece movement, collision detection,
 * line clearing, scoring, and game state management
 */

// Game constants
const COLS = 10;
const ROWS = 20;
const BLOCK_SIZE = 30;
const NEXT_BLOCK_SIZE = 25;

// Scoring system (standard Tetris scoring)
const SCORES = {
    SINGLE: 100,
    DOUBLE: 300,
    TRIPLE: 500,
    TETRIS: 800,
    SOFT_DROP: 1,
    HARD_DROP: 2
};

// Game state
let board = [];
let currentPiece = null;
let nextPiece = null;
let score = 0;
let level = 1;
let lines = 0;
let gameOver = false;
let isPaused = false;
let dropInterval = 1000;
let lastDropTime = 0;
let animationId = null;

// Canvas elements
const canvas = document.getElementById('gameCanvas');
const ctx = canvas.getContext('2d');
const nextCanvas = document.getElementById('nextCanvas');
const nextCtx = nextCanvas.getContext('2d');

// UI elements
const scoreElement = document.getElementById('score');
const levelElement = document.getElementById('level');
const linesElement = document.getElementById('lines');
const overlay = document.getElementById('overlay');
const overlayTitle = document.getElementById('overlay-title');
const overlayMessage = document.getElementById('overlay-message');
const startBtn = document.getElementById('start-btn');
const pauseBtn = document.getElementById('pause-btn');
const restartBtn = document.getElementById('restart-btn');

/**
 * Initialize the game board
 */
function initBoard() {
    board = [];
    for (let row = 0; row < ROWS; row++) {
        board[row] = [];
        for (let col = 0; col < COLS; col++) {
            board[row][col] = null;
        }
    }
}

/**
 * Draw a single block on canvas
 * @param {CanvasRenderingContext2D} context - Canvas context
 * @param {number} x - X position (grid coordinate)
 * @param {number} y - Y position (grid coordinate)
 * @param {string} color - Block color
 * @param {number} blockSize - Size of each block
 * @param {boolean} isNext - Whether this is for the next piece preview
 */
function drawBlock(context, x, y, color, blockSize, isNext = false) {
    const size = isNext ? NEXT_BLOCK_SIZE : BLOCK_SIZE;
    const padding = 1;

    // Main block fill with gradient
    const gradient = context.createLinearGradient(
        x * size + padding, y * size + padding,
        (x + 1) * size - padding, (y + 1) * size - padding
    );
    gradient.addColorStop(0, lightenColor(color, 30));
    gradient.addColorStop(0.5, color);
    gradient.addColorStop(1, darkenColor(color, 20));

    context.fillStyle = gradient;
    context.fillRect(
        x * size + padding,
        y * size + padding,
        size - padding * 2,
        size - padding * 2
    );

    // Inner highlight
    context.fillStyle = 'rgba(255, 255, 255, 0.3)';
    context.fillRect(
        x * size + padding,
        y * size + padding,
        size - padding * 2,
        2
    );
    context.fillRect(
        x * size + padding,
        y * size + padding,
        2,
        size - padding * 2
    );

    // Inner shadow
    context.fillStyle = 'rgba(0, 0, 0, 0.3)';
    context.fillRect(
        x * size + padding,
        (y + 1) * size - padding - 2,
        size - padding * 2,
        2
    );
    context.fillRect(
        (x + 1) * size - padding - 2,
        y * size + padding,
        2,
        size - padding * 2
    );

    // Border
    context.strokeStyle = 'rgba(0, 0, 0, 0.3)';
    context.lineWidth = 1;
    context.strokeRect(
        x * size + padding,
        y * size + padding,
        size - padding * 2,
        size - padding * 2
    );
}

/**
 * Draw the game board with all placed blocks
 */
function drawBoard() {
    // Clear canvas
    ctx.fillStyle = '#0a0a1a';
    ctx.fillRect(0, 0, canvas.width, canvas.height);

    // Draw grid lines (subtle)
    ctx.strokeStyle = 'rgba(255, 255, 255, 0.03)';
    ctx.lineWidth = 1;

    for (let row = 0; row <= ROWS; row++) {
        ctx.beginPath();
        ctx.moveTo(0, row * BLOCK_SIZE);
        ctx.lineTo(canvas.width, row * BLOCK_SIZE);
        ctx.stroke();
    }

    for (let col = 0; col <= COLS; col++) {
        ctx.beginPath();
        ctx.moveTo(col * BLOCK_SIZE, 0);
        ctx.lineTo(col * BLOCK_SIZE, canvas.height);
        ctx.stroke();
    }

    // Draw placed blocks
    for (let row = 0; row < ROWS; row++) {
        for (let col = 0; col < COLS; col++) {
            if (board[row][col] !== null) {
                drawBlock(ctx, col, row, board[row][col]);
            }
        }
    }
}

/**
 * Draw the current falling piece with ghost piece
 */
function drawCurrentPiece() {
    if (!currentPiece || gameOver || isPaused) return;

    // Save canvas state before drawing
    ctx.save();
    
    // Draw ghost piece (shadow showing where piece will land)
    const ghostY = getGhostPosition();
    for (let row = 0; row < currentPiece.shape.length; row++) {
        for (let col = 0; col < currentPiece.shape[row].length; col++) {
            if (currentPiece.shape[row][col] !== 0) {
                const x = currentPiece.x + col;
                const y = ghostY + row;

                // Only draw ghost if it's within bounds and not overlapping actual piece
                if (y >= 0 && y < ROWS && y !== currentPiece.y) {
                    ctx.globalAlpha = 0.2;
                    drawBlock(ctx, x, y, currentPiece.color);
                }
            }
        }
    }

    // Draw actual piece
    for (let row = 0; row < currentPiece.shape.length; row++) {
        for (let col = 0; col < currentPiece.shape[row].length; col++) {
            if (currentPiece.shape[row][col] !== 0) {
                const x = currentPiece.x + col;
                const y = currentPiece.y + row;

                // Only draw if within visible area
                if (y >= -1 && y < ROWS) {
                    ctx.globalAlpha = 1.0;
                    drawBlock(ctx, x, y, currentPiece.color);
                }
            }
        }
    }
    
    // Restore canvas state to reset alpha and other properties
    ctx.restore();
}

/**
 * Draw the next piece preview
 */
function drawNextPiece() {
    // Clear canvas
    nextCtx.fillStyle = 'rgba(0, 0, 0, 0.3)';
    nextCtx.fillRect(0, 0, nextCanvas.width, nextCanvas.height);

    if (!nextPiece) return;

    // Calculate center position for preview
    const shape = nextPiece.shape;
    const offsetX = (nextCanvas.width / NEXT_BLOCK_SIZE - shape[0].length) / 2;
    const offsetY = (nextCanvas.height / NEXT_BLOCK_SIZE - shape.length) / 2;

    for (let row = 0; row < shape.length; row++) {
        for (let col = 0; col < shape[row].length; col++) {
            if (shape[row][col] !== 0) {
                drawBlock(
                    nextCtx,
                    Math.floor(offsetX + col),
                    Math.floor(offsetY + row),
                    nextPiece.color,
                    NEXT_BLOCK_SIZE,
                    true
                );
            }
        }
    }
}

/**
 * Get the ghost piece Y position (where piece will land)
 * @returns {number} Ghost Y position
 */
function getGhostPosition() {
    if (!currentPiece) return currentPiece.y;

    let ghostY = currentPiece.y;

    while (!checkCollision(currentPiece.x, ghostY + 1, currentPiece.shape)) {
        ghostY++;
    }

    return ghostY;
}

/**
 * Check for collision between piece and board boundaries/blocks
 * @param {number} x - X position
 * @param {number} y - Y position
 * @param {number[][]} shape - Piece shape to check
 * @returns {boolean} True if collision detected
 */
function checkCollision(x, y, shape) {
    for (let row = 0; row < shape.length; row++) {
        for (let col = 0; col < shape[row].length; col++) {
            if (shape[row][col] !== 0) {
                const newX = x + col;
                const newY = y + row;

                // Check boundary conditions
                if (newX < 0 || newX >= COLS || newY >= ROWS) {
                    return true;
                }

                // Check collision with placed blocks (only if within board)
                if (newY >= 0 && board[newY][newX] !== null) {
                    return true;
                }
            }
        }
    }

    return false;
}

/**
 * Lock the current piece into the board
 */
function lockPiece() {
    for (let row = 0; row < currentPiece.shape.length; row++) {
        for (let col = 0; col < currentPiece.shape[row].length; col++) {
            if (currentPiece.shape[row][col] !== 0) {
                const x = currentPiece.x + col;
                const y = currentPiece.y + row;

                // Game over if piece locks above visible area
                if (y < 0) {
                    gameOver = true;
                    showGameOver();
                    return;
                }

                board[y][x] = currentPiece.color;
            }
        }
    }

    clearLines();
    spawnNewPiece();
}

/**
 * Clear completed lines and update score
 */
function clearLines() {
    let linesCleared = 0;

    for (let row = ROWS - 1; row >= 0; row--) {
        // Check if line is complete
        if (board[row].every(cell => cell !== null)) {
            linesCleared++;

            // Remove the line and add new empty one at top
            board.splice(row, 1);
            board.unshift(Array(COLS).fill(null));

            // Don't decrement row since we shifted everything down
            row++;
        }
    }

    if (linesCleared > 0) {
        // Update score based on lines cleared
        const lineScores = [0, SCORES.SINGLE, SCORES.DOUBLE, SCORES.TRIPLE, SCORES.TETRIS];
        score += lineScores[linesCleared] * level;

        // Update lines and level
        lines += linesCleared;
        const newLevel = Math.floor(lines / 10) + 1;

        if (newLevel > level) {
            level = newLevel;
            dropInterval = Math.max(100, 1000 - (level - 1) * 100); // Speed up
            showLevelUp();
        }

        updateUI();
    }
}

/**
 * Spawn a new piece at the top of the board
 */
function spawnNewPiece() {
    currentPiece = nextPiece || getRandomPiece();

    // Center the piece
    currentPiece.x = Math.floor((COLS - currentPiece.shape[0].length) / 2);
    currentPiece.y = 0;

    // Generate next piece
    nextPiece = getRandomPiece();
    drawNextPiece();

    // Check if game over on spawn
    if (checkCollision(currentPiece.x, currentPiece.y, currentPiece.shape)) {
        gameOver = true;
        showGameOver();
    }
}

/**
 * Move the current piece
 * @param {number} dx - X direction (-1, 0, or 1)
 * @param {number} dy - Y direction (usually 1 for soft drop)
 * @returns {boolean} True if move was successful
 */
function movePiece(dx, dy) {
    if (!currentPiece || gameOver || isPaused) return false;

    const newX = currentPiece.x + dx;
    const newY = currentPiece.y + dy;

    if (!checkCollision(newX, newY, currentPiece.shape)) {
        currentPiece.x = newX;
        currentPiece.y = newY;
        return true;
    }

    // If moving down and collision, lock the piece
    if (dy > 0) {
        lockPiece();
    }

    return false;
}

/**
 * Hard drop - instantly move piece to bottom
 */
function hardDrop() {
    if (!currentPiece || gameOver || isPaused) return;

    let dropDistance = 0;

    while (!checkCollision(currentPiece.x, currentPiece.y + 1, currentPiece.shape)) {
        currentPiece.y++;
        dropDistance++;
    }

    score += dropDistance * SCORES.HARD_DROP;
    updateUI();
    lockPiece();
}

/**
 * Update UI elements (score, level, lines)
 */
function updateUI() {
    scoreElement.textContent = score.toLocaleString();
    levelElement.textContent = level;
    linesElement.textContent = lines;
}

/**
 * Show game over overlay
 */
function showGameOver() {
    overlayTitle.textContent = 'Game Over';
    overlayMessage.textContent = `Final Score: ${score.toLocaleString()}\nLevel: ${level}`;
    restartBtn.style.display = 'block';
    overlay.classList.remove('hidden');
}

/**
 * Show level up notification
 */
function showLevelUp() {
    levelElement.classList.add('level-up');
    setTimeout(() => {
        levelElement.classList.remove('level-up');
    }, 500);
}

/**
 * Pause/Resume game
 */
function togglePause() {
    if (gameOver) return;

    isPaused = !isPaused;

    if (isPaused) {
        overlayTitle.textContent = 'Paused';
        overlayMessage.textContent = 'Press P or click Resume to continue';
        restartBtn.style.display = 'none';
        overlay.classList.remove('hidden');
    } else {
        overlay.classList.add('hidden');
        lastDropTime = performance.now();
        gameLoop(lastDropTime);
    }
}

/**
 * Reset all game state and start new game
 */
function resetGame() {
    initBoard();
    score = 0;
    level = 1;
    lines = 0;
    gameOver = false;
    isPaused = false;
    dropInterval = 1000;

    currentPiece = null;
    nextPiece = getRandomPiece();

    spawnNewPiece();
    updateUI();

    overlay.classList.add('hidden');

    lastDropTime = performance.now();
    if (animationId) {
        cancelAnimationFrame(animationId);
    }
    gameLoop(lastDropTime);
}

/**
 * Main game loop using requestAnimationFrame
 * @param {number} currentTime - Current timestamp
 */
function gameLoop(currentTime) {
    if (gameOver || isPaused) return;

    const deltaTime = currentTime - lastDropTime;

    if (deltaTime >= dropInterval) {
        movePiece(0, 1);
        lastDropTime = currentTime;
    }

    // Draw everything
    drawBoard();
    drawCurrentPiece();

    animationId = requestAnimationFrame(gameLoop);
}

/**
 * Lighten a color by percentage
 * @param {string} color - Hex color
 * @param {number} percent - Percentage to lighten (0-100)
 * @returns {string} Lightened hex color
 */
function lightenColor(color, percent) {
    const num = parseInt(color.slice(1), 16);
    const amt = Math.round(2.55 * percent);
    const R = Math.min(255, (num >> 16) + amt);
    const G = Math.min(255, ((num >> 8) & 0x00FF) + amt);
    const B = Math.min(255, (num & 0x0000FF) + amt);
    return `rgb(${R}, ${G}, ${B})`;
}

/**
 * Darken a color by percentage
 * @param {string} color - Hex color
 * @param {number} percent - Percentage to darken (0-100)
 * @returns {string} Darkened hex color
 */
function darkenColor(color, percent) {
    const num = parseInt(color.slice(1), 16);
    const amt = Math.round(2.55 * percent);
    const R = Math.max(0, (num >> 16) - amt);
    const G = Math.max(0, ((num >> 8) & 0x00FF) - amt);
    const B = Math.max(0, (num & 0x0000FF) - amt);
    return `rgb(${R}, ${G}, ${B})`;
}

/**
 * Handle keyboard input
 * @param {KeyboardEvent} event - Keyboard event
 */
function handleKeyPress(event) {
    // Prevent default for game keys to avoid scrolling
    if (['ArrowUp', 'ArrowDown', 'ArrowLeft', 'ArrowRight', 'Space'].includes(event.key)) {
        event.preventDefault();
    }

    if (gameOver && event.key !== 'Enter') return;

    switch (event.key) {
        case 'ArrowLeft':
            movePiece(-1, 0);
            break;
        case 'ArrowRight':
            movePiece(1, 0);
            break;
        case 'ArrowDown':
            if (movePiece(0, 1)) {
                score += SCORES.SOFT_DROP;
                updateUI();
            }
            break;
        case 'ArrowUp':
            rotatePiece(currentPiece, board);
            break;
        case ' ': // Space - Hard drop
            hardDrop();
            break;
        case 'p':
        case 'P':
            togglePause();
            break;
        case 'Enter':
            if (gameOver) {
                resetGame();
            } else if (!overlay.classList.contains('hidden')) {
                // Resume if paused
                togglePause();
            }
            break;
    }

    if (!isPaused && !gameOver) {
        drawBoard();
        drawCurrentPiece();
    }
}

/**
 * Initialize event listeners
 */
function initEventListeners() {
    document.addEventListener('keydown', handleKeyPress);

    startBtn.addEventListener('click', () => {
        if (gameOver || board.every(row => row.every(cell => cell === null))) {
            resetGame();
        }
    });

    pauseBtn.addEventListener('click', togglePause);

    restartBtn.addEventListener('click', resetGame);

    // Touch controls for mobile
    let touchStartX = 0;
    let touchStartY = 0;

    canvas.addEventListener('touchstart', (e) => {
        touchStartX = e.touches[0].clientX;
        touchStartY = e.touches[0].clientY;
        e.preventDefault();
    }, { passive: false });

    canvas.addEventListener('touchmove', (e) => {
        e.preventDefault();
    }, { passive: false });

    canvas.addEventListener('touchend', (e) => {
        const touchEndX = e.changedTouches[0].clientX;
        const touchEndY = e.changedTouches[0].clientY;

        const deltaX = touchEndX - touchStartX;
        const deltaY = touchEndY - touchStartY;

        // Determine swipe direction
        if (Math.abs(deltaX) > Math.abs(deltaY)) {
            // Horizontal swipe
            if (Math.abs(deltaX) > 30) {
                if (deltaX > 0) {
                    movePiece(1, 0);
                } else {
                    movePiece(-1, 0);
                }
            }
        } else {
            // Vertical swipe
            if (Math.abs(deltaY) > 30) {
                if (deltaY > 0) {
                    movePiece(0, 1);
                } else {
                    rotatePiece(currentPiece, board);
                }
            }
        }

        if (!isPaused && !gameOver) {
            drawBoard();
            drawCurrentPiece();
        }
    });
}

/**
 * Initialize the game
 */
function init() {
    initBoard();
    initEventListeners();
    resetGame();
}

// Start the game when page loads
window.addEventListener('load', init);

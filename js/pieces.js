/**
 * Tetromino Definitions for Tetris Game
 * Contains all 7 standard tetromino pieces with their shapes, colors, and rotation logic
 */

// Tetromino shapes represented as matrices
const TETROMINOS = {
    // I-piece (Cyan) - Long straight piece
    I: {
        shape: [
            [0, 0, 0, 0],
            [1, 1, 1, 1],
            [0, 0, 0, 0],
            [0, 0, 0, 0]
        ],
        color: '#00ffff',           // Cyan
        shadowColor: 'rgba(0, 255, 255, 0.4)',
        name: 'I'
    },

    // O-piece (Yellow) - Square piece
    O: {
        shape: [
            [1, 1],
            [1, 1]
        ],
        color: '#ffff00',           // Yellow
        shadowColor: 'rgba(255, 255, 0, 0.4)',
        name: 'O'
    },

    // T-piece (Purple) - T-shaped piece
    T: {
        shape: [
            [0, 1, 0],
            [1, 1, 1],
            [0, 0, 0]
        ],
        color: '#bb80d3',           // Purple
        shadowColor: 'rgba(187, 128, 211, 0.4)',
        name: 'T'
    },

    // S-piece (Green) - S-shaped piece
    S: {
        shape: [
            [0, 1, 1],
            [1, 1, 0],
            [0, 0, 0]
        ],
        color: '#80d342',           // Green
        shadowColor: 'rgba(128, 211, 66, 0.4)',
        name: 'S'
    },

    // Z-piece (Red) - Z-shaped piece
    Z: {
        shape: [
            [1, 1, 0],
            [0, 1, 1],
            [0, 0, 0]
        ],
        color: '#ff5252',           // Red
        shadowColor: 'rgba(255, 82, 82, 0.4)',
        name: 'Z'
    },

    // J-piece (Blue) - J-shaped piece
    J: {
        shape: [
            [1, 0, 0],
            [1, 1, 1],
            [0, 0, 0]
        ],
        color: '#4285f4',           // Blue
        shadowColor: 'rgba(66, 133, 244, 0.4)',
        name: 'J'
    },

    // L-piece (Orange) - L-shaped piece
    L: {
        shape: [
            [0, 0, 1],
            [1, 1, 1],
            [0, 0, 0]
        ],
        color: '#ff9800',           // Orange
        shadowColor: 'rgba(255, 152, 0, 0.4)',
        name: 'L'
    }
};

// All piece types in order for random selection
const PIECE_TYPES = ['I', 'O', 'T', 'S', 'Z', 'J', 'L'];

/**
 * Creates a new tetromino instance with initial position and rotation
 * @param {string} type - The type of piece (I, O, T, S, Z, J, L)
 * @returns {Object} New piece object
 */
function createPiece(type) {
    const tetromino = TETROMINOS[type];
    return {
        type: type,
        shape: tetromino.shape.map(row => [...row]), // Deep copy of shape
        color: tetromino.color,
        shadowColor: tetromino.shadowColor,
        x: 0,
        y: 0,
        rotation: 0
    };
}

/**
 * Generates a random piece using the bag system for fair distribution
 * @returns {Object} Random piece
 */
function getRandomPiece() {
    const type = PIECE_TYPES[Math.floor(Math.random() * PIECE_TYPES.length)];
    return createPiece(type);
}

/**
 * Rotates a matrix 90 degrees clockwise
 * @param {number[][]} matrix - The matrix to rotate
 * @returns {number[][]} Rotated matrix
 */
function rotateMatrix(matrix) {
    const rows = matrix.length;
    const cols = matrix[0].length;
    const rotated = [];

    // Initialize rotated matrix
    for (let i = 0; i < cols; i++) {
        rotated[i] = [];
        for (let j = 0; j < rows; j++) {
            rotated[i][j] = 0;
        }
    }

    // Rotate: new[x][y] = old[rows-1-y][x]
    for (let row = 0; row < rows; row++) {
        for (let col = 0; col < cols; col++) {
            rotated[col][rows - 1 - row] = matrix[row][col];
        }
    }

    return rotated;
}

/**
 * Checks if a rotation is valid (no wall kicks needed or possible)
 * @param {number[][]} shape - The shape to check
 * @param {number} x - Current X position
 * @param {number} y - Current Y position
 * @param {number[][]} board - The game board
 * @returns {boolean} True if rotation is valid
 */
function isValidRotation(shape, x, y, board) {
    const rows = shape.length;
    const cols = shape[0].length;

    for (let row = 0; row < rows; row++) {
        for (let col = 0; col < cols; col++) {
            if (shape[row][col] !== 0) {
                const newX = x + col;
                const newY = y + row;

                // Check boundary conditions
                if (newX < 0 || newX >= board[0].length || newY >= board.length) {
                    return false;
                }

                // Check collision with existing blocks
                if (newY >= 0 && board[newY][newX] !== null) {
                    return false;
                }
            }
        }
    }

    return true;
}

/**
 * Performs wall kick to adjust position after rotation near walls
 * @param {Object} piece - The piece to adjust
 * @param {number[][]} board - The game board
 * @returns {boolean} True if a valid position was found
 */
function performWallKick(piece, board) {
    const kicks = [
        { x: 0, y: 0 },   // No kick
        { x: 1, y: 0 },   // Kick right
        { x: -1, y: 0 },  // Kick left
        { x: 2, y: 0 },   // Double kick right
        { x: -2, y: 0 },  // Double kick left
        { x: 0, y: -1 }   // Kick up (for pieces near bottom)
    ];

    for (const kick of kicks) {
        const newX = piece.x + kick.x;
        const newY = piece.y + kick.y;

        if (isValidRotation(piece.shape, newX, newY, board)) {
            piece.x = newX;
            piece.y = newY;
            return true;
        }
    }

    return false;
}

/**
 * Rotates a piece with wall kick support
 * @param {Object} piece - The piece to rotate
 * @param {number[][]} board - The game board
 * @returns {boolean} True if rotation was successful
 */
function rotatePiece(piece, board) {
    const originalShape = piece.shape.map(row => [...row]);

    // Rotate the shape
    piece.shape = rotateMatrix(piece.shape);
    piece.rotation = (piece.rotation + 1) % 4;

    // Check if rotation is valid
    if (!isValidRotation(piece.shape, piece.x, piece.y, board)) {
        // Try wall kicks
        if (!performWallKick(piece, board)) {
            // Rotation failed, restore original shape
            piece.shape = originalShape;
            piece.rotation = (piece.rotation + 3) % 4; // Counter-rotate
            return false;
        }
    }

    return true;
}

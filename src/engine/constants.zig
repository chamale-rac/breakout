//! Game constants and configuration values
//! This module contains all the magic numbers and configuration
//! that would otherwise be hardcoded throughout the application.

const raylib = @import("raylib");

pub const GameConfig = struct {
    // Window settings
    pub const WINDOW_TITLE = "F**cking Awesome Breakout Game";
    pub const WINDOW_WIDTH: i32 = 800;
    pub const WINDOW_HEIGHT: i32 = 600;
    pub const TARGET_FPS: i32 = 60;

    // Ball settings
    pub const BALL_SIZE: f32 = 15.0;
    pub const BALL_INITIAL_X: f32 = 10.0;
    pub const BALL_INITIAL_Y: f32 = 10.0;
    pub const BALL_SPEED_X: f32 = 150.0;
    pub const BALL_SPEED_Y: f32 = 150.0;

    // Paddle settings
    pub const PADDLE_WIDTH_MULTIPLIER: f32 = 10.0; // Relative to ball size
    pub const PADDLE_HEIGHT: f32 = 15.0;
    pub const PADDLE_SPEED: f32 = 200.0;
    pub const PADDLE_BOTTOM_MARGIN: f32 = 15.0; // Distance from bottom of screen

    // Colors - using Raylib's predefined colors
    pub const BACKGROUND_COLOR = raylib.Color.gray;
    pub const BALL_COLOR = raylib.Color.black;
    pub const PADDLE_COLOR = raylib.Color.black;

    // UI settings
    pub const FPS_TEXT_X: i32 = 10;
    pub const FPS_TEXT_Y: i32 = 40;
};

pub const InputAction = enum {
    Left,
    Right,
    Pause,
    Quit,
    Resume,
    Restart, // R key for restart
};

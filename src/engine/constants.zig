//! Game constants and configuration values
//! This module contains all the magic numbers and configuration
//! that would otherwise be hardcoded throughout the application.

pub const GameConfig = struct {
    // Window settings
    pub const WINDOW_TITLE = "Breakout Game";
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

    // Colors
    pub const BACKGROUND_COLOR = .{ .r = 128, .g = 128, .b = 128, .a = 255 }; // Gray
    pub const BALL_COLOR = .{ .r = 0, .g = 0, .b = 0, .a = 255 }; // Black
    pub const PADDLE_COLOR = .{ .r = 0, .g = 0, .b = 0, .a = 255 }; // Black
    pub const FPS_TEXT_COLOR = .{ .r = 255, .g = 0, .b = 0, .a = 255 }; // Red

    // UI settings
    pub const FPS_TEXT_SIZE: i32 = 20;
    pub const FPS_TEXT_X: i32 = 10;
    pub const FPS_TEXT_Y: i32 = 40;
};

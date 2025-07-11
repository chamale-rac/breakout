//! Rendering system for handling all drawing operations
//! This module provides a clean interface for rendering game objects
//! and UI elements.

const std = @import("std");
const raylib = @import("raylib");
const types = @import("types.zig");
const Rectangle = types.Rectangle;
const Vector2 = types.Vector2;
const constants = @import("constants.zig");
const GameConfig = constants.GameConfig;

/// Rendering system that handles all drawing operations
pub const Renderer = struct {
    /// Initialize the rendering system
    pub fn init() void {
        raylib.setTargetFPS(GameConfig.TARGET_FPS);
    }

    /// Begin a new frame
    pub fn beginFrame() void {
        raylib.beginDrawing();
    }

    /// End the current frame
    pub fn endFrame() void {
        raylib.endDrawing();
    }

    /// Clear the background with the default color
    pub fn clearBackground() void {
        raylib.clearBackground(GameConfig.BACKGROUND_COLOR);
    }

    /// Draw a rectangle
    pub fn drawRectangle(rect: Rectangle, color: raylib.Color) void {
        const r = rect.toRaylibRect();
        raylib.drawRectangleRec(r, color);
    }

    /// Draw a circle
    pub fn drawCircle(center: Vector2, radius: f32, color: raylib.Color) void {
        raylib.drawCircle(@as(i32, @intFromFloat(center.x)), @as(i32, @intFromFloat(center.y)), radius, color);
    }

    /// Draw text
    pub fn drawText(text: [*:0]const u8, x: i32, y: i32, size: i32, color: raylib.Color) void {
        raylib.drawText(text, x, y, size, color);
    }

    /// Draw formatted text
    pub fn drawTextFmt(comptime format: []const u8, args: anytype, x: i32, y: i32, size: i32, color: raylib.Color) void {
        var buf: [256:0]u8 = undefined;
        const text = std.fmt.bufPrintZ(&buf, format, args) catch "Error";
        drawText(text, x, y, size, color);
    }

    /// Draw the FPS counter
    pub fn drawFPS() void {
        const fps = raylib.getFPS();
        drawTextFmt("FPS: {}", .{fps}, GameConfig.FPS_TEXT_X, GameConfig.FPS_TEXT_Y, GameConfig.FPS_TEXT_SIZE, GameConfig.FPS_TEXT_COLOR);
    }

    /// Draw a game object (ball, paddle, etc.)
    pub fn drawGameObject(rect: Rectangle, object_type: types.GameObjectType) void {
        const color = switch (object_type) {
            .Ball => GameConfig.BALL_COLOR,
            .Paddle => GameConfig.PADDLE_COLOR,
            .Brick => raylib.Color{ .r = 255, .g = 0, .b = 0, .a = 255 }, // Red
            .PowerUp => raylib.Color{ .r = 0, .g = 255, .b = 0, .a = 255 }, // Green
        };
        drawRectangle(rect, color);
    }

    /// Draw debug information
    pub fn drawDebugInfo(ball_pos: Vector2, paddle_pos: Vector2, frame_count: i32) void {
        const debug_y = GameConfig.FPS_TEXT_Y + 30;
        drawTextFmt("Ball: ({:.1}, {:.1})", .{ ball_pos.x, ball_pos.y }, 10, debug_y, 16, raylib.Color.white);
        drawTextFmt("Paddle: ({:.1}, {:.1})", .{ paddle_pos.x, paddle_pos.y }, 10, debug_y + 20, 16, raylib.Color.white);
        drawTextFmt("Frame: {}", .{frame_count}, 10, debug_y + 40, 16, raylib.Color.white);
    }

    /// Draw game state information
    pub fn drawGameState(state: types.GameState) void {
        const state_text = switch (state) {
            .Playing => "Playing",
            .Paused => "PAUSED",
            .GameOver => "GAME OVER",
            .Victory => "VICTORY!",
        };

        const screen_center_x = @divTrunc(GameConfig.WINDOW_WIDTH, 2);
        const screen_center_y = @divTrunc(GameConfig.WINDOW_HEIGHT, 2);

        drawText(state_text, screen_center_x - 50, screen_center_y, 32, raylib.Color.white);
    }

    /// Draw a border around the screen
    pub fn drawBorder() void {
        const border_rect = Rectangle.init(0, 0, @as(f32, @floatFromInt(GameConfig.WINDOW_WIDTH)), @as(f32, @floatFromInt(GameConfig.WINDOW_HEIGHT)));
        const border_color = raylib.Color{ .r = 255, .g = 255, .b = 255, .a = 255 }; // White
        raylib.drawRectangleLinesEx(border_rect.toRaylibRect(), 2, border_color);
    }
};

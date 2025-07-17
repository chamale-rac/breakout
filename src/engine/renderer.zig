//! Rendering system for handling all drawing operations
//! This module provides a clean interface for rendering game objects
//! and UI elements.

const std = @import("std");
const raylib = @import("raylib");
const types = @import("types.zig");
const constants = @import("constants.zig");
const GameConfig = constants.GameConfig;
const game_objects = @import("game_objects.zig");

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
    pub fn drawRectangle(rect: raylib.Rectangle, color: raylib.Color) void {
        raylib.drawRectangleRec(rect, color);
    }

    /// Draw a circle
    pub fn drawCircle(center: raylib.Vector2, radius: f32, color: raylib.Color) void {
        raylib.drawCircle(@as(i32, @intFromFloat(center.x)), @as(i32, @intFromFloat(center.y)), radius, color);
    }

    /// Draw text
    pub fn drawText(text: [:0]const u8, x: i32, y: i32, size: i32, color: raylib.Color) void {
        raylib.drawText(text, x, y, size, color);
    }

    /// Draw formatted text
    pub fn drawTextFmt(comptime format: []const u8, args: anytype, x: i32, y: i32, size: i32, color: raylib.Color) void {
        var buf: [256:0]u8 = undefined;
        const text = std.fmt.bufPrintZ(&buf, format, args) catch "Error";
        drawText(text, x, y, size, color);
    }

    /// Draw the FPS counter using Raylib's built-in function
    pub fn drawFPS() void {
        raylib.drawFPS(GameConfig.FPS_TEXT_X, GameConfig.FPS_TEXT_Y);
    }

    /// Draw a game object (ball, paddle, etc.)
    pub fn drawGameObject(rect: raylib.Rectangle, object_type: types.GameObjectType) void {
        const color = switch (object_type) {
            .Ball => GameConfig.BALL_COLOR,
            .Paddle => GameConfig.PADDLE_COLOR,
            .Brick => raylib.Color.red,
            .PowerUp => raylib.Color.green,
        }; // TODO: make this constants
        drawRectangle(rect, color);
    }

    /// Draw debug information
    pub fn drawDebugInfo(ball_pos: raylib.Vector2, paddle_pos: raylib.Vector2, frame_count: i32) void {
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
            .GameOver => "GAME OVER!\nPress R to restart",
            .Victory => "YOU WIN!\nPress R to restart",
        };

        const screen_center_x = @divTrunc(GameConfig.WINDOW_WIDTH, 2);
        const screen_center_y = @divTrunc(GameConfig.WINDOW_HEIGHT, 2);

        drawText(state_text, screen_center_x - 100, screen_center_y, 32, raylib.Color.white);
    }

    /// Draw a border around the screen
    pub fn drawBorder() void {
        const border_rect = raylib.Rectangle{ .x = 0, .y = 0, .width = @as(f32, @floatFromInt(GameConfig.WINDOW_WIDTH)), .height = @as(f32, @floatFromInt(GameConfig.WINDOW_HEIGHT)) };
        raylib.drawRectangleLinesEx(border_rect, 2, raylib.Color.white);
    }

    pub fn drawBlocks(blocks: []const game_objects.Block) void {
        for (blocks) |block| {
            if (block.is_active) {
                drawRectangle(block.bounds, raylib.Color.red);
            }
        }
    }
};

//! Game state management module
//! This module handles the overall game state, scoring, and game logic.

const raylib = @import("raylib");
const types = @import("types.zig");
const GameState = types.GameState;
const InputAction = types.InputAction;
const constants = @import("constants.zig");
const GameConfig = constants.GameConfig;
const input = @import("input.zig");
const InputSystem = input.InputSystem;
const game_objects = @import("game_objects.zig");
const Ball = game_objects.Ball;
const Paddle = game_objects.Paddle;
const Block = game_objects.Block;
const createBlockGrid = game_objects.createBlockGrid;
const PhysicsSystem = @import("physics.zig").PhysicsSystem;
const std = @import("std");

/// Main game state manager
pub const GameStateManager = struct {
    current_state: GameState,
    frame_count: i32,
    score: i32,
    ball: Ball,
    paddle: Paddle,
    input_system: InputSystem,
    screen_width: f32,
    screen_height: f32,
    blocks: []Block,
    allocator: std.mem.Allocator,
    ball_ready: bool,

    pub fn init(allocator: std.mem.Allocator) GameStateManager {
        const screen_width = @as(f32, @floatFromInt(GameConfig.WINDOW_WIDTH));
        const screen_height = @as(f32, @floatFromInt(GameConfig.WINDOW_HEIGHT));
        const rows = 1;
        const cols = 2;
        const top_margin = 40.0;
        const block_height = 20.0;
        const block_spacing = 8.0;
        const blocks = allocator.alloc(Block, rows * cols) catch @panic("Failed to allocate blocks");
        createBlockGrid(blocks, rows, cols, screen_width, top_margin, block_height, block_spacing);
        var ball = Ball.init(GameConfig.BALL_INITIAL_X, GameConfig.BALL_INITIAL_Y);
        const paddle = Paddle.init(screen_width, screen_height);
        // Place ball on top of paddle for initial state
        ball.is_active = false;
        ball.velocity = raylib.Vector2{ .x = 0, .y = 0 };
        ball.bounds.x = paddle.bounds.x + (paddle.bounds.width - ball.bounds.width) / 2;
        const gap: f32 = 2.0;
        ball.bounds.y = paddle.bounds.y - ball.bounds.height - gap;
        return GameStateManager{
            .current_state = .Playing,
            .frame_count = 0,
            .score = 0,
            .ball = ball,
            .paddle = paddle,
            .input_system = InputSystem.init(),
            .screen_width = screen_width,
            .screen_height = screen_height,
            .blocks = blocks,
            .allocator = allocator,
            .ball_ready = true,
        };
    }

    pub fn update(self: *GameStateManager) void {
        const delta_time = raylib.getFrameTime();

        // Update input system
        self.input_system.update();

        // Handle input based on current state
        self.handleInput();

        // Update game objects based on state
        switch (self.current_state) {
            .Playing => self.updatePlaying(delta_time),
            .Paused => self.updatePaused(),
            .GameOver => self.updateGameOver(),
            .Victory => self.updateVictory(),
        }

        self.frame_count += 1;
    }

    fn handleInput(self: *GameStateManager) void {
        // Handle quit input in any state
        if (self.input_system.isActionJustPressed(.Quit) or InputSystem.shouldClose()) {
            self.current_state = .GameOver;
            return;
        }

        switch (self.current_state) {
            .Playing => {
                // Handle paddle movement
                const horizontal_input = self.input_system.getHorizontalInput();
                self.paddle.handleInput(horizontal_input);

                // Handle pause
                if (self.input_system.isActionJustPressed(.Pause)) {
                    self.current_state = .Paused;
                }
            },
            .Paused => {
                // Handle resume
                if (self.input_system.isActionJustPressed(.Resume)) {
                    self.current_state = .Playing;
                }
            },
            .GameOver, .Victory => {
                // Handle restart (R key)
                if (self.input_system.isActionJustPressed(.Restart)) {
                    self.restart();
                }
            },
        }
    }

    fn updatePlaying(self: *GameStateManager, delta_time: f32) void {
        // Update paddle
        self.paddle.update(delta_time, self.screen_width, self.screen_height);

        if (self.ball_ready) {
            // Ball follows paddle
            self.ball.bounds.x = self.paddle.bounds.x + (self.paddle.bounds.width - self.ball.bounds.width) / 2;
            self.ball.bounds.y = self.paddle.bounds.y - self.ball.bounds.height;
            // Launch ball on up arrow
            if (raylib.isKeyPressed(raylib.KeyboardKey.up)) {
                self.ball.velocity = raylib.Vector2{ .x = GameConfig.BALL_SPEED_X, .y = -@abs(GameConfig.BALL_SPEED_Y) };
                self.ball.is_active = true;
                self.ball_ready = false;
            }
        } else {
            // Update ball physics
            self.ball.update(delta_time, self.screen_width, self.screen_height);
            // Check for game over condition only if ball is in play
            if (!self.ball.is_active) {
                if (self.current_state != .GameOver) {
                    self.current_state = .GameOver;
                    std.debug.print("Game Over\n", .{});
                }
                return;
            }
        }

        // Handle ball-paddle collision
        self.ball.handlePaddleCollision(&self.paddle);

        // Handle ball-block collision
        var blocks_remaining: usize = 0;
        for (self.blocks) |*block| {
            if (block.is_active) {
                blocks_remaining += 1;
                if (PhysicsSystem.checkCollision(self.ball.getBounds(), block.getBounds())) {
                    block.is_active = false;
                    self.ball.velocity.y *= -1;
                    self.addScore(100);
                }
            }
        }
        if (blocks_remaining == 0) {
            if (self.current_state != .Victory) {
                self.current_state = .Victory;
                std.debug.print("You Win!\n", .{});
            }
        }
    }

    fn updatePaused(self: *GameStateManager) void {
        // No updates needed when paused
        _ = self;
    }

    fn updateGameOver(self: *GameStateManager) void {
        // No updates needed when game over
        _ = self;
    }

    fn updateVictory(self: *GameStateManager) void {
        // No updates needed when victory
        _ = self;
    }

    fn resetBall(self: *GameStateManager) void {
        // Position ball on top of paddle and set ready
        const gap: f32 = 2.0;
        self.ball_ready = true;
        self.ball.is_active = false;
        self.ball.velocity = raylib.Vector2{ .x = 0, .y = 0 };
        self.ball.bounds.x = self.paddle.bounds.x + (self.paddle.bounds.width - self.ball.bounds.width) / 2;
        self.ball.bounds.y = self.paddle.bounds.y - self.ball.bounds.height - gap;
    }

    fn restart(self: *GameStateManager) void {
        self.current_state = .Playing;
        self.frame_count = 0;
        self.score = 0;
        // Reset paddle position first
        const paddle_width = GameConfig.BALL_SIZE * GameConfig.PADDLE_WIDTH_MULTIPLIER;
        const paddle_x = (self.screen_width / 2) - (paddle_width / 2);
        const paddle_y = self.screen_height - GameConfig.PADDLE_BOTTOM_MARGIN - GameConfig.PADDLE_HEIGHT;
        self.paddle.bounds.x = paddle_x;
        self.paddle.bounds.y = paddle_y;
        // Now reset the ball on top of the paddle
        self.resetBall();
        self.ball_ready = true;
        // Reset blocks
        const rows = 1;
        const cols = 2;
        const top_margin = 40.0;
        const block_height = 20.0;
        const block_spacing = 8.0;
        createBlockGrid(self.blocks, rows, cols, self.screen_width, top_margin, block_height, block_spacing);
    }

    pub fn addScore(self: *GameStateManager, points: i32) void {
        self.score += points;
    }

    pub fn getCurrentState(self: GameStateManager) GameState {
        return self.current_state;
    }

    pub fn getScore(self: GameStateManager) i32 {
        return self.score;
    }

    pub fn getFrameCount(self: GameStateManager) i32 {
        return self.frame_count;
    }

    pub fn getBall(self: *GameStateManager) *Ball {
        return &self.ball;
    }

    pub fn getPaddle(self: *GameStateManager) *Paddle {
        return &self.paddle;
    }

    pub fn isRunning(self: GameStateManager) bool {
        return self.current_state != .GameOver;
    }
};

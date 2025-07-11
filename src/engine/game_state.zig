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

/// Main game state manager
pub const GameStateManager = struct {
    current_state: GameState,
    frame_count: i32,
    score: i32,
    lives: i32,
    ball: Ball,
    paddle: Paddle,
    input_system: InputSystem,
    screen_width: f32,
    screen_height: f32,

    pub fn init() GameStateManager {
        const screen_width = @as(f32, @floatFromInt(GameConfig.WINDOW_WIDTH));
        const screen_height = @as(f32, @floatFromInt(GameConfig.WINDOW_HEIGHT));

        return GameStateManager{
            .current_state = .Playing,
            .frame_count = 0,
            .score = 0,
            .lives = 3,
            .ball = Ball.init(GameConfig.BALL_INITIAL_X, GameConfig.BALL_INITIAL_Y),
            .paddle = Paddle.init(screen_width, screen_height),
            .input_system = InputSystem.init(),
            .screen_width = screen_width,
            .screen_height = screen_height,
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
                // Handle restart (space key)
                if (self.input_system.isActionJustPressed(.Pause)) {
                    self.restart();
                }
            },
        }
    }

    fn updatePlaying(self: *GameStateManager, delta_time: f32) void {
        // Update game objects
        self.ball.update(delta_time, self.screen_width, self.screen_height);
        self.paddle.update(delta_time, self.screen_width, self.screen_height);

        // Handle ball-paddle collision
        self.ball.handlePaddleCollision(&self.paddle);

        // Check for game over condition
        if (!self.ball.is_active) {
            self.lives -= 1;
            if (self.lives <= 0) {
                self.current_state = .GameOver;
            } else {
                self.resetBall();
            }
        }

        // Check for victory condition (placeholder)
        if (self.score >= 1000) {
            self.current_state = .Victory;
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
        self.ball.reset(GameConfig.BALL_INITIAL_X, GameConfig.BALL_INITIAL_Y);
    }

    fn restart(self: *GameStateManager) void {
        self.current_state = .Playing;
        self.frame_count = 0;
        self.score = 0;
        self.lives = 3;
        self.resetBall();

        // Reset paddle position
        const paddle_width = GameConfig.BALL_SIZE * GameConfig.PADDLE_WIDTH_MULTIPLIER;
        const paddle_x = (self.screen_width / 2) - (paddle_width / 2);
        const paddle_y = self.screen_height - GameConfig.PADDLE_BOTTOM_MARGIN - GameConfig.PADDLE_HEIGHT;
        self.paddle.bounds.x = paddle_x;
        self.paddle.bounds.y = paddle_y;
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

    pub fn getLives(self: GameStateManager) i32 {
        return self.lives;
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

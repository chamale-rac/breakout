//! Main game engine module
//! This module orchestrates all systems and provides the main game loop.

const raylib = @import("raylib");
const std = @import("std");
const constants = @import("constants.zig");
const GameConfig = constants.GameConfig;
const renderer = @import("renderer.zig");
const Renderer = renderer.Renderer;
const game_state = @import("game_state.zig");
const GameStateManager = game_state.GameStateManager;
const types = @import("types.zig");
const GameState = types.GameState;
const GameObjectType = types.GameObjectType;

/// Main game engine that orchestrates all systems
pub const GameEngine = struct {
    game_state: GameStateManager,
    renderer: Renderer,
    is_running: bool,

    pub fn init() GameEngine {
        // Initialize raylib window
        raylib.initWindow(GameConfig.WINDOW_WIDTH, GameConfig.WINDOW_HEIGHT, GameConfig.WINDOW_TITLE);

        // Initialize renderer
        Renderer.init();

        return GameEngine{
            .game_state = GameStateManager.init(std.heap.c_allocator),
            .renderer = Renderer{},
            .is_running = true,
        };
    }

    pub fn deinit(self: *GameEngine) void {
        _ = self;
        raylib.closeWindow();
    }

    /// Main game loop
    pub fn run(self: *GameEngine) void {
        while (self.is_running) {
            self.update();
            self.render();
        }
    }

    /// Update game logic for one frame
    fn update(self: *GameEngine) void {
        // Update game state
        self.game_state.update();

        // Only exit if the user closes the window
        if (raylib.windowShouldClose()) {
            self.is_running = false;
        }
    }

    /// Render the current frame
    fn render(self: *GameEngine) void {
        Renderer.beginFrame();
        Renderer.clearBackground();

        // Render game objects
        self.renderGameObjects();

        // Render UI elements
        self.renderUI();

        // Render game state overlay if needed
        self.renderGameStateOverlay();

        Renderer.endFrame();
    }

    /// Render all game objects
    fn renderGameObjects(self: *GameEngine) void {
        const ball = self.game_state.getBall();
        const paddle = self.game_state.getPaddle();
        // Always render the ball, even if inactive
        Renderer.drawGameObject(ball.getBounds(), .Ball);
        Renderer.drawGameObject(paddle.getBounds(), .Paddle);
        // Draw blocks
        Renderer.drawBlocks(self.game_state.blocks);

        // Show launch instructions if ball is ready
        if (self.game_state.ball_ready) {
            const screen_center_x = @divTrunc(GameConfig.WINDOW_WIDTH, 2);
            const text = "Press Up Arrow to start playing and Space to Pause";
            // Center the text horizontally, place it above the paddle
            const text_x = screen_center_x - 270; // Adjust as needed for centering
            const text_y = @as(i32, @intFromFloat(paddle.bounds.y)) - 80;
            Renderer.drawText(text, text_x, text_y, 20, raylib.Color.white);
        }
    }

    /// Render UI elements
    fn renderUI(self: *GameEngine) void {
        // Draw FPS counter
        Renderer.drawFPS();

        // Draw score and lives
        const score = self.game_state.getScore();
        const frame_count = self.game_state.getFrameCount();

        // Draw score
        Renderer.drawTextFmt("Score: {}", .{score}, 10, 10, 20, raylib.Color.white);

        // Draw debug info in debug mode
        if (self.isDebugMode()) {
            const ball = self.game_state.getBall();
            const paddle = self.game_state.getPaddle();
            Renderer.drawDebugInfo(ball.getPosition(), paddle.getPosition(), frame_count);
        }
    }

    /// Render game state overlay (pause, game over, etc.)
    fn renderGameStateOverlay(self: *GameEngine) void {
        const current_state = self.game_state.getCurrentState();

        switch (current_state) {
            .Playing => {
                // No overlay needed
            },
            .Paused => {
                Renderer.drawGameState(.Paused);
            },
            .GameOver => {
                Renderer.drawGameState(.GameOver);
            },
            .Victory => {
                Renderer.drawGameState(.Victory);
            },
        }
    }

    /// Check if debug mode is enabled
    fn isDebugMode(self: *GameEngine) bool {
        _ = self;
        // In a real implementation, this could be controlled by a debug flag
        // or command line argument
        return false;
    }

    /// Get the current game state manager
    pub fn getGameState(self: *GameEngine) *GameStateManager {
        return &self.game_state;
    }

    /// Check if the engine is still running
    pub fn isEngineRunning(self: GameEngine) bool {
        return self.is_running;
    }
};

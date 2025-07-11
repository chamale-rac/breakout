const std = @import("std");
const engine = @import("engine");
const GameEngine = engine.GameEngine;

/// Main entry point for the Breakout game
/// This file is now much cleaner and delegates all game logic
/// to the modular engine architecture.
pub fn main() !void {
    // Initialize the game engine
    var game_engine = GameEngine.init();
    defer game_engine.deinit();

    // Run the main game loop
    game_engine.run();
}

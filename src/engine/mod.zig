//! Engine module exports
//! This file exports all engine components for easy importing.

pub const constants = @import("constants.zig");
pub const types = @import("types.zig");
pub const input = @import("input.zig");
pub const physics = @import("physics.zig");
pub const renderer = @import("renderer.zig");
pub const game_objects = @import("game_objects.zig");
pub const game_state = @import("game_state.zig");
pub const engine = @import("engine.zig");

// Re-export commonly used types for convenience
pub const GameConfig = constants.GameConfig;
pub const GameState = types.GameState;
pub const InputAction = types.InputAction;
pub const Vector2 = types.Vector2;
pub const Rectangle = types.Rectangle;
pub const Ball = game_objects.Ball;
pub const Paddle = game_objects.Paddle;
pub const GameStateManager = game_state.GameStateManager;
pub const GameEngine = engine.GameEngine;
pub const InputSystem = input.InputSystem;
pub const PhysicsSystem = physics.PhysicsSystem;
pub const Renderer = renderer.Renderer;

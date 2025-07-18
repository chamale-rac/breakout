//! Game-specific types, enums, and data structures
//! This module defines only game-specific types that don't exist in Raylib.

const raylib = @import("raylib");

/// Represents the current state of the game
pub const GameState = enum {
    Playing,
    Paused,
    GameOver,
    Victory,
};

/// Represents different types of game objects
pub const GameObjectType = enum {
    Ball,
    Paddle,
    Brick,
    PowerUp,
};

/// Represents input actions that can be performed
pub const InputAction = enum {
    MoveLeft,
    MoveRight,
    Pause,
    Resume,
    Quit,
    Restart,
};

/// Represents collision types
pub const CollisionType = enum {
    None,
    Wall,
    Paddle,
    Brick,
    Ceiling,
    Floor,
};

/// Represents the side of a collision
pub const CollisionSide = enum {
    Top,
    Bottom,
    Left,
    Right,
    Corner,
};

/// Represents a collision between two objects
pub const Collision = struct {
    ctype: CollisionType,
    side: CollisionSide,
    position: raylib.Vector2,
    normal: raylib.Vector2,

    pub fn init(ctype: CollisionType, side: CollisionSide, position: raylib.Vector2, normal: raylib.Vector2) Collision {
        return Collision{ .ctype = ctype, .side = side, .position = position, .normal = normal };
    }
};

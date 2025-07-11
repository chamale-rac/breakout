//! Game-specific types, enums, and data structures
//! This module defines the core data types used throughout the game.

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

/// Represents the direction of movement
pub const Direction = enum {
    Up,
    Down,
    Left,
    Right,
    UpLeft,
    UpRight,
    DownLeft,
    DownRight,
};

/// Represents input actions that can be performed
pub const InputAction = enum {
    MoveLeft,
    MoveRight,
    Pause,
    Resume,
    Quit,
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

/// A 2D vector for position and velocity
pub const Vector2 = struct {
    x: f32,
    y: f32,

    pub fn init(x: f32, y: f32) Vector2 {
        return Vector2{ .x = x, .y = y };
    }

    pub fn add(self: Vector2, other: Vector2) Vector2 {
        return Vector2{ .x = self.x + other.x, .y = self.y + other.y };
    }

    pub fn multiply(self: Vector2, scalar: f32) Vector2 {
        return Vector2{ .x = self.x * scalar, .y = self.y * scalar };
    }

    pub fn negate(self: Vector2) Vector2 {
        return Vector2{ .x = -self.x, .y = -self.y };
    }
};

/// A rectangle with position and size
pub const Rectangle = struct {
    x: f32,
    y: f32,
    width: f32,
    height: f32,

    pub fn init(x: f32, y: f32, width: f32, height: f32) Rectangle {
        return Rectangle{ .x = x, .y = y, .width = width, .height = height };
    }

    pub fn getCenter(self: Rectangle) Vector2 {
        return Vector2.init(self.x + self.width / 2, self.y + self.height / 2);
    }

    pub fn getLeft(self: Rectangle) f32 {
        return self.x;
    }

    pub fn getRight(self: Rectangle) f32 {
        return self.x + self.width;
    }

    pub fn getTop(self: Rectangle) f32 {
        return self.y;
    }

    pub fn getBottom(self: Rectangle) f32 {
        return self.y + self.height;
    }

    pub fn toRaylibRect(self: Rectangle) raylib.Rectangle {
        return raylib.Rectangle{ .x = self.x, .y = self.y, .width = self.width, .height = self.height };
    }
};

/// Represents a collision between two objects
pub const Collision = struct {
    type: CollisionType,
    side: CollisionSide,
    position: Vector2,
    normal: Vector2,

    pub fn init(type: CollisionType, side: CollisionSide, position: Vector2, normal: Vector2) Collision {
        return Collision{ .type = type, .side = side, .position = position, .normal = normal };
    }
};

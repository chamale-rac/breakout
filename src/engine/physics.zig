//! Physics system for collision detection and physics calculations
//! This module provides a clean interface for physics operations
//! and collision detection between game objects.

const raylib = @import("raylib");
const raymath = raylib.math;
const types = @import("types.zig");
const Collision = types.Collision;
const CollisionType = types.CollisionType;
const CollisionSide = types.CollisionSide;

/// Physics system that handles collision detection and physics calculations
pub const PhysicsSystem = struct {
    /// Check collision between two rectangles using Raylib's built-in function
    pub fn checkCollision(rect1: raylib.Rectangle, rect2: raylib.Rectangle) bool {
        return raylib.checkCollisionRecs(rect1, rect2);
    }

    /// Get detailed collision information between two rectangles
    pub fn getCollisionInfo(rect1: raylib.Rectangle, rect2: raylib.Rectangle) ?Collision {
        if (!checkCollision(rect1, rect2)) {
            return null;
        }

        // Calculate collision side and normal using raymath
        const center1 = raymath.vector2Add(raylib.Vector2{ .x = rect1.x, .y = rect1.y }, raymath.vector2Scale(raylib.Vector2{ .x = rect1.width, .y = rect1.height }, 0.5));
        const center2 = raymath.vector2Add(raylib.Vector2{ .x = rect2.x, .y = rect2.y }, raymath.vector2Scale(raylib.Vector2{ .x = rect2.width, .y = rect2.height }, 0.5));
        const diff = raymath.vector2Subtract(center2, center1);

        // Determine collision side based on overlap
        const overlap_x = @min(rect1.x + rect1.width, rect2.x + rect2.width) - @max(rect1.x, rect2.x);
        const overlap_y = @min(rect1.y + rect1.height, rect2.y + rect2.height) - @max(rect1.y, rect2.y);

        var side: CollisionSide = undefined;
        var normal: raylib.Vector2 = undefined;

        if (overlap_x < overlap_y) {
            // Horizontal collision
            if (diff.x > 0) {
                side = .Left;
                normal = raylib.Vector2{ .x = -1, .y = 0 };
            } else {
                side = .Right;
                normal = raylib.Vector2{ .x = 1, .y = 0 };
            }
        } else {
            // Vertical collision
            if (diff.y > 0) {
                side = .Top;
                normal = raylib.Vector2{ .x = 0, .y = -1 };
            } else {
                side = .Bottom;
                normal = raylib.Vector2{ .x = 0, .y = 1 };
            }
        }

        const collision_point = raylib.Vector2{ .x = @max(rect1.x, rect2.x), .y = @max(rect1.y, rect2.y) };

        return Collision.init(.Wall, side, collision_point, normal);
    }

    /// Check if a rectangle is within screen bounds
    pub fn isWithinBounds(rect: raylib.Rectangle, screen_width: f32, screen_height: f32) bool {
        return rect.x >= 0 and
            rect.x + rect.width <= screen_width and
            rect.y >= 0 and
            rect.y + rect.height <= screen_height;
    }

    /// Clamp a rectangle to screen bounds
    pub fn clampToBounds(rect: *raylib.Rectangle, screen_width: f32, screen_height: f32) void {
        if (rect.x < 0) {
            rect.x = 0;
        }
        if (rect.x + rect.width > screen_width) {
            rect.x = screen_width - rect.width;
        }
        if (rect.y < 0) {
            rect.y = 0;
        }
        if (rect.y + rect.height > screen_height) {
            rect.y = screen_height - rect.height;
        }
    }

    /// Check if a point is within a rectangle using Raylib's built-in function
    pub fn isPointInRect(point: raylib.Vector2, rect: raylib.Rectangle) bool {
        return raylib.checkCollisionPointRec(point, rect);
    }

    /// Get the distance between two points using raymath
    pub fn getDistance(point1: raylib.Vector2, point2: raylib.Vector2) f32 {
        return raymath.vector2Distance(point1, point2);
    }

    /// Reflect a velocity vector off a surface normal using raymath
    pub fn reflectVelocity(velocity: raylib.Vector2, normal: raylib.Vector2) raylib.Vector2 {
        return raymath.vector2Reflect(velocity, normal);
    }

    /// Apply friction to a velocity vector
    pub fn applyFriction(velocity: raylib.Vector2, friction: f32) raylib.Vector2 {
        return raymath.vector2Scale(velocity, 1.0 - friction);
    }
};

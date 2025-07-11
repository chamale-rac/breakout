//! Physics system for collision detection and physics calculations
//! This module provides a clean interface for physics operations
//! and collision detection between game objects.

const raylib = @import("raylib");
const types = @import("types.zig");
const Rectangle = types.Rectangle;
const Vector2 = types.Vector2;
const Collision = types.Collision;
const CollisionType = types.CollisionType;
const CollisionSide = types.CollisionSide;

/// Physics system that handles collision detection and physics calculations
pub const PhysicsSystem = struct {
    /// Check collision between two rectangles
    pub fn checkCollision(rect1: Rectangle, rect2: Rectangle) bool {
        const r1 = rect1.toRaylibRect();
        const r2 = rect2.toRaylibRect();
        return raylib.checkCollisionRecs(r1, r2);
    }

    /// Get detailed collision information between two rectangles
    pub fn getCollisionInfo(rect1: Rectangle, rect2: Rectangle) ?Collision {
        if (!checkCollision(rect1, rect2)) {
            return null;
        }

        // Calculate collision side and normal
        const center1 = rect1.getCenter();
        const center2 = rect2.getCenter();
        const diff = Vector2.init(center2.x - center1.x, center2.y - center1.y);

        // Determine collision side based on overlap
        const overlap_x = @min(rect1.getRight(), rect2.getRight()) - @max(rect1.getLeft(), rect2.getLeft());
        const overlap_y = @min(rect1.getBottom(), rect2.getBottom()) - @max(rect1.getTop(), rect2.getTop());

        var side: CollisionSide = undefined;
        var normal: Vector2 = undefined;

        if (overlap_x < overlap_y) {
            // Horizontal collision
            if (diff.x > 0) {
                side = .Left;
                normal = Vector2.init(-1, 0);
            } else {
                side = .Right;
                normal = Vector2.init(1, 0);
            }
        } else {
            // Vertical collision
            if (diff.y > 0) {
                side = .Top;
                normal = Vector2.init(0, -1);
            } else {
                side = .Bottom;
                normal = Vector2.init(0, 1);
            }
        }

        const collision_point = Vector2.init(@max(rect1.getLeft(), rect2.getLeft()), @max(rect1.getTop(), rect2.getTop()));

        return Collision.init(.Wall, side, collision_point, normal);
    }

    /// Check if a rectangle is within screen bounds
    pub fn isWithinBounds(rect: Rectangle, screen_width: f32, screen_height: f32) bool {
        return rect.getLeft() >= 0 and
            rect.getRight() <= screen_width and
            rect.getTop() >= 0 and
            rect.getBottom() <= screen_height;
    }

    /// Clamp a rectangle to screen bounds
    pub fn clampToBounds(rect: *Rectangle, screen_width: f32, screen_height: f32) void {
        if (rect.getLeft() < 0) {
            rect.x = 0;
        }
        if (rect.getRight() > screen_width) {
            rect.x = screen_width - rect.width;
        }
        if (rect.getTop() < 0) {
            rect.y = 0;
        }
        if (rect.getBottom() > screen_height) {
            rect.y = screen_height - rect.height;
        }
    }

    /// Check if a point is within a rectangle
    pub fn isPointInRect(point: Vector2, rect: Rectangle) bool {
        return point.x >= rect.getLeft() and
            point.x <= rect.getRight() and
            point.y >= rect.getTop() and
            point.y <= rect.getBottom();
    }

    /// Get the distance between two points
    pub fn getDistance(point1: Vector2, point2: Vector2) f32 {
        const dx = point1.x - point2.x;
        const dy = point1.y - point2.y;
        return @sqrt(dx * dx + dy * dy);
    }

    /// Reflect a velocity vector off a surface normal
    pub fn reflectVelocity(velocity: Vector2, normal: Vector2) Vector2 {
        const dot_product = velocity.x * normal.x + velocity.y * normal.y;
        return Vector2.init(velocity.x - 2 * dot_product * normal.x, velocity.y - 2 * dot_product * normal.y);
    }

    /// Apply friction to a velocity vector
    pub fn applyFriction(velocity: Vector2, friction: f32) Vector2 {
        return Vector2.init(velocity.x * (1.0 - friction), velocity.y * (1.0 - friction));
    }
};

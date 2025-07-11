//! Game objects module containing Ball and Paddle classes
//! This module defines the core game objects with their properties
//! and behaviors.

const types = @import("types.zig");
const Rectangle = types.Rectangle;
const Vector2 = types.Vector2;
const constants = @import("constants.zig");
const GameConfig = constants.GameConfig;
const physics = @import("physics.zig");
const PhysicsSystem = physics.PhysicsSystem;

/// Ball game object
pub const Ball = struct {
    bounds: Rectangle,
    velocity: Vector2,
    is_active: bool,

    pub fn init(x: f32, y: f32) Ball {
        return Ball{
            .bounds = Rectangle.init(x, y, GameConfig.BALL_SIZE, GameConfig.BALL_SIZE),
            .velocity = Vector2.init(GameConfig.BALL_SPEED_X, GameConfig.BALL_SPEED_Y),
            .is_active = true,
        };
    }

    pub fn update(self: *Ball, delta_time: f32, screen_width: f32, screen_height: f32) void {
        if (!self.is_active) return;

        // Update position
        self.bounds.x += self.velocity.x * delta_time;
        self.bounds.y += self.velocity.y * delta_time;

        // Handle wall collisions
        if (self.bounds.getLeft() <= 0 or self.bounds.getRight() >= screen_width) {
            self.velocity.x *= -1;
            // Clamp to prevent sticking to walls
            if (self.bounds.getLeft() <= 0) {
                self.bounds.x = 0;
            } else {
                self.bounds.x = screen_width - self.bounds.width;
            }
        }

        if (self.bounds.getTop() <= 0) {
            self.velocity.y *= -1;
            self.bounds.y = 0;
        }

        // Check if ball fell off screen (game over condition)
        if (self.bounds.getTop() >= screen_height) {
            self.is_active = false;
        }
    }

    pub fn handlePaddleCollision(self: *Ball, paddle: *const Paddle) void {
        if (!self.is_active) return;

        if (PhysicsSystem.checkCollision(self.bounds, paddle.bounds)) {
            // Reverse vertical velocity
            self.velocity.y *= -1;

            // Adjust horizontal velocity based on where the ball hit the paddle
            const ball_center = self.bounds.getCenter();
            const paddle_center = paddle.bounds.getCenter();
            const hit_position = (ball_center.x - paddle_center.x) / (paddle.bounds.width / 2);

            // Add some horizontal velocity based on hit position
            self.velocity.x += hit_position * GameConfig.PADDLE_SPEED * 0.5;

            // Ensure minimum velocity
            const min_velocity = 100.0;
            if (@fabs(self.velocity.x) < min_velocity) {
                self.velocity.x = if (self.velocity.x > 0) min_velocity else -min_velocity;
            }

            // Clamp maximum velocity
            const max_velocity = 300.0;
            if (@fabs(self.velocity.x) > max_velocity) {
                self.velocity.x = if (self.velocity.x > 0) max_velocity else -max_velocity;
            }
        }
    }

    pub fn reset(self: *Ball, x: f32, y: f32) void {
        self.bounds.x = x;
        self.bounds.y = y;
        self.velocity = Vector2.init(GameConfig.BALL_SPEED_X, GameConfig.BALL_SPEED_Y);
        self.is_active = true;
    }

    pub fn getPosition(self: Ball) Vector2 {
        return self.bounds.getCenter();
    }

    pub fn getBounds(self: Ball) Rectangle {
        return self.bounds;
    }
};

/// Paddle game object
pub const Paddle = struct {
    bounds: Rectangle,
    velocity: Vector2,
    speed: f32,

    pub fn init(screen_width: f32, screen_height: f32) Paddle {
        const paddle_width = GameConfig.BALL_SIZE * GameConfig.PADDLE_WIDTH_MULTIPLIER;
        const paddle_x = (screen_width / 2) - (paddle_width / 2);
        const paddle_y = screen_height - GameConfig.PADDLE_BOTTOM_MARGIN - GameConfig.PADDLE_HEIGHT;

        return Paddle{
            .bounds = Rectangle.init(paddle_x, paddle_y, paddle_width, GameConfig.PADDLE_HEIGHT),
            .velocity = Vector2.init(0, 0),
            .speed = GameConfig.PADDLE_SPEED,
        };
    }

    pub fn update(self: *Paddle, delta_time: f32, screen_width: f32, screen_height: f32) void {
        // Update position based on velocity
        self.bounds.x += self.velocity.x * delta_time;
        self.bounds.y += self.velocity.y * delta_time;

        // Clamp to screen bounds
        PhysicsSystem.clampToBounds(&self.bounds, screen_width, screen_height);
    }

    pub fn handleInput(self: *Paddle, horizontal_input: i32) void {
        self.velocity.x = @as(f32, @floatFromInt(horizontal_input)) * self.speed;
    }

    pub fn getPosition(self: Paddle) Vector2 {
        return self.bounds.getCenter();
    }

    pub fn getBounds(self: Paddle) Rectangle {
        return self.bounds;
    }

    pub fn setSpeed(self: *Paddle, new_speed: f32) void {
        self.speed = new_speed;
    }

    pub fn getSpeed(self: Paddle) f32 {
        return self.speed;
    }
};

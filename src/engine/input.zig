//! Input system for handling keyboard and mouse input
//! This module provides a clean interface for input handling
//! and maps physical keys to game actions.

const raylib = @import("raylib");
const types = @import("types.zig");
const InputAction = types.InputAction;

/// Input system that handles all input processing
pub const InputSystem = struct {
    /// Maps physical keys to game actions
    const KeyMapping = struct {
        pub const MOVE_LEFT = raylib.KeyboardKey.left;
        pub const MOVE_RIGHT = raylib.KeyboardKey.right;
        pub const PAUSE = raylib.KeyboardKey.space;
        pub const QUIT = raylib.KeyboardKey.escape;
    };

    /// Input state tracking
    const InputState = struct {
        move_left_pressed: bool = false,
        move_right_pressed: bool = false,
        pause_pressed: bool = false,
        quit_pressed: bool = false,
    };

    state: InputState,

    pub fn init() InputSystem {
        return InputSystem{ .state = InputState{} };
    }

    /// Process all input for the current frame
    pub fn update(self: *InputSystem) void {
        self.state.move_left_pressed = raylib.isKeyDown(KeyMapping.MOVE_LEFT);
        self.state.move_right_pressed = raylib.isKeyDown(KeyMapping.MOVE_RIGHT);
        self.state.pause_pressed = raylib.isKeyPressed(KeyMapping.PAUSE);
        self.state.quit_pressed = raylib.isKeyPressed(KeyMapping.QUIT);
    }

    /// Check if the window should close
    pub fn shouldClose() bool {
        return raylib.windowShouldClose();
    }

    /// Check if a specific action is currently pressed
    pub fn isActionPressed(self: InputSystem, action: InputAction) bool {
        return switch (action) {
            .MoveLeft => self.state.move_left_pressed,
            .MoveRight => self.state.move_right_pressed,
            .Pause => self.state.pause_pressed,
            .Resume => self.state.pause_pressed, // Same key for pause/resume
            .Quit => self.state.quit_pressed,
        };
    }

    /// Check if a specific action was just pressed this frame
    pub fn isActionJustPressed(self: InputSystem, action: InputAction) bool {
        return switch (action) {
            .MoveLeft => false, // Continuous movement, not just pressed
            .MoveRight => false, // Continuous movement, not just pressed
            .Pause => self.state.pause_pressed,
            .Resume => self.state.pause_pressed,
            .Quit => self.state.quit_pressed,
        };
    }

    /// Get the horizontal input value (-1 for left, 0 for none, 1 for right)
    pub fn getHorizontalInput(self: InputSystem) i32 {
        if (self.state.move_left_pressed and self.state.move_right_pressed) {
            return 0; // Both pressed, no movement
        } else if (self.state.move_left_pressed) {
            return -1;
        } else if (self.state.move_right_pressed) {
            return 1;
        }
        return 0;
    }

    // Get the vertical input value (-1 for up, 0 for none, 1 for down)
    // pub fn getVerticalInput(self: InputSystem) i32 {
    //     // Currently no vertical input, but ready for future expansion
    //     return 0;
    // }
};

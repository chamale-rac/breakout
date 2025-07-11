# Breakout Game (Zig + Raylib)

A simple Breakout-style game written in Zig using the [raylib-zig](https://github.com/Not-Nik/raylib-zig) bindings.

## Project Structure

```
breakout/
├── build.zig         # Zig build script (multi-target, raylib integration)
├── build.zig.zon     # Zig package manager file (includes raylib-zig)
├── README.md         # This file
└── src/
    ├── main.zig      # Main game logic (entry point)
    └── root.zig      # (Optional) Library code or tests
```

## Useful Commands

- **Build the game:**
  ```sh
  zig build
  ```

- **Update dependencies:**
  ```sh
  zig fetch
  ```

## Requirements
- [Zig](https://ziglang.org/) 0.14.1 or newer
- No manual raylib install needed (raylib-zig handles it)

## How it Works
- Uses raylib for windowing, drawing, and input.
- All game logic is in `src/main.zig`.
- Paddle is controlled with the left/right arrow keys.
- Ball bounces off walls and paddle; game ends if the ball hits the bottom.

---

Feel free to extend the game or add new features!
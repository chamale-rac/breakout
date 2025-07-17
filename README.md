# Breakout Game - Modular Engine Architecture

A modern implementation of the classic Breakout game using Zig and Raylib, featuring a well-structured modular game engine architecture.

## Architecture Overview

This project demonstrates best practices in game development by implementing a clean, modular architecture with proper separation of concerns. The codebase is organized into distinct modules, each with a single responsibility.

### Module Structure

```
src/
├── main.zig              # Entry point - minimal and clean
└── engine/               # Game engine modules
    ├── mod.zig           # Module exports
    ├── constants.zig     # Game configuration and constants
    ├── types.zig         # Game-specific data types and enums
    ├── input.zig         # Input handling system
    ├── physics.zig       # Physics and collision detection
    ├── renderer.zig      # Rendering system
    ├── game_objects.zig  # Ball and Paddle classes
    ├── game_state.zig    # Game state management
    └── engine.zig        # Main engine orchestrator
```

## Design Patterns Used

### 1. **Separation of Concerns**
Each module has a single, well-defined responsibility:
- **Constants**: All configuration values in one place
- **Types**: Game-specific data structures and enums
- **Input**: Handles all input processing and key mapping
- **Physics**: Collision detection and physics calculations
- **Renderer**: All drawing operations
- **Game Objects**: Encapsulated game entities with behavior
- **Game State**: Overall game logic and state management
- **Engine**: Orchestrates all systems

### 2. **Dependency Injection**
The engine components are loosely coupled and can be easily tested or modified independently.

### 3. **State Pattern**
The game uses a state machine pattern for managing different game states (Playing, Paused, GameOver, Victory).

### 4. **Component-Based Architecture**
Game objects are composed of components (position, velocity, bounds) that can be easily extended.

## Key Features

### Configuration Management
All magic numbers and hardcoded values are centralized in `constants.zig`:
```zig
pub const GameConfig = struct {
    pub const WINDOW_WIDTH: i32 = 800;
    pub const BALL_SPEED_X: f32 = 150.0;
    pub const PADDLE_SPEED: f32 = 200.0;
    // ... more constants
};
```

### Type Safety
Strong typing with game-specific enums and Raylib's built-in types:
```zig
pub const GameState = enum {
    Playing,
    Paused,
    GameOver,
    Victory,
};

// Uses raylib.Vector2 and raylib.Rectangle directly
```

### Input System
Clean input abstraction that maps physical keys to game actions:
```zig
pub const InputAction = enum {
    MoveLeft,
    MoveRight,
    Pause,
    Resume,
    Quit,
};
```

### Physics System
Comprehensive collision detection and physics utilities using Raylib's built-in functions:
```zig
pub const PhysicsSystem = struct {
    pub fn checkCollision(rect1: raylib.Rectangle, rect2: raylib.Rectangle) bool { ... }
    pub fn reflectVelocity(velocity: raylib.Vector2, normal: raylib.Vector2) raylib.Vector2 { ... }
    // ... more physics functions using raymath
};
```

### Game Objects
Encapsulated game entities with clear interfaces:
```zig
pub const Ball = struct {
    bounds: raylib.Rectangle,
    velocity: raylib.Vector2,
    is_active: bool,
    // ... methods for behavior
};
```

## Building and Running

### Prerequisites
- Zig compiler (latest version)
- Raylib-zig dependency (configured in build.zig)

### Build Commands
```bash
# Build the project
zig build

# Run the game
zig build run

# Build for release
zig build -Doptimize=ReleaseFast
```

## Game Controls

- **Left Arrow**: Move paddle left
- **Right Arrow**: Move paddle right
- **Space**: Pause/Resume game
- **Escape**: Quit game
- **Space** (in Game Over/Victory): Restart game

## Game Features

- **Smooth Physics**: Ball bounces realistically off walls and paddle
- **Paddle Physics**: Ball direction changes based on where it hits the paddle
- **Lives System**: Player has 3 lives
- **State Management**: Proper pause, game over, and victory states
- **FPS Display**: Real-time frame rate counter
- **Score System**: Basic scoring mechanism
- **Debug Information**: Optional debug mode for development

## Extensibility

The modular architecture makes it easy to add new features:

### Adding New Game Objects
1. Define the object in `game_objects.zig`
2. Add rendering logic in `renderer.zig`
3. Update collision detection in `physics.zig`

### Adding New Input Actions
1. Extend `InputAction` enum in `types.zig`
2. Update `InputSystem` in `input.zig`
3. Handle the action in `game_state.zig`

### Adding New Game States
1. Extend `GameState` enum in `types.zig`
2. Add state handling in `GameStateManager`
3. Update rendering in `engine.zig`

## Best Practices Demonstrated

1. **No Hardcoding**: All values are constants or configuration
2. **Single Responsibility**: Each module has one clear purpose
3. **Encapsulation**: Game objects hide internal state
4. **Type Safety**: Strong typing prevents runtime errors
5. **Clean Interfaces**: Clear public APIs for each module
6. **Error Handling**: Proper error handling throughout
7. **Documentation**: Comprehensive comments and documentation
8. **Testability**: Modules can be tested independently
9. **No Reinvention**: Uses Raylib's existing types and functions instead of creating duplicates
10. **Simplicity**: Focuses on organization rather than unnecessary abstractions
11. **Raylib Integration**: Leverages Raylib's built-in functions (DrawFPS, collision detection, colors, raymath)
12. **Minimal Wrappers**: Only creates abstractions where Raylib doesn't provide what we need

## Future Enhancements

The architecture is designed to easily support:
- Multiple levels
- Power-ups
- Sound effects
- Particle systems
- AI opponents
- Network multiplayer
- Save/load functionality
- Level editor

This modular approach ensures the codebase remains maintainable and extensible as the game grows in complexity.

# Requirements acomplishment

- [x] El jugador debe de manejar un “paddle” que se puede mover solo de izquierda a derecha en la pantalla.
- [x] Se debe controlar con el teclado.
- [x] Utilicen movimiento time-based (delta time).
- [x] Debe haber un rectángulo “pelota” que continuamente esté moviéndose en la pantalla.
- [x] Cuando la pelota toque la “paddle” debe invertir su movimiento en X y aumentar su velocidad. (Nota: invertido en Y, es lo mismo)
- [x] Cuando la pelota toque la pared de arriba o de los lados debe invertir su movimiento. 
- [ ] Si toca la pared de abajo, el juego debe cerrarse y se debe mostrar un mensaje en la terminal que diga “Game Over”
- [ ] En la pantalla, coloquen algunos rectángulos para representar los “bloques”. Si la pelota toca un bloque eliminen el bloque.
- [ ] Si se eliminan todos los bloques, muestren un mensaje que diga algo como “You Win!” (puede ser en consola)

# References

- [https://www.raylib.com/cheatsheet/raymath_cheatsheet.html](https://www.raylib.com/cheatsheet/raymath_cheatsheet.html)
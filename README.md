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
Strong typing with custom enums and structs:
```zig
pub const GameState = enum {
    Playing,
    Paused,
    GameOver,
    Victory,
};

pub const Vector2 = struct {
    x: f32,
    y: f32,
    // ... methods
};
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
Comprehensive collision detection and physics utilities:
```zig
pub const PhysicsSystem = struct {
    pub fn checkCollision(rect1: Rectangle, rect2: Rectangle) bool { ... }
    pub fn reflectVelocity(velocity: Vector2, normal: Vector2) Vector2 { ... }
    // ... more physics functions
};
```

### Game Objects
Encapsulated game entities with clear interfaces:
```zig
pub const Ball = struct {
    bounds: Rectangle,
    velocity: Vector2,
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
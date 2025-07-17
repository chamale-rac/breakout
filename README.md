# F**cking Awesome Breakout Game

Disclamer: Is not that awesome, project just for exploring raylib and zig usage.

## Requirements Accomplished

- [x] El jugador debe de manejar un “paddle” que se puede mover solo de izquierda a derecha en la pantalla.
- [x] Se debe controlar con el teclado.
- [x] Utilicen movimiento time-based (delta time).
- [x] Debe haber un rectángulo “pelota” que continuamente esté moviéndose en la pantalla.
- [x] Cuando la pelota toque la “paddle” debe invertir su movimiento en Y y ajustar su velocidad en X según el punto de contacto.
- [x] Cuando la pelota toque la pared de arriba o de los lados debe invertir su movimiento.
- [x] Si toca la pared de abajo, el juego muestra un mensaje en la terminal que dice “Game Over” y permite reiniciar con R.
- [x] En la pantalla, hay algunos rectángulos para representar los “bloques”. Si la pelota toca un bloque, el bloque se elimina.
- [x] Si se eliminan todos los bloques, se muestra un mensaje que dice “You Win!” (en consola) y permite reiniciar con R.

## Project Structure

```
breakout/
  build.zig
  build.zig.zon
  README.md
  src/
    engine/
      constants.zig      # Game constants and configuration
      engine.zig         # Main game engine and loop
      game_objects.zig   # Ball, Paddle, Block definitions
      game_state.zig     # Game state management and logic
      input.zig          # Input handling
      mod.zig            # Engine module exports
      physics.zig        # Collision and physics
      renderer.zig       # Rendering logic
      types.zig          # Game-specific types and enums
    main.zig             # Entry point
  zig-out/
```

## How to Build

- Run `zig build` in the project root.
- The compiled executables will be found in the `zig-out` folder.

## Controls

- **Left Arrow / Right Arrow:** Move the paddle left/right
- **Up Arrow:** Launch the ball (when waiting to start)
- **Space:** Pause/Resume the game
- **R:** Restart the game (after Game Over or Victory)
- **Escape:** Quit the game
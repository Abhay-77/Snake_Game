# Snake (Godot 4)

A clean, fast Snake clone built with Godot and GDScript.

This project is currently a gameplay prototype with classic movement, apple pickup, and growth mechanics.

## Features

- Grid-based Snake movement
- Directional snake head sprites
- Apple spawning on free tiles
- Snake growth when eating apples
- Crunch sound effect on pickup
- Keyboard controls with Arrow keys and WASD

## Tech Stack

- Engine: Godot 4.7
- Language: GDScript
- Rendering method: Mobile renderer
- Window size: 800x800

## Controls

- Move Up: Up Arrow or W
- Move Down: Down Arrow or S
- Move Left: Left Arrow or A
- Move Right: Right Arrow or D

## How to Run

1. Install Godot 4.7 (or a compatible Godot 4.x version).
2. Open Godot and import this folder as a project.
3. Launch the main scene (or press F5) to play.

## Gameplay Notes

- The snake starts stationary and begins moving after your first direction input.
- Reverse-direction turns are blocked (for example, Left to Right in one tick).
- Apples spawn within a 20x20 grid and never on top of the snake.

## Current Limitations

This is an early version. The following classic Snake features are not yet implemented:

- Wall collision / game over
- Self-collision / game over
- Score display
- Restart flow after losing

## Project Structure

- `project.godot`: Engine/project settings and input mappings
- `Scenes/Main_Scene.tscn`: Main game scene
- `Scripts/main_scene.gd`: Core gameplay logic (movement, drawing, input, apple logic)
- `Assets/`: Fonts, sprite textures, and audio

## Roadmap Ideas

- Add game-over conditions and restart prompt
- Add score and high-score tracking
- Add start menu and pause support
- Add difficulty settings (speed scaling)
- Add screen-wrap or bounded-wall modes

## License

No license file is currently included.
If you plan to publish or share the code, consider adding a license such as MIT.

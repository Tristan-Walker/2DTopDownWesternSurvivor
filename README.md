# ⚔️ [Game Title]

A fast-paced, 2D top-down "Survivor" roguelite built with the **Godot Engine**. Survive waves of relentless enemies, collect experience, and build the ultimate power-up synergy to conquer the arena.

![Gameplay Preview](https://via.placeholder.com/800x450.png?text=Add+a+GIF+or+Screenshot+Here)

## 🚀 Features

* **Dynamic Mob Hordes:** Dozens of enemies on screen simultaneously using Godot's optimized 2D engine.
* **Level-up System:** Gain XP from fallen enemies to unlock and upgrade unique abilities.
* **Procedural Difficulty:** Waves grow in intensity and complexity as time progresses.
* **Modular Ability System:** Easily extensible weapon and skill system using Godot's `Resources`.

## 🛠️ Technical Stack

| Component      | Technology              |
| :------------- | :---------------------- |
| **Engine** | Godot 4.x (GDScript)    |
| **Art** | [e.g., Aseprite]        |
| **Sound** | [e.g., Bfxr]            |
| **Version Control** | Git + GitHub       |

## 🏗️ Architecture

The game follows a decoupled, signal-based architecture to ensure performance and scalability.
"Implemented VisibleOnScreenNotifier3D to handle automatic object pooling and memory cleanup, ensuring consistent performance even during high-intensity bullet-hell scenarios."



* **Global Signals:** Used for XP gain and game state transitions.
* **Composition over Inheritance:** Abilities are added as child nodes to the player for easy swapping.
* **Node Optimization:** Efficient use of `Area2D` and `CollisionLayers` for high-performance hit detection.

## 🕹️ Getting Started

### Prerequisites
* [Godot Engine 4.x](https://godotengine.org/download)

### Installation
1. **Clone the repository:**
   ```bash
   git clone [https://github.com/your-username/your-game-name.git](https://github.com/your-username/your-game-name.git)

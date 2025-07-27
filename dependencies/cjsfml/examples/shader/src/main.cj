package shader

import cjsfml.audio.*
import cjsfml.graphics.*
import cjsfml.system.*
import cjsfml.window.*
import std.math.*
import std.random.*

main(): Int64 {
    // Create the main window
    let videoMode = VideoMode(800, 600)
    let window = RenderWindow(videoMode, "SFML Shader", style: WindowStyle.Titlebar | WindowStyle.Close)
    window.setVerticalSyncEnabled(true)

    // Load the application font and pass it to the Effect class
    let font = Font("resources/tuffy.ttf")
    Effect.setFont(font)

    // Create the effects
    let effects = [Pixelate(), WaveBlur(), StormBlink(), Edge(), Geometry()]
    var current = 0

    // Initialize them
    for (effect in effects) {
        effect.load()
    }

    // Create the messages background
    let textBackgroundTexture = Texture("resources/text-background.png")
    let textBackground = Sprite(textBackgroundTexture)
    textBackground.position = Vector2f(0.0, 520.0)
    textBackground.color = Color(255, 255, 255, 200)

    // Create the description text
    let description = Text("Current effect: ${effects[current].name}", font, characterSize: 20)
    description.position = Vector2f(10.0, 530.0)
    description.fillColor = Color(80, 80, 80)

    // Create the instructions text
    let instructions = Text("Press left and right arrows to change the current shader", font, characterSize: 20)
    instructions.position = Vector2f(280.0, 555.0)
    instructions.fillColor = Color(80, 80, 80)

    // Start the game loop
    let clock = Clock()
    while (window.isOpen) {
        // Process events
        while (let Some(evt) <- window.pollEvent()) {
            // Window closed or escape key pressed: exit
            match (evt) {
                // Close window: exit
                case EvtClosed => window.closeWindow()
                case EvtKeyPressed(keyEvt) =>
                    if (keyEvt.code == KeyCode.Escape) {
                        // Escape key: exit
                        window.closeWindow()
                    } else if (keyEvt.code == KeyCode.Left) {
                        // Left arrow key: previous shader
                        if (current == 0) {
                            current = effects.size - 1
                        } else {
                            current--
                        }
                        description.string = "Current effect: ${effects[current].name}"
                    } else if (keyEvt.code == KeyCode.Right) {
                        // Right arrow key: next shader
                        if (current == effects.size - 1) {
                            current = 0
                        } else {
                            current++
                        }
                        description.string = "Current effect: ${effects[current].name}"
                    }
                case _ => ()
            }
        }

        // Clear the window
        window.clear(Color(50, 50, 50))

        // Update the current example
        let x = Float32(Mouse.getPosition(window).x) / Float32(window.size.x)
        let y = Float32(Mouse.getPosition(window).y) / Float32(window.size.y)
        effects[current].update(clock.elapsedTime.seconds, x, y);

        // Clear the window
        if (effects[current].name == "Edge Post-effect") {
            window.clear(Color.white)
        } else {
            window.clear(Color(50, 50, 50))
        }

        // Draw the current example
        window.draw(effects[current])

        // Draw the text
        window.draw(textBackground)
        window.draw(instructions)
        window.draw(description)

        // Finally, display the rendered frame on screen
        window.display()
    }

    font.close()
    window.close()

    return 0
}

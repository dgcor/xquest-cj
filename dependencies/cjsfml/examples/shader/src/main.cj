package shader

import cjsfml.graphics.{Color, Font, RenderWindow, Shader, Sprite, Text, Texture}
import cjsfml.system.{Clock, Time, Vector2f, Vector2u}
import cjsfml.window.{Event, KeyCode, Mouse, VideoMode, WindowStyle}

main(): Int64 { // cjlint-ignore !G.FUN.01 function too long
    try {
        // Exit early if shaders are not available
        if (!Shader.isAvailable) {
            eprintln("Shaders not supported on current system, aborting")
            return 1
        }

        // Create the main window
        let videoMode = VideoMode(Vector2u(800, 600))
        let window = RenderWindow(videoMode, "SFML Shader", style: WindowStyle.Titlebar | WindowStyle.Close)
        window.setVerticalSyncEnabled(true)

        // Open the application font
        let font = Font("resources/tuffy.ttf")

        // Create the effects
        let effects = [
            Pixelate.tryLoad(),
            WaveBlur.tryLoad(font),
            StormBlink.tryLoad(),
            Edge.tryLoad(),
            Geometry.tryLoad()
        ]

        let effectNames = ["Pixelate", "Wave + Blur", "Storm + Blink", "Edge Post-effect", "Geometry Shader Billboards"]

        // Index of currently selected effect
        var current = 0 // cjlint-ignore !G.VAR.02 minimize scope

        // Create the messages background
        let textBackgroundTexture = Texture("resources/text-background.png")
        let textBackground = Sprite(textBackgroundTexture)
        textBackground.position = Vector2f(0.0, 520.0)
        textBackground.color = Color(255, 255, 255, 200)

        // Create the description text
        let description = Text(font, "Current effect: ${effectNames[current]}", characterSize: 20)
        description.position = Vector2f(10.0, 530.0)
        description.fillColor = Color(80, 80, 80)

        // Create the instructions text
        let instructions = Text(font, "Press left and right arrows to change the current shader", characterSize: 20)
        instructions.position = Vector2f(280.0, 555.0)
        instructions.fillColor = Color(80, 80, 80)

        let error = Text(font, "Shader not\nsupported", characterSize: 36)
        error.position = Vector2f(320.0, 200.0)

        // Start the game loop
        let clock = Clock()
        while (window.isOpen) {
            // Process events
            while (let Some(evt) <- window.pollEvent()) {
                // Window closed or escape key pressed: exit
                match (evt) {
                    // Close window: exit
                    case EvtClosed =>
                        window.closeWindow()
                        break
                    case EvtKeyPressed(keyEvt) =>
                        if (keyEvt.code == KeyCode.Escape) {
                            // Escape key: exit
                            window.closeWindow()
                            break
                        } else if (keyEvt.code == KeyCode.Left) {
                            // Left arrow key: previous shader
                            if (current == 0) {
                                current = effects.size - 1
                            } else {
                                current--
                            }
                        } else if (keyEvt.code == KeyCode.Right) {
                            // Right arrow key: next shader
                            if (current == effects.size - 1) {
                                current = 0
                            } else {
                                current++
                            }
                        }
                        description.string = "Current effect: ${effectNames[current]}"
                    case _ => ()
                }
            }

            // If the current example was loaded successfully...
            if (let Some(currentEffect) <- effects[current]) {
                // Update the current example
                let x = Float32(Mouse.getPosition(window).x) / Float32(window.size.x)
                let y = Float32(Mouse.getPosition(window).y) / Float32(window.size.y)
                currentEffect.update(clock.elapsedTime.seconds, x, y)

                // Clear the window
                if (currentEffect is Edge) {
                    window.clear(Color.WHITE)
                } else {
                    window.clear(Color(50, 50, 50))
                }

                // Draw the current example
                window.draw(currentEffect)
            } else {
                // Clear the window to grey to make sure the text is always readable
                window.clear(Color(50, 50, 50))

                window.draw(error)
            }

            // Draw the text
            window.draw(textBackground)
            window.draw(instructions)
            window.draw(description)

            // Finally, display the rendered frame on screen
            window.display()
        }

        error.close()
        instructions.close()
        description.close()
        textBackground.close()
        textBackgroundTexture.close()
        for (effect in effects) {
            effect?.close()
        }
        font.close()
        window.close()

        return 0
    } catch (ex: Exception) {
        eprintln(ex)
        return 1
    }
}

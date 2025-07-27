package tennis

import cjsfml.audio.*
import cjsfml.graphics.*
import cjsfml.system.*
import cjsfml.window.*
import std.math.*
import std.random.*

func resourcesDir(): String {
    return "resources/"
}

main(): Int64 {
    let rand = Random()

    // Define some constants
    const pi = 3.14159f32
    const gameWidth = 800.0f32
    const gameHeight = 600.0f32
    const paddleSize = Vector2f(25.0, 100.0)
    const ballRadius = 10.0f32

    let videoMode = VideoMode(UInt32(gameWidth), UInt32(gameHeight))
    let window = RenderWindow(videoMode, "SFML Tennis", style: WindowStyle.Titlebar | WindowStyle.Close)
    window.setVerticalSyncEnabled(true)

    // Load the sounds used in the game
    let ballSoundBuffer = SoundBuffer(resourcesDir() + "ball.wav")
    let ballSound = Sound(ballSoundBuffer)

    // Create the SFML logo texture
    let sfmlLogoTexture = Texture(resourcesDir() + "sfml_logo.png")
    let sfmlLogo = Sprite(sfmlLogoTexture)
    sfmlLogo.position = Vector2f(170.0, 50.0)

    // Create the left paddle
    let leftPaddle = RectangleShape(paddleSize - (3.0, 3.0))
    leftPaddle.outlineThickness = 3.0
    leftPaddle.outlineColor = Color.black
    leftPaddle.fillColor = Color(100, 100, 200)
    leftPaddle.origin = paddleSize / 2.0

    // Create the right paddle
    let rightPaddle = RectangleShape(paddleSize - (3.0, 3.0))
    rightPaddle.outlineThickness = 3.0
    rightPaddle.outlineColor = Color.black
    rightPaddle.fillColor = Color(200, 100, 100)
    rightPaddle.origin = paddleSize / 2.0

    // Create the ball
    let ball = CircleShape(ballRadius - 3.0)
    ball.outlineThickness = 2.0
    ball.outlineColor = Color.black
    ball.fillColor = Color.white
    ball.origin = Vector2f(ballRadius / 2.0, ballRadius / 2.0)

    // Load the text font
    let font = Font(resourcesDir() + "tuffy.ttf")

    // Initialize the pause message
    let pauseMessage = Text(font, characterSize: 40)
    pauseMessage.position = Vector2f(170.0, 200.0)
    pauseMessage.fillColor = Color.white
    pauseMessage.string = "Welcome to SFML Tennis!\n\nPress space to start the game."

    // Define the paddles properties
    var AITimer = Clock()
    var AITime = Time(seconds: 0.1f32)
    const paddleSpeed = 400.0f32
    var rightPaddleSpeed = 0.0f32
    const ballSpeed = 400.0f32
    var ballAngle = 0.0f32 // to be changed later

    var clock = Clock()
    var isPlaying = false
    while (window.isOpen) {
        // Handle events
        while (let Some(evt) <- window.pollEvent()) {
            // Window closed or escape key pressed: exit
            match (evt) {
                case EvtClosed =>
                    window.closeWindow()
                    break
                case EvtKeyPressed(keyEvt) where keyEvt.code == KeyCode.Escape =>
                    window.closeWindow()
                    break
                case _ => ()
            }

            func play(paddleSize: Vector2f) {
                if (!isPlaying) {
                    // (re)start the game
                    isPlaying = true
                    clock.restart()

                    // Reset the position of the paddles and ball
                    leftPaddle.position = Vector2f(10.0 + (paddleSize.x / 2.0), gameHeight / 2.0)
                    rightPaddle.position = Vector2f(gameWidth - 10.0 - paddleSize.x / 2.0, gameHeight / 2.0)
                    ball.position = Vector2f(gameWidth / 2.0, gameHeight / 2.0)

                    // Reset the ball angle
                    do {
                        // Make sure the ball initial angle is not too much vertical
                        ballAngle = Float32(rand.nextInt16(360)) * 2.0 * pi / 360.0
                    } while (abs(cos(ballAngle)) < 0.7)
                }
            }

            // Space key pressed: play
            match (evt) {
                case EvtKeyPressed(keyEvt) where keyEvt.code == KeyCode.Space => play(paddleSize)
                case _ => ()
            }

            // Window size changed, adjust view appropriately
            match (evt) {
                case EvtResized(sizeEvt) => try (view = View()) {
                    view.size = Vector2f(gameWidth, gameHeight)
                    view.center = Vector2f(gameWidth / 2.0, gameHeight / 2.0)
                    window.view = view
                }
                case _ => ()
            }
        }

        if (isPlaying) {
            let deltaTime = clock.restart().seconds

            // Move the player's paddle
            if (Keyboard.isKeyPressed(KeyCode.Up) && (leftPaddle.position.y - paddleSize.y / 2.0 > 5.0)) {
                leftPaddle.move(Vector2f(0.0, -paddleSpeed * deltaTime))
            }
            if (Keyboard.isKeyPressed(KeyCode.Down) && (leftPaddle.position.y + paddleSize.y / 2.0 < gameHeight - 5.0)) {
                leftPaddle.move(Vector2f(0.0, paddleSpeed * deltaTime))
            }

            if (Touch.isDown(0)) {
                let pos = Touch.getPosition(0)
                let mappedPos = window.mapPixelToCoords(pos)
                leftPaddle.position = Vector2f(leftPaddle.position.x, mappedPos.y)
            }

            // Move the computer's paddle
            if (((rightPaddleSpeed < 0.0) && (rightPaddle.position.y - paddleSize.y / 2.0 > 5.0)) || ((rightPaddleSpeed >
                0.0) && (rightPaddle.position.y + paddleSize.y / 2.0 < gameHeight - 5.0))) {
                rightPaddle.move(Vector2f(0.0, rightPaddleSpeed * deltaTime))
            }

            // Update the computer's paddle direction according to the ball position
            if (AITimer.elapsedTime > AITime) {
                AITimer.restart()
                if (ball.position.y + ballRadius > rightPaddle.position.y + paddleSize.y / 2.0) {
                    rightPaddleSpeed = paddleSpeed
                } else if (ball.position.y - ballRadius < rightPaddle.position.y - paddleSize.y / 2.0) {
                    rightPaddleSpeed = -paddleSpeed
                } else {
                    rightPaddleSpeed = 0.0
                }
            }

            // Move the ball
            let factor = ballSpeed * deltaTime
            ball.move(Vector2f(cos(ballAngle) * factor, sin(ballAngle) * factor))

            const inputString = "Press space to restart or\nescape to exit."

            // Check collisions between the ball and the screen
            if (ball.position.x - ballRadius < 0.0) {
                isPlaying = false
                pauseMessage.string = "You Lost!\n\n" + inputString
            }
            if (ball.position.x + ballRadius > gameWidth) {
                isPlaying = false
                pauseMessage.string = "You Won!\n\n" + inputString
            }
            if (ball.position.y - ballRadius < 0.0) {
                ballSound.play()
                ballAngle = -ballAngle
                ball.position = Vector2f(ball.position.x, ballRadius + 0.1)
            }
            if (ball.position.y + ballRadius > gameHeight) {
                ballSound.play()
                ballAngle = -ballAngle
                ball.position = Vector2f(ball.position.x, gameHeight - ballRadius - 0.1)
            }

            // Check the collisions between the ball and the paddles
            // Left Paddle
            if (ball.position.x - ballRadius < leftPaddle.position.x + paddleSize.x / 2.0 &&
                ball.position.x - ballRadius > leftPaddle.position.x && ball.position.y + ballRadius >=
                leftPaddle.position.y - paddleSize.y / 2.0 && ball.position.y - ballRadius <= leftPaddle.position.y +
                paddleSize.y / 2.0) {
                if (ball.position.y > leftPaddle.position.y) {
                    ballAngle = pi - ballAngle + Float32(rand.nextInt16(20)) * pi / 180.0
                } else {
                    ballAngle = pi - ballAngle - Float32(rand.nextInt16(20)) * pi / 180.0
                }

                ballSound.play()
                ball.position = Vector2f(leftPaddle.position.x + ballRadius + paddleSize.x / 2.0 + 0.1, ball.position.y)
            }

            // Right Paddle
            if (ball.position.x + ballRadius > rightPaddle.position.x - paddleSize.x / 2.0 &&
                ball.position.x + ballRadius < rightPaddle.position.x && ball.position.y + ballRadius >=
                rightPaddle.position.y - paddleSize.y / 2.0 && ball.position.y - ballRadius <= rightPaddle.position.y +
                paddleSize.y / 2.0) {
                if (ball.position.y > rightPaddle.position.y) {
                    ballAngle = pi - ballAngle + Float32(rand.nextInt16(20)) * pi / 180.0
                } else {
                    ballAngle = pi - ballAngle - Float32(rand.nextInt16(20)) * pi / 180.0
                }

                ballSound.play()
                ball.position = Vector2f(
                    rightPaddle.position.x - ballRadius - paddleSize.x / 2.0 - 0.1,
                    ball.position.y
                )
            }
        }

        // Clear the window
        window.clear(Color(50, 50, 50))

        if (isPlaying) {
            // Draw the paddles and the ball
            window.draw(leftPaddle)
            window.draw(rightPaddle)
            window.draw(ball)
        } else {
            // Draw the pause message
            window.draw(pauseMessage)
            window.draw(sfmlLogo)
        }

        // Display things on screen
        window.display()
    }

    pauseMessage.close()
    font.close()
    ball.close()
    rightPaddle.close()
    leftPaddle.close()
    sfmlLogo.close()
    sfmlLogoTexture.close()
    ballSound.close()
    ballSoundBuffer.close()
    window.close()

    return 0
}

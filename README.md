# finalProjectQuizAnimationPde
This school project was the final project, it is a simple quiz on Elliptic Curve Cryptography.

Made using the Processing language

Quiz controls:

* Click on visible buttons to open them

* Press escape button or e to exit using keyboard

Game controls:

* Move mouse to the right end of the screen and make sure the 
turret of the tank is facing the right place

* Press enter to pause

* Click using the mouse to shoot

This is a quiz based on the topics Elliptic Curve Cryptographic algorithms(```ECC```) for public key generation, Elliptic Cryptography Digital Signature Algorithm(```ECDSA```) and Elliptic Cryptography Integrated Encryption Scheme(```ECIAS```). There are 10 questions you have to answer in under 10 seconds, if you don’t, you won’t get a point. If you get it right, you will get 10 points. The whole quiz is worth 100 points. When you get a question right, you play a tank game where you have to try and shoot a bird on the screen using the mouse. Keep the mouse as close to the right end as possible for better aiming. Click using any mouse button to shoot, the goal is to try and shoot the bird in under 10 seconds. If you do, you get 100 points which is the total amount of points in the quiz. This code is 1107 lines long and took around 10 days to make.

equation for the physics of the ammo for the game,

``` x = m+V0 * cos(θ) * t```

``` y = h-l - V0*sin(θ)*t + 5*t² ```

where,
* θ = degree of turret before shooting
* h = tank width
* l = tank height
* m = x location of turret
* t = time in seconds
* V0 = speed

NOTE:

ignore the warning
```
==== JavaSound Minim Error ====
==== Don't know the ID3 code TXXX
```
in the console.

LIBRARIES: minim

This code is quite long and sometimes inefficient. The timers I used sometimes work a bit off but I think that might be because rdweb sometimes lags as well, the timers are a bit annoying but the goal is to press the answer as fast as possible anyway. The game’s turret might be better if you didn’t have to aim down for a straight shot. These aren’t necessary since the game is supposed to be hard to win considering it gives you 100 points but it would be some good changes. If I could make the order of the questions random it would have been a good change but with my current setup, it is impossible, but if I made a list with all the questions and randomized them in the setup function and accessed all the questions in the map, it would’ve been random. If I had more time and motivation, I would’ve done this. One of the worst errors I encountered was the randomizing not working properly in the draw function, not even the noLoop function helped me fix it. Another error that might be complicated that I fixed was the Sound error. The Sound library doesn’t work properly on rdweb because of the unsupported frequency. Using the millis library solves this problem. A problem outside the code was downloading sound safely, I found a website that was genuinely recommended on instagram that lets you download sound without any adware or unwanted downloads. The site also seemed legit and I downloaded it on my phone using the Tor browser (The Tor browser gives you so much privacy that it is mostly just known for being used in the black market). After downloading the sound, implementation was easy. The code currently works without errors but I couldn’t download the millis library on Replit and it is a required library in the code.


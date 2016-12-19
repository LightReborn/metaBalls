# metaBalls
I saw a neat tutorial on metaballs by Daniel Shiffman on youtube (https://www.youtube.com/watch?v=ccYLb7cLB1I&amp;t=710s) and I thought I would improve on the design a bit as a fun programming task.
Everything was written in Processing. (https://processing.org/)
I decided to add some physics to the objects, and have them gravitate towards each other depending on their size.
The way that the metaBalls were implemented caused a lot of strain on the processor since every pixel is calculated by the CPU rather than GPU. I attempted to compensate for this by splitting up the screen into four quadrants and thread each of them so that they can be calculated in parallel. 
The speed gain was very notable, but still suffers greatly at high resolutions or greater numbers of balls.

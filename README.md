# Unit-UI
UNIT is a user interface (UI) library for Codea. It is currently in a pre-alpha state. There is also no documentation yet. But I have some lofty goals for this project!

***

## So... what is this, again?
To make a long story short, I was a beginner programmer. What I lacked in skill, I made up for in ambition! One day, I decided to make a little game in Codea, just to learn programming better, and for that, I needed a UI. I looked at the default UI library in Codea, and did not understand how it worked. So I looked for third party options, and Soda was basically the only one. That too, confused me. I was only a baby programmer, you see. I needed to learn UI the hard way. And thus, MyUi was born!

Yeah, this repository is not MyUi. MyUi was a terribly inefficient library. But it was a good first attempt, and so I decided to restart the project with a new engine, new design principles, a new name, a new everything! *Then* Unit was born, and I think it is pretty good! (Of course, I could be totally wrong because I'm a self-taught programmer living in a vacuum.)

***

## Design Principles
I want Unit to be as easy to use as possible. I also want Unit to be as modular as possible. I also want Unit to be as performant as possible. I also— wait, this merits a bullet-point list, doesn't it?
- **Easy to use:** I made my own UI library because all the others were a pain to use. Unit should be the shortest distance from a Codea programmer and a great UI. To accomplish this, I need to have great default values for everything, as well as an extremely intuitive implementation for everything. For example, parent-child relationships between UI elements can be represented as nested tables.
- **Modular:** Unit is centered around the Panel class, and nearly all its methods are swappable, so you can make panels behave exactly the way you want. In addition to the default values, there are also many useful functions defined to allow for a nice amount of hot-swappablity out of the box.
- **Performant:** Remember when I said that Unit "should be the shortest distance from a Codea programmer and a great UI"? Well, Unit should also be the shortest distance between the hardware and all the tasks that need to be performed for a great user experience. There cannot be any redundancy! Every line of code that is run needs to serve a purpose.
- **Feature-packed:** Unit needs to be able to do everything. For example, one of my loftier goals is to implement text editing for non-monospaced fonts. That's not implemented yet, but you get my point.

***

## Installation
To use Unit, download this repository, look in the Unit-UI-main folder that was downloaded, archive the Unit.codea folder as a ZIP file, and then open that ZIP file in Codea on your iOS/iPadOS device. Now that it is in your project library, you can make a new project and add the Unit project as a dependency. Put Unit.setup() into the setup() function, put Unit.draw() into the draw function, and do likewise for the touched(touch), sizeChanged(w, h), hover(gesture), scroll(gesture), and keyboard(key) functions. Now, you can start defining your first screen wherever you like!

***

## Where do I start?
For now, you'll have to examine the code. I haven't the time to write documentation at the moment. It's not a super complex project at the moment, though.

***

## License
<p xmlns:dct="http://purl.org/dc/terms/" xmlns:vcard="http://www.w3.org/2001/vcard-rdf/3.0#">
  <a rel="license"
     href="http://creativecommons.org/publicdomain/zero/1.0/">
    <img src="http://i.creativecommons.org/p/zero/1.0/88x31.png" style="border-style: none;" alt="CC0" />
  </a>
  <br />
  To the extent possible under law,
  <a rel="dct:publisher"
     href="https://github.com/calm-dolphin">
    <span property="dct:title">calm-dolphin</span></a>
  has waived all copyright and related or neighboring rights to
  <span property="dct:title">Unit-UI</span>.
This work is published from:
<span property="vcard:Country" datatype="dct:ISO3166"
      content="US" about="https://github.com/calm-dolphin">
  United States</span>.
</p>

# Oreo Cursors

### Install build version

https://www.pling.com/p/1360254/

The cursors can also be found under dist/ directory. Copy them to ~/.icons/ (only available to $USER) or /usr/share/icons/ (available to all users).

### Manual Install

1. Install dependencies:

    - git
    - make
    - inkscape
    - xcursorgen

2. Run the following commands as normal user:

    ```
    git clone https://github.com/varlesh/oreo-cursors.git
    cd oreo-cursors
    make build
    sudo make install
    ```
Note that on a i3 desktop processor, this might take 15 minutes to build all the 20 default cursors.

3. Choose a theme in the Settings or in the Tweaks tool.

### Generate user defined colours:

1. Install dependencies:
    - ruby (Minimum version 2.4 is required)

2. cd into the generator/ directory.

3. Create a file called colours.conf with colourname and colour value in hex, separated with =. For example:

```
# Name = Colour LabelColour ShadowColour ShadowOpacity
black_mod = #424242 #FFF #222 0.4

# This is a comment
```
It's most likely to have some contents in the colours.conf, remove and insert lines according to your likings.
Do note that if you don't specify the LabelColour, ShadowColour, ShadowOpacity, they will be default to #FFF, #000, 0.3 respectively.

4. Run `ruby convert.rb`. This will convert your colours and map it to the cursors.

5. Follow [Manual Install](https://github.com/Souravgoswami/oreo-cursors#manual-install) for build and installation.

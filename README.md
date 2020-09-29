# Oreo Cursors

### Install build version

https://www.pling.com/p/1360254/

The cursors can also be found under dist/ directory. Copy them to ~/.icons/ (only available to $USER) or /usr/share/icons/ (available to all users).

### Manual Install

1. Install dependencies:

    - git
    - make
    - ruby
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
black_mod = color: #424242, label: #FFF, shadow: #222, shadow-opacity: 0.4, stroke: #fff, stroke-opacity: 1, stroke-width: 1

# Lines with # are skipped.

Also follow the first Intro section from generator/colours.conf for more details.
```

(`make build` automatically runs the convert.rb file)

4. Follow [Manual Install](https://github.com/Souravgoswami/oreo-cursors#manual-install) for build and installation.

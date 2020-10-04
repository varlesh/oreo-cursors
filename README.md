# Oreo Cursors ![Screenshot Animated](https://raw.githubusercontent.com/Souravgoswami/oreo-cursors/oreo-multisize/images/oreo-animated-32.gif)

![Screenshot 1](https://raw.githubusercontent.com/Souravgoswami/oreo-cursors/oreo-multisize/images/image1.webp)

https://www.pling.com/p/1360254/

### Install build version 📦

The cursors can also be found under dist/ directory. Copy them to ~/.icons/ (only available to $USER) or /usr/share/icons/ (available to all users).

Alternatively run `make install` as root to copy them to /usr/share/icons.

### Manual Install 📦

1. Install dependencies 

    - git
    - make
    - ruby >= 2.4
    - inkscape
    - xcursorgen

2. Run the following commands as a regular non-root user

    ```
    git clone https://github.com/varlesh/oreo-cursors.git
    cd oreo-cursors
    make build
    
    # installs the cursor to /usr/share/icons/
    # To uninstall, remove the /usr/share/icons/oreo_* directories
    sudo make install 
    ```

⚠️ Note that on an i3 desktop processor, this might take 45 minutes to build 20 cursors with all the sizes given.

⚠️ You can avoid building and just install what's already built by us!

3. Choose a theme in the Settings or in the Tweaks tool.

### Generate user defined colours and sizes 🎨

1. Edit the file cursors.conf with colour name and colour value in hex:

```
black_mod = color: #424242, label: #FFF, shadow: #222, shadow-opacity: 0.4, stroke: #fff, stroke-opacity: 1, stroke-width: 1

# Lines with # are skipped.

Also read the comments in cursors.conf for more details.
```

To add custom size, use:

```
sizes = 24, 32, 40, 48, 64
```

(`make build` automatically runs all the necessary files)

⚠️ More sizes means more time to build. It can take upto an hour to build 5 - 6 sizes.

⚠️ More sizes also means more disk space .

2. Follow [Manual Install](https://github.com/Souravgoswami/oreo-cursors#manual-install) for build and installation.

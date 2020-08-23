# Oreo Cursors

### Install build version

https://www.pling.com/p/1360254/

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

3. Choose a theme in the Settings or in the Tweaks tool.

### Generate user defined colours:

1. Install dependencies:
    - ruby

2. cd into the src/ directory.

3. Generate a file called colours.conf with colourname and colour value in hex, separated with =. For example:

```
spark_dark = #222
spark_red = #ff5555
spark_blue = #55ffff
spark_pink = #ff50a6
spark_orange = #FFA726
spark_green = #4E9A06
spark_purple = #912BFF
```

4. Run convert.rb This will convert your colours and map it to the cursors.

5. Go to the manual install section and start building the cursor.

# Flathub Images

Interface snapshot settings.

## General Settings

- Theme: Light
- Screen resolution: 1920x1080

- **Turn off Night Light mode**!
- Resize the window (see *Window Size* settings)
- Aim for no scrollbars (horizontal or vertical)
- Command center: closed
- No `nls` script visible
- *View updates* enabled
- Maintain default settings

## Window Size

Install `wmctrl` to manage windows (if not already installed).

- For resizing the *NetLogo* Window, use:

```bash
#gravity,x,y,width,height
wmctrl -r NetLogo -e 0,112,75,950,613
```

- For resizing the *Models Library* window, use:

```bash
wmctrl -r "Models Library" -e 0,112,75,950,613
```

- For resizing the *3D View* window, use:

```bash
wmctrl -r "3D View" -e 0,112,75,950,613
```

## Screenshots

> The screenshots should have 1000x700 resolution in the end.

### NetLogo

1. Open NetLogo.
2. Go to *File > Models Library*.
3. Select and open the *Chloroplast and Food* model from the *Sample Models > Biology* category.
4. Go to *Zoom > Smaller* (2x).
5. If the an asterisk appears next to the model name, go to *File > Recent Files* and click on the first entry to reload the model.
6. Resize the window (see *Window Size* settings).
7. Click `setup` and then `go`.
8. Run until the 2000th tick, then click `go` again to pause the model.
9. Take the screenshots below using by right-clicking the window and selecting *Take Screenshot* (GNOME).

#### `images/netlogo-interface.png`

1. Take a screenshot of the *Interface* tab.
2. Fix it

#### `images/netlogo-info.png`

Take a screenshot of the *Info* tab.

#### `images/netlogo-code.png`

Take a screenshot of the *Code* tab.

### Model Library (`images/netlogo-library.png`)

1. Go to *File > Models Library*.
2. Resize the *Models Library* window (see *Window Size* settings).
3. Select and open the *Chloroplast and Food* model from the *Sample Models > Biology* category.
4. Roll the bar at the bottom of the window.
5. Take the screenshot.

### NetLogo 3D (`images/netlogo-3d.png`)

1. Open NetLogo 3D.
2. Go to *File > Models Library*.
3. Select the *Mousetraps 3D* model from the *3D > Sample Models* category.
4. Resize the *3D View* window (see *Window Size* settings).
5. Click `setup` and then `go`.
6. Run until the 500th tick, then click `go` again to pause the model.
7. Orbit the view to show the 3D environment.
8. Move the view to the center of the environment.
9. Take the screenshot.

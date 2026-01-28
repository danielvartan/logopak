# Resize Icons

Use the following commands to resize the icons to 512x512 pixels for Flatpak packaging:

```bash
magick mogrify -resize 512x512 *.png
```

Rename the files with:

```bash
for file in *.png; do
  filename=$(basename "$file" .png)
  mv "$file" "${filename}-512x512.png"
done
```

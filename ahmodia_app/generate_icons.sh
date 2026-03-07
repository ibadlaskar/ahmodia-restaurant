#!/bin/bash
# Generates all Android launcher icons using ImageMagick
set -e

RES_DIR="$CM_BUILD_DIR/ahmodia_app/android/app/src/main/res"

declare -A SIZES=(
  ["mipmap-mdpi"]=48
  ["mipmap-hdpi"]=72
  ["mipmap-xhdpi"]=96
  ["mipmap-xxhdpi"]=144
  ["mipmap-xxxhdpi"]=192
)

for folder in "${!SIZES[@]}"; do
  size=${SIZES[$folder]}
  mkdir -p "$RES_DIR/$folder"

  # Create icon: green rounded square + gold circle + rice emoji style
  convert -size ${size}x${size} xc:none \
    -fill "#1B4332" \
    -draw "roundrectangle 0,0,$((size-1)),$((size-1)),$((size/8)),$((size/8))" \
    -fill "#F0A500" \
    -draw "ellipse $((size/2)),$((size/2)),$((size/3)),$((size/3)),0,360" \
    -fill "#FAF5EB" \
    -draw "ellipse $((size/2)),$((size/2)),$((size/3-4)),$((size/3-4)),0,360" \
    -fill "#FFFCF0" \
    -draw "ellipse $((size/2)),$((size/2-2)),$((size/4)),$((size/6)),0,360" \
    -fill "#B45020" \
    -draw "ellipse $((size*2/5)),$((size/2)),$((size/5)),$((size/7)),0,360" \
    "$RES_DIR/$folder/ic_launcher.png"

  cp "$RES_DIR/$folder/ic_launcher.png" "$RES_DIR/$folder/ic_launcher_round.png"
  echo "Created $folder (${size}x${size})"
done

echo "All icons generated!"

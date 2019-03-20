name='osm'
path='https://tile.openstreetmap.org/{z}/{x}/{y}.png'

z=19

x1=324900
y1=205210

x2=325040
y2=205290

################################################################################

tiles="$name-tiles"
mkdir -p $tiles

width=$(($x2 - $x1))
height=$(($y2 - $y1))
size=$(($width * $height))
echo "$size files are needed for a $width × $height tile image"

echo >| "$tiles/manifest.txt"
echo >| "$tiles/required.txt"

for y in $(seq $y1 $y2)
do
    for x in $(seq $x1 $x2)
    do
        tilename="$tiles/$z-$y-$x.png"
        echo $tilename >> "$tiles/manifest.txt"
        test -f $tilename && continue
        echo "Downloading $tilename..."
        location=$(echo $path | sed "s/{x}/$x/" | sed "s/{y}/$y/" | sed "s/{z}/$z/")
        echo $location >> "$tiles/required.txt"
        curl -sSL $location -o $tilename &
    done
    wait
done

for filename in $(cat "$tiles/manifest.txt")
do
    test ! -f $filename && echo "$filename is missing!" && exit 1
done
echo 'Tiles downloaded. Montaging...'

output="$name-$z-$x1-$y1-$x2-$y2.png"
preview="$name-$z-$x1-$y1-$x2-$y2-preview.png"
magick montage -mode concatenate -tile "$(($width + 1))x" -monitor @"$tiles/manifest.txt" $output 2>&1 | grep -v 'Load/Image'
magick convert -resize 7680x -quality 100 -monitor $output $preview

echo
echo 'Created:'
echo "  $output"
echo "  $preview"

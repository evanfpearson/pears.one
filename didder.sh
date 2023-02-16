FMT=$(echo "$1" | awk -F. '{ print $NF }')

IN="image.$FMT"
OUT="image.didder.png"

curl -o $IN -s $1

didder -i $IN -o $OUT -p '0 96 255' bayer 4x4

rm $IN

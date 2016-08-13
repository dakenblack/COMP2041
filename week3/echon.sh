if [ $# -ne 2 ]; then
  echo "Usage: ./echon.sh <number of lines> <string>"
  exit
fi

if ! [[ $1 =~ ^[0-9]+$ ]]; then
  echo "./echon.sh: argument 1 must be a non-negative integer"
  exit
fi

for i in $(seq $1); do
  echo $2
done

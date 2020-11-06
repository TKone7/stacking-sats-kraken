
BASE_DIR=$(cd `dirname $0` && pwd)
cd $BASE_DIR
result=$(npm run withdraw-sats 2>&1)
echo $result

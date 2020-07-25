# #!/bin/bash
set -ue -o pipefail
export LC_ALL=C

if [ $# -ne 1 ]; then
    echo 'Usage : `test save`（正しい出力データをセーブする） or `test check`（書き換えたAPIで出力を検査）'
    exit 1
fi

# テストを書く
## test save
### apiにアクセスして結果を順にtestdata/${name}.saveとして保存する。

# (apiを書き換える)
## test check
### apiにアクセスして結果を順にtestdata/${name}.checkとして保存する。
### 保存後、*.saveと*.checkを比較する。
### 比較はがんばる…

mkdir -p testdata

if [ $1 = 'save' ]; then
    echo 'SAVE MODE.'
    # もしtestdata/*.saveがあったら警告
    if ls testdata/*.save > /dev/null 2>&1 ; then
        echo 'testdata/*.save are found.'
        echo 'REMOVE these files if you want to update *.save file'
        echo 'or'
        echo 'TYPE `test check` if you typo `test save` by mistake when you want to check api.'
        exit 1
    fi
elif [ $1 = 'check' ]; then
    echo 'CHECK MODE.'
else
    echo '正しい入力じゃないよ！'
    exit 1
fi

# 番号をわりふるやつ
global_increment_num=0
function increment_num {
    idxxx=`printf %02d $global_increment_num`
    global_increment_num=$((global_increment_num+=1))
    echo $idxxx
}

## ここから下適宜書き換える
ADDRESS='localhost:1234'
EXT=$1
echo "access [ $ADDRESS ]."

# initialize (no output)
curl -XGET $ADDRESS/initialize

# 登録
increment_num
curl -XPOST $ADDRESS/api/users -H "Content-Type: application/json" --data '{ "nickname": "hoge", "login_name": "hoge", "password": "hoge"}' -o "testdata/`increment_num`register.$1"
id=$(cat "testdata/`increment_num`register.$1" | jq '.id')

# cookieをつくるためにログイン
increment_num
curl -XPOST -c cookie.txt $ADDRESS/api/actions/login -H "Content-Type: application/json" --data '{"login_name": "hoge", "password": "hoge"}' -o "testdata/`increment_num`login.$1"

# user info
increment_num
curl -XGET -b cookie.txt $ADDRESS/api/users/$id -o "testdata/`increment_num`api.user.$id.$1"

# all events
increment_num
curl -XGET -b cookie.txt $ADDRESS/api/events -o "testdata/`increment_num`api.events.$1"

# event info
increment_num
curl -XGET -b cookie.txt $ADDRESS/api/events/11 -o "testdata/`increment_num`api.events.11.$1"

# get reservation (今回はappのsheet idを固定すれば良い)
increment_num
curl -XPOST -b cookie.txt $ADDRESS/api/events/11/actions/reserve -H "Content-Type: application/json" --data '{"sheet_rank": "S"}' -o "testdata/`increment_num`api.events.11.actions.reserve.$1"
sheet_num=$(cat "testdata/`increment_num`api.events.11.actions.reserve.$1" | jq '.sheet_num')

# AFTER reservation

# user info ()
increment_num
curl -XGET -b cookie.txt $ADDRESS/api/users/$id -o "testdata/`increment_num`api.user.$id.one.$1"

# all events ()
increment_num
curl -XGET -b cookie.txt $ADDRESS/api/events -o "testdata/`increment_num`api.events.after.$1"

# event info ()
increment_num
curl -XGET -b cookie.txt $ADDRESS/api/events/11 -o "testdata/`increment_num`api.events.11.after.$1"

# delete reservation (no output)
increment_num
curl -XDELETE -b cookie.txt $ADDRESS/api/events/11/sheets/S/$sheet_num/reservation

## ここまで適宜書き換える

if [ $1 = 'save' ]; then
    echo 'Saving api result is completed. You can verify your new api via `test check`!'
    exit 0
fi

result=0
for f in testdata/*.save; do
    echo '-----start-----:'
    echo 'case' $f

    echo 'expect answer: '
    echo "$(cat ${f})"

    echo 'your answer:'
    echo "$(cat ${f/.save/.check})"

    echo "diff:"
    echo $(diff -b $f ${f/.save/.check})
    res="AC"
    if diff -b $f ${f/.save/.check} >/dev/null 2>&1; then
        res="AC"
    else
        res="WA"
        result=1
    fi
    echo "------fin[$res]------"
    echo ""
done

exit $result

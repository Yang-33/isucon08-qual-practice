from inspect import currentframe

# 現在のスコープに最も近い変数の情報を得る
def DEBUG(*args):
    names = {id(v):k for k,v in globals().items()}
    for k,v in currentframe().f_back.f_locals.items():
        names.update({id(v):k})
    print('-----------------')
    print(', '.join(names.get(id(arg),'???')+' = '+repr(arg) for arg in args))
    print('-----------------')


if __name__ == "__main__":
    a=121
    DEBUG(a)

    li=[1,2,3]
    DEBUG(li)

    li=[1,2,[3,a]]
    DEBUG(li)

    uku = {'x': 10, 'y': 20}
    DEBUG(uku) 

    import json
    json_data = """{
        "name": "taro",
        "age": 20,
        "home": {
            "zip_code": "0000000",
            "city": "Osaka"
        }
    }"""
    user = json.loads(json_data)
    DEBUG(user)

    def f():
        a = 12111
        b = 1212111
        DEBUG(a)
        DEBUG(b)
        DEBUG(user)

    f()

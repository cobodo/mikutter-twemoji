# mikutter-twemoji
[twemoji](https://github.com/twitter/twemoji)の絵文字リソースを使って、mikutter上の絵文字を置き換えます。フォントをインストールすることなくカラー絵文字が楽しめます。

# インストール方法
* mikutter 3.7をインストールします。もしくはmikutterリポジトリの`topic/1164-score`ブランチをcheckoutします。
* コマンドを実行します。
```shell-session
mkdir -p ~/.mikutter/plugin && git clone git://github.com/cobodo/mikutter-twemoji ~/.mikutter/plugin/twemoji
```

# 注意事項
* mikutter 3.7ではない場合は`.mikutter.yml`を適当に書き換えてください。
* twemojiの更新に追従しきれなかった場合は死んでしまうと思います。
* mikutter側の仕様変更で死ぬ可能性も多分にあります。

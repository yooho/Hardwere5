

シミュレータで100byte通信はテスト済み
r232cはrx=0となったらstateを0→1→2・・・と変えて値を読んでいき、state=9(stopbitの途中)でcompを出す

topはcompが出たらgoを立てる

u232cはgoが立ったら、dataを送信する。8bit目のデータを送信し終わると(sendbufの中身が1のみ)waitに戻り、goを待つ

・現状
通信が不安定
(典型的な1bit落ち？minicomから0.5秒ごとにスペースキー入力をしていても@に化けることがある)

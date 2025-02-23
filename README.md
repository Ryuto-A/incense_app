# incense_app
お香のアプリケーション

■サービス概要
どんなサービスなのかを３行で説明してください。

「お香に特化した食べログ」
お香を嗜むユーザーに対して、自身の好みのお香から、新たな発見・出会いを提供するサービスです。
ユーザーは自身のお気に入りのお香や、新しく試したお香など、ブランドやお店、種類ごとにレビューを写真付きで投稿することができます。
ユーザーは他者の投稿や投稿内に作成された香りのタグから、気になる香りのお香を検索することができるだけでなく、投稿内のリンクから商品購入サイトへアクセスすることができ、スムーズな製品購入にも繋げます。


■ このサービスへの思い・作りたい理由
このサービスの題材となるものに関してのエピソードがあれば詳しく教えてください。
このサービスを思いつくにあたって元となる思いがあれば詳しく教えてください。

私はお香を焚くことが趣味です。多いときには週に３回以上、作業時間や寝る前のリラックス時間にお香を焚いています。
特にお気に入りのブランドがあり、気分を上げたい時やリラックスしたい時など、気持ちをリフレッシュさせたい時に必ずと入って良いほど活躍してくれる存在であり、今では私生活の中になくてはならないグッズの一つです。

私が初めてお香を購入したとき、実際に気になっていた店舗でさまざまな香りを総当たりで試しました。
その結果、30種類以上ある香りの中で、自分が良いと思ったものはわずか３種類ほどでした。

さまざまな香りを試してみることも醍醐味ですし、案外そういう時間が楽しくて、新しい出会いにつながることもあると思います。
しかし、「自分の好みの香りの系統から派生させて、徐々に広げていく」出会い方があっても良いのでは？と思い、今回のアプリ開発のアイデアとして考えました。


■ ユーザー層について
決めたユーザー層についてどうしてその層を対象にしたのかそれぞれ理由を教えてください。

ユーザー層はかなりニッチですが、老若男女を問わず、お香を好む全てのユーザーを対象に考えています。
先述の「自分の好みの香りの系統から派生させて、徐々に広げていく」出会い方を体験してもらいたいという思いからです。


■サービスの利用イメージ
ユーザーがこのサービスをどのように利用できて、それによってどんな価値を得られるかを簡単に説明してください。

ユーザーはアカウント登録ひとつで、自身のお香について投稿することができます。また、他のユーザーの投稿やタグ検索から、新しいお香との出会いを体験することができます。


■ ユーザーの獲得について
想定したユーザー層に対してそれぞれどのようにサービスを届けるのか現状考えていることがあれば教えてください。

Instagramのように、ユーザーが気になるタグをフォローし、該当のタグに新規投稿が追加されると通知される仕組みを考えています。

■ サービスの差別化ポイント・推しポイント
似たようなサービスが存在する場合、そのサービスとの明確な差別化ポイントとその差別化ポイントのどこが優れているのか教えてください。
独自性の強いサービスの場合、このサービスの推しとなるポイントを教えてください。

似たようなサービスにSNSが挙げられますが、Instagramではお香以外にも投稿があるため、お香に特化しているという点で差別化を図っています。
具体的には、一つ一つのお香について焦点を当て、お香自体のレビューに特化したアプリケーションのため、ユーザーが求めている香りや成分でお香を探すことができる、という部分で差別化を図っています。

■ 機能候補
現状作ろうと思っている機能、案段階の機能をしっかりと固まっていなくても構わないのでMVPリリース時に作っていたいもの、本リリースまでに作っていたいものをそれぞれ分けて教えてください。

● MVPリリース時
・ユーザー登録機能
・ログイン機能
・ログアウト機能
・投稿のCRUD機能
・画像アップロード機能
・コメント機能
・検索機能

● 本リリース時
・お気に入り機能（ブックマーク）
・通知機能（LINE または メール）
・パスワードリセット
・お問い合わせ
・利用規約
・SNSログイン
・投稿時の該当商品の製品画面（外部サイト）へのリンク

■ 機能の実装方針予定
一般的なCRUD以外の実装予定の機能についてそれぞれどのようなイメージ(使用するAPIや)で実装する予定なのか現状考えているもので良いので教えて下さい

ここまで学習したことを活かし、全ての機能をRuby on Railsを用いて実装する予定です。

以下、現段階で考えている各機能の使用技術です。
● MVPリリース時
・ユーザー登録機能：devise
・ログイン機能：devise
・ログアウト機能：devise
・投稿のCRUD機能：resources
・画像アップロード機能：active_storage
・コメント機能：has_many :comments
・検索機能：ransack

● 本リリース時
・お気に入り機能（ブックマーク）：ajax
・通知機能（LINE または メール）：line-bot-api または action_mailer
・パスワードリセット：devise
・お問い合わせ：mail_form
・利用規約：high_voltage
・SNSログイン：omuiauth
・投稿時の該当商品の製品画面（外部サイト）へのリンク：nokogiri

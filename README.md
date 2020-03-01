# Jpx

[東証データクラウド](http://db-ec.jpx.co.jp/)から購入したデータのCSVファイルをパースするライブラリです。

現在対応しているのは以下のデータです。

- 日経225先物　1分足

## Installation

Add this line to your application's Gemfile:

    gem "jpx"

And then execute:

    $ bundle install --path vendor/bundle

Or install it yourself as:

    $ gem install jpx


## Usage

日本の証券取引所で取引が行われる日であるか判定します。<br>
大発会〜大納会のうち、休日及び祝日でない日が該当します。

``` ruby
Jpx::Price.parse("/path/to/file.csv")

#=> [{
      :datetime=>2018-01-04 08:45:00 +0900, # 実際に取引が行われた日時に変換しています
      :session=>0,                          # 0 - 日中, 1 - ナイトセッション
      :open=>23100,
      :high=>23200,
      :low=>23080,
      :close=>23082,
      :volume=>3027
     }, ...]
```

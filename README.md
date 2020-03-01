# Jpx

[JPXデータクラウド](http://db-ec.jpx.co.jp/)から購入したデータのCSVファイルをパースするライブラリです。

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

``` ruby
# CSVファイルから期近のデータを取得します
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

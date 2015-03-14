# Humans.rb

A Ruby gem for parsing humans.txt files

## Installation

1. Add `gem 'humans-rb'` to your project's Gemfile
2. `bundle install`

## Usage

```ruby
# Passing a domain (defaults to domain/humans.txt)
> HumansRb.new("http://ben.balter.com").parse
=> {
    :site=> {
      :"last updated"=>"2015/03/12",
      :standards=>"HTML5, CSS3",
      :components=> "jekyll, jekyll-coffeescript, jekyll-sass-converter, kramdown, maruku, rdiscount, redcarpet, RedCloth, liquid, pygments.rb, jemoji, jekyll-mentions, jekyll-redirect-from, jekyll-sitemap, github-pages, ruby"
    },
    :team=> {
      :name=>"benbalter", :site=>"https://github.com/benbalter"},
      :name=>"balterbot", :site=>"https://github.com/balterbot"}
    }
  }

# Passing a URL
> HumansRb.new("http://ben.balter.com/humans.txt").parse
=> {:site=>..}

# Passing a string
> HumansRb.new("/* SITE */...").parse
```

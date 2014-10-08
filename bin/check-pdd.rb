#!/usr/local/bin/ruby -Ke
# -*- coding: euc-jp -*-
# -*- ruby -*-

## check-pdd.rb
##

$fullerenes = { }
$pair = { }
$reverse = { }
while gets
  if $_ =~ /(Mirror=(.+),)?Pdd=(.+)\) (.+)$/
    $mirror = $2
    $pdd = $3
    $key = $4
    $fullerenes[$key] = $pdd
    if $mirror
      $pair[$key] = $mirror
    end
  end
end
$fullerenes.each { |key, pdd|
  already = $reverse[pdd]
  if already
    if already != $pair[key]
      print "#{already} and #{key} have same pdd #{pdd}\n"
    end
  else
    $reverse[pdd] = key
  end
}

#!/usr/local/bin/ruby
# -*- coding: utf-8 -*-
# -*- ruby -*-

## pddgf2cc.rb
##

$name = ARGV[0]
$root = ARGV[1]

print "/*\n"
print " * this file is generated by pddgf2cc.rb from .pddgf file.\n"
print " */\n"
print "\n"
print "#include \"TreeItem.h\"\n"
print "\n"

$already = { }
$table = { }
while $stdin.gets
  if $_ =~ /^C(\d+) \(NoA=(\d+),(MirrorSymmetric,)?(Mirror=(.+),)?(Pdd=[0-9;]+)\) (.+)$/
    $Cn = $1.to_i
    $NoA = $2.to_i
    if $3
      $MirrorSymmetric = true
    else
      $MirrorSymmetric = false
    end
    $Mirror = $5
    $Gen = $7
    $already[$5] = true if $Mirror
    if ! $already.has_key?($Gen)
      if ! $table.has_key?($Cn)
        $table[$Cn] = { "contents" => { } }
      end
      key = $table[$Cn]["contents"]
      if ! key.has_key?($Gen)
        key[$Gen] = { }
      end
      key = key[$Gen]
      key["NoA"] = $NoA
      if $Mirror
        key["mirror"] = $Mirror
      end
      key["mirrorSymmetric"] = $MirrorSymmetric
    end
  end
end
$offset = 0
$child = 0
$row = 0
$keys = $table.keys.sort
$num = $keys.length
print "const int number_of_#{$name}_top = #{$num};\n"
print "const TreeItem #{$name}[] = {\n"
$child = $child + $num
$me = 0
$keys.each do |key1|
  current1 = $table[key1]
  keys1 = current1["contents"].keys
  num1 = keys1.length
  current1["id"] = $me
  print "  TreeItem( #{$row}, root_mtis + #{$root}, #{num1}, #{$name} + #{$child}, \"C#{key1}\" ), /* #{$offset} */\n"
  $offset = $offset + 1
  $row = $row + 1
  $me = $me + 1
  $child = $child + num1
end
$keys.each do |key|
  current1 = $table[key]
  parent1 = current1["id"]
  keys1 = current1["contents"].keys
  row1 = 0
  keys1.each do |key2|
    current2 = current1["contents"][key2]
    $NoA = current2["NoA"]
    if current2["mirrorSymmetric"]
      $NoA = $NoA.to_s + "M"
    end
    if current2.has_key?("mirror")
      current2["id"] = $me
      print "  TreeItem( #{row1}, #{$name} + #{parent1}, 1, #{$name} + #{$child}, \"(NoA=#{$NoA}) #{key2}\" ), /* #{$offset} */\n"
      $child = $child + 1
    else
      print "  TreeItem( #{row1}, #{$name} + #{parent1}, 0, #{$name} + 0, \"(NoA=#{$NoA}) #{key2}\" ), /* #{$offset} */\n"
    end
    $offset = $offset + 1
    row1 = row1 + 1
    $me = $me + 1
  end
end
$keys.each do |key|
  current1 = $table[key]
  keys1 = current1["contents"].keys
  keys1.each do |key2|
    current2 = current1["contents"][key2]
    if current2.has_key?("mirror")
      parent2 = current2["id"]
      key3 = current2["mirror"]
      print "  TreeItem( 0, #{$name} + #{parent2}, 0, #{$name} + 0, \"(鏡像) #{key3}\" ), /* #{$offset} */\n"
      $offset = $offset + 1
    end
    $me = $me + 1
  end
end

print "};\n"

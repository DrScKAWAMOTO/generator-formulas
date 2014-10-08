#!/usr/local/bin/ruby -Ke
# -*- coding: euc-jp -*-
# -*- ruby -*-

## moreNoA=3.rb
##

while gets
  if $_ =~ /NoA=(\d+),/
    noa = $1.to_i
    if $_ =~ /MirrorSymmetric/
      if noa >= 2
        print
      end
    else
      if noa.to_i >= 3
        print
      end
    end
  end
end

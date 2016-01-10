s/<\(\/\)\?\(b\|i\|u\|s\|center\|left\|right\|justify\|sub\|sup\|br\|hr\|pre\|blockquote\|ol\|ul\|li\|spoiler\|quote\)>/[\1\2]/g
s/<h1>/[b][size=30]/g
s/<h2>/[b][size=25]/g
s/<h3>/[b][size=20]/g
s/<h4>/[b][size=15]/g
s/<\/h1>/[\/size=30][\/b]/g
s/<\/h2>/[\/size=25][\/b]/g
s/<\/h3>/[\/size=20][\/b]/g
s/<\/h4>/[\/size=15][\/b]/g
s/<font color=\([a-z]+\)>/[color=\1]/g
s/<\/font>/[\/color]/g
s/<img src=\"\([^"]\+\)\"[^>]*>/[img]\1[\/img]/g
s/\/\"/\"/g
s/<a href=\"\([^"]\+\)\"[^>]*>/[url=\1]/g
s/<\/a>/[\/url]/g

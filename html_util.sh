if [ $DIAGDIR == '.' ]; then
  DIAGDIR=$PWD
fi

html_header() {
# prints HTML header and the begining of body
# starts a table
RUNID=$1
cat > $HTML << EOF
<?xml version="1.1" encoding="UTF-8" ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtmll1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ja" lang="ja">
<head>
  <meta http-equiv="content-type" content="text/html; charset="UTF-8" />
  <title>${RUNID}</title>
</head>
<body>
<h1>${RUNID}</h1>
<hr />
<table>
EOF
}

html_dataset() {
# prints a header with a name of dataset ($1)
DSET=$1
cat >> $HTML << EOF
  <tr>
    <th align=left><font color=navy size=+1>${DSET}</font></th>
  </tr>
EOF
}

html_row_begin() {
# starts a row with a label ($1)
LABEL=$1
cat >> $HTML << EOF
  <tr>
    <th>${LABEL}</th>
EOF
}

html_entry() {
# creates a link to a fig ($1) with a label ($2)
FIG=$1
LABEL=$2
cat >> $HTML << EOF
    <td><a href="${FIG}">${LABEL}</td>
EOF
}

html_row_end() {
# terminates a row
cat >> $HTML << EOF
  </tr>
EOF
}

html_footer() {
# closes body and html
cat >> $HTML << EOF
</table>
<hr />
</body>
</html>
EOF
}


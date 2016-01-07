#!/bin/bash

test_regexp() {
    regexp_test="$1"
    test="$2"
    
    #echo "Testing '$test' against '$regexp_test'"

    if [[ $test =~ $regexp_test ]]; then
        echo "'$test' passes with '${BASH_REMATCH[1]}'"
    else
        echo "'$test' doesn't matches"
    fi
}


echo "Validation regexp HELO"
regexp_helo="^HELO\s?(.*)"

test_regexp "$regexp_helo" "HELO"
test_regexp "$regexp_helo" "HELO "
test_regexp "$regexp_helo" "HELO from mars"
test_regexp "$regexp_helo" "HELO [127.0.0.1]"
test_regexp "$regexp_helo" "HELO (127.0.0.1)"

echo "Validation regexp MAIL FROM"
regexp_mail_from="^MAIL FROM:<?([a-z0-9._%+-]+@[a-z0-9.-]+(\.[a-z]{2,4})?)>?"

test_regexp "$regexp_mail_from" "MAIL FROM:bill.gates@microsoft.com"
test_regexp "$regexp_mail_from" "MAIL FROM:<bill.gates@microsoft.com>"
test_regexp "$regexp_mail_from" "MAIL FROM:bob@localhost"
test_regexp "$regexp_mail_from" "MAIL FROM:<bob@localhost>"
test_regexp "$regexp_mail_from" "MAIL FROM:bill.gates"
test_regexp "$regexp_mail_from" "MAIL FROM:<bill.gates>"

echo "Validation regexp RCPT TO"
regexp_rcpt_to="^RCPT TO:<?([a-z0-9._%+-]+@[a-z0-9.-]+(\.[a-z]{2,4})?)>?"

test_regexp "$regexp_rcpt_to" "RCPT TO:test@tpmail.info.unicaen.fr"
test_regexp "$regexp_rcpt_to" "RCPT TO:<test@tpmail.info.unicaen.fr>"
test_regexp "$regexp_mail_from" "MAIL FROM:bob@localhost"
test_regexp "$regexp_mail_from" "MAIL FROM:<bob@localhost>"
test_regexp "$regexp_mail_from" "MAIL FROM:bill.gates"
test_regexp "$regexp_mail_from" "MAIL FROM:<bill.gates>"

include("${COMMON}")

set(P "Arrays")
run("${P} 1" "[]K=1,2,3;[2]K=a,b;[2]K" "a")
run("${P} 2" "[]K=1,2,3;[?]K" "3")
run("${P} 3" "K=1,2,3;[1]K=9;[]K" "1\n9\n3")
run("${P} 4" "[]K=1,2,3;[1]K" "2")
run("${P} 5" "K=1,2,3;[-]K;[]K" "3\n1\n2")
run("${P} 6" "[]K=1,2,3;[+]K;[]K" "1\n2\n3")
run("${P} 7" "K=1,2,3;[-1]K" "2")
run("${P} 8" "[]K=1,2,3;[-1]K;[?]K" "2\n2")
run("${P} 9" "K=1,2,3;[-1]K=;[]K" "2\n1\n3")
run("${P} 10" "[]K=1,2,3;[+1]K=a;[]K" "1\na\n2\n3")
run("${P} 11" "K=1,2,3;[0]K" "1")
run("${P} 12" "[]K=1,2,3;[4]K" "")
run("${P} 13" "K=1;[1]K=2;K" "1,2")
run("${P} 14" "[]K=1,2;[+]K=3;[]K" "1\n2\n3")
run("${P} 15" "[]K=1,2;[+]K=2;[]K" "1\n2")
run("${P} 16" "K=a,b,c;[-b]K;K" "a,c")
# XXX run("${P} 17" "[]K=a,b,c;[b]K" "1")
run("${P} 18" "[]K=a,b,c;[-]K=b;[]K" "a\nc")
run("${P} crash test" "[b]b" "") # crash test
run("${P} 19" "foo=1,2,3,4;+[1]foo=1;foo" "1,0x3,3,4")
run("${P} 20" "foo=1,2,3,4;+[1]foo" "3")
run("${P} 21" "foo=1,2,3,4;-[1]foo" "1")

set(P "Sorted Arrays")
run("${P} 1" "[]K=cd,bc,ab;[!]K;K" "ab,bc,cd")
run("${P} 2" "[]K=aa,bb,yy;[!+]K=xx,qq,aa;K" "aa,aa,bb,qq,xx,yy")
run("${P} 3" "[!+]K=xx,qq,aa;[!+]K=ff,bb,zz;K" "aa,bb,ff,qq,xx,zz")
run("${P} 4" "[]K=,x,a, ;[!]K;K" ", ,a,x")
run("${P} 5" "[]K=9,9,8,5,1,10;[#]K;K" "1,5,8,9,9,10")
run("${P} 6" "[]K=0x1,0x5,0xf;[#+]K=0xa;K" "0x1,0x5,0xa,0xf")
run("${P} 7" "[#+]K=0x1;[#+]K=0xa;[#+]K=0x5;K" "0x1,0x5,0xa")

set(P "Set")
run("${P} 1" "K=;[+]K=1;[+]K=1;K" 1)
run("${P} 2" "K=;[+]K=a;[+]K=b;K" "a,b")
run("${P} 3" "K=;[+]K=a;[+]K=b;[+]K=a;K" "a,b")
run("${P} 4" "K=;[+]K=a;[+]K=b;[-]K=a;K" "b")
run("${P} 5" "K=;[+]K=a;[+]K=b;[-]K=a;[-]K=b;K" "")

set(P "Stack")
run("${P} 1" "K=1,2;[++]K=;K" ",1,2")
run("${P} 2" "K=1,2;[--]K=;K" "1,2")
run("${P} 3" "K=1,2;[--]K;K" "1\n2")
run("${P} 4" "K=;[++]K=1;K" "1")
run("${P} 5" "[]K=;[++]K=1;K" "1")
run("${P} 6" "[]K=;[++]K=1;[++]K=2;K" "2,1")
run("${P} 7" "K=1,2,3;[--]K;[?]K" "1\n2")
run("${P} 8" "K=1,2,3;[--]K;[]K" "1\n2\n3")

# [+] and [-] is wrongly defined. mixes stack and set concepts
set(P "Wrong parsing")
#run("${P} 1" "[]K=1,2,3;[-]K;[+]K=4;[]K" "3\n1\n2\n4")
#run("${P} 2" "[]K=1,2,3\n[-]K\n[+]K=4\n[]K" "3\n1\n2\n4")

end()
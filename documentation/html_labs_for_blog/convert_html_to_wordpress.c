#include <stdio.h>

/*

<pre>
<font face="Courier"><pre>

</pre>
</pre></font>

<p><big><big><b>
<h2>

<p><big><b>
<h3>

<p><b>
<h4>

</b></big></big></p>
</h2>

</b></big></p>
</h3>

</b></p>
</h4>




final_rename \<pre\> \<font face=\"Courier\"\>\<pre\>

final_rename \<\/pre\> \<\/pre\>\<font face=\"Courier\"\>

final_rename \<p\>\<big\>\<big\>\<b\> \<h2\>

final_rename \<p\>\<big\>\<b\> \<h3\>

final_rename \<p\>\<b\> \<h4\>

final_rename \<\/b\>\<\/big\>\<\/big\>\<\/p\> \<\/h2\>

final_rename \<\/b\>\<\/big\>\<\/p\> \<\/h3\>

final_rename \<\/b\>\<\/p\> \<\/h4\>

*/

int main ()
{
    int c, pc = 0, ppc = 0, pppc = 0, ppppc = 0, mode = 0;

    while ((c = getchar ()) != EOF)
    {
        if (      ppc == '<' &&               pc == 'p' &&  c == '>')
            mode = 1;
        else if (pppc == '<' && ppc == '/' && pc == 'p' && c == '>')
            mode = 0;

        if (      pppc == '<' &&                ppc == 'l' && pc == 'i' && c == '>')
            mode = 1;
        else if (ppppc == '<' && pppc == '/' && ppc == 'l' && pc == 'i' && c == '>')
            mode = 0;

        if (mode && c == '\n')
            c = ' ';
        else if (c == '\r')
            continue;
            
        putchar (c);
    
        ppppc = pppc;
        pppc  = ppc;
        ppc   = pc;
        pc    = c;
    }
}

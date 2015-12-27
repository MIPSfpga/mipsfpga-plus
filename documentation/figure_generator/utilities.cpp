# include "stdio.h"
# include "string.h"

char const mipsfpga_plus_github_location [] = "http://github.com/MIPSfpga/mipsfpga-plus/blob/master";
char const mipsfpga_download_instruction [] = "http://www.silicon-russia.com/2015/12/11/mipsfpga-download-instructions";

const char * module_names [1000];
int          n_module_names;

const char * current_module_name;
int          current_module_is_already_described;

int level = 0;

//----------------------------------------------------------------------------

#define p         printf

#define header    p ("<font size=2 face=\"Verdana, Arial, Helvetica, sans_serif\">\n");
#define footer    p ("</font>\n");

#define tr        p ("<tr>\n");
#define td        p ("<td valign=top>\n");
#define _tr       p ("</tr>\n");
#define _td       p ("</td>\n");
#define hbreak    _td td
#define vbreak    _td _tr tr td
#define ellipsis  p (". . . . . . . . . .<br><br>\n");

//----------------------------------------------------------------------------

void module
(
    const char * file_url      = NULL,
    const char * module_name   = NULL,
    const char * instance_name = NULL,
    const char * description   = NULL,
    int          colspan       = 1
)
{
    level ++;

    if (current_module_name == NULL && module_name != NULL)
        module_names [n_module_names ++] = module_name;

    int the_module_is_current

        =    current_module_name != NULL
          && module_name         != NULL
          && strcmp (module_name, current_module_name) == 0;

    // if (! the_module_is_current || current_module_is_already_described)
    //     description = NULL;

    if (the_module_is_current)
        current_module_is_already_described = 1;

    char buf [BUFSIZ];

    if (file_url != NULL && strstr (file_url, "http") == NULL)
    {
        sprintf (buf, "%s/%s", mipsfpga_plus_github_location, file_url);
        file_url = buf;
    }

    p ("<table width=%s", level == 1 ? "1000" : "100%%");

    char const * level_colors []
        = { "A3FFD1", "A3FFFF", "A3D1FF" };

    p (" bgcolor=#%s", the_module_is_current ? "FFFF29"
        : level_colors [level % (sizeof (level_colors) / sizeof (* level_colors))]);
        
    if (module_name != NULL || instance_name != NULL || description != NULL) p (" border=2");

    p (" cellpadding=10 cellspacing=0 rules=none>\n");

    if (module_name != NULL || instance_name != NULL || description != NULL)
    {
        // p ("<tr><td valign=top nowrap=nowrap");
        p ("<tr><td valign=top");
        
        if (colspan != 1)
            p (" colspan=%d", colspan);
        
        p (">\n");

        if (module_name != NULL || instance_name != NULL) p ("<b>");
        
        if (module_name != NULL)
        {
            if (file_url != NULL) p ("<a href=\"%s\">", file_url);
        
            p ("%s", module_name);
        
            if (file_url != NULL) p ("</a>");
        }
        
        if (module_name != NULL && instance_name != NULL) p (" ");
        
        if (instance_name != NULL) p ("%s", instance_name);
        
        if (module_name != NULL || instance_name != NULL) p ("</b>");
        
        if ((module_name != NULL || instance_name != NULL) && description != NULL) p ("<br><br>\n");
        
        if (description != NULL) p ("%s", description);
        
        p ("\n</td></tr>\n");
    }

    p ("<tr><td valign=top>\n");

    colspan = 1;
}

//----------------------------------------------------------------------------

#define _module  p ("</td></tr>\n</table>\n"), level --;

#define group   module ();
#define _group  _module

//----------------------------------------------------------------------------

void leaf
(
    const char * file_url      = NULL,
    const char * module_name   = NULL,
    const char * instance_name = NULL,
    const char * description   = NULL
)
{
    module
    (
        file_url,
        module_name,
        instance_name,
        description
    );

    _module
}

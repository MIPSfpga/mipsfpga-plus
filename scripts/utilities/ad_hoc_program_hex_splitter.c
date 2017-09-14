#include "stdio.h"
#include "stdlib.h"
#include "string.h"

char program_hex          [] = "program.hex";
char program_00000000_hex [] = "program_00000000.hex";
char program_1fc00000_hex [] = "program_1fc00000.hex";

int main (void)
{
    char buf [BUFSIZ];

    if (! freopen (program_hex, "r", stdin))
    {
        fprintf (stderr, "Cannot open \"%s\" for reading\n", program_hex);
        return EXIT_FAILURE;
    }

    if (! freopen (program_00000000_hex, "w", stdout))
    {
        fprintf (stderr, "Cannot open \"%s\" for writing\n", program_00000000_hex);
        return EXIT_FAILURE;
    }

    while (fgets (buf, sizeof (buf), stdin))
    {
        if (buf [0] == '@')
        {
            if (buf [1] == '9')
                break;

            if (buf [1] != '8')
            {
                fprintf (stderr, "Address starting with 8 is expected\n");
                return EXIT_FAILURE;
            }

            buf [1] = '0';
        }

        if (fputs (buf, stdout) == EOF)
        {
            fprintf (stderr, "Error writing \"%s\"\n", program_00000000_hex);
            return EXIT_FAILURE;
        }
    }

    if (ferror (stdin))
    {
        fprintf (stderr, "Error reading \"%s\"\n", program_hex);
        return EXIT_FAILURE;
    }

    if (feof (stdin))
    {
        fprintf (stderr, "Unexpected end of file \"%s\"\n", program_hex);
        return EXIT_FAILURE;
    }

    /************************************************************************/

    if (! freopen (program_1fc00000_hex, "w", stdout))
    {
        fprintf (stderr, "Cannot open \"%s\" for writing\n", program_1fc00000_hex);
        return EXIT_FAILURE;
    }

    do
    {
        if (buf [0] == '@')
        {
            if (! (buf [1] == '9' && buf [2] == 'F' && buf [3] == 'C'))
            {
                fprintf (stderr, "Address starting with 9FC is expected\n");
                return EXIT_FAILURE;
            }

            buf [1] = buf [2] = buf [3] = '0';
        }

        if (fputs (buf, stdout) == EOF)
        {
            fprintf (stderr, "Error writing \"%s\"\n", program_1fc00000_hex);
            return EXIT_FAILURE;
        }
    }
    while (fgets (buf, sizeof (buf), stdin));

    if (ferror (stdin))
    {
        fprintf (stderr, "Error reading \"%s\"\n", program_hex);
        return EXIT_FAILURE;
    }

    return EXIT_SUCCESS;
}

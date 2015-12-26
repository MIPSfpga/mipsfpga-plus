#include "stdio.h"
#include "string.h"

char const mipsfpga_plus_github_location [] = "http://github.com/MIPSfpga/mipsfpga-plus/blob/master";
char const mipsfpga_download_instruction [] = "http://www.silicon-russia.com/2015/12/11/mipsfpga-download-instructions";

const char * current_module_name                 = NULL;
int          current_module_is_already_described = 0;

int level   = 0;
int colspan = 1;

//----------------------------------------------------------------------------

void module_instance
(
    const char * module_name   = NULL,
    const char * instance_name = NULL,
    const char * description   = NULL,
    const char * file_url      = NULL
)
{
    int describe_current_module

        =      current_module_name != NULL
          && ! current_module_is_already_described
          &&   strcmp (module_name, current_module_name) == 0;

    if (! describe_current_module)
        description = NULL;

    char buf [BUFSIZ];

    if (file_url == NULL && module_name != NULL)
    {
        sprintf (buf, "%s/%s.v", mipsfpga_plus_github_location, module_name);
        file_url = buf;
    }

    if (level > 0)
    {
        printf ("<tr><td valign=top>\n");
    }

    level ++;

    printf ("<table width=100%%");

    if (module_name != NULL || instance_name != NULL || description != NULL) printf (" border=1");

    printf (" cellpadding=10 cellspacing=0 rules=none>\n");

    printf ("<tr><td valign=top colspan=%d nowrap=nowrap bkcolor=#%s>",
        colspan, describe_current_module ? "ffff3f" : "cfcfcf");

    if (module_name != NULL || instance_name != NULL) printf ("<b>");

    if (module_name != NULL)
    {
        if (file_url != NULL) printf ("<a href=\"%s\">", file_url);

        printf ("%s", module_name);

        if (file_url != NULL) printf ("</a>");
    }

    if (module_name != NULL && instance_name != NULL) printf (" ");

    if (instance_name != NULL) printf ("%s", instance_name);

    if (module_name != NULL || instance_name != NULL) printf ("</b>");

    if ((module_name != NULL || instance_name != NULL) && description != NULL) printf (" ");

    if (description != NULL) printf ("%s", description);

    printf ("</td></tr>\n");

    if (describe_current_module)
        current_module_is_already_described = 1;

    colspan = 1;
}

//----------------------------------------------------------------------------

void end_module_instance ()
{
    printf ("</table>\n");

    level --;

    if (level > 0)
        printf ("</td></tr>\n");
}

//----------------------------------------------------------------------------

void leaf_module_instance
(
    const char * module_name   = NULL,
    const char * instance_name = NULL,
    const char * description   = NULL,
    const char * file_name     = NULL
)
{
    module_instance
    (
        module_name,
        instance_name,
        description,
        file_name
    );

    end_module_instance ();
}

//----------------------------------------------------------------------------

void ellipsis ()
{
    printf ("<tr><td valign=top>. . . . . . . . . .<br><br></td></tr>\n");
}

//----------------------------------------------------------------------------

struct board_descriptor
{
    char const * module_name;
    int          testbench;
    int          altera;
    int          display;
    char const * description;
}
boards [] =
{
    { "mfp_testbench" , 1, 0, 0, "Testbench for RTL simulation"                                    },
    { "de0_cv"        , 0, 1, 1, "Wrapper for Terasic DE0-CV board with Altera Cyclone V FPGA"     }, 
    { "de0_nano"      , 0, 1, 0, "Wrapper for Terasic DE0-Nano board with Altera Cyclone IV FPGA"  },
    { "nexys4_ddr"    , 0, 0, 1, "Wrapper for Digilent Nexys 4 DDR board with Xilinx Artix-7 FPGA" },
    { "basys3"        , 0, 0, 1, "Wrapper for Digilent Basys 3 board with Xilinx Artix-7 FPGA"     },
    { "marsohod3"     , 0, 1, 0, "Wrapper for Marsohod 3 board with Altera MAX10 FPGA"             }
};

int i_board;
int switchable_clock;
int light_sensor;
int serial_loader;

void print_hierarchy ()
{
    char buf [BUFSIZ];

    sprintf
    (
        buf,
        "../run/hierarchy_%s%s%s%s.html",
        boards [i_board].module_name,
        switchable_clock ? "_switchable_clock" : "", 
        light_sensor     ? "_light_sensor"     : "", 
        serial_loader    ? "_serial_loader"    : "" 
    );

    freopen (buf, "w", stdout);

    char const * file_url = NULL;

    if (! boards [i_board].testbench)
    {
        sprintf (buf, "%s/boards/%s/%s.v",
            mipsfpga_plus_github_location,
            boards [i_board].module_name,
            boards [i_board].module_name);

        file_url = buf;
    }

    module_instance
    (
        boards [i_board].module_name,
        NULL,
        boards [i_board].description,
        file_url
    );

    if (switchable_clock)
    {
        mfp_multi_switch_or_button_sync_and_debouncer
        mfp_clock_divider_50_MHz_to_25_MHz_12_Hz_0_75_Hz 
        global gclk
    }

        module_instance ("mfp_ahb_gpio_slave.v", "mfp_ahb_gpio_slave" );
        module_instance ("mfp_ahb_lite_matrix.v", "mfp_ahb_lite_matrix" );
        module_instance ("mfp_ahb_lite_matrix.v", "mfp_ahb_lite_decoder" );
        module_instance ("mfp_ahb_lite_matrix.v", "mfp_ahb_lite_response_mux" );
        module_instance ("mfp_ahb_lite_matrix_with_loader.v", "mfp_ahb_lite_matrix_with_loader" );
        module_instance ("mfp_ahb_ram_slave.v", "mfp_ahb_ram_slave" );
        module_instance ("mfp_clock_dividers.v", "mfp_clock_divider" );
        module_instance ("mfp_clock_dividers.v", "mfp_clock_divider_100_MHz_to_25_MHz_12_Hz_0_75_Hz" );
        module_instance ("mfp_clock_dividers.v", "mfp_clock_divider_50_MHz_to_25_MHz_12_Hz_0_75_Hz" );
        module_instance ("mfp_clock_dividers.v", "mfp_clock_divider_100_MHz_to_763_Hz" );
        module_instance ("mfp_dual_port_ram.v", "mfp_dual_port_ram" );
        module_instance ("mfp_pmod_als_spi_receiver.v", "mfp_pmod_als_spi_receiver" );
        module_instance ("mfp_seven_segment_displays.v", "mfp_single_digit_seven_segment_display" );
        module_instance ("mfp_seven_segment_displays.v", "mfp_multi_digit_display" );
        module_instance ("mfp_srec_parser.v", "mfp_srec_parser" );
        module_instance ("mfp_srec_parser_to_ahb_lite_bridge.v", "mfp_srec_parser_to_ahb_lite_bridge" );
        module_instance ("mfp_switch_and_button_debouncers.v", "mfp_switch_or_button_sync_and_debouncer" );
        module_instance ("mfp_switch_and_button_debouncers.v", "mfp_multi_switch_or_button_sync_and_debouncer" );
        module_instance ("mfp_system.v", "mfp_system" );
        module_instance ("mfp_system.v", "mfp_ejtag_reset" );
        module_instance ("mfp_testbench.v", "mfp_testbench" );
        module_instance ("mfp_uart_receiver.v", "mfp_uart_receiver" );


/*2

    sprintf
    (
        buf,
        "../run/hierarchy_%s%s%s%s.html",
        boards [i_board].module_name,
        switchable_clock ? "_switchable_clock" : "", 
        light_sensor     ? "_light_sensor"     : "", 
        serial_loader    ? "_serial_loader"    : "" 
    );

    module_instance


void print_hierarchy_for_board (char const * board)
{
    module_instance ("mfp_clock_dividers", NULL, NULL);


    mfp_multi_switch_or_button_sync_and_debouncer
    mfp_clock_divider_50_MHz_to_25_MHz_12_Hz_0_75_Hz 
    global gclk
    mfp_system mfp_system

    mfp_single_digit_seven_segment_display digit_0
    ellipsis ();
    mfp_single_digit_seven_segment_display digit_5


        module_instance ("mfp_ahb_gpio_slave.v", "mfp_ahb_gpio_slave" );
        module_instance ("mfp_ahb_lite_matrix.v", "mfp_ahb_lite_matrix" );
        module_instance ("mfp_ahb_lite_matrix.v", "mfp_ahb_lite_decoder" );
        module_instance ("mfp_ahb_lite_matrix.v", "mfp_ahb_lite_response_mux" );
        module_instance ("mfp_ahb_lite_matrix_with_loader.v", "mfp_ahb_lite_matrix_with_loader" );
        module_instance ("mfp_ahb_ram_slave.v", "mfp_ahb_ram_slave" );
        module_instance ("mfp_clock_dividers.v", "mfp_clock_divider" );
        module_instance ("mfp_clock_dividers.v", "mfp_clock_divider_100_MHz_to_25_MHz_12_Hz_0_75_Hz" );
        module_instance ("mfp_clock_dividers.v", "mfp_clock_divider_50_MHz_to_25_MHz_12_Hz_0_75_Hz" );
        module_instance ("mfp_clock_dividers.v", "mfp_clock_divider_100_MHz_to_763_Hz" );
        module_instance ("mfp_dual_port_ram.v", "mfp_dual_port_ram" );
        module_instance ("mfp_pmod_als_spi_receiver.v", "mfp_pmod_als_spi_receiver" );
        module_instance ("mfp_seven_segment_displays.v", "mfp_single_digit_seven_segment_display" );
        module_instance ("mfp_seven_segment_displays.v", "mfp_multi_digit_display" );
        module_instance ("mfp_srec_parser.v", "mfp_srec_parser" );
        module_instance ("mfp_srec_parser_to_ahb_lite_bridge.v", "mfp_srec_parser_to_ahb_lite_bridge" );
        module_instance ("mfp_switch_and_button_debouncers.v", "mfp_switch_or_button_sync_and_debouncer" );
        module_instance ("mfp_switch_and_button_debouncers.v", "mfp_multi_switch_or_button_sync_and_debouncer" );
        module_instance ("mfp_system.v", "mfp_system" );
        module_instance ("mfp_system.v", "mfp_ejtag_reset" );
        module_instance ("mfp_testbench.v", "mfp_testbench" );
        module_instance ("mfp_uart_receiver.v", "mfp_uart_receiver" );
*/
    end_module_instance ();
}

//----------------------------------------------------------------------------

int main ()
{
    i_board          = 0;
    switchable_clock = 0;
    light_sensor     = 0;
    serial_loader    = 0;

    print_hierarchy ();

    for (i_board = 1; i_board < sizeof (boards) / sizeof (* boards); i_board ++)
    for (switchable_clock = 0; switchable_clock <= 1; switchable_clock ++)
    for (light_sensor     = 0; light_sensor     <= 1; light_sensor     ++)
    for (serial_loader    = 0; serial_loader    <= 1; serial_loader    ++)
    {
        print_hierarchy ();
    }

    return 0;
}

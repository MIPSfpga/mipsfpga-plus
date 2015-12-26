#include "utilities.cpp"

struct board_descriptor
{
    char const * module_name;
    int          testbench;
    int          clock_frequency;
    int          altera;
    int          static_7_segment_display;
    int          dynamic_7_segment_display;
    char const * description;
}
boards [] =
{
    { "mfp_testbench" , 1 ,   0 , 0 , 0 , 0 , "Testbench for RTL simulation"                                    },
    { "de0_cv"        , 0 ,  50 , 1 , 1 , 0 , "Wrapper for Terasic DE0-CV board with Altera Cyclone V FPGA"     }, 
    { "de0_nano"      , 0 ,  50 , 1 , 0 , 0 , "Wrapper for Terasic DE0-Nano board with Altera Cyclone IV FPGA"  },
    { "nexys4_ddr"    , 0 , 100 , 0 , 0 , 1 , "Wrapper for Digilent Nexys 4 DDR board with Xilinx Artix-7 FPGA" },
    { "basys3"        , 0 , 100 , 0 , 0 , 1 , "Wrapper for Digilent Basys 3 board with Xilinx Artix-7 FPGA"     },
    { "marsohod3"     , 0 ,  50 , 1 , 0 , 0 , "Wrapper for Marsohod 3 board with Altera MAX10 FPGA"             }
};

int i_board;
int switchable_clock;
int light_sensor;
int serial_loader;

void print_hierarchy ()
{
    board_descriptor * b = & boards [i_board];

    char buf [BUFSIZ];

    sprintf
    (
        buf,
        "../run/hierarchy_%s%s%s%s.html",
        b -> module_name,
        switchable_clock ? "_switchable_clock" : "", 
        light_sensor     ? "_light_sensor"     : "", 
        serial_loader    ? "_serial_loader"    : "" 
    );

    freopen (buf, "w", stdout);

    char const * file_url = NULL;

    if (! b -> testbench)
    {
        sprintf (buf, "boards/%s/%s.v",
            b -> module_name,
            b -> module_name);

        file_url = buf;
    }

    module
    (
        file_url,
        b -> module_name,
        NULL,
        b -> description
    )

        if (switchable_clock)
        {
            group

            module ("mfp_switch_and_button_debouncers.v", "mfp_multi_switch_or_button_sync_and_debouncer")
                leaf ("mfp_switch_and_button_debouncers.v", "mfp_switch_or_button_sync_and_debouncer",
                    "debouncer for switches that controls the clock")
            _module

            hbreak

            if (b -> clock_frequency == 50)
                module ("mfp_clock_dividers.v", "mfp_clock_divider_50_MHz_to_25_MHz_12_Hz_0_75_Hz")
            else if (b -> clock_frequency == 100)
                module ("mfp_clock_dividers.v", "mfp_clock_divider_100_MHz_to_25_MHz_12_Hz_0_75_Hz")

                leaf ("mfp_clock_dividers.v", "mfp_clock_divider" )

            _module
            hbreak

            if (b -> altera)
                leaf_module (NULL, "global", "gclk", "needed for the divided clock")
            else
                leaf_module (NULL, "BUFG", NULL, "needed for the divided clock")

            _group
        }

        if (b -> static_7_segment_display)
        {
            group
            leaf_module_instance ("mfp_seven_segment_displays.v", "mfp_single_digit_seven_segment_display", "digit_0");
            hbr
            leaf_module_instance ("mfp_seven_segment_displays.v", "mfp_single_digit_seven_segment_display", "digit_1");
            hbr
            ellipsis
            _group
        }

        if (b -> dynamic_7_segment_display)
        {
            tr td
            leaf_module_instance ("mfp_clock_dividers.v", "mfp_clock_divider_100_MHz_to_763_Hz", NULL, "clock for 7-segment display");
            _td td
            leaf_module_instance ("mfp_seven_segment_displays.v", "mfp_multi_digit_display" );
            _td _tr
        }

        _group

        module_instance ("mfp_system.v", "mfp_system" );

            leaf_module_instance ("mfp_system.v", "mfp_ejtag_reset" );

            leaf_module_instance (mipsfpga_download_instruction, "m14k_top", NULL, "the CPU core");

        end_module_instance ();

    end_module_instance ();
/*
        module_instance ("mfp_ahb_gpio_slave.v", "mfp_ahb_gpio_slave" );
        module_instance ("mfp_ahb_lite_matrix.v", "mfp_ahb_lite_matrix" );
        module_instance ("mfp_ahb_lite_matrix.v", "mfp_ahb_lite_decoder" );
        module_instance ("mfp_ahb_lite_matrix.v", "mfp_ahb_lite_response_mux" );
        module_instance ("mfp_ahb_lite_matrix_with_loader.v", "mfp_ahb_lite_matrix_with_loader" );
        module_instance ("mfp_ahb_ram_slave.v", "mfp_ahb_ram_slave" );
        module_instance ("mfp_clock_dividers.v", "mfp_clock_divider_100_MHz_to_763_Hz" );
        module_instance ("mfp_dual_port_ram.v", "mfp_dual_port_ram" );
        module_instance ("mfp_pmod_als_spi_receiver.v", "mfp_pmod_als_spi_receiver" );
        module_instance ("mfp_srec_parser.v", "mfp_srec_parser" );
        module_instance ("mfp_srec_parser_to_ahb_lite_bridge.v", "mfp_srec_parser_to_ahb_lite_bridge" );
        module_instance ("mfp_testbench.v", "mfp_testbench" );
        module_instance ("mfp_uart_receiver.v", "mfp_uart_receiver" );
*/

/*2

    sprintf
    (
        buf,
        "../run/hierarchy_%s%s%s%s.html",
        b -> module_name,
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

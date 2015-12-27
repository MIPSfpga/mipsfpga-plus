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
        "../run/hierarchy_%s%s%s%s%s%s.html",
        b -> module_name,
        switchable_clock            ? "_switchable_clock" : "", 
        light_sensor                ? "_light_sensor"     : "", 
        serial_loader               ? "_serial_loader"    : "",
        current_module_name != NULL ? "_"                 : "",  
        current_module_name != NULL ? current_module_name : ""
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
    );

        group

        if (switchable_clock)
        {
            group

                module ("mfp_switch_and_button_debouncers.v", "mfp_multi_switch_or_button_sync_and_debouncer");
                    leaf ("mfp_switch_and_button_debouncers.v", "mfp_switch_or_button_sync_and_debouncer", NULL,
                        "Debouncer for switches that controls the clock");
                _module

                vbreak

            if (b -> clock_frequency == 50)
                module ("mfp_clock_dividers.v", "mfp_clock_divider_50_MHz_to_25_MHz_12_Hz_0_75_Hz");
            else if (b -> clock_frequency == 100)
                module ("mfp_clock_dividers.v", "mfp_clock_divider_100_MHz_to_25_MHz_12_Hz_0_75_Hz");

                    leaf ("mfp_clock_dividers.v", "mfp_clock_divider");

                _module

                vbreak

            if (b -> altera)
                leaf (NULL, "global", "gclk", "Needed for the divided clock");
            else
                leaf (NULL, "BUFG", NULL, "Needed for the divided clock");

            _group
        }

        hbreak

        if (b -> static_7_segment_display)
        {
            group
            leaf ("mfp_seven_segment_displays.v", "mfp_single_digit_seven_segment_display", "digit_0");
            vbreak
            leaf ("mfp_seven_segment_displays.v", "mfp_single_digit_seven_segment_display", "digit_1");
            vbreak
            leaf ("mfp_seven_segment_displays.v", "mfp_single_digit_seven_segment_display", "digit_2");
            vbreak
            ellipsis
            _group
        }

        if (b -> dynamic_7_segment_display)
        {
            group
            leaf ("mfp_clock_dividers.v", "mfp_clock_divider_100_MHz_to_763_Hz", NULL, "Clock for 7-segment display");
            vbreak
            leaf ("mfp_seven_segment_displays.v", "mfp_multi_digit_display");
            _group
        }

        _group

        vbreak

        module ("mfp_system.v", "mfp_system", NULL, NULL, 2 + light_sensor);
            group
            leaf (mipsfpga_download_instruction, "m14k_top", NULL, "The CPU core");
            vbreak
            leaf ("mfp_system.v", "mfp_ejtag_reset");
            _group

            hbreak

            if (serial_loader)
            {
                module ("mfp_ahb_lite_matrix_with_loader.v", "mfp_ahb_lite_matrix_with_loader", NULL, NULL, 2);
                    group
                    leaf ("mfp_uart_receiver.v", "mfp_uart_receiver");
                    vbreak
                    leaf ("mfp_srec_parser.v", "mfp_srec_parser");
                    vbreak
                    leaf ("mfp_srec_parser_to_ahb_lite_bridge.v", "mfp_srec_parser_to_ahb_lite_bridge");
                    _group

                    hbreak
            }

            module ("mfp_ahb_lite_matrix.v", "mfp_ahb_lite_matrix" );

                leaf ("mfp_ahb_lite_matrix.v", "mfp_ahb_lite_decoder" );
                vbreak

                module ("mfp_ahb_ram_slave.v", "mfp_ahb_ram_slave", "reset_ram");
                    leaf ("mfp_dual_port_ram.v", "mfp_dual_port_ram", "i0");
                    vbreak
                    leaf ("mfp_dual_port_ram.v", "mfp_dual_port_ram", "i1");
                    vbreak
                    leaf ("mfp_dual_port_ram.v", "mfp_dual_port_ram", "i2");
                    vbreak
                    leaf ("mfp_dual_port_ram.v", "mfp_dual_port_ram", "i3");
                _module
            
                vbreak

                module ("mfp_ahb_ram_slave.v", "mfp_ahb_ram_slave", "ram");
                    leaf ("mfp_dual_port_ram.v", "mfp_dual_port_ram", "i0");
                    vbreak
                    leaf ("mfp_dual_port_ram.v", "mfp_dual_port_ram", "i1");
                    vbreak
                    ellipsis
                _module
            
                vbreak
                leaf ("mfp_ahb_gpio_slave.v", "mfp_ahb_gpio_slave", "gpio");
                vbreak
                leaf ("mfp_ahb_lite_matrix.v", "mfp_ahb_lite_response_mux");

            _module

            if (serial_loader)
                _module

            if (light_sensor)
            {
                hbreak
                leaf ("mfp_pmod_als_spi_receiver.v", "mfp_pmod_als_spi_receiver" );
            }

        _module

    _module
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
        // module_names and n_module_names are extracted when current_module_name is NULL

        current_module_name = NULL;
        print_hierarchy ();

        for (int i = 0; i < n_module_names; i ++)
        {
            current_module_name = module_names [i];
            print_hierarchy ();
        }
    }

    return 0;
}

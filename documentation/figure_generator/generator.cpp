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
    { "mfp_testbench" , 1 ,   0 , 0 , 0 , 0 , "Testbench for RTL simulation"                                                                       },
    { "nexys4_ddr"    , 0 , 100 , 0 , 0 , 1 , "Wrapper for Digilent Nexys 4 DDR board with Xilinx Artix-7 FPGA"                                    },
    { "de0_cv"        , 0 ,  50 , 1 , 1 , 0 , "Wrapper for Terasic DE0-CV board with Altera Cyclone V FPGA"                                        }, 
    { "nexys4_ddr"    , 0 , 100 , 0 , 0 , 1 , "Wrapper for Digilent Nexys 4 DDR board with Xilinx Artix-7 FPGA (without 7-segment display module)" },
    { "de0_cv"        , 0 ,  50 , 1 , 1 , 0 , "Wrapper for Terasic DE0-CV board with Altera Cyclone V FPGA (without 7-segment display module)"     }, 
    { "de0_nano"      , 0 ,  50 , 1 , 0 , 0 , "Wrapper for Terasic DE0-Nano board with Altera Cyclone IV FPGA"                                     },
    { "basys3"        , 0 , 100 , 0 , 0 , 1 , "Wrapper for Digilent Basys 3 board with Xilinx Artix-7 FPGA"                                        },
    { "marsohod3"     , 0 ,  50 , 1 , 0 , 0 , "Wrapper for Marsohod 3 board with Altera MAX10 FPGA"                                                }
};

int i_board;
int narrow_write_support;
int switchable_clock;
int light_sensor;
int serial_loader;
int without_7_segment_display;

void print_hierarchy ()
{
    current_module_is_already_described = 0;

    board_descriptor * b = & boards [i_board];

    char buf [BUFSIZ];

    sprintf
    (
        buf,
        "../run/hierarchy_%s%s%s%s%s%s%s.html",
        b -> module_name,
        narrow_write_support        ? "__narrow_write_support" : "",
        light_sensor                ? "__light_sensor"         : "", 
        serial_loader               ? "__serial_loader"        : "",
        switchable_clock            ? "__switchable_clock"     : "", 
        without_7_segment_display   ? "__wo_7_segment_display" : "", 
        current_module_name != NULL ? "__"                     : "",  
        current_module_name != NULL ? current_module_name      : ""
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

    header

    module
    (
        file_url,
        b -> module_name,
        NULL,
        b -> description
    );

        if (   switchable_clock
            || 
                  ! without_7_segment_display
               && (b -> static_7_segment_display || b -> dynamic_7_segment_display))
        {
            group
            
            if (switchable_clock)
            {
                group
            
                    module ("mfp_switch_and_button_debouncers.v", "mfp_multi_switch_or_button_sync_and_debouncer");
                        leaf ("mfp_switch_and_button_debouncers.v", "mfp_switch_or_button_sync_and_debouncer", NULL,
                            "Debouncer for the switches that control the clock");
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
            
            if (   ! without_7_segment_display
                && (b -> static_7_segment_display || b -> dynamic_7_segment_display))
            {
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
            }
            
            _group
            
            vbreak
        }

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
                    leaf ("mfp_uart_receiver.v", "mfp_uart_receiver", NULL, "Receives data bytes from the PC via UART");
                    vbreak
                    leaf ("mfp_srec_parser.v", "mfp_srec_parser", NULL, "Parses data received via UART as text in Motorola S-Record format and issues transactions to fill the system memory with this data");
                    vbreak
                    leaf ("mfp_srec_parser_to_ahb_lite_bridge.v", "mfp_srec_parser_to_ahb_lite_bridge", NULL, "Converts the transactions from S-Record parser into AHB-Lite protocol. Also converts virtual addresses into physical using fixed mapping");
                    _group

                    hbreak
            }

            module ("mfp_ahb_lite_matrix.v", "mfp_ahb_lite_matrix" );

                leaf ("mfp_ahb_lite_matrix.v", "mfp_ahb_lite_decoder" );
                vbreak

                module ("mfp_ahb_ram_slave.v", "mfp_ahb_ram_slave", "reset_ram");

                    if (narrow_write_support)
                    {
                        leaf ("mfp_dual_port_ram.v", "mfp_dual_port_ram", "i0");
                        vbreak
                        leaf ("mfp_dual_port_ram.v", "mfp_dual_port_ram", "i1");
                        vbreak
                        leaf ("mfp_dual_port_ram.v", "mfp_dual_port_ram", "i2");
                        vbreak
                        leaf ("mfp_dual_port_ram.v", "mfp_dual_port_ram", "i3");
                    }
                    else
                    {
                        leaf ("mfp_dual_port_ram.v", "mfp_dual_port_ram");
                    }
                _module
            
                vbreak

                module ("mfp_ahb_ram_slave.v", "mfp_ahb_ram_slave", "ram");
                    if (narrow_write_support)
                    {
                        leaf ("mfp_dual_port_ram.v", "mfp_dual_port_ram", "i0");
                        vbreak
                        leaf ("mfp_dual_port_ram.v", "mfp_dual_port_ram", "i1");
                        vbreak
                        ellipsis
                    }
                    else
                    {
                        leaf ("mfp_dual_port_ram.v", "mfp_dual_port_ram");
                    }
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
                leaf ("mfp_pmod_als_spi_receiver.v", "mfp_pmod_als_spi_receiver", NULL, "Receives data from the light sensor using a version of SPI protocol");
            }

        _module

    _module
    footer
}

//----------------------------------------------------------------------------

int main ()
{
    if (0)
    {
    for (i_board              = 0; i_board < sizeof (boards) / sizeof (* boards); i_board ++)
    for (narrow_write_support = 0; narrow_write_support <= 1; narrow_write_support ++)
    for (switchable_clock     = 0; switchable_clock     <= 1; switchable_clock     ++)
    for (light_sensor         = 0; light_sensor         <= 1; light_sensor         ++)
    for (serial_loader        = 0; serial_loader        <= 1; serial_loader        ++)
    {
        int features =   narrow_write_support
                       + switchable_clock + light_sensor + serial_loader;

        if (    i_board == 0 && (switchable_clock + light_sensor + serial_loader) != 0
             || i_board != 0 && narrow_write_support == 0
             || i_board >  2 )
        {
            continue;
        }

        // module_names and n_module_names are extracted when current_module_name is NULL

        n_module_names      = 0;
        current_module_name = NULL;

        print_hierarchy ();

        for (int i = 0; i < n_module_names; i ++)
        {
            current_module_name = module_names [i];

            if (current_module_name != NULL)
                print_hierarchy ();
        }
    }
    }

    if (0)
    {
    // Special cases

    current_module_name = NULL;

    i_board              = 0;
    narrow_write_support = 0;
    switchable_clock     = 0;
    light_sensor         = 0;
    serial_loader        = 0;

    print_hierarchy ();

    narrow_write_support = 1;

    print_hierarchy ();

    light_sensor         = 1;
    serial_loader        = 1;

    print_hierarchy ();

    for (i_board = 1; i_board <= 2; i_board ++)
    {
        narrow_write_support = 0;
        switchable_clock     = 0;
        light_sensor         = 0;
        serial_loader        = 0;

        print_hierarchy ();

        narrow_write_support = 1;
        print_hierarchy ();

        light_sensor = 1;
        print_hierarchy ();

        serial_loader = 1;
        print_hierarchy ();

        switchable_clock = 1;
        print_hierarchy ();
    }
    }

    // Support for Lab YP1. Serial Loader Flow

    current_module_name = NULL;

    for (i_board = 3; i_board <= 4; i_board ++)
    {
        narrow_write_support      = 1;
        switchable_clock          = 0;
        light_sensor              = 0;
        without_7_segment_display = 1;

        serial_loader = 0;
        print_hierarchy ();

        serial_loader = 1;
        print_hierarchy ();
    }

    return 0;
}

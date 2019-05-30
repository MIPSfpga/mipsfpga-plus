
# path where project will be created
set project_path [pwd]
set script_path [file dirname [file normalize [info script]]]

# global settings
set project_name    "system"
set project_part    "xc7a100tcsg324-1"
set testbench_top   "mfp_testbench"

# source files path
set rtl_path $project_path/../rtl
set tb_path  $project_path/../tb

# project local settings
set source_files [list \
    "[file normalize "../nexys4_ddr.v"]" \
    "[file normalize "../../../system_rtl/mfp_ahb_gpio_slave.v"]" \
    "[file normalize "../../../system_rtl/mfp_ahb_lite_adc_max10.v"]" \
    "[file normalize "../../../system_rtl/mfp_ahb_lite_eic.v"]" \
    "[file normalize "../../../system_rtl/mfp_ahb_lite_matrix_config.vh"]" \
    "[file normalize "../../../system_rtl/mfp_ahb_lite_matrix.v"]" \
    "[file normalize "../../../system_rtl/mfp_ahb_lite_matrix_with_loader.v"]" \
    "[file normalize "../../../system_rtl/mfp_ahb_lite_pmod_als.v"]" \
    "[file normalize "../../../system_rtl/mfp_ahb_lite_slave.v"]" \
    "[file normalize "../../../system_rtl/mfp_ahb_lite_uart16550.v"]" \
    "[file normalize "../../../system_rtl/mfp_ahb_lite.vh"]" \
    "[file normalize "../../../system_rtl/mfp_ahb_ram_busy.v"]" \
    "[file normalize "../../../system_rtl/mfp_ahb_ram_sdram.v"]" \
    "[file normalize "../../../system_rtl/mfp_ahb_ram_slave.v"]" \
    "[file normalize "../../../system_rtl/mfp_clock_dividers.v"]" \
    "[file normalize "../../../system_rtl/mfp_dual_port_ram.v"]" \
    "[file normalize "../../../system_rtl/mfp_eic_core.v"]" \
    "[file normalize "../../../system_rtl/mfp_eic_core.vh"]" \
    "[file normalize "../../../system_rtl/mfp_eic_handler.v"]" \
    "[file normalize "../../../system_rtl/mfp_pmod_als_spi_receiver.v"]" \
    "[file normalize "../../../system_rtl/mfp_priority_encoder.v"]" \
    "[file normalize "../../../system_rtl/mfp_register.v"]" \
    "[file normalize "../../../system_rtl/mfp_seven_segment_displays.v"]" \
    "[file normalize "../../../system_rtl/mfp_srec_parser_to_ahb_lite_bridge.v"]" \
    "[file normalize "../../../system_rtl/mfp_srec_parser.v"]" \
    "[file normalize "../../../system_rtl/mfp_switch_and_button_debouncers.v"]" \
    "[file normalize "../../../system_rtl/mfp_system.v"]" \
    "[file normalize "../../../system_rtl/mfp_uart_loader.v"]" \
    "[file normalize "../../../system_rtl/mfp_uart_receiver.v"]" \
    "[file normalize "../../../system_rtl/uart16550/raminfr.v"]" \
    "[file normalize "../../../system_rtl/uart16550/uart_defines.vh"]" \
    "[file normalize "../../../system_rtl/uart16550/uart_receiver.v"]" \
    "[file normalize "../../../system_rtl/uart16550/uart_regs.v"]" \
    "[file normalize "../../../system_rtl/uart16550/uart_rfifo.v"]" \
    "[file normalize "../../../system_rtl/uart16550/uart_sync_flops.v"]" \
    "[file normalize "../../../system_rtl/uart16550/uart_tfifo.v"]" \
    "[file normalize "../../../system_rtl/uart16550/uart_transmitter.v"]" \
    "[file normalize "../../../core/dataram_2k2way_xilinx.v"]" \
    "[file normalize "../../../core/d_wsram_2k2way_xilinx.v"]" \
    "[file normalize "../../../core/i_wsram_2k2way_xilinx.v"]" \
    "[file normalize "../../../core/m14k_alu_dsp_stub.v"]" \
    "[file normalize "../../../core/m14k_alu_shft_32bit.v"]" \
    "[file normalize "../../../core/m14k_bistctl.v"]" \
    "[file normalize "../../../core/m14k_biu.v"]" \
    "[file normalize "../../../core/m14k_cache_cmp.v"]" \
    "[file normalize "../../../core/m14k_cache_mux.v"]" \
    "[file normalize "../../../core/m14k_cdmm_ctl.v"]" \
    "[file normalize "../../../core/m14k_cdmm_mpustub.v"]" \
    "[file normalize "../../../core/m14k_cdmmstub.v"]" \
    "[file normalize "../../../core/m14k_cdmm.v"]" \
    "[file normalize "../../../core/m14k_clockandlatch.v"]" \
    "[file normalize "../../../core/m14k_clock_buf.v"]" \
    "[file normalize "../../../core/m14k_clock_nogate.v"]" \
    "[file normalize "../../../core/m14k_clockxnorgate.v"]" \
    "[file normalize "../../../core/m14k_config.vh"]" \
    "[file normalize "../../../core/m14k_const.vh"]" \
    "[file normalize "../../../core/m14k_cop1_stub.v"]" \
    "[file normalize "../../../core/m14k_cop2_stub.v"]" \
    "[file normalize "../../../core/m14k_core.v"]" \
    "[file normalize "../../../core/m14k_cp1_stub.v"]" \
    "[file normalize "../../../core/m14k_cp2_stub.v"]" \
    "[file normalize "../../../core/m14k_cpu.v"]" \
    "[file normalize "../../../core/m14k_cpz_antitamper_stub.v"]" \
    "[file normalize "../../../core/m14k_cpz_eicoffset_stub.v"]" \
    "[file normalize "../../../core/m14k_cpz_guest_srs1.v"]" \
    "[file normalize "../../../core/m14k_cpz_guest_stub.v"]" \
    "[file normalize "../../../core/m14k_cpz_pc_top.v"]" \
    "[file normalize "../../../core/m14k_cpz_pc.v"]" \
    "[file normalize "../../../core/m14k_cpz_prid.v"]" \
    "[file normalize "../../../core/m14k_cpz_root_stub.v"]" \
    "[file normalize "../../../core/m14k_cpz_sps_stub.v"]" \
    "[file normalize "../../../core/m14k_cpz_srs1.v"]" \
    "[file normalize "../../../core/m14k_cpz.v"]" \
    "[file normalize "../../../core/m14k_cpz_watch_stub.v"]" \
    "[file normalize "../../../core/m14k_cscramble_scanio_stub.v"]" \
    "[file normalize "../../../core/m14k_cscramble_stub.v"]" \
    "[file normalize "../../../core/m14k_cscramble_tpl.v"]" \
    "[file normalize "../../../core/m14k_dc_bistctl.v"]" \
    "[file normalize "../../../core/m14k_dcc_fb.v"]" \
    "[file normalize "../../../core/m14k_dcc_mb_stub.v"]" \
    "[file normalize "../../../core/m14k_dcc_parity_stub.v"]" \
    "[file normalize "../../../core/m14k_dcc_spmb_stub.v"]" \
    "[file normalize "../../../core/m14k_dcc_spstub.v"]" \
    "[file normalize "../../../core/m14k_dcc.v"]" \
    "[file normalize "../../../core/m14k_dc.v"]" \
    "[file normalize "../../../core/m14k_dsp_const.vh"]" \
    "[file normalize "../../../core/m14k_dspram_ext_stub.v"]" \
    "[file normalize "../../../core/m14k_edp_add_simple.v"]" \
    "[file normalize "../../../core/m14k_edp_buf_misc_pro.v"]" \
    "[file normalize "../../../core/m14k_edp_buf_misc.v"]" \
    "[file normalize "../../../core/m14k_edp_clz_16b.v"]" \
    "[file normalize "../../../core/m14k_edp_clz_4b.v"]" \
    "[file normalize "../../../core/m14k_edp_clz.v"]" \
    "[file normalize "../../../core/m14k_edp.v"]" \
    "[file normalize "../../../core/m14k_ejt_and2.v"]" \
    "[file normalize "../../../core/m14k_ejt_area.v"]" \
    "[file normalize "../../../core/m14k_ejt_async_rec.v"]" \
    "[file normalize "../../../core/m14k_ejt_async_snd.v"]" \
    "[file normalize "../../../core/m14k_ejt_brk21.v"]" \
    "[file normalize "../../../core/m14k_ejt_bus32mux2.v"]" \
    "[file normalize "../../../core/m14k_ejt_dbrk.v"]" \
    "[file normalize "../../../core/m14k_ejt_fifo_1r1w_stub.v"]" \
    "[file normalize "../../../core/m14k_ejt_gate.v"]" \
    "[file normalize "../../../core/m14k_ejt_ibrk.v"]" \
    "[file normalize "../../../core/m14k_ejt_mux2.v"]" \
    "[file normalize "../../../core/m14k_ejt_pdttcb_stub.v"]" \
    "[file normalize "../../../core/m14k_ejt_tap_dasamstub.v"]" \
    "[file normalize "../../../core/m14k_ejt_tap_dasam.v"]" \
    "[file normalize "../../../core/m14k_ejt_tap_fdcstub.v"]" \
    "[file normalize "../../../core/m14k_ejt_tap_fdc.v"]" \
    "[file normalize "../../../core/m14k_ejt_tap_pcsamstub.v"]" \
    "[file normalize "../../../core/m14k_ejt_tap_pcsam.v"]" \
    "[file normalize "../../../core/m14k_ejt_tap.v"]" \
    "[file normalize "../../../core/m14k_ejt_tck.v"]" \
    "[file normalize "../../../core/m14k_ejt_tripsync.v"]" \
    "[file normalize "../../../core/m14k_ejt.v"]" \
    "[file normalize "../../../core/m14k_fpuclk1_nogate.v"]" \
    "[file normalize "../../../core/m14k_gf_mux2.v"]" \
    "[file normalize "../../../core/m14k_glue.v"]" \
    "[file normalize "../../../core/m14k_ic_bistctl.v"]" \
    "[file normalize "../../../core/m14k_icc_mb_stub.v"]" \
    "[file normalize "../../../core/m14k_icc_parity_stub.v"]" \
    "[file normalize "../../../core/m14k_icc_spmb_stub.v"]" \
    "[file normalize "../../../core/m14k_icc_spstub.v"]" \
    "[file normalize "../../../core/m14k_icc_umips_stub.v"]" \
    "[file normalize "../../../core/m14k_icc.v"]" \
    "[file normalize "../../../core/m14k_ic.v"]" \
    "[file normalize "../../../core/m14k_ispram_ext_stub.v"]" \
    "[file normalize "../../../core/m14k_mdl_add_simple.v"]" \
    "[file normalize "../../../core/m14k_mdl_ctl.v"]" \
    "[file normalize "../../../core/m14k_mdl_dp.v"]" \
    "[file normalize "../../../core/m14k_mdl.v"]" \
    "[file normalize "../../../core/m14k_mmuc.v"]" \
    "[file normalize "../../../core/m14k_mmu.vh"]" \
    "[file normalize "../../../core/m14k_mpc_ctl.v"]" \
    "[file normalize "../../../core/m14k_mpc_dec.v"]" \
    "[file normalize "../../../core/m14k_mpc_exc.v"]" \
    "[file normalize "../../../core/m14k_mpc.v"]" \
    "[file normalize "../../../core/m14k_rf_reg.v"]" \
    "[file normalize "../../../core/m14k_rf_rngc.v"]" \
    "[file normalize "../../../core/m14k_rf_stub.v"]" \
    "[file normalize "../../../core/m14k_siu_int_sync.v"]" \
    "[file normalize "../../../core/m14k_siu.v"]" \
    "[file normalize "../../../core/m14k_spram_top.v"]" \
    "[file normalize "../../../core/m14k_tlb_collector.v"]" \
    "[file normalize "../../../core/m14k_tlb_cpy.v"]" \
    "[file normalize "../../../core/m14k_tlb_ctl.v"]" \
    "[file normalize "../../../core/m14k_tlb_dtlb.v"]" \
    "[file normalize "../../../core/m14k_tlb_itlb.v"]" \
    "[file normalize "../../../core/m14k_tlb_jtlb16entries.v"]" \
    "[file normalize "../../../core/m14k_tlb_jtlb16.v"]" \
    "[file normalize "../../../core/m14k_tlb_jtlb1entry.v"]" \
    "[file normalize "../../../core/m14k_tlb_jtlb4entries.v"]" \
    "[file normalize "../../../core/m14k_tlb_utlbentry.v"]" \
    "[file normalize "../../../core/m14k_tlb_utlb.v"]" \
    "[file normalize "../../../core/m14k_tlb.v"]" \
    "[file normalize "../../../core/m14k_top.v"]" \
    "[file normalize "../../../core/m14k_udi_custom.v"]" \
    "[file normalize "../../../core/m14k_udi_scanio_stub.v"]" \
    "[file normalize "../../../core/m14k_udi_stub.v"]" \
    "[file normalize "../../../core/mvp_cregister_c.v"]" \
    "[file normalize "../../../core/mvp_cregister_ngc.v"]" \
    "[file normalize "../../../core/mvp_cregister_s.v"]" \
    "[file normalize "../../../core/mvp_cregister.v"]" \
    "[file normalize "../../../core/mvp_cregister_wide_tlb.v"]" \
    "[file normalize "../../../core/mvp_cregister_wide_utlb.v"]" \
    "[file normalize "../../../core/mvp_cregister_wide.v"]" \
    "[file normalize "../../../core/mvp_latchn.v"]" \
    "[file normalize "../../../core/mvp_mux16.v"]" \
    "[file normalize "../../../core/mvp_mux1hot_10.v"]" \
    "[file normalize "../../../core/mvp_mux1hot_13.v"]" \
    "[file normalize "../../../core/mvp_mux1hot_24.v"]" \
    "[file normalize "../../../core/mvp_mux1hot_3.v"]" \
    "[file normalize "../../../core/mvp_mux1hot_4.v"]" \
    "[file normalize "../../../core/mvp_mux1hot_5.v"]" \
    "[file normalize "../../../core/mvp_mux1hot_6.v"]" \
    "[file normalize "../../../core/mvp_mux1hot_8.v"]" \
    "[file normalize "../../../core/mvp_mux1hot_9.v"]" \
    "[file normalize "../../../core/mvp_mux2.v"]" \
    "[file normalize "../../../core/mvp_mux4.v"]" \
    "[file normalize "../../../core/mvp_mux8.v"]" \
    "[file normalize "../../../core/mvp_register_c.v"]" \
    "[file normalize "../../../core/mvp_register_ngc.v"]" \
    "[file normalize "../../../core/mvp_register_s.v"]" \
    "[file normalize "../../../core/mvp_register.v"]" \
    "[file normalize "../../../core/mvp_ucregister_wide.v"]" \
    "[file normalize "../../../core/RAMB4K_S16.v"]" \
    "[file normalize "../../../core/RAMB4K_S2.v"]" \
    "[file normalize "../../../core/RAMB4K_S8.v"]" \
    "[file normalize "../../../core/ram_dual_port.v"]" \
    "[file normalize "../../../core/ram_reset_dual_port.v"]" \
    "[file normalize "../../../core/tagram_2k2way_xilinx.v"]" \
]

set constr_files [list \
    "[file normalize "../nexys4_ddr.xdc"]" \
]

set sim_files [list \
    "[file normalize "../../../testbench/sdr_sdram"]" \
    "[file normalize "../../../testbench/sdr_sdram/sdr.v"]" \
    "[file normalize "../../../testbench/sdr_sdram/sdr_parameters.vh"]" \
    "[file normalize "../../../testbench/mfp_testbench.v"]" \
    "[file normalize "../../../testbench/mfp_uart_testbench.v"]" \
]

# create project
create_project $project_name $project_path -part $project_part -force

# fill 'sources_1' fileset
if {[info exists source_files]} {
    add_files -norecurse -fileset [get_filesets sources_1] $source_files
}

# fill 'constrs_1' fileset
if {[info exists constr_files]} {
    add_files -norecurse -fileset [get_filesets constrs_1] $constr_files
}

# fill 'sim_1' fileset
if {[info exists sim_files]} {
    set obj [get_filesets sim_1]
    add_files -norecurse -fileset $obj $sim_files
    set_property top $testbench_top $obj
}

# define macros VIVADO_SYNTHESIS
set_property -name {STEPS.SYNTH_DESIGN.ARGS.MORE OPTIONS} -value {-verilog_define VIVADO_SYNTHESIS} -objects [get_runs synth_1]

puts "INFO: Project created:$project_name"

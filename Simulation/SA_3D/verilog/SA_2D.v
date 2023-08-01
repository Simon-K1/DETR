module srio_example_top_srio_gen2_0 #(
    parameter SIM_VERBOSE               = 1, // If set, generates unsynthesizable reporting
    parameter VALIDATION_FEATURES       = 1, // If set, uses internal instruction sequences for hw and sim test
    parameter QUICK_STARTUP             = 0, // If set, quick-launch configuration access is contained here
    parameter STATISTICS_GATHERING      = 1, // If set, I/O can be rerouted to the maint port [0,1]
    parameter C_LINK_WIDTH              = 1
  )
  //  port declarations ----------------
  (
    // Clocks and Resets
    input            sys_clkp,              // MMCM reference clock
    input            sys_clkn,              // MMCM reference clock
    input            sys_rst,               // Global reset signal

    // high-speed IO
    input           srio_rxn0,              // Serial Receive Data
    input           srio_rxp0,              // Serial Receive Data



    output          srio_txn0,              // Serial Transmit Data
    output          srio_txp0,              // Serial Transmit Data



    input           sim_train_en,           // Set this only when simulating to reduce the size of counters
    output  [7:0]   led0,

    //自定义的信号=================================================
    input            axis_ireq_tvalid,
    output            axis_ireq_tready,
    input            axis_ireq_tlast,
    input   [63:0]   axis_ireq_tdata,
    input   [7:0]    axis_ireq_tkeep,
    input   [31:0]   axis_ireq_tuser,

    output         axis_iresp_tvalid,
    input          axis_iresp_tready,
    output         axis_iresp_tlast,
    output [63:0]  axis_iresp_tdata,
    output [7:0]   axis_iresp_tkeep,
    output [31:0]  axis_iresp_tuser,

    output       link_initialized_out,

    output              log_clk_out
  );
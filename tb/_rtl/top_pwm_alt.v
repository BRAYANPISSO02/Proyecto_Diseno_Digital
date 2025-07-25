//------------------------------------------------------------------------------
// top_pwm_alt.v — Top-level adaptado para reg_iface y pwm_unit
//------------------------------------------------------------------------------
module top_pwm_alt (
  clk_i,
  rst_ni,
  addr_i,
  wr_data_i,
  rd_data_o,
  wr_en_i,
  rd_en_i,
  pwm_out_o
);
  parameter AW = 8;
  parameter DW = 32;
  parameter WIDTH_PERIOD = 16;
  parameter WIDTH_DUTY   = 16;

  input                  clk_i;
  input                  rst_ni;
  input  [AW-1:0]        addr_i;
  input  [DW-1:0]        wr_data_i;
  output [DW-1:0]        rd_data_o;
  input                  wr_en_i;
  input                  rd_en_i;
  output                 pwm_out_o;

  // Internas
  wire [DW-1:0] ctrl_reg;
  wire [DW-1:0] status_in;
  wire [DW-1:0] status_reg;

  wire [WIDTH_PERIOD-1:0] period_ch0;
  wire [WIDTH_DUTY-1:0]   duty_ch0;

  assign period_ch0 = ctrl_reg[DW-1:WIDTH_DUTY];
  assign duty_ch0   = ctrl_reg[WIDTH_DUTY-1:0];

  wire error_flag = (duty_ch0 > period_ch0);
  assign status_in = {{DW-1{1'b0}}, error_flag};

  // Instancia reg_iface
  reg_iface reg_unit (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .addr_i(addr_i),
    .wr_data_i(wr_data_i),
    .rd_data_o(rd_data_o),
    .wr_en_i(wr_en_i),
    .rd_en_i(rd_en_i),
    .ctrl_o(ctrl_reg),
    .status_in_i(status_in),
    .status_o(status_reg)
  );

  // Instancia pwm_unit
  pwm_unit #(
    .CNT_WIDTH(WIDTH_PERIOD),
    .DUTY_WIDTH(WIDTH_DUTY)
) pwm_core_inst (
    .clk_i     (clk_i),
    .rst_ni    (rst_ni),
    .cfg_period(period_ch0),
    .cfg_duty  (duty_ch0),
    .pwm_o     (pwm_out_o)
);

endmodule

//------------------------------------------------------------------------------
// pwm_unit.v — Módulo PWM sencillo (Verilog-2001)
//------------------------------------------------------------------------------

module pwm_unit #(
  parameter CNT_WIDTH = 16,
  parameter DUTY_WIDTH = 16
)(
  input                      clk_i,
  input                      rst_ni,
  input  [CNT_WIDTH-1:0]     cfg_period,
  input  [DUTY_WIDTH-1:0]    cfg_duty,
  output                     pwm_o
);

  reg [CNT_WIDTH-1:0] cnt;

  // Contador principal
  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni)
      cnt <= 0;
    else if (cnt >= cfg_period - 1)
      cnt <= 0;
    else
      cnt <= cnt + 1;
  end

  // Lógica PWM
  assign pwm_o = (cnt < cfg_duty);

endmodule

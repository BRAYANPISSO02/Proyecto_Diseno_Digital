//------------------------------------------------------------------------------
// reg_iface.v — Interfaz de registro con nombres modificados (Verilog-2001)
//------------------------------------------------------------------------------
module reg_iface (
  clk_i,
  rst_ni,
  addr_i,
  wr_data_i,
  rd_data_o,
  wr_en_i,
  rd_en_i,
  ctrl_o,
  status_in_i,
  status_o
);
  parameter AW = 8;
  parameter DW = 32;

  input                   clk_i;
  input                   rst_ni;
  input  [AW-1:0]         addr_i;
  input  [DW-1:0]         wr_data_i;
  output [DW-1:0]         rd_data_o;
  input                   wr_en_i;
  input                   rd_en_i;
  output [DW-1:0]         ctrl_o;
  input  [DW-1:0]         status_in_i;
  output [DW-1:0]         status_o;

  // Offsets locales
  localparam [AW-1:0] CTRL_ADDR   = 8'h00;
  localparam [AW-1:0] STATUS_ADDR = 8'h04;

  reg [DW-1:0] ctrl_reg;
  reg [DW-1:0] status_reg;
  reg [DW-1:0] rd_data_reg;

  // Escritura y actualización de status
  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      ctrl_reg   <= {DW{1'b0}};
      status_reg <= {DW{1'b0}};
    end else begin
      status_reg <= status_in_i;
      if (wr_en_i) begin
        case (addr_i)
          CTRL_ADDR: ctrl_reg <= wr_data_i;
          default: /* noop */ ;
        endcase
      end
    end
  end

  // Lectura
  always @(*) begin
    if (rd_en_i) begin
      case (addr_i)
        CTRL_ADDR:   rd_data_reg = ctrl_reg;
        STATUS_ADDR: rd_data_reg = status_reg;
        default:     rd_data_reg = {DW{1'b0}};
      endcase
    end else begin
      rd_data_reg = {DW{1'b0}};
    end
  end

  assign ctrl_o   = ctrl_reg;
  assign status_o = status_reg;
  assign rd_data_o = rd_data_reg;

endmodule

module axi4lite_sva (
  input clk, rst_n,
  input awvalid, awready,
  input wvalid, wready,
  input bvalid, bready,
  input [1:0] bresp,
  input arvalid, arready,
  input rvalid, rready,
  input [1:0] rresp,
  input [31:0] rdata
);

  property awvalid_stable;
    @(posedge clk) disable iff (!rst_n)
    ($past(awvalid) && !$past(awready)) |-> awvalid;
  endproperty
  assume_awvalid_stable: assume property (awvalid_stable);

  property bvalid_stable;
    @(posedge clk) disable iff (!rst_n)
    ($past(bvalid) && !$past(bready)) |-> bvalid;
  endproperty
  assert_bvalid_stable: assert property (bvalid_stable);

  property bresp_okay;
    @(posedge clk) disable iff (!rst_n)
    bvalid |-> (bresp == 2'b00);
  endproperty
  assert_bresp_okay: assert property (bresp_okay);

  property rdata_stable;
    @(posedge clk) disable iff (!rst_n)
    ($past(rvalid) && !$past(rready)) |-> ($stable(rdata) && rvalid);
  endproperty
  assert_rdata_stable: assert property (rdata_stable);

  property bresp_stable;
    @(posedge clk) disable iff (!rst_n)
    ($past(bvalid) && !$past(bready)) |-> $stable(bresp);
  endproperty
  assert_bresp_stable: assert property (bresp_stable);

  property write_ch_onehot;
    @(posedge clk) disable iff (!rst_n)
    $onehot0({awready, wready, bvalid});
  endproperty
  assert_write_onehot: assert property (write_ch_onehot);

  property read_ch_onehot;
    @(posedge clk) disable iff (!rst_n)
    $onehot0({arready, rvalid});
  endproperty
  assert_read_onehot: assert property (read_ch_onehot);

  property rresp_okay;
    @(posedge clk) disable iff (!rst_n)
    rvalid |-> (rresp == 2'b00);
  endproperty
  assert_rresp_okay: assert property (rresp_okay);

endmodule

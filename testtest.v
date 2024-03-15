module FormatSpecifierExample();

  reg [7:0] binaryValue = 42;
  reg [7:0] decimalValue = 42;
  reg [7:0] hexValue = 42;
  reg [7:0] octalValue = 42;
  reg [31:0] floatValue = 3.14;

  initial begin
    $display("Binary: %b, Decimal: %d, Hex: %h, Octal: %o", binaryValue, decimalValue, hexValue, octalValue);
    $display("Floating-point: %f", floatValue);
  end

endmodule


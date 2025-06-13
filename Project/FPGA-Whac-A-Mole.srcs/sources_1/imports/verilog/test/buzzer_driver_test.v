module buzzer_driver_test(
    input   clk,
    input   [5:0] SW,
    output  buzzer
);

    buzzer_driver u_buzzer_driver (
        .clk   (clk),
        .note  (SW),
        .beep  (buzzer)
    );

endmodule
library ieee;
use ieee.std_logic_1164.all;

entity temporizacao is
    port(
        Total_logic_elements: out integer;
        Total_registers: out integer;
        Device: out string;
        Input_port: out string;
        Output_port: out string;
        Max_Propagation_delay: out real;
        a_65ns: out integer;
        b_65ns: out integer;
        soma_65ns: out integer;
        cout_65ns: out std_logic
    );
end entity;

architecture res of temporizacao is
begin

    Total_logic_elements <= 27;
    Total_registers <= 0;
    Device <= "EP4CGX22CF19C6";
    Input_port  <= "op";
    Output_port <= "ovf"; 
    Max_Propagation_delay <= 16.829;
    
    -- aqui o professor disse que nao precisava preencher
    a_65ns <= 0;
    b_65ns <= 0;
    result_65ns <= 0;
    ovf_65ns<= 'X';
    cout_65ns<= 'X';
    
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity binaryEncoder is
	generic(inputWidth: positive;
			priorityMSB: boolean; -- se True, os bits mais significativos são prioritários
			generateValid: boolean); -- se True, uma saida valid é ativada quando pelo menos um dos bits da entrada está ativo
	port(input: in std_logic_vector(inputWidth-1 downto 0);
		valid: out std_logic;
		output: out std_logic_vector(integer(ceil(log2(real(inputWidth))))-1 downto 0) );
end entity;

architecture behav0 of binaryEncoder is
begin

process(input)
variable b: integer;


begin
b := 0;
if priorityMSB then 
    for i in inputWidth-1 downto 0 loop 
        if input(i) = '1' then -- 001101110
            b := i;
            exit;
        end if;
        
    end loop;

else 
    for i in 0  to inputWidth-1 loop
        if input(i) = '1' then
            b := i;
            exit;
        end if;
    end loop;
end if;

output <= std_logic_vector(to_unsigned(b, output'length));

end process;

genValid: if generateValid generate
valid <= '1' when to_integer(unsigned(input)) > 0 else
        '0';
end generate;

end architecture;

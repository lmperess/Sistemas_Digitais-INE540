library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity bitsCombCounter is
    generic (
        N: positive;
        count1s: boolean := true
    );
    port (
        input: in std_logic_vector(N-1 downto 0);
        output: out std_logic_vector(integer(ceil(log2(real(N))))-1 downto 0)
    );
end entity;

architecture sequential_behavour_thats_a_hint of bitsCombCounter is
begin

process(input)
variable count: integer;
begin
count := 0;
for i in 0 to N-1 loop
 if count1s then
    if input(i) = '1' then
    count := count + 1;
    end if;
 elsif not count1s then
    if input(i) = '0' then
    count := count + 1;
    end if;
 end if;
end loop;
output <= std_logic_vector(to_unsigned(count, output'length));
end process;

end architecture;

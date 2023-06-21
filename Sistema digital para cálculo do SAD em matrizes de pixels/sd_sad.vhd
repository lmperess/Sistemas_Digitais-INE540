library ieee;
use ieee.std_logic_1164.all;

entity sd_sad is
	generic(
		datawidth: positive := 8;
		addresswidth: positive := 6);
	port(
		-- control in
		ck, reset, iniciar: in std_logic;
		-- data in
		pA, pB: in std_logic_vector(datawidth-1 downto 0);
		-- controll out
		ender: out std_logic_vector(addresswidth-1 downto 0);
		readmem, pronto: out std_logic;
		sad: out std_logic_vector(datawidth+addresswidth-1 downto 0));
end entity;

architecture archstruct of sd_sad is
	
	component blocooperativo_sad is
	generic(
		datawidth: positive ;
		addresswidth: positive);
	port(
		-- control in
		ck, reset, zi, ci, cpA, cpB, zsoma, csoma, csad_reg : in std_logic;
		-- data in
		pA, pB: in std_logic_vector(datawidth-1 downto 0);
		-- controll out
		ender: out std_logic_vector(addresswidth-1 downto 0);
		menor: out std_logic;
		sad: out std_logic_vector(datawidth+addresswidth-1 downto 0)
	);
	end component;
	
	component blococontrole_sad is
	port(
		-- control in
		ck, reset, iniciar, 
		menor : in std_logic;
		-- data in
		-- controll out
		zi, ci, cpA, cpB, zsoma, csoma, csad_reg, readmem, pronto: out std_logic
		-- data out
	);
	end component;

	-- SINAIS INTERNOS --
	signal zi, ci, cpA, cpB, zsoma, csoma, csad_reg, menor : std_logic;
	
begin
    -- COMPLETE
	 
	BO: blocooperativo_sad
			generic map(datawidth=>datawidth, addresswidth=>addresswidth)
			port map(ck=>ck, reset=>reset, zi=>zi, ci=>ci, cpA=>cpA, cpB=>cpB, zsoma=>zsoma, csoma=>csoma, csad_reg=>csad_reg, pA=>pA, pB=>pB, ender=>ender, menor=>menor, sad=>sad);
			
	BC: blococontrole_sad
			port map(ck=>ck, reset=>reset, iniciar=>iniciar, menor=>menor, zi=>zi, ci=>ci, cpA=>cpA, cpB=>cpB, zsoma=>zsoma, csoma=>csoma, csad_reg=>csad_reg, readmem=>readmem, pronto=>pronto);

end architecture;

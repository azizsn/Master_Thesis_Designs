Entity dreg is
	generic (d: positive :=10);
	port (i:in bit_vector(5*d-1 downto 0);
		o:out bit_vector(5*d-1 downto 0);
		clk,reset,enable: in bit);
end dreg;

Architecture behave of dreg is
begin
	process (clk,reset)
		variable tmp: bit_vector(5*d-1 downto 0);
	begin
		if (reset = '1') then
			tmp := (others => '0');
		elsif (clk = '1' and clk'event and enable = '1') then
			tmp := i;
		end if;
		o <= tmp;
	end process;
end behave;

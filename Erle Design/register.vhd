Entity reg is
	generic (n: positive :=5);
	port (i:in bit_vector(n-1 downto 0);
		o:out bit_vector(n-1 downto 0);
		clk,reset,enable: in bit);
end reg;

Architecture behave of reg is
begin
	process (clk,reset)
		variable tmp: bit_vector(n-1 downto 0);
	begin
		if (reset = '1') then
			tmp := (others => '0');
		elsif (clk = '1' and clk'event and enable = '1') then --rising edge 
			tmp := i;
		end if;
		o <= tmp;
	end process;
end behave;
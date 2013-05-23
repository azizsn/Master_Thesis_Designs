--shift right register with parallel load,

Entity RShreg is
	generic (d: positive :=10; -- number of stages
		w: positive := 4); -- input width
	port (pl:in bit_vector((w)*(d)-1 downto 0);
		i:in bit_vector(w-1 downto 0);
		o:out bit_vector(w-1 downto 0);
		cont:out bit_vector((w)*(d)-1 downto 0);
		clk,reset,enable,load: in bit);
end RShreg;

Architecture behave of RShreg is
begin
	process (clk,reset,load,enable)
		variable tmp: bit_vector((w)*(d)-1 downto 0);
	begin
	if (clk = '1' and clk'event) then 
		if (reset = '1') then
			tmp := (others => '0');
		elsif (load = '1') then --parallel load
			tmp := pl;
		elsif (enable = '1') then --rising edge
			tmp := i &(tmp ((w)*(d)-1 downto w));
		end if;
		end if;
		o <= tmp ((w-1) downto 0);
		cont <= tmp;
	end process;
end behave;



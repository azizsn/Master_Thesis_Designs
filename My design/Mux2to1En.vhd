Entity Mux2X1EN is
	generic (d: positive := 10);
	port (en,sel: in bit;
		input0,input1: in bit_vector(5*d-1 downto 0);
		output: out bit_vector(5*d-1 downto 0));
end Mux2X1EN;

Architecture behave of Mux2X1EN is	
begin
	process(en,sel,input0,input1)
	--	variable index: bit;
	begin
		if (en = '0') then
			output <= (others => '0');
		elsif ( sel = '1' ) then
			output <= input1;
		elsif( sel = '0' ) then
			output <= input0;
		end if;
	end process;

end behave;


Entity Bufr is
	generic (d: positive := 10);
	port (en: in bit;
		input:	in  bit_vector(5*d-1 downto 0);
		output:out bit_vector(5*d-1 downto 0));
end entity;

Architecture behave of Bufr is	
begin
	process(en,input)
	begin
		if (en = '0') then
			output <= (others => '0');
		else
			output <= input;
		end if;
	end process;
end behave;



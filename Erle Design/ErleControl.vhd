Entity ErleCont is
	generic (n: positive := 8);
	port (start,clk: in bit;
		enaA,enaB,ldB,rst,enaPP: out bit);
End Entity;

Architecture cont of ErleCont is
signal count: integer := 0;
begin
	process(clk,start)
	begin
	if (Clk'EVENT and Clk = '1') then
		enaA <= '0';
		enaB <= '0';
		ldB <= '0';
		rst <= '0';
		enaPP <= '0';
		if (start = '1') then
			enaA <= '1';
			ldB <= '1';
			rst <= '1';
			count <= 0;
		elsif (count < n) then
			enaPP <= '1';
			count <= count+1;
		end if;
		end if;
	end process;
End cont;
 
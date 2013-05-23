-- this component generates the control signals for Muxs
Entity control521 is
	port (xi,yi: in bit_vector (4 downto 0);
			signX,signY: out bit; --sign of the new numbers and clock signal
			muxy5_Sel,muxx5_Sel,muxy2_Sel,muxx2_Sel: out bit; -- select signals for muxs
			muxy5_En,muxx5_En,muxy2_En,muxx2_En: out bit); -- Enable signals for muxs
end entity;

architecture behave of control521 is
begin
	process (xi,yi)
		variable tmpX,tmpY: bit_vector(4 downto 0);
	begin
		signX <= xi(4);
		signY <= yi(4);
		-- take the absolute Value of the xi and yi
		if (xi(4) = '1') then -- the value of X is negative
			tmpX := Not xi;
		else
			tmpX := xi;
		end if;
		
		if (yi(4) = '1') then -- the value of Y is negative
			tmpY := Not yi;
		else
			tmpY := yi;
		end if;
		
		case tmpY is
			when "00000" => muxx2_En <= '0'; muxx5_En <='0';muxx2_Sel <= '0'; muxx5_Sel <='0';
			when "00011" => muxx2_En <= '0'; muxx5_En <='1';muxx2_Sel <= '0'; muxx5_Sel <='0';
			when "00110" => muxx2_En <= '1'; muxx5_En <='0';muxx2_Sel <= '1'; muxx5_Sel <='0';
			when "01001" => muxx2_En <= '1'; muxx5_En <='1';muxx2_Sel <= '1'; muxx5_Sel <='0';
			when "01100" => muxx2_En <= '1'; muxx5_En <='1';muxx2_Sel <= '0'; muxx5_Sel <='1';
			when "01111" => muxx2_En <= '0'; muxx5_En <='1';muxx2_Sel <= '0'; muxx5_Sel <='1';
			when others => muxx2_En <= '0'; muxx5_En <='0';muxx2_Sel <= '0'; muxx5_Sel <='0';
		end case;
		
		case tmpX is
			when "00000" => muxy2_En <= '0'; muxy5_En <='0';muxy2_Sel <= '0'; muxy5_Sel <='0';
			when "00011" => muxy2_En <= '0'; muxy5_En <='1';muxy2_Sel <= '0'; muxy5_Sel <='0';
			when "00110" => muxy2_En <= '1'; muxy5_En <='0';muxy2_Sel <= '1'; muxy5_Sel <='0';
			when "01001" => muxy2_En <= '1'; muxy5_En <='1';muxy2_Sel <= '1'; muxy5_Sel <='0';
			when "01100" => muxy2_En <= '1'; muxy5_En <='1';muxy2_Sel <= '0'; muxy5_Sel <='1';
			when "01111" => muxy2_En <= '0'; muxy5_En <='1';muxy2_Sel <= '0'; muxy5_Sel <='1';
			when others => muxy2_En <= '0'; muxy5_En <='0';muxy2_Sel <= '0'; muxy5_Sel <='0';
		end case;
	end process;
end behave;
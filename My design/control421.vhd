-- this component generates the control signals for Muxs
Entity control421 is
	port (xi,yi: in bit_vector (4 downto 0);
			signX,signY: out bit; --sign of the new numbers and clock signal
			muxy_Sel,muxx_Sel: out bit; -- select signals for muxs
			muxy_En,muxx_En,Eny,Enx: out bit); -- Enable signals for muxs
end entity;

architecture behave of control421 is
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
		-- mux input0=2X, input1=4X
		case tmpY is
			when "00000" => muxx_En <= '0'; muxx_Sel <='0'; Enx <= '0';
			when "00011" => muxx_En <= '0'; muxx_Sel <='0'; Enx <= '1';
			when "00110" => muxx_En <= '1'; muxx_Sel <='0'; Enx <= '0';
			when "01001" => muxx_En <= '1'; muxx_Sel <='0'; Enx <= '1';
			when "01100" => muxx_En <= '1'; muxx_Sel <='1'; Enx <= '0';
			when "01111" => muxx_En <= '1'; muxx_Sel <='1'; Enx <= '1';
			when others => muxx_En <= '0'; muxx_Sel <='0'; Enx <= '0';
		end case;
		
		case tmpX is
			when "00000" => muxy_En <= '0'; muxy_Sel <='0'; Eny <= '0';
			when "00011" => muxy_En <= '0'; muxy_Sel <='0'; Eny <= '1';
			when "00110" => muxy_En <= '1'; muxy_Sel <='0'; Eny <= '0';
			when "01001" => muxy_En <= '1'; muxy_Sel <='0'; Eny <= '1';
			when "01100" => muxy_En <= '1'; muxy_Sel <='1'; Eny <= '0';
			when "01111" => muxy_En <= '1'; muxy_Sel <='1'; Eny <= '1';
			when others => muxy_En <= '0'; muxy_Sel <='0'; Eny <= '0';
		end case;
	end process;
end behave;

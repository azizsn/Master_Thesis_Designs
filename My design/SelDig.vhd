-- this component perform the operation Sel(di) = sign (w)*floor(abs(w)+0.5)
Entity SelD is
	port (	wi: in bit_vector (4 downto 0);
		wi_1: in bit_vector (4 downto 0);
		di: out bit_vector (4 downto 0));
End SelD;

Architecture behave of SelD is
	signal cn,sign,add,addp,addn: bit;
	signal carry: bit_vector (4 downto 0);
	component FA
		port ( a,b,c: in bit;
			sum,carry: out bit);
	end component;
begin
	process (wi,wi_1)
		variable tmp: bit_vector(4 downto 0);
	begin
		sign <= wi(4);
		-- take the absolute Value of the wi
		if (wi(4) = '1') then
			tmp := Not wi;
		else
			tmp := wi;
		end if;
		if (Wi_1="01111" or Wi_1="10000" or Wi_1="10010" or Wi_1="01101") then
			add <= '1';
		else
			add <= '0';
		end if;
	end process;
	addn <= add and sign;
	addp <= add and (not sign);
	
	cn <= (addp and addn) or (wi(1) and  (not wi(0)) and addn) or  (wi(3) and addn)
		 or (wi(4) and addn) or (wi(4) and wi(3) and wi(1) and addp); 
	
	reduce0: FA port map (wi(0),addp,cn,di(0),carry(0));
	reduce1: FA port map (wi(1),addp,carry(0),di(1),carry(1));
	reduce2: FA port map (wi(2),addn,carry(1),di(2),carry(2));
	reduce3: FA port map (wi(3),addn,carry(2),di(3),carry(3));
	reduce4: FA port map (wi(4),addn,carry(3),di(4),carry(4));

end behave;